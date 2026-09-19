import 'package:equatable/equatable.dart';
import 'package:medcollab_app/features/auth/data/models/user_model.dart';

/// `GET /api/users/lookup?phone=` response payload.
class UserLookupResult extends Equatable {
  const UserLookupResult({
    required this.user,
    required this.relationship,
    required this.canMessage,
    this.acceptsMessageRequests = false,
    this.pendingRequest,
  });

  factory UserLookupResult.fromJson(Map<String, dynamic> json) {
    final pending = json['pendingRequest'];
    final canMessage = json['canMessage'] as bool? ?? false;
    return UserLookupResult(
      user: UserModel.fromJson(json['user'] as Map<String, dynamic>),
      relationship: json['relationship'] as String? ?? 'stranger',
      canMessage: canMessage,
      acceptsMessageRequests:
          json['acceptsMessageRequests'] as bool? ?? canMessage,
      pendingRequest: pending is Map<String, dynamic>
          ? PendingRequestHint.fromJson(pending)
          : null,
    );
  }

  final UserModel user;
  final String relationship;
  final bool canMessage;
  /// True when known (can message) or target opted into stranger requests.
  final bool acceptsMessageRequests;
  final PendingRequestHint? pendingRequest;

  @override
  List<Object?> get props =>
      [user, relationship, canMessage, acceptsMessageRequests, pendingRequest];
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
