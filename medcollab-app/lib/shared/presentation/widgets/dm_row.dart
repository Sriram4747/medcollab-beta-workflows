import 'package:flutter/material.dart';
import 'package:medcollab_app/core/theme/app_colors.dart';
import 'package:medcollab_app/core/theme/app_text_styles.dart';
import 'package:medcollab_app/shared/presentation/widgets/app_avatar.dart';

/// Direct-message list row (brief SCREEN 2).
class DMRow extends StatelessWidget {
  const DMRow({
    required this.name,
    required this.preview,
    this.imageUrl,
    this.timestamp,
    this.isOnline = false,
    this.onTap,
    super.key,
  });

  final String name;
  final String preview;
  final String? imageUrl;
  final String? timestamp;
  final bool isOnline;
  final VoidCallback? onTap;

  static Color colorFromName(String name) {
    const palette = <Color>[
      Color(0xFF00A88F),
      Color(0xFF6366F1),
      Color(0xFF0EA5E9),
      Color(0xFFD97706),
      Color(0xFFEC4899),
      Color(0xFF059669),
      Color(0xFF8B5CF6),
      Color(0xFF1A6FBF),
    ];
    if (name.isEmpty) return palette[0];
    var hash = 0;
    for (final unit in name.codeUnits) {
      hash = (hash + unit * 31) & 0x7fffffff;
    }
    return palette[hash % palette.length];
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: const BorderRadius.all(Radius.circular(10)),
        child: Container(
          decoration: BoxDecoration(
            color: AppColors.surfaceCard,
            borderRadius: const BorderRadius.all(Radius.circular(10)),
            border: Border.all(
              color: AppColors.borderDefault,
              width: 0.5,
            ),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
          child: Row(
            children: [
              AppAvatar(
                name: name,
                imageUrl: imageUrl,
                size: 38,
                showPresence: true,
                isOnline: isOnline,
                backgroundColor: colorFromName(name).withValues(alpha: 0.18),
                foregroundColor: colorFromName(name),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.cardTitle,
                    ),
                    const SizedBox(height: 2),
                    Text(
                      preview,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: AppTextStyles.caption,
                    ),
                  ],
                ),
              ),
              if (timestamp != null && timestamp!.isNotEmpty) ...[
                const SizedBox(width: 8),
                Text(timestamp!, style: AppTextStyles.timestamp),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
