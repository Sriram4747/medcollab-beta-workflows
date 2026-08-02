import 'package:equatable/equatable.dart';
import 'package:medcollab_app/core/utils/json_map_utils.dart';
import 'package:medcollab_app/features/auth/data/models/user_model.dart';

class MessageReadReceipt extends Equatable {
  const MessageReadReceipt({
    required this.userId,
    this.readAt,
    this.user,
  });

  factory MessageReadReceipt.fromJson(Map<String, dynamic> json) {
    final userJson = asJsonMap(json['userId']);
    return MessageReadReceipt(
      userId: userJson != null
          ? UserModel.fromJson(userJson).id
          : json['userId']?.toString() ?? '',
      readAt: json['readAt'] != null
          ? DateTime.tryParse(json['readAt'].toString())
          : null,
      user: userJson != null ? UserModel.fromJson(userJson) : null,
    );
  }

  final String userId;
  final DateTime? readAt;
  final UserModel? user;

  String get displayName => user?.displayName ?? 'Colleague';

  @override
  List<Object?> get props => [userId, readAt, user];
}
