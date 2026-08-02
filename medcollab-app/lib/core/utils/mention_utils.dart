import 'package:medcollab_app/features/auth/data/models/user_model.dart';

/// Parses `@Name` tokens from message text for clinical @mentions.
class MentionUtils {
  MentionUtils._();

  /// Active `@` query at cursor for autocomplete (null if not mentioning).
  static String? activeMentionQuery(String text, int cursor) {
    if (cursor <= 0 || cursor > text.length) return null;
    final before = text.substring(0, cursor);
    final at = before.lastIndexOf('@');
    if (at < 0) return null;
    // Allow `@` at start of text or after whitespace.
    if (at > 0) {
      final prev = before[at - 1];
      if (prev != ' ' && prev != '\n' && prev != '\t') return null;
    }
    final fragment = before.substring(at + 1);
    if (fragment.contains('\n')) return null;
    if (RegExp(r'\s{2,}').hasMatch(fragment)) return null;
    if (fragment.split(RegExp(r'\s+')).where((p) => p.isNotEmpty).length > 3) {
      return null;
    }
    return fragment;
  }

  /// Insert a selected mention. Uses the user's plain [UserModel.name] when
  /// available so the token is stable for exact extraction later.
  static String insertMention(String text, int cursor, UserModel user) {
    final before = text.substring(0, cursor);
    final after = text.substring(cursor);
    final at = before.lastIndexOf('@');
    if (at < 0) return text;

    final name = (user.name != null && user.name!.trim().isNotEmpty)
        ? user.name!.trim()
        : user.displayName.trim();
    final prefix = before.substring(0, at);
    final inserted = '@$name ';
    return '$prefix$inserted$after';
  }

  /// Extract mentioned user IDs from [text].
  ///
  /// Matching is **exact only** against candidate names / display names
  /// (longest first). Partial `startsWith` matching is intentionally avoided —
  /// it caused the sender to get their own "X mentioned you" notification
  /// when names shared a common first word (e.g. "Doctor …").
  static List<String> extractMentionedUserIds(
    String text,
    List<UserModel> candidates, {
    String? excludeUserId,
  }) {
    if (text.isEmpty || candidates.isEmpty) return [];

    final ranked = List<UserModel>.from(candidates)
      ..sort((a, b) {
        final al = _primaryName(a).length;
        final bl = _primaryName(b).length;
        return bl.compareTo(al);
      });

    final ids = <String>{};
    // Work on a mutable copy so longer matches consume their `@token` first.
    var remaining = text;

    for (final user in ranked) {
      if (user.id.isEmpty) continue;
      if (excludeUserId != null &&
          excludeUserId.isNotEmpty &&
          user.id == excludeUserId) {
        continue;
      }

      final tokens = <String>{
        if (user.name != null && user.name!.trim().isNotEmpty)
          user.name!.trim(),
        if (user.displayName.trim().isNotEmpty) user.displayName.trim(),
      };

      for (final token in tokens) {
        if (token.isEmpty) continue;
        final pattern = RegExp(
          '@${RegExp.escape(token)}(?=\\s|\$|[.,!?])',
          caseSensitive: false,
        );
        if (pattern.hasMatch(remaining)) {
          ids.add(user.id);
          remaining = remaining.replaceFirst(pattern, ' ');
          break;
        }
      }
    }

    return ids.toList();
  }

  static String _primaryName(UserModel user) {
    if (user.name != null && user.name!.trim().isNotEmpty) {
      return user.name!.trim();
    }
    return user.displayName.trim();
  }
}
