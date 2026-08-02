import 'package:equatable/equatable.dart';
import 'package:medcollab_app/core/constants/app_enums.dart';
import 'package:medcollab_app/core/utils/json_map_utils.dart';
import 'package:medcollab_app/features/auth/data/models/user_model.dart';
import 'package:medcollab_app/features/spaces/data/models/last_message_preview.dart';

class ChannelModel extends Equatable {
  const ChannelModel({
    required this.id,
    this.spaceId,
    required this.name,
    this.description = '',
    this.type = ChannelType.general,
    this.isPrivate = false,
    this.lastMessage,
    this.position = 0,
    this.peer,
    this.members = const [],
  });

  factory ChannelModel.fromJson(Map<String, dynamic> json) {
    final id = json['_id'] ?? json['id'];
    final peerJson = asJsonMap(json['peer']);
    final membersRaw = json['members'];
    final members = <UserModel>[];
    if (membersRaw is List) {
      for (final m in membersRaw) {
        final map = asJsonMap(m);
        if (map != null && (map['_id'] != null || map['id'] != null)) {
          members.add(UserModel.fromJson(map));
        }
      }
    }
    return ChannelModel(
      id: id.toString(),
      spaceId: json['spaceId']?.toString(),
      name: json['name'] as String? ?? 'channel',
      description: json['description'] as String? ?? '',
      type: ChannelType.fromString(json['type'] as String?),
      isPrivate: json['isPrivate'] as bool? ?? false,
      lastMessage: json['lastMessage'] is Map<String, dynamic>
          ? LastMessagePreview.fromJson(
              json['lastMessage'] as Map<String, dynamic>,
            )
          : null,
      position: json['position'] as int? ?? 0,
      peer: peerJson != null ? UserModel.fromJson(peerJson) : null,
      members: members,
    );
  }

  final String id;
  final String? spaceId;
  final String name;
  final String description;
  final ChannelType type;
  final bool isPrivate;
  final LastMessagePreview? lastMessage;
  final int position;
  final UserModel? peer;
  final List<UserModel> members;

  bool get isDirect => type == ChannelType.direct;

  String get displayName {
    if (isDirect) {
      if (peer != null) return peer!.displayName;
      if (name.isNotEmpty && name != 'channel') return name;
      return 'Direct message';
    }
    return name.startsWith('#') ? name : '#$name';
  }

  @override
  List<Object?> get props => [
        id,
        spaceId,
        name,
        description,
        type,
        isPrivate,
        lastMessage,
        position,
        peer,
        members,
      ];
}
