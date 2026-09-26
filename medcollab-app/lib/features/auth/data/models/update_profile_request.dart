import 'package:equatable/equatable.dart';
import 'package:medcollab_app/core/constants/app_enums.dart';

/// `PUT /api/users/me` request body.
class UpdateProfileRequest extends Equatable {
  const UpdateProfileRequest({
    required this.name,
    required this.role,
    this.speciality,
    this.institution,
    this.city,
    this.displayTitle,
    this.pgYear,
  });

  final String name;
  final UserRole role;
  final String? speciality;
  final String? institution;
  final String? city;
  final String? displayTitle;
  final int? pgYear;

  Map<String, dynamic> toJson() => {
        'name': name.trim(),
        'role': role.value,
        // Always send speciality so clearing / role switches persist on server.
        'speciality': speciality?.trim() ?? '',
        if (institution != null && institution!.trim().isNotEmpty)
          'institution': institution!.trim(),
        if (city != null && city!.trim().isNotEmpty) 'city': city!.trim(),
        if (displayTitle != null && displayTitle!.trim().isNotEmpty)
          'displayTitle': displayTitle!.trim(),
        if (pgYear != null) 'pgYear': pgYear,
      };

  @override
  List<Object?> get props =>
      [name, role, speciality, institution, city, displayTitle, pgYear];
}
