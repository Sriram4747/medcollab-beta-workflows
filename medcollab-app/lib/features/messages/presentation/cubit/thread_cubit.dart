import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medcollab_app/core/constants/app_enums.dart';
import 'package:medcollab_app/core/constants/socket_events.dart';
import 'package:medcollab_app/core/error/app_exception.dart';
import 'package:medcollab_app/core/socket/socket_client.dart';
import 'package:medcollab_app/core/utils/json_map_utils.dart';
import 'package:medcollab_app/features/auth/data/models/user_model.dart';
import 'package:medcollab_app/features/media/data/repositories/media_repository.dart';
import 'package:medcollab_app/features/messages/data/models/message_model.dart';
import 'package:medcollab_app/features/messages/data/repositories/thread_repository.dart';

part 'thread_state.dart';

class ThreadCubit extends Cubit<ThreadState> {
  ThreadCubit({
    required ThreadRepository threadRepository,
    required MediaRepository mediaRepository,
    required SocketClient socketClient,
    required this.channelId,
    required this.rootMessageId,
    required this.currentUserId,
    MessageModel? initialRoot,
  })  : _threadRepository = threadRepository,
        _mediaRepository = mediaRepository,
        _socketClient = socketClient,
        super(ThreadState(rootMessage: initialRoot)) {
    if (_socketClient.isConnected) {
      _socketClient.joinChannel(channelId);
    }
    _listenForSocketReplies();
    _listenForTyping();
    _connectionSub = _socketClient.connectionStream.listen((connected) {
      if (connected) {
        _socketClient.joinChannel(channelId);
        loadThread(silent: true);
      }
    });
    loadThread();
  }

  final ThreadRepository _threadRepository;
  final MediaRepository _mediaRepository;
  final SocketClient _socketClient;
  final String channelId;
  final String rootMessageId;
  final String currentUserId;

  StreamSubscription<Map<String, dynamic>>? _messageSub;
  StreamSubscription<bool>? _connectionSub;
  StreamSubscription<Map<String, dynamic>>? _typingSub;
  StreamSubscription<Map<String, dynamic>>? _stoppedTypingSub;

  final Map<String, String> _typingUsers = {};

  Future<void> loadThread({bool silent = false}) async {
    if (!silent) {
      emit(state.copyWith(isLoading: true, error: null));
    }
    try {
      final detail = await _threadRepository.getThread(
        channelId,
        rootMessageId,
      );
      emit(
        state.copyWith(
          rootMessage: detail.rootMessage,
          replies: detail.replies,
          hasMore: detail.hasMore,
          isLoading: false,
        ),
      );
    } on AppException catch (e) {
      emit(state.copyWith(isLoading: false, error: e.message));
    }
  }

  Future<void> sendReply(String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || state.isSending) return;

    emit(state.copyWith(isSending: true, error: null));
    try {
      final reply = await _threadRepository.sendReply(
        channelId: channelId,
        rootMessageId: rootMessageId,
        text: trimmed,
      );
      _upsertReply(reply);
      emit(state.copyWith(isSending: false));
    } on AppException catch (e) {
      emit(state.copyWith(isSending: false, error: e.message));
    } catch (_) {
      emit(state.copyWith(isSending: false, error: 'Failed to send reply'));
    }
  }

  Future<void> sendAttachment({
    required List<int> bytes,
    required String fileName,
    required String mimeType,
  }) async {
    if (state.isSending) return;

    final tempId = 'local-${DateTime.now().millisecondsSinceEpoch}';
    final isImage = mimeType.startsWith('image/');
    final optimistic = MessageModel(
      id: tempId,
      channelId: channelId,
      sender: UserModel(id: currentUserId),
      type: isImage ? MessageType.image : MessageType.document,
      content: MessageContent(fileName: fileName, mimeType: mimeType),
      threadId: rootMessageId,
      createdAt: DateTime.now(),
      localOnly: true,
    );
    _upsertReply(optimistic);

    emit(state.copyWith(isSending: true, isUploading: true, error: null));
    try {
      final upload = await _mediaRepository.uploadFile(
        bytes: bytes,
        fileName: fileName,
        mimeType: mimeType,
      );
      final reply = await _threadRepository.sendReplyMedia(
        channelId: channelId,
        rootMessageId: rootMessageId,
        type: isImage ? MessageType.image : MessageType.document,
        upload: upload,
      );
      _replaceLocalReply(tempId, reply);
      emit(state.copyWith(isSending: false, isUploading: false));
    } on AppException catch (e) {
      emit(state.copyWith(isSending: false, isUploading: false, error: e.message));
    } catch (_) {
      emit(state.copyWith(
        isSending: false,
        isUploading: false,
        error: 'Failed to send attachment',
      ));
    }
  }

  void _replaceLocalReply(String tempId, MessageModel reply) {
    final updated = List<MessageModel>.from(state.replies);
    updated.removeWhere((r) => r.id == tempId);
    updated.add(reply);
    updated.sort((a, b) {
      final at = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      final bt = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
      return at.compareTo(bt);
    });
    emit(state.copyWith(replies: updated));
  }

  void _listenForSocketReplies() {
    _messageSub =
        _socketClient.onMapEvent(SocketEvents.newMessage).listen((data) {
      final message = _parseSocketMessage(data);
      if (message == null) return;
      if (message.threadId != rootMessageId) return;
      if (message.channelId.isNotEmpty && message.channelId != channelId) {
        return;
      }
      _upsertReply(message);
    });
  }

  void _listenForTyping() {
    _typingSub =
        _socketClient.onMapEvent(SocketEvents.userTyping).listen((data) {
      final msgChannelId = data['channelId']?.toString() ?? '';
      if (msgChannelId != channelId) return;
      final userId = data['userId']?.toString() ?? '';
      if (userId.isEmpty || userId == currentUserId) return;
      final userName = data['userName']?.toString() ?? 'Someone';
      _typingUsers[userId] = userName;
      emit(state.copyWith(typingUserNames: _typingUsers.values.toList()));
    });

    _stoppedTypingSub = _socketClient
        .onMapEvent(SocketEvents.userStoppedTyping)
        .listen((data) {
      final msgChannelId = data['channelId']?.toString() ?? '';
      if (msgChannelId != channelId) return;
      final userId = data['userId']?.toString() ?? '';
      if (userId.isEmpty) return;
      _typingUsers.remove(userId);
      emit(state.copyWith(typingUserNames: _typingUsers.values.toList()));
    });
  }

  void emitTypingStart() {
    _socketClient.emitTypingStart(channelId);
  }

  void emitTypingStop() {
    _socketClient.emitTypingStop(channelId);
  }

  MessageModel? _parseSocketMessage(Map<String, dynamic> data) {
    try {
      return MessageModel.fromJson(data);
    } catch (_) {
      final nested = asJsonMap(data['message']);
      if (nested == null) return null;
      try {
        return MessageModel.fromJson(nested);
      } catch (_) {
        return null;
      }
    }
  }

  void _upsertReply(MessageModel reply) {
    final existing = state.replies.indexWhere((r) => r.id == reply.id);
    final updated = List<MessageModel>.from(state.replies);
    if (existing >= 0) {
      updated[existing] = reply;
    } else {
      updated.add(reply);
      updated.sort((a, b) {
        final at = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bt = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
        return at.compareTo(bt);
      });
    }
    emit(state.copyWith(replies: updated));
  }

  @override
  Future<void> close() {
    emitTypingStop();
    _connectionSub?.cancel();
    _messageSub?.cancel();
    _typingSub?.cancel();
    _stoppedTypingSub?.cancel();
    return super.close();
  }
}
