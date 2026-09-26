import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:medcollab_app/core/constants/socket_events.dart';
import 'package:medcollab_app/core/socket/socket_client.dart';

/// Who is typing, keyed by channel, for the open chat and the DM list.
class TypingPresence extends ChangeNotifier {
  TypingPresence._();

  static final TypingPresence instance = TypingPresence._();

  final Map<String, Map<String, String>> _byChannel = {};
  final Map<String, Timer> _expiry = {};
  bool _attached = false;

  bool isTyping(String channelId) =>
      _byChannel[channelId]?.isNotEmpty ?? false;

  /// First names currently typing in [channelId], or null.
  String? labelFor(String channelId) {
    final names = _byChannel[channelId]?.values.toList() ?? const [];
    if (names.isEmpty) return null;
    return names.join(', ');
  }

  void attach(SocketClient socket) {
    if (_attached) return;
    _attached = true;

    socket.onMapEvent(SocketEvents.userTyping).listen((data) {
      final channelId = data['channelId']?.toString() ?? '';
      final userId = data['userId']?.toString() ?? '';
      final name = data['userName']?.toString().trim();
      if (channelId.isEmpty || userId.isEmpty) return;
      _set(channelId, userId, (name == null || name.isEmpty) ? 'Someone' : name);
    });

    socket.onMapEvent(SocketEvents.userStoppedTyping).listen((data) {
      final channelId = data['channelId']?.toString() ?? '';
      final userId = data['userId']?.toString() ?? '';
      if (channelId.isEmpty || userId.isEmpty) return;
      _clear(channelId, userId);
    });
  }

  void _set(String channelId, String userId, String name) {
    final users = _byChannel.putIfAbsent(channelId, () => {});
    users[userId] = name;
    final key = '$channelId:$userId';
    _expiry[key]?.cancel();
    _expiry[key] = Timer(const Duration(seconds: 4), () {
      _clear(channelId, userId);
    });
    notifyListeners();
  }

  void _clear(String channelId, String userId) {
    _expiry.remove('$channelId:$userId')?.cancel();
    final users = _byChannel[channelId];
    if (users == null) return;
    users.remove(userId);
    if (users.isEmpty) _byChannel.remove(channelId);
    notifyListeners();
  }
}
