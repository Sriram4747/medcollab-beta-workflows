import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medcollab_app/core/chat/active_chat_tracker.dart';
import 'package:medcollab_app/core/constants/app_enums.dart';
import 'package:medcollab_app/core/constants/socket_events.dart';
import 'package:medcollab_app/core/error/app_exception.dart';
import 'package:medcollab_app/core/socket/socket_client.dart';
import 'package:medcollab_app/core/utils/json_map_utils.dart';
import 'package:medcollab_app/features/auth/data/models/user_model.dart';
import 'package:medcollab_app/features/media/data/repositories/media_repository.dart';
import 'package:medcollab_app/features/messages/data/models/message_delivery_state.dart';
import 'package:medcollab_app/features/messages/data/models/message_model.dart';
import 'package:medcollab_app/features/messages/data/models/thread_reply_preview.dart';
import 'package:medcollab_app/features/messages/data/repositories/message_repository.dart';
import 'package:medcollab_app/features/notifications/data/repositories/notification_repository.dart';

part 'channel_chat_state.dart';

class ChannelChatCubit extends Cubit<ChannelChatState> {
  StreamSubscription<bool>? _connectionSub;

  ChannelChatCubit({
    required MessageRepository messageRepository,
    required MediaRepository mediaRepository,
    required SocketClient socketClient,
    required this.channelId,
    required this.currentUserId,
    NotificationRepository? notificationRepository,
    void Function(int unreadCount)? onChannelAlertsCleared,
  })  : _messageRepository = messageRepository,
        _mediaRepository = mediaRepository,
        _socketClient = socketClient,
        _notificationRepository = notificationRepository,
        _onChannelAlertsCleared = onChannelAlertsCleared,
        super(const ChannelChatState()) {
    _listenForSocketMessages();
    _listenForSocketUpdates();
    _listenForTyping();
    _listenForInChatNotificationFallback();
    _connectionSub = _socketClient.connectionStream.listen((connected) {
      if (connected) {
        _socketClient.joinChannel(channelId);
        loadMessages(silent: true);
      }
    });
    if (_socketClient.isConnected) {
      _socketClient.joinChannel(channelId);
    }
    ActiveChatTracker.instance.enter(channelId);
    loadMessages();
    _markChannelNotificationsRead();
  }

  final MessageRepository _messageRepository;
  final MediaRepository _mediaRepository;
  final SocketClient _socketClient;
  final NotificationRepository? _notificationRepository;
  final void Function(int unreadCount)? _onChannelAlertsCleared;
  final String channelId;
  final String currentUserId;

  StreamSubscription<Map<String, dynamic>>? _messageSub;
  StreamSubscription<Map<String, dynamic>>? _messageUpdatedSub;
  StreamSubscription<Map<String, dynamic>>? _messageDeletedSub;
  StreamSubscription<Map<String, dynamic>>? _typingSub;
  StreamSubscription<Map<String, dynamic>>? _stoppedTypingSub;
  StreamSubscription<Map<String, dynamic>>? _notificationSub;

  final Map<String, String> _typingUsers = {};

  Future<void> _markChannelNotificationsRead() async {
    final repo = _notificationRepository;
    if (repo == null) return;
    try {
      final count = await repo.markReadByChannel(channelId);
      _onChannelAlertsCleared?.call(count);
    } catch (_) {
      /* non-fatal — chat still works */
    }
  }

  Future<void> loadMessages({bool silent = false}) async {
    if (!silent) {
      emit(state.copyWith(isLoading: true, error: null));
    }
    try {
      final page = await _messageRepository.getMessages(channelId);
      emit(
        state.copyWith(
          messages: page.messages,
          hasMore: page.hasMore,
          isLoading: false,
        ),
      );
      _socketClient.joinChannel(channelId);
      unawaited(_markMessagesRead(page.messages));
      unawaited(_markChannelNotificationsRead());
    } on AppException catch (e) {
      emit(state.copyWith(isLoading: false, error: e.message));
    }
  }

  Future<void> _markMessagesRead(List<MessageModel> messages) async {
    final ids = messages
        .where((m) => !m.localOnly && !m.isDeleted && m.sender.id != currentUserId)
        .map((m) => m.id)
        .where((id) => id.isNotEmpty)
        .toList();
    if (ids.isEmpty) return;
    try {
      await _messageRepository.markMessagesRead(
        channelId: channelId,
        messageIds: ids,
      );
    } catch (_) {
      /* non-fatal */
    }
  }

  /// If `new_message` is missed (room race), inbox events still refresh the open chat.
  void _listenForInChatNotificationFallback() {
    _notificationSub = _socketClient
        .onMapEvent(SocketEvents.newNotification)
        .listen((data) {
      final meta = asJsonMap(data['metadata']);
      final cid = meta?['channelId']?.toString() ??
          data['channelId']?.toString() ??
          '';
      if (cid.isEmpty || cid == 'null' || cid != channelId) return;
      unawaited(loadMessages(silent: true));
      unawaited(_markChannelNotificationsRead());
    });
  }

