import 'package:equatable/equatable.dart';
import 'package:medcollab_app/core/utils/json_map_utils.dart';
import 'package:medcollab_app/features/auth/data/models/user_model.dart';

/// One entry in the Needl (threads) inbox.
class NeedlThreadPreview extends Equatable {
  const NeedlThreadPreview({
    required this.rootMessageId,
    required this.channelId,
    this.spaceId,
    this.channelName,
    this.preview = '',
    this.replyCount = 0,
    this.lastReplyAt,
    this.sender,
  });

  factory NeedlThreadPreview.fromJson(Map<String, dynamic> json) {
    final senderRaw = asJsonMap(json['sender']);
    return NeedlThreadPreview(
      rootMessageId: json['rootMessageId']?.toString() ?? '',
      channelId: json['channelId']?.toString() ?? '',
      spaceId: json['spaceId']?.toString(),
      channelName: json['channelName'] as String?,
      preview: json['preview'] as String? ?? '',
      replyCount: json['replyCount'] as int? ?? 0,
      lastReplyAt: json['lastReplyAt'] != null
          ? DateTime.tryParse(json['lastReplyAt'].toString())
          : null,
      sender: senderRaw != null ? UserModel.fromJson(senderRaw) : null,
    );
  }

  final String rootMessageId;
  final String channelId;
  final String? spaceId;
  final String? channelName;
  final String preview;
  final int replyCount;
  final DateTime? lastReplyAt;
  final UserModel? sender;

  @override
  List<Object?> get props => [
        rootMessageId,
        channelId,
        spaceId,
        channelName,
        preview,
        replyCount,
        lastReplyAt,
        sender,
      ];
}
