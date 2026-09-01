import 'package:flutter/material.dart';
import 'package:medcollab_app/core/theme/app_colors.dart';
import 'package:medcollab_app/core/theme/app_decorations.dart';
import 'package:medcollab_app/core/theme/app_spacing.dart';

/// Consistent empty states — calm, informative, clinical.
class AppEmptyState extends StatelessWidget {
  const AppEmptyState({
    required this.icon,
    required this.title,
    this.subtitle,
    this.action,
    this.compact = false,
    super.key,
  });

  final IconData icon;
  final String title;
  final String? subtitle;
  final Widget? action;
  final bool compact;

  @override
  Widget build(BuildContext context) {
    final padding = compact ? AppSpacing.lg : AppSpacing.xxl;
    final iconSize = compact ? 52.0 : 64.0;
    final glyphSize = compact ? 24.0 : 28.0;

    return Center(
      child: Padding(
        padding: EdgeInsets.all(padding),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: iconSize,
              height: iconSize,
              decoration: AppDecorations.emptyStateIcon(),
              child: Icon(
                icon,
                size: glyphSize,
                color: AppColors.primary,
              ),
            ),
            SizedBox(height: compact ? AppSpacing.md : AppSpacing.lg),
            Text(
              title,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontSize: compact ? 16 : null,
                  ),
              textAlign: TextAlign.center,
            ),
            if (subtitle != null) ...[
              SizedBox(height: compact ? AppSpacing.xxs : AppSpacing.xs),
              Text(
                subtitle!,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      color: AppColors.textSecondary,
                      fontSize: compact ? 13 : null,
                    ),
                textAlign: TextAlign.center,
              ),
            ],
            if (action != null) ...[
              SizedBox(height: compact ? AppSpacing.lg : AppSpacing.xl),
              action!,
            ],
          ],
        ),
      ),
    );
  }
}
