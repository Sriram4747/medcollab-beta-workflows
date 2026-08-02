import 'package:medcollab_app/core/constants/api_endpoints.dart';
import 'package:medcollab_app/core/error/app_exception.dart';
import 'package:medcollab_app/core/utils/json_map_utils.dart';
import 'package:medcollab_app/features/auth/data/models/user_model.dart';
import 'package:medcollab_app/features/channels/data/models/channel_detail_model.dart';
import 'package:medcollab_app/features/spaces/data/models/channel_model.dart';
import 'package:medcollab_app/shared/data/repositories/base_repository.dart';

class ChannelRepository extends BaseRepository {
  ChannelRepository({required super.apiClient});

  /// `GET /api/channels/:id`
  Future<ChannelDetailModel> getChannelById(String channelId) {
    return execute(
      () => apiClient.get(
        ApiEndpoints.channelById(channelId),
        parser: (json) {
          final channel = asJsonMap(json['channel']);
          if (channel == null) {
            throw const UnknownException('Unexpected channel response');
          }
          return ChannelDetailModel.fromJson(channel);
        },
      ),
    );
  }

  /// `GET /api/channels/dm`
  Future<List<ChannelModel>> getMyDMs() {
    return execute(
      () => apiClient.get(
        ApiEndpoints.listDms,
        parser: (json) => parseNestedList(json, 'channels', ChannelModel.fromJson),
      ),
    );
  }

  /// `POST /api/channels/dm`
  Future<ChannelModel> createOrGetDM(String userId) {
    return execute(
      () => apiClient.post(
        ApiEndpoints.createDm,
        data: {'userId': userId},
        parser: (json) => parseNested(json, 'channel', ChannelModel.fromJson),
      ),
    );
  }

  /// `GET /api/channels/:id/members`
  Future<List<UserModel>> getChannelMembers(String channelId) {
    return execute(
      () => apiClient.get(
        ApiEndpoints.channelMembers(channelId),
        parser: (json) => parseNestedList(json, 'members', UserModel.fromJson),
      ),
    );
  }

  /// `POST /api/channels/:id/pin/:messageId`
  Future<void> pinMessage(String channelId, String messageId) {
    return executeVoid(
      () => apiClient.post(ApiEndpoints.pinMessage(channelId, messageId)),
    );
  }

  /// `DELETE /api/channels/:id/pin/:messageId`
  Future<void> unpinMessage(String channelId, String messageId) {
    return executeVoid(
      () => apiClient.delete(ApiEndpoints.pinMessage(channelId, messageId)),
    );
  }

  /// `GET /api/spaces/:spaceId/channels`
  Future<List<ChannelModel>> getSpaceChannels(String spaceId) {
    return execute(
      () => apiClient.get(
        ApiEndpoints.spaceChannels(spaceId),
        parser: (json) =>
            parseNestedList(json, 'channels', ChannelModel.fromJson),
      ),
    );
  }

  /// `POST /api/spaces/:spaceId/channels`
  Future<ChannelModel> createChannel({
    required String spaceId,
    required String name,
    String description = '',
    bool isPrivate = false,
  }) {
    return execute(
      () => apiClient.post(
        ApiEndpoints.spaceChannels(spaceId),
        data: {
          'name': name.trim().toLowerCase().replaceAll(' ', '-'),
          'description': description.trim(),
          'isPrivate': isPrivate,
        },
        parser: (json) =>
            parseNested(json, 'channel', ChannelModel.fromJson),
      ),
    );
  }
}
