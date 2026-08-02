import 'package:medcollab_app/core/constants/api_endpoints.dart';
import 'package:medcollab_app/core/utils/json_map_utils.dart';
import 'package:medcollab_app/features/auth/data/models/user_model.dart';
import 'package:medcollab_app/shared/data/repositories/base_repository.dart';

class SearchMessageHit {
  const SearchMessageHit({
    required this.id,
    required this.channelId,
    this.spaceId,
    required this.text,
    this.createdAt,
    this.sender,
    this.channelName,
    this.channelType,
  });

  factory SearchMessageHit.fromJson(Map<String, dynamic> json) {
    return SearchMessageHit(
      id: (json['_id'] ?? json['id']).toString(),
      channelId: json['channelId'].toString(),
      spaceId: json['spaceId']?.toString(),
      text: json['text'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      sender: asJsonMap(json['sender']) != null
          ? UserModel.fromJson(asJsonMap(json['sender'])!)
          : null,
      channelName: json['channelName'] as String?,
      channelType: json['channelType'] as String?,
    );
  }

  final String id;
  final String channelId;
  final String? spaceId;
  final String text;
  final DateTime? createdAt;
  final UserModel? sender;
  final String? channelName;
  final String? channelType;
}

class SearchAttachmentHit {
  const SearchAttachmentHit({
    required this.id,
    required this.channelId,
    this.spaceId,
    this.type,
    this.fileName,
    this.mediaUrl,
    this.text = '',
    this.createdAt,
    this.sender,
    this.channelName,
  });

  factory SearchAttachmentHit.fromJson(Map<String, dynamic> json) {
    return SearchAttachmentHit(
      id: (json['_id'] ?? json['id']).toString(),
      channelId: json['channelId'].toString(),
      spaceId: json['spaceId']?.toString(),
      type: json['type'] as String?,
      fileName: json['fileName'] as String?,
      mediaUrl: json['mediaUrl'] as String?,
      text: json['text'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      sender: asJsonMap(json['sender']) != null
          ? UserModel.fromJson(asJsonMap(json['sender'])!)
          : null,
      channelName: json['channelName'] as String?,
    );
  }

  final String id;
  final String channelId;
  final String? spaceId;
  final String? type;
  final String? fileName;
  final String? mediaUrl;
  final String text;
  final DateTime? createdAt;
  final UserModel? sender;
  final String? channelName;
}

class SearchChannelHit {
  const SearchChannelHit({
    required this.id,
    required this.name,
    this.type,
    this.spaceId,
    this.spaceName,
  });

  factory SearchChannelHit.fromJson(Map<String, dynamic> json) {
    return SearchChannelHit(
      id: (json['_id'] ?? json['id']).toString(),
      name: json['name'] as String? ?? '',
      type: json['type'] as String?,
      spaceId: json['spaceId']?.toString(),
      spaceName: json['spaceName'] as String?,
    );
  }

  final String id;
  final String name;
  final String? type;
  final String? spaceId;
  final String? spaceName;
}

class SearchHandoffHit {
  const SearchHandoffHit({
    required this.id,
    required this.spaceId,
    this.channelId,
    required this.title,
    this.shiftSummary = '',
    this.status,
    this.spaceName,
    this.fromName,
    this.toName,
  });

  factory SearchHandoffHit.fromJson(Map<String, dynamic> json) {
    String? userName(dynamic raw) {
      if (raw is Map<String, dynamic>) {
        return (raw['name'] ?? raw['displayTitle'])?.toString();
      }
      return null;
    }

    return SearchHandoffHit(
      id: (json['_id'] ?? json['id']).toString(),
      spaceId: json['spaceId']?.toString() ?? '',
      channelId: json['channelId']?.toString(),
      title: json['title'] as String? ?? 'Handoff',
      shiftSummary: json['shiftSummary'] as String? ?? '',
      status: json['status'] as String?,
      spaceName: json['spaceName'] as String?,
      fromName: userName(json['fromUser']),
      toName: userName(json['toUser']),
    );
  }

  final String id;
  final String spaceId;
  final String? channelId;
  final String title;
  final String shiftSummary;
  final String? status;
  final String? spaceName;
  final String? fromName;
  final String? toName;
}

class GlobalSearchResult {
  const GlobalSearchResult({
    required this.query,
    this.messages = const [],
    this.doctors = const [],
    this.channels = const [],
    this.attachments = const [],
    this.handoffs = const [],
  });

  final String query;
  final List<SearchMessageHit> messages;
  final List<UserModel> doctors;
  final List<SearchChannelHit> channels;
  final List<SearchAttachmentHit> attachments;
  final List<SearchHandoffHit> handoffs;

  bool get isEmpty =>
      messages.isEmpty &&
      doctors.isEmpty &&
      channels.isEmpty &&
      attachments.isEmpty &&
      handoffs.isEmpty;
}

class SearchRepository extends BaseRepository {
  SearchRepository({required super.apiClient});

  /// `GET /api/search`
  Future<GlobalSearchResult> search({
    required String query,
    String type = 'all',
    int limit = 20,
  }) {
    return execute(
      () => apiClient.get(
        ApiEndpoints.search,
        queryParameters: {
          'q': query,
          'type': type,
          'limit': limit,
        },
        parser: (json) {
          return GlobalSearchResult(
            query: json['query'] as String? ?? query,
            messages: parseNestedList(
              json,
              'messages',
              SearchMessageHit.fromJson,
            ),
            doctors: parseNestedList(json, 'doctors', UserModel.fromJson),
            channels: parseNestedList(
              json,
              'channels',
              SearchChannelHit.fromJson,
            ),
            attachments: parseNestedList(
              json,
              'attachments',
              SearchAttachmentHit.fromJson,
            ),
            handoffs: parseNestedList(
              json,
              'handoffs',
              SearchHandoffHit.fromJson,
            ),
          );
        },
      ),
    );
  }
}
