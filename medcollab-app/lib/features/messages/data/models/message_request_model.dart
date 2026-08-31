import 'package:equatable/equatable.dart';
import 'package:medcollab_app/features/auth/data/models/user_model.dart';

class MessageRequestModel extends Equatable {
  const MessageRequestModel({
    required this.id,
    required this.status,
    required this.direction,
    required this.peer,
    this.introMessage = '',
    this.createdAt,
  });

  factory MessageRequestModel.fromJson(Map<String, dynamic> json) {
    return MessageRequestModel(
      id: json['id']?.toString() ?? '',
      status: json['status'] as String? ?? 'pending',
      direction: json['direction'] as String? ?? 'received',
      introMessage: json['introMessage'] as String? ?? '',
      createdAt: json['createdAt'] != null
          ? DateTime.tryParse(json['createdAt'].toString())
          : null,
      peer: UserModel.fromJson(json['peer'] as Map<String, dynamic>),
    );
  }

  final String id;
  final String status;
  final String direction;
  final String introMessage;
  final DateTime? createdAt;
  final UserModel peer;

  bool get isPending => status == 'pending';
  bool get isReceived => direction == 'received';

  @override
  List<Object?> get props => [id, status, direction, introMessage, createdAt, peer];
}
