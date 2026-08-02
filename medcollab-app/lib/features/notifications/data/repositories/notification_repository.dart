import 'package:medcollab_app/core/constants/api_endpoints.dart';
import 'package:medcollab_app/features/notifications/data/models/notification_model.dart';
import 'package:medcollab_app/shared/data/repositories/base_repository.dart';

class NotificationRepository extends BaseRepository {
  NotificationRepository({required super.apiClient});

  Future<NotificationsPageResult> getNotifications({
    bool unreadOnly = false,
    String? before,
    String? type,
    int limit = 30,
  }) {
    return execute(
      () => apiClient.get(
        ApiEndpoints.notifications,
        queryParameters: {
          'limit': limit,
          if (before != null) 'before': before,
          if (unreadOnly) 'unreadOnly': 'true',
          if (type != null) 'type': type,
        },
        parser: (json) => NotificationsPageResult(
          notifications: parseNestedList(
            json,
            'notifications',
            AppNotificationModel.fromJson,
          ),
          hasMore: json['hasMore'] as bool? ?? false,
          unreadCount: (json['unreadCount'] as num?)?.toInt() ?? 0,
        ),
      ),
    );
  }

  Future<int> getUnreadCount() {
    return execute(
      () => apiClient.get(
        ApiEndpoints.unreadCount,
        parser: (json) => (json['count'] as num?)?.toInt() ?? 0,
      ),
    );
  }

  Future<void> markAsRead(String notificationId) {
    return executeVoid(
      () => apiClient.put(ApiEndpoints.markNotificationRead(notificationId)),
    );
  }

  Future<void> markAsUnread(String notificationId) {
    return executeVoid(
      () => apiClient.put(ApiEndpoints.markNotificationUnread(notificationId)),
    );
  }

  Future<void> markAllAsRead() {
    return executeVoid(() => apiClient.put(ApiEndpoints.markAllRead));
  }

  Future<void> deleteNotification(String notificationId) {
    return executeVoid(
      () => apiClient.delete(ApiEndpoints.notificationById(notificationId)),
    );
  }
}