  Future<void> sendMessage(String text, {List<String> mentions = const []}) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty || state.isSending) return;

    final tempId = 'local-${DateTime.now().millisecondsSinceEpoch}';
    final optimistic = MessageModel(
      id: tempId,
      channelId: channelId,
      sender: UserModel(id: currentUserId),
      type: MessageType.text,
      content: MessageContent(text: trimmed),
      createdAt: DateTime.now(),
      localOnly: true,
    );
    _upsertRootMessage(optimistic);

    emit(state.copyWith(isSending: true, error: null));
    try {
      final message = await _messageRepository.sendTextMessage(
        channelId: channelId,
        text: trimmed,
        mentions: mentions,
      );
      _replaceLocalMessage(tempId, message);
      emit(state.copyWith(isSending: false));
    } on AppException catch (e) {
      _markFailed(tempId);
      emit(state.copyWith(isSending: false, error: e.message));
    } catch (_) {
      _markFailed(tempId);
      emit(state.copyWith(isSending: false, error: 'Failed to send message'));
    }
  }

  Future<void> sendAttachment({
    required List<int> bytes,
    required String fileName,
    required String mimeType,
    String? caption,
  }) async {
    if (state.isSending) return;

    final tempId = 'local-${DateTime.now().millisecondsSinceEpoch}';
    final isImage = mimeType.startsWith('image/');
    final optimistic = MessageModel(
      id: tempId,
      channelId: channelId,
      sender: UserModel(id: currentUserId),
      type: isImage ? MessageType.image : MessageType.document,
      content: MessageContent(
        text: caption,
        fileName: fileName,
        mimeType: mimeType,
      ),
      createdAt: DateTime.now(),
      localOnly: true,
    );
    _upsertRootMessage(optimistic);

    emit(state.copyWith(isSending: true, error: null, isUploading: true));
    try {
      final upload = await _mediaRepository.uploadFile(
        bytes: bytes,
        fileName: fileName,
        mimeType: mimeType,
      );
      final message = await _messageRepository.sendMediaMessage(
        channelId: channelId,
        type: isImage ? MessageType.image : MessageType.document,
        upload: upload,
        caption: caption,
      );
      _replaceLocalMessage(tempId, message);
      emit(state.copyWith(isSending: false, isUploading: false));
    } on AppException catch (e) {
      _markFailed(tempId);
      emit(state.copyWith(isSending: false, isUploading: false, error: e.message));
    } catch (_) {
      _markFailed(tempId);
      emit(
        state.copyWith(
          isSending: false,
          isUploading: false,
          error: 'Failed to send attachment',
        ),
      );
    }
  }

  Future<void> editMessage(String messageId, String text) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    try {
      final updated = await _messageRepository.editMessage(
        channelId: channelId,
        messageId: messageId,
        text: trimmed,
      );
      _upsertRootMessage(updated);
    } on AppException catch (e) {
      emit(state.copyWith(error: e.message));
    }
  }

  Future<void> deleteMessage(String messageId) async {
    final index = state.messages.indexWhere((m) => m.id == messageId);
    if (index < 0) return;
    final existing = state.messages[index];
    // Optimistic soft-delete — API does not return the deleted message body.
    _upsertRootMessage(existing.copyWith(isDeleted: true));
    try {
      await _messageRepository.deleteMessage(
        channelId: channelId,
        messageId: messageId,
      );
    } on AppException catch (e) {
      _upsertRootMessage(existing);
      emit(state.copyWith(error: e.message));
    }
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

  void _listenForSocketUpdates() {
    _messageUpdatedSub =
        _socketClient.onMapEvent(SocketEvents.messageUpdated).listen((data) {
      final messageId =
          data['messageId']?.toString() ?? data['_id']?.toString() ?? '';
      final reactionsRaw = data['reactions'];
      if (messageId.isNotEmpty && reactionsRaw is List) {
        final reactions = reactionsRaw
            .map(asJsonMap)
            .whereType<Map<String, dynamic>>()
            .map(MessageReaction.fromJson)
            .toList();
        final index = state.messages.indexWhere((m) => m.id == messageId);
        if (index >= 0) {
          final updated = List<MessageModel>.from(state.messages);
          updated[index] = updated[index].copyWith(reactions: reactions);
          emit(state.copyWith(messages: updated));
        }
        return;
      }

      final message = _parseSocketMessage(data);
      if (message == null) return;
      final msgChannelId = message.channelId.isNotEmpty
          ? message.channelId
          : data['channelId']?.toString() ?? '';
      if (msgChannelId.isNotEmpty && msgChannelId != channelId) return;
      if (message.isThreadReply) {
        _applyThreadReplyToRoot(message);
      } else {
        _upsertRootMessage(message);
      }
    });

    _messageDeletedSub =
        _socketClient.onMapEvent(SocketEvents.messageDeleted).listen((data) {
      final messageId =
          data['messageId']?.toString() ?? data['_id']?.toString() ?? '';
      if (messageId.isEmpty) return;
      final index = state.messages.indexWhere((m) => m.id == messageId);
      if (index < 0) {
        // May be a thread reply — refresh counts softly when possible.
        final parsed = _parseSocketMessage(data);
        if (parsed != null && parsed.channelId == channelId) {
          _upsertRootMessage(parsed.copyWith(isDeleted: true));
        }
        return;
      }
      _upsertRootMessage(state.messages[index].copyWith(isDeleted: true));
    });
  }

  void _markFailed(String tempId) {
    final index = state.messages.indexWhere((m) => m.id == tempId);
    if (index < 0) return;
    final updated = List<MessageModel>.from(state.messages);
    updated[index] = updated[index].copyWith(
      deliveryState: MessageDeliveryState.failed,
    );
    emit(state.copyWith(messages: updated));
  }

  void _replaceLocalMessage(String tempId, MessageModel message) {
    final updated = List<MessageModel>.from(state.messages);
    updated.removeWhere(
      (m) =>
          m.id == tempId ||
          m.id == message.id ||
          (m.localOnly &&
              m.sender.id == currentUserId &&
              _messagesMatch(m, message)),
    );
    updated.add(message);
    updated.sort(_compareByCreatedAt);
    emit(state.copyWith(messages: updated));
  }

  void _listenForSocketMessages() {
    _messageSub =
        _socketClient.onMapEvent(SocketEvents.newMessage).listen((data) {
      final message = _parseSocketMessage(data);
      if (message == null) return;

      final msgChannelId = message.channelId.isNotEmpty
          ? message.channelId
          : data['channelId']?.toString() ?? '';
      if (msgChannelId != channelId) return;
      _handleIncomingMessage(message);
    });
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

  void _handleIncomingMessage(MessageModel message) {
    if (message.isThreadReply) {
      _applyThreadReplyToRoot(message);
      return;
    }
    _upsertRootMessage(message, fromSocket: true);
    // Keep Alerts in sync when messages arrive while this chat is open.
    unawaited(_markMessagesRead([message]));
    unawaited(_markChannelNotificationsRead());
  }

  Future<void> toggleReaction(String messageId, String emoji) async {
    try {
      final reactions = await _messageRepository.toggleReaction(
        channelId: channelId,
        messageId: messageId,
        emoji: emoji,
      );
      final index = state.messages.indexWhere((m) => m.id == messageId);
      if (index < 0) return;
      final updated = List<MessageModel>.from(state.messages);
      updated[index] = updated[index].copyWith(reactions: reactions);
      emit(state.copyWith(messages: updated));
    } on AppException catch (e) {
      emit(state.copyWith(error: e.message));
    }
  }

  void _applyThreadReplyToRoot(MessageModel reply) {
    final rootId = reply.threadId;
    if (rootId == null || rootId.isEmpty) return;

    final index = state.messages.indexWhere((m) => m.id == rootId);
    if (index < 0) return;

    final root = state.messages[index];
    final updated = List<MessageModel>.from(state.messages);
    updated[index] = root.copyWith(
      replyCount: root.replyCount + 1,
      lastReply: ThreadReplyPreview(
        senderName: reply.sender.displayName,
        text: _truncate(reply.displayText, 100),
        sentAt: reply.createdAt,
      ),
    );
    emit(state.copyWith(messages: updated));
  }

  String _truncate(String text, int max) {
    if (text.length <= max) return text;
    return '${text.substring(0, max)}…';
  }

  void _upsertRootMessage(MessageModel message, {bool fromSocket = false}) {
    final updated = List<MessageModel>.from(state.messages);

    if (fromSocket && message.sender.id == currentUserId) {
      updated.removeWhere(
        (m) =>
            m.localOnly &&
            m.sender.id == currentUserId &&
            _messagesMatch(m, message),
      );
    }

    final existing = updated.indexWhere((m) => m.id == message.id);
    if (existing >= 0) {
      updated[existing] = message;
    } else {
      updated.add(message);
      updated.sort(_compareByCreatedAt);
    }
    emit(state.copyWith(messages: updated));
  }

  bool _messagesMatch(MessageModel a, MessageModel b) {
    if (a.type != b.type) return false;
    if (a.type == MessageType.text) {
      return a.content.text?.trim() == b.content.text?.trim();
    }
    if (a.type == MessageType.image || a.type == MessageType.document) {
      return a.content.fileName == b.content.fileName &&
          a.content.text == b.content.text;
    }
    return a.displayText == b.displayText;
  }

  int _compareByCreatedAt(MessageModel a, MessageModel b) {
    final at = a.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
    final bt = b.createdAt ?? DateTime.fromMillisecondsSinceEpoch(0);
    return at.compareTo(bt);
  }

  @override
  Future<void> close() {
    emitTypingStop();
    ActiveChatTracker.instance.leave(channelId);
    _connectionSub?.cancel();
    _socketClient.leaveChannel(channelId);
    _messageSub?.cancel();
    _messageUpdatedSub?.cancel();
    _messageDeletedSub?.cancel();
    _typingSub?.cancel();
    _stoppedTypingSub?.cancel();
    _notificationSub?.cancel();
    return super.close();
  }
}
