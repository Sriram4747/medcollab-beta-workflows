import 'package:equatable/equatable.dart';
import 'package:medcollab_app/core/utils/json_map_utils.dart';
import 'package:medcollab_app/features/auth/data/models/user_model.dart';
import 'package:medcollab_app/features/messages/data/models/message_model.dart';
import 'package:medcollab_app/features/spaces/data/models/channel_model.dart';

class PinnedMessageEntry extends Equatable {
  const PinnedMessageEntry({
    required this.message,
    this.pinnedAt,
  });

  factory PinnedMessageEntry.fromJson(Map<String, dynamic> json) {
    final messageJson = asJsonMap(json['messageId']);
    return PinnedMessageEntry(
      message: messageJson != null
          ? MessageModel.fromJson(messageJson)
          : MessageModel(
              id: json['messageId']?.toString() ?? '',
              channelId: '',
              sender: UserModel(id: ''),
            ),
      pinnedAt: json['pinnedAt'] != null
          ? DateTime.tryParse(json['pinnedAt'].toString())
          : null,
    );
  }

  final MessageModel message;
  final DateTime? pinnedAt;

  @override
  List<Object?> get props => [message, pinnedAt];
}

class ChannelDetailModel extends Equatable {
  const ChannelDetailModel({
    required this.channel,
    this.pinnedMessages = const [],
  });

  factory ChannelDetailModel.fromJson(Map<String, dynamic> json) {
    final channel = ChannelModel.fromJson(json);
    final pinnedRaw = json['pinnedMessages'];
    final pinned = pinnedRaw is List
        ? pinnedRaw
            .map(asJsonMap)
            .whereType<Map<String, dynamic>>()
            .map(PinnedMessageEntry.fromJson)
            .toList()
        : <PinnedMessageEntry>[];

    return ChannelDetailModel(channel: channel, pinnedMessages: pinned);
  }

  final ChannelModel channel;
  final List<PinnedMessageEntry> pinnedMessages;

  @override
  List<Object?> get props => [channel, pinnedMessages];
}
