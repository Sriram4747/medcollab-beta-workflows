/// Tracks which chat the user is currently viewing (channel / DM).
/// Used to suppress local banners and avoid unread spam while reading.
class ActiveChatTracker {
  ActiveChatTracker._();
  static final ActiveChatTracker instance = ActiveChatTracker._();

  String? _channelId;

  String? get channelId => _channelId;

  void enter(String channelId) {
    _channelId = channelId;
  }

  void leave(String channelId) {
    if (_channelId == channelId) {
      _channelId = null;
    }
  }

  bool isViewing(String? channelId) {
    if (channelId == null || channelId.isEmpty || _channelId == null) {
      return false;
    }
    return _channelId == channelId;
  }
}
