import 'package:shared_preferences/shared_preferences.dart';

/// Persists unfinished chat drafts per channel (and optional thread root).
class DraftMessageService {
  DraftMessageService();

  static const _prefix = 'draft_msg_';

  String _key(String channelId, {String? threadId}) {
    if (threadId != null && threadId.isNotEmpty) {
      return '$_prefix${channelId}_t_$threadId';
    }
    return '$_prefix$channelId';
  }

  Future<String?> getDraft(String channelId, {String? threadId}) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_key(channelId, threadId: threadId));
  }

  Future<void> saveDraft(
    String channelId,
    String text, {
    String? threadId,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final trimmed = text.trimRight();
    final key = _key(channelId, threadId: threadId);
    if (trimmed.isEmpty) {
      await prefs.remove(key);
    } else {
      await prefs.setString(key, text);
    }
  }

  Future<void> clearDraft(String channelId, {String? threadId}) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_key(channelId, threadId: threadId));
  }

  /// True when this channel has a non-empty root (non-thread) draft.
  Future<bool> hasDraft(String channelId) async {
    final draft = await getDraft(channelId);
    return draft != null && draft.trim().isNotEmpty;
  }

  /// Channel IDs that currently have a root draft.
  Future<Set<String>> draftChannelIds() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = <String>{};
    for (final key in prefs.getKeys()) {
      if (!key.startsWith(_prefix) || key.contains('_t_')) continue;
      final value = prefs.getString(key);
      if (value == null || value.trim().isEmpty) continue;
      ids.add(key.substring(_prefix.length));
    }
    return ids;
  }

  /// Removes all draft keys (root and thread).
  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys().where((k) => k.startsWith(_prefix)).toList();
    for (final key in keys) {
      await prefs.remove(key);
    }
  }
}
