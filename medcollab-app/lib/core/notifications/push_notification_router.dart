import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:medcollab_app/core/notifications/fcm_service.dart';
import 'package:medcollab_app/core/router/app_routes.dart';

/// Routes a tapped push notification into the correct Vocle screen.
abstract final class PushNotificationRouter {
  static void open(BuildContext context, PushPayload payload) {
    final type = payload.type.toLowerCase();

    if (payload.handoffId != null &&
        payload.handoffId!.isNotEmpty &&
        payload.spaceId != null &&
        payload.spaceId!.isNotEmpty) {
      context.push(
        AppRoutes.spaceHandoffDetailPath(
          payload.spaceId!,
          payload.handoffId!,
        ),
      );
      return;
    }

    if (payload.channelId != null && payload.channelId!.isNotEmpty) {
      final spaceId = payload.spaceId;
      if (spaceId != null && spaceId.isNotEmpty) {
        context.push(AppRoutes.channelPath(spaceId, payload.channelId!));
      } else {
        context.push(AppRoutes.dmPath(payload.channelId!));
      }
      return;
    }

    if (type.contains('handoff')) {
      context.go(AppRoutes.handoffs);
      return;
    }

    // Mentions, messages, emergency without channel → Alerts inbox.
    context.go(AppRoutes.notifications);
  }
}
