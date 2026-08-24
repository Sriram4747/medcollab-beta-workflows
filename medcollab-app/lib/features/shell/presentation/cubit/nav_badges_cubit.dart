import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medcollab_app/core/constants/app_enums.dart';
import 'package:medcollab_app/core/constants/socket_events.dart';
import 'package:medcollab_app/core/socket/socket_client.dart';
import 'package:medcollab_app/features/handoffs/data/repositories/handoff_repository.dart';
import 'package:medcollab_app/features/notifications/data/repositories/notification_repository.dart';
import 'package:medcollab_app/features/notifications/presentation/cubit/notification_badge_cubit.dart';
import 'package:medcollab_app/features/notifications/presentation/utils/notification_unread_utils.dart';

class NavBadgesState extends Equatable {
  const NavBadgesState({
    this.alertsCount = 0,
    this.messagesDot = false,
    this.handoffsDot = false,
  });

  final int alertsCount;
  final bool messagesDot;
  final bool handoffsDot;

  NavBadgesState copyWith({
    int? alertsCount,
    bool? messagesDot,
    bool? handoffsDot,
  }) {
    return NavBadgesState(
      alertsCount: alertsCount ?? this.alertsCount,
      messagesDot: messagesDot ?? this.messagesDot,
      handoffsDot: handoffsDot ?? this.handoffsDot,
    );
  }

  @override
  List<Object?> get props => [alertsCount, messagesDot, handoffsDot];
}

/// Bottom-nav badge state — Alerts count + Messages/Handoffs dots.
class NavBadgesCubit extends Cubit<NavBadgesState> {
  NavBadgesCubit({
    required NotificationRepository notificationRepository,
    required HandoffRepository handoffRepository,
    required NotificationBadgeCubit notificationBadgeCubit,
    required SocketClient socketClient,
  })  : _notificationRepository = notificationRepository,
        _handoffRepository = handoffRepository,
        _notificationBadgeCubit = notificationBadgeCubit,
        _socketClient = socketClient,
        super(const NavBadgesState()) {
    _alertsSub = _notificationBadgeCubit.stream.listen((count) {
      emit(state.copyWith(alertsCount: count));
    });
    _socketSub = _socketClient
        .onMapEvent(SocketEvents.newNotification)
        .listen((_) => refresh());
    _connectionSub = _socketClient.connectionStream.listen((connected) {
      if (connected) refresh();
    });
  }

  final NotificationRepository _notificationRepository;
  final HandoffRepository _handoffRepository;
  final NotificationBadgeCubit _notificationBadgeCubit;
  final SocketClient _socketClient;

  StreamSubscription<int>? _alertsSub;
  StreamSubscription<Map<String, dynamic>>? _socketSub;
  StreamSubscription<bool>? _connectionSub;

  String? _userId;

  void setUserId(String? userId) {
    _userId = userId;
    refresh();
  }

  Future<void> refresh() async {
    try {
      final alerts = await _notificationRepository.getUnreadCount();
      _notificationBadgeCubit.setCount(alerts);

      final page =
          await _notificationRepository.getNotifications(limit: 50);
      final messagesDot = hasUnreadChatNotifications(page.notifications);

      var handoffsDot = false;
      final userId = _userId;
      if (userId != null && userId.isNotEmpty) {
        final handoffs = await _handoffRepository.getMyHandoffs();
        handoffsDot = handoffs.any(
          (h) =>
              h.status == HandoffStatus.submitted && h.toUser.id == userId,
        );
      }

      emit(
        NavBadgesState(
          alertsCount: alerts,
          messagesDot: messagesDot,
          handoffsDot: handoffsDot,
        ),
      );
    } catch (_) {
      /* keep last known badges */
    }
  }

  @override
  Future<void> close() {
    _alertsSub?.cancel();
    _socketSub?.cancel();
    _connectionSub?.cancel();
    return super.close();
  }
}
