import 'package:medcollab_app/core/constants/api_endpoints.dart';
import 'package:medcollab_app/features/messages/data/models/message_request_model.dart';
import 'package:medcollab_app/shared/data/repositories/base_repository.dart';

class MessageRequestRepository extends BaseRepository {
  MessageRequestRepository({required super.apiClient});

  Future<MessageRequestModel> sendRequest({
    required String toUserId,
    String? introMessage,
  }) {
    return execute(
      () => apiClient.post(
        ApiEndpoints.messageRequests,
        data: {
          'toUserId': toUserId,
          if (introMessage != null && introMessage.trim().isNotEmpty)
            'introMessage': introMessage.trim(),
        },
        parser: (json) => MessageRequestModel.fromJson(
          json['request'] as Map<String, dynamic>,
        ),
      ),
    );
  }

  Future<List<MessageRequestModel>> listRequests({
    String direction = 'received',
    String status = 'pending',
  }) {
    return execute(
      () => apiClient.get(
        ApiEndpoints.messageRequests,
        queryParameters: {
          'direction': direction,
          'status': status,
        },
        parser: (json) =>
            parseNestedList(json, 'requests', MessageRequestModel.fromJson),
      ),
    );
  }

  Future<int> pendingCount() {
    return execute(
      () => apiClient.get(
        ApiEndpoints.messageRequestsPendingCount,
        parser: (json) => (json['count'] as num?)?.toInt() ?? 0,
      ),
    );
  }

  Future<MessageRequestModel> acceptRequest(String id) {
    return execute(
      () => apiClient.post(
        ApiEndpoints.messageRequestAccept(id),
        parser: (json) => MessageRequestModel.fromJson(
          json['request'] as Map<String, dynamic>,
        ),
      ),
    );
  }

  Future<MessageRequestModel> declineRequest(String id) {
    return execute(
      () => apiClient.post(
        ApiEndpoints.messageRequestDecline(id),
        parser: (json) => MessageRequestModel.fromJson(
          json['request'] as Map<String, dynamic>,
        ),
      ),
    );
  }
}
