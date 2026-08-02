import 'package:flutter/material.dart';
import 'package:medcollab_app/core/theme/app_colors.dart';
import 'package:medcollab_app/core/theme/app_radius.dart';
import 'package:medcollab_app/core/theme/app_text_styles.dart';

/// Uppercase section label with optional teal "See all" action (brief §7).
class SectionHeader extends StatelessWidget {
  const SectionHeader({
    required this.label,
    this.actionLabel,
    this.onAction,
    this.padding = const EdgeInsets.only(bottom: AppGaps.itemGap),
    super.key,
  });

  final String label;
  final String? actionLabel;
  final VoidCallback? onAction;
  final EdgeInsetsGeometry padding;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: padding,
      child: Row(
        children: [
          Expanded(
            child: Text(
              label.toUpperCase(),
              style: AppTextStyles.sectionLabel,
            ),
          ),
          if (actionLabel != null && onAction != null)
            GestureDetector(
              onTap: onAction,
              child: Text(
                actionLabel!,
                style: AppTextStyles.caption.copyWith(
                  color: AppColors.tealDark,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
        ],
      ),
    );
  }
}
