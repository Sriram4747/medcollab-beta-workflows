import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medcollab_app/core/notifications/fcm_service.dart';
import 'package:medcollab_app/core/router/app_routes.dart';

/// Routes a tapped push notification into the correct Vocle screen.
/// Guards against duplicate pushes from rapid notification taps.
abstract final class PushNotificationRouter {
  static DateTime? _lastPushAt;
  static String? _lastPushRoute;

  static void open(BuildContext context, PushPayload payload) {
    final type = payload.type.toLowerCase();

    String targetRoute;
    if (payload.handoffId != null &&
        payload.handoffId!.isNotEmpty &&
        payload.spaceId != null &&
        payload.spaceId!.isNotEmpty) {
      targetRoute = AppRoutes.spaceHandoffDetailPath(
        payload.spaceId!,
        payload.handoffId!,
      );
    } else if (payload.channelId != null && payload.channelId!.isNotEmpty) {
      final spaceId = payload.spaceId;
      if (spaceId != null && spaceId.isNotEmpty) {
        targetRoute = AppRoutes.channelPath(spaceId, payload.channelId!);
      } else {
        targetRoute = AppRoutes.dmPath(payload.channelId!);
      }
    } else if (type.contains('handoff')) {
      context.go(AppRoutes.handoffs);
      return;
    } else {
      context.go(AppRoutes.notifications);
      return;
    }

    // Deduplicate rapid taps to the same route within 1 second.
    final now = DateTime.now();
    if (_lastPushRoute == targetRoute &&
        _lastPushAt != null &&
        now.difference(_lastPushAt!) < const Duration(seconds: 1)) {
      return;
    }
    _lastPushAt = now;
    _lastPushRoute = targetRoute;
    context.push(targetRoute);
  }
}
