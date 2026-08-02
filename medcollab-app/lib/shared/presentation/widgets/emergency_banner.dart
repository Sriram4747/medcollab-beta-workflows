import 'package:flutter/material.dart';
import 'package:medcollab_app/core/theme/app_colors.dart';
import 'package:medcollab_app/core/theme/app_radius.dart';
import 'package:medcollab_app/core/theme/app_text_styles.dart';

/// Full-red emergency alert strip for Home (brief SCREEN 1).
class EmergencyBanner extends StatelessWidget {
  const EmergencyBanner({
    required this.onPressed,
    // Shortcut to the emergency channel — not an active alarm.
    this.title = 'Emergency channel',
    this.subtitle = 'Tap to open department emergency',
    super.key,
  });

  final VoidCallback onPressed;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: title,
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onPressed,
          borderRadius: AppRadius.card,
          child: Container(
            decoration: const BoxDecoration(
              color: AppColors.emergencyRed,
              borderRadius: AppRadius.card,
            ),
            padding: const EdgeInsets.symmetric(
              horizontal: AppGaps.cardH,
              vertical: AppGaps.cardV,
            ),
            child: Row(
              children: [
                Container(
                  width: 36,
                  height: 36,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: AppRadius.groupIcon,
                  ),
                  child: const Icon(
                    Icons.warning_amber_rounded,
                    color: AppColors.textOnDark,
                    size: 20,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: AppTextStyles.cardTitle.copyWith(
                          color: AppColors.textOnDark,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        subtitle,
                        style: AppTextStyles.caption.copyWith(
                          color: Colors.white.withValues(alpha: 0.75),
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(
                  Icons.chevron_right,
                  color: Colors.white.withValues(alpha: 0.6),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
