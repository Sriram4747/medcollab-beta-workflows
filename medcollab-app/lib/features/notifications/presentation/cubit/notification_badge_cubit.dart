import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medcollab_app/core/chat/active_chat_tracker.dart';
import 'package:medcollab_app/core/constants/socket_events.dart';
import 'package:medcollab_app/core/socket/socket_client.dart';
import 'package:medcollab_app/features/notifications/data/repositories/notification_repository.dart';

/// App-wide unread notification count for the Alerts tab badge.
class NotificationBadgeCubit extends Cubit<int> {
  NotificationBadgeCubit({
    required NotificationRepository repository,
    required SocketClient socketClient,
  })  : _repository = repository,
        _socketClient = socketClient,
        super(0) {
    refresh();
    _sub = _socketClient
        .onMapEvent(SocketEvents.newNotification)
        .listen(_onNotification);
    _connectionSub = _socketClient.connectionStream.listen((connected) {
      if (connected) refresh();
    });
  }

  final NotificationRepository _repository;
  final SocketClient _socketClient;
  StreamSubscription<Map<String, dynamic>>? _sub;
  StreamSubscription<bool>? _connectionSub;

  void _onNotification(Map<String, dynamic> raw) {
    final meta = raw['metadata'];
    String? channelId;
    if (meta is Map) {
      channelId = meta['channelId']?.toString();
    }
    channelId ??= raw['channelId']?.toString();
    if (channelId != null &&
        ActiveChatTracker.instance.isViewing(channelId)) {
      // Doctor already has the chat open — clear matching Alerts server-side.
      unawaited(_clearWhileViewing(channelId));
      return;
    }
    refresh();
  }

  Future<void> _clearWhileViewing(String channelId) async {
    try {
      final count = await _repository.markReadByChannel(channelId);
      emit(count);
    } catch (_) {
      await refresh();
    }
  }

  Future<void> refresh() async {
    try {
      final count = await _repository.getUnreadCount();
      emit(count);
    } catch (_) {}
  }

  void setCount(int count) => emit(count.clamp(0, 9999));

  void clear() => emit(0);

  @override
  Future<void> close() {
    _sub?.cancel();
    _connectionSub?.cancel();
    return super.close();
  }
}
