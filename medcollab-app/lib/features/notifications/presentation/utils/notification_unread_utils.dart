import 'package:medcollab_app/features/notifications/data/models/notification_model.dart';

/// Derive chat unread indicators from the in-app notification inbox.
Map<String, int> unreadCountsByChannel(
  Iterable<AppNotificationModel> notifications,
) {
  final counts = <String, int>{};
  for (final n in notifications) {
    if (n.read) continue;
    if (!_isChatCategory(n.category)) continue;
    final channelId = n.metadata.channelId;
    if (channelId == null || channelId.isEmpty) continue;
    counts[channelId] = (counts[channelId] ?? 0) + 1;
  }
  return counts;
}

bool hasUnreadChatNotifications(
  Iterable<AppNotificationModel> notifications,
) {
  for (final n in notifications) {
    if (!n.read && _isChatCategory(n.category)) return true;
  }
  return false;
}

bool _isChatCategory(AppNotificationCategory category) {
  return category == AppNotificationCategory.message ||
      category == AppNotificationCategory.reply ||
      category == AppNotificationCategory.mention;
}
