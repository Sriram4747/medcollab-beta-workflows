import 'package:flutter/material.dart';
import 'package:medcollab_app/core/theme/app_colors.dart';

/// Renders message text with highlighted `@mentions`.
class MentionRichText extends StatelessWidget {
  const MentionRichText({
    required this.text,
    this.style,
    this.mentionIds = const [],
    this.currentUserId,
    super.key,
  });

  final String text;
  final TextStyle? style;
  final List<String> mentionIds;
  final String? currentUserId;

  @override
  Widget build(BuildContext context) {
    final baseStyle = style ?? Theme.of(context).textTheme.bodyMedium;
    final pattern = RegExp(r'@([\w\s.]+?)(?=\s@|\s|$|[.,!?])');
    final spans = <TextSpan>[];
    var last = 0;

    for (final match in pattern.allMatches(text)) {
      if (match.start > last) {
        spans.add(TextSpan(text: text.substring(last, match.start)));
      }
      final mentionText = match.group(0) ?? '';
      final isUnreadMention = mentionIds.isNotEmpty &&
          currentUserId != null &&
          mentionIds.contains(currentUserId);
      spans.add(
        TextSpan(
          text: mentionText,
          style: baseStyle?.copyWith(
            color: AppColors.primary,
            fontWeight: FontWeight.w600,
            backgroundColor:
                isUnreadMention ? AppColors.primaryContainer : null,
          ),
        ),
      );
      last = match.end;
    }

    if (last < text.length) {
      spans.add(TextSpan(text: text.substring(last)));
    }

    if (spans.isEmpty) {
      return Text(text, style: baseStyle);
    }

    return Text.rich(
      TextSpan(style: baseStyle, children: spans),
    );
  }
}
