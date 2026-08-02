import 'package:flutter/material.dart';
import 'package:medcollab_app/core/constants/app_enums.dart';
import 'package:medcollab_app/core/theme/app_colors.dart';
import 'package:medcollab_app/core/theme/app_radius.dart';
import 'package:medcollab_app/core/theme/app_text_styles.dart';
import 'package:medcollab_app/core/utils/clinical_formatters.dart';

/// Status pill with colored dot + label (brief §2 / SCREEN 1 & 8).
///
/// [onDark] uses teal border + teal text for navy header shift cards.
class AvailabilityPill extends StatelessWidget {
  const AvailabilityPill({
    required this.status,
    this.onDark = false,
    this.compact = false,
    super.key,
  });

  final AvailabilityStatus status;
  final bool onDark;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final color = availabilityColor(status);
    final label = availabilityLabel(status);

    if (onDark) {
      return Container(
        decoration: BoxDecoration(
          color: Colors.transparent,
          borderRadius: AppRadius.pill,
          border: Border.all(
            color: AppColors.tealPrimary.withValues(alpha: 0.55),
          ),
        ),
        padding: EdgeInsets.symmetric(
          horizontal: compact ? 8 : 10,
          vertical: compact ? 3 : 4,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 7,
              height: 7,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: AppTextStyles.caption.copyWith(
                color: AppColors.tealPrimary,
                fontWeight: FontWeight.w500,
                fontSize: 12,
              ),
            ),
          ],
        ),
      );
    }

    return Container(
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: AppRadius.pill,
        border: Border.all(color: color.withValues(alpha: 0.35)),
      ),
      padding: EdgeInsets.symmetric(
        horizontal: compact ? 8 : 10,
        vertical: compact ? 3 : 4,
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            label,
            style: AppTextStyles.caption.copyWith(
              color: color,
              fontWeight: FontWeight.w500,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}
