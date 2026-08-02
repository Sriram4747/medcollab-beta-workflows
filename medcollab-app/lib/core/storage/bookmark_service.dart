import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

enum BookmarkType { message, thread, handoff }

class BookmarkItem {
  const BookmarkItem({
    required this.id,
    required this.type,
    required this.title,
    required this.subtitle,
    required this.savedAt,
    this.spaceId,
    this.channelId,
    this.messageId,
    this.handoffId,
  });

  factory BookmarkItem.fromJson(Map<String, dynamic> json) {
    return BookmarkItem(
      id: json['id'] as String,
      type: BookmarkType.values.firstWhere(
        (e) => e.name == json['type'],
        orElse: () => BookmarkType.message,
      ),
      title: json['title'] as String? ?? '',
      subtitle: json['subtitle'] as String? ?? '',
      savedAt: DateTime.tryParse(json['savedAt'] as String? ?? '') ??
          DateTime.now(),
      spaceId: json['spaceId'] as String?,
      channelId: json['channelId'] as String?,
      messageId: json['messageId'] as String?,
      handoffId: json['handoffId'] as String?,
    );
  }

  final String id;
  final BookmarkType type;
  final String title;
  final String subtitle;
  final DateTime savedAt;
  final String? spaceId;
  final String? channelId;
  final String? messageId;
  final String? handoffId;

  Map<String, dynamic> toJson() => {
        'id': id,
        'type': type.name,
        'title': title,
        'subtitle': subtitle,
        'savedAt': savedAt.toIso8601String(),
        if (spaceId != null) 'spaceId': spaceId,
        if (channelId != null) 'channelId': channelId,
        if (messageId != null) 'messageId': messageId,
        if (handoffId != null) 'handoffId': handoffId,
      };
}

/// Local bookmarks — persisted on device until server sync in a future sprint.
class BookmarkService {
  BookmarkService({SharedPreferences? prefs}) : _prefs = prefs;

  SharedPreferences? _prefs;
  static const _key = 'medcollab_bookmarks_v1';

  Future<void> init() async {
    _prefs ??= await SharedPreferences.getInstance();
  }

  Future<List<BookmarkItem>> getAll() async {
    await init();
    final raw = _prefs!.getString(_key);
    if (raw == null) return [];
    try {
      final list = jsonDecode(raw) as List<dynamic>;
      return list
          .whereType<Map<String, dynamic>>()
          .map(BookmarkItem.fromJson)
          .toList()
        ..sort((a, b) => b.savedAt.compareTo(a.savedAt));
    } catch (_) {
      return [];
    }
  }

  Future<bool> isBookmarked(String id) async {
    final all = await getAll();
    return all.any((b) => b.id == id);
  }

  Future<void> save(BookmarkItem item) async {
    await init();
    final all = await getAll();
    all.removeWhere((b) => b.id == item.id);
    all.insert(0, item);
    await _prefs!.setString(
      _key,
      jsonEncode(all.map((e) => e.toJson()).toList()),
    );
  }

  Future<void> remove(String id) async {
    await init();
    final all = await getAll()..removeWhere((b) => b.id == id);
    await _prefs!.setString(
      _key,
      jsonEncode(all.map((e) => e.toJson()).toList()),
    );
  }

  Future<void> toggle(BookmarkItem item) async {
    if (await isBookmarked(item.id)) {
      await remove(item.id);
    } else {
      await save(item);
    }
  }

  Future<void> clearAll() async {
    await init();
    await _prefs!.remove(_key);
  }
}
