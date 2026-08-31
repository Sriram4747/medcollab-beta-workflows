import 'package:medcollab_app/core/constants/app_enums.dart';

/// NEET-PG broad specialty papers (19 subjects) + common clinical labels.
abstract final class ClinicalProfileOptions {
  static const neetPgSubjects = [
    'Anaesthesiology',
    'Anatomy',
    'Biochemistry',
    'Community Medicine (PSM)',
    'Dermatology',
    'ENT (Otorhinolaryngology)',
    'Forensic Medicine',
    'General Medicine',
    'General Surgery',
    'Microbiology',
    'Obstetrics & Gynaecology',
    'Ophthalmology',
    'Orthopaedics',
    'Paediatrics',
    'Pathology',
    'Pharmacology',
    'Physiology',
    'Psychiatry',
    'Radiology',
  ];

  /// Full speciality field for PG+ roles.
  static bool showClinicalSpeciality(UserRole role) =>
      role == UserRole.pgResident ||
      role == UserRole.juniorConsultant ||
      role == UserRole.consultant;

  /// Optional NEET PG prep track for interns / MBBS graduates.
  static bool showPgPrepSubject(UserRole role) => role == UserRole.intern;

  /// Free-text speciality for nurse / other.
  static bool showFreeTextSpeciality(UserRole role) =>
      role == UserRole.nurse || role == UserRole.other;
}
