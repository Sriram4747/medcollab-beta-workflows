import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:medcollab_app/core/theme/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

/// Renders message text with highlighted `@mentions` and tappable URLs.
class MentionRichText extends StatefulWidget {
  const MentionRichText({
    required this.text,
    this.style,
    this.mentionIds = const [],
    this.currentUserId,
    this.linkColor,
    super.key,
  });

  final String text;
  final TextStyle? style;
  final List<String> mentionIds;
  final String? currentUserId;
  final Color? linkColor;

  @override
  State<MentionRichText> createState() => _MentionRichTextState();
}

class _MentionRichTextState extends State<MentionRichText> {
  static final _urlPattern = RegExp(
    r'(https?:\/\/[^\s<>\[\]()]+)|(www\.[^\s<>\[\]()]+)',
    caseSensitive: false,
  );
  static final _mentionPattern = RegExp(r'@([\w\s.]+?)(?=\s@|\s|$|[.,!?])');

  final List<TapGestureRecognizer> _recognizers = [];

  @override
  void dispose() {
    for (final r in _recognizers) {
      r.dispose();
    }
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant MentionRichText oldWidget) {
    super.didUpdateWidget(oldWidget);
  }

  TapGestureRecognizer _linkRecognizer(String href) {
    final recognizer = TapGestureRecognizer()
      ..onTap = () async {
        final uri = Uri.tryParse(href);
        if (uri == null) return;
        await launchUrl(uri, mode: LaunchMode.externalApplication);
      };
    _recognizers.add(recognizer);
    return recognizer;
  }

  @override
  Widget build(BuildContext context) {
    for (final r in _recognizers) {
      r.dispose();
    }
    _recognizers.clear();

    final baseStyle = widget.style ?? Theme.of(context).textTheme.bodyMedium;
    final resolvedLinkColor = widget.linkColor ?? AppColors.tealPrimary;
    final spans = _buildSpans(baseStyle, resolvedLinkColor);

    if (spans.isEmpty) {
      return Text(widget.text, style: baseStyle);
    }

    return Text.rich(
      TextSpan(style: baseStyle, children: spans),
    );
  }

  List<InlineSpan> _buildSpans(TextStyle? baseStyle, Color linkColor) {
    final text = widget.text;
    final spans = <InlineSpan>[];
    var cursor = 0;

    final tokens = <_Token>[];
    for (final m in _mentionPattern.allMatches(text)) {
      tokens.add(_Token(m.start, m.end, _TokenKind.mention));
    }
    for (final m in _urlPattern.allMatches(text)) {
      tokens.add(_Token(m.start, m.end, _TokenKind.url));
    }
    tokens.sort((a, b) => a.start.compareTo(b.start));

    final filtered = <_Token>[];
    var lastEnd = -1;
    for (final t in tokens) {
      if (t.start < lastEnd) continue;
      filtered.add(t);
      lastEnd = t.end;
    }

    for (final token in filtered) {
      if (token.start > cursor) {
        spans.add(TextSpan(text: text.substring(cursor, token.start)));
      }
      final slice = text.substring(token.start, token.end);
      if (token.kind == _TokenKind.mention) {
        final isUnreadMention = widget.mentionIds.isNotEmpty &&
            widget.currentUserId != null &&
            widget.mentionIds.contains(widget.currentUserId);
        spans.add(
          TextSpan(
            text: slice,
            style: baseStyle?.copyWith(
              color: AppColors.primary,
              fontWeight: FontWeight.w600,
              backgroundColor:
                  isUnreadMention ? AppColors.primaryContainer : null,
            ),
          ),
        );
      } else {
        final href = slice.toLowerCase().startsWith('http')
            ? slice
            : 'https://$slice';
        spans.add(
          TextSpan(
            text: slice,
            style: baseStyle?.copyWith(
              color: linkColor,
              decoration: TextDecoration.underline,
              decorationColor: linkColor,
            ),
            recognizer: _linkRecognizer(href),
          ),
        );
      }
      cursor = token.end;
    }

    if (cursor < text.length) {
      spans.add(TextSpan(text: text.substring(cursor)));
    }
    return spans;
  }
}

enum _TokenKind { mention, url }

class _Token {
  const _Token(this.start, this.end, this.kind);
  final int start;
  final int end;
  final _TokenKind kind;
}
