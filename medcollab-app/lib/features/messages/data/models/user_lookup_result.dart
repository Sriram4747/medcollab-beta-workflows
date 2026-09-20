import 'package:equatable/equatable.dart';
import 'package:medcollab_app/features/auth/data/models/user_model.dart';

/// `GET /api/users/lookup?phone=` response payload.
class UserLookupResult extends Equatable {
  const UserLookupResult({
    required this.user,
    required this.relationship,
    required this.canMessage,
    this.sharesGroup = false,
    this.acceptsMessageRequests = false,
    this.canRequest = false,
    this.isSelf = false,
    this.pendingRequest,
  });

  factory UserLookupResult.fromJson(Map<String, dynamic> json) {
    final pending = json['pendingRequest'];
    final canMessage = json['canMessage'] as bool? ?? false;
    final canRequest = json['canRequest'] as bool? ??
        json['acceptsMessageRequests'] as bool? ??
        false;
    final isSelf = json['isSelf'] as bool? ??
        json['relationship'] == 'self';
    return UserLookupResult(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      relationship: json['relationship'] as String? ?? 'stranger',
      canMessage: canMessage,
      sharesGroup: json['sharesGroup'] as bool? ??
          json['relationship'] == 'group_member',
      acceptsMessageRequests: canRequest,
      canRequest: canRequest,
      isSelf: isSelf,
      pendingRequest: pending is Map<String, dynamic>
          ? PendingRequestHint.fromJson(pending)
          : null,
    );
  }

  final UserModel user;
  final String relationship;
  final bool canMessage;
  final bool sharesGroup;
  /// Alias used by UI: may send a message request.
  final bool acceptsMessageRequests;
  final bool canRequest;
  final bool isSelf;
  final PendingRequestHint? pendingRequest;

  @override
  List<Object?> get props => [
        user,
        relationship,
        canMessage,
        sharesGroup,
        acceptsMessageRequests,
        canRequest,
        isSelf,
        pendingRequest,
      ];
}

class PendingRequestHint extends Equatable {
  const PendingRequestHint({
    required this.id,
    required this.direction,
    this.introMessage,
    this.createdAt,
  });

  factory PendingRequestHint.fromJson(Map<String, dynamic> json) {
    return PendingRequestHint(
      id: json['id']?.toString() ?? '',
      direction: json['direction'] as String? ?? 'sent',
      introMessage: json['introMessage'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
    );
  }

  final String id;
  final String direction;
  final String? introMessage;
  final DateTime? createdAt;

  bool get isReceived => direction == 'received';
  bool get isSent => direction == 'sent';

  @override
  List<Object?> get props => [id, direction, introMessage, createdAt];
}
