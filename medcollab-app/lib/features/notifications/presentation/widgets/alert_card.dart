import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:medcollab_app/core/theme/app_colors.dart';
import 'package:medcollab_app/core/theme/app_radius.dart';
import 'package:medcollab_app/core/theme/app_text_styles.dart';
import 'package:medcollab_app/features/notifications/data/models/notification_model.dart';

/// Vocle alert / notification row (brief § SCREEN 7).
class AlertCard extends StatelessWidget {
  const AlertCard({
    required this.notification,
    required this.onTap,
    this.onLongPress,
    super.key,
  });

  final AppNotificationModel notification;
  final VoidCallback onTap;
  final VoidCallback? onLongPress;

  static const Color _mentionBg = Color(0xFFEEF2FF);
  static const Color _mentionFg = Color(0xFF6366F1);
  static const Color _emergencyTitle = Color(0xFF991B1B);
  static const Color _emergencyCardBg = Color(0xFFFFF5F5);
  static const Color _unreadTint = Color(0xFFF0FDFA);

  bool get _isEmergency {
    final cat = notification.categoryLabel.toLowerCase();
    final title = notification.title.toLowerCase();
    final type = notification.type.toLowerCase();
    return cat.contains('emergency') ||
        title.contains('emergency') ||
        type.contains('emergency');
  }

  bool get _isUnread => !notification.read;

  @override
  Widget build(BuildContext context) {
    final time = notification.createdAt != null
        ? DateFormat('MMM d · h:mm a').format(notification.createdAt!.toLocal())
        : '';
    final icon = _iconStyle();
    final title = notification.title.isNotEmpty
        ? notification.title
        : (notification.actorName ?? 'Alert');

    return Material(
      color: _isEmergency
          ? _emergencyCardBg
          : (_isUnread ? _unreadTint : AppColors.surfaceCard),
      shape: RoundedRectangleBorder(
        borderRadius: AppRadius.card,
        side: BorderSide(
          color: _isEmergency
              ? AppColors.emergencyBorder
              : (_isUnread
                  ? AppColors.tealPrimary.withValues(alpha: 0.35)
                  : AppColors.borderDefault),
          width: _isUnread && !_isEmergency ? 1 : 0.5,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        onLongPress: onLongPress,
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (_isUnread)
                Container(
                  width: 4,
                  color: _isEmergency
                      ? AppColors.emergencyRed
                      : AppColors.tealPrimary,
                ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppGaps.cardH,
                    vertical: AppGaps.cardV,
                  ),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        width: 36,
                        height: 36,
                        decoration: BoxDecoration(
                          color: icon.bg,
                          borderRadius: AppRadius.groupIcon,
                        ),
                        child: Icon(icon.icon, color: icon.fg, size: 18),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              title,
                              style: AppTextStyles.cardTitle.copyWith(
                                fontWeight: _isUnread
                                    ? FontWeight.w700
                                    : FontWeight.w500,
                                color: _isEmergency
                                    ? _emergencyTitle
                                    : AppColors.textPrimary,
                              ),
                            ),
                            if (notification.body.isNotEmpty) ...[
                              const SizedBox(height: 2),
                              Text(
                                notification.body,
                                maxLines: 2,
                                overflow: TextOverflow.ellipsis,
                                style: AppTextStyles.body.copyWith(
                                  fontWeight: _isUnread
                                      ? FontWeight.w500
                                      : FontWeight.w400,
                                  color: _isUnread
                                      ? AppColors.textPrimary
                                      : AppColors.textSecondary,
                                ),
                              ),
                            ],
                            if (time.isNotEmpty) ...[
                              const SizedBox(height: 4),
                              Text(time, style: AppTextStyles.timestamp),
                            ],
                          ],
                        ),
                      ),
                      if (_isUnread) ...[
                        const SizedBox(width: 8),
                        Padding(
                          padding: const EdgeInsets.only(top: 6),
                          child: Container(
                            width: 8,
                            height: 8,
                            decoration: BoxDecoration(
                              color: _isEmergency
                                  ? AppColors.emergencyRed
                                  : AppColors.tealPrimary,
                              shape: BoxShape.circle,
                            ),
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  ({Color bg, IconData icon, Color fg}) _iconStyle() {
    if (_isEmergency) {
      return (
        bg: AppColors.emergencyRed,
        icon: Icons.warning_rounded,
        fg: Colors.white,
      );
    }
    return switch (notification.category) {
      AppNotificationCategory.mention => (
          bg: _mentionBg,
          icon: Icons.alternate_email,
          fg: _mentionFg,
        ),
      AppNotificationCategory.handoff => (
          bg: AppColors.statusPendTint,
          icon: Icons.swap_horiz_rounded,
          fg: AppColors.statusPending,
        ),
      AppNotificationCategory.invite => (
          bg: AppColors.tealTint,
          icon: Icons.group_add_outlined,
          fg: AppColors.tealPrimary,
        ),
      AppNotificationCategory.reply ||
      AppNotificationCategory.message ||
      AppNotificationCategory.announcement ||
      AppNotificationCategory.other =>
        (
          bg: AppColors.tealTint,
          icon: Icons.chat_bubble_outline,
          fg: AppColors.tealPrimary,
        ),
    };
  }
}
