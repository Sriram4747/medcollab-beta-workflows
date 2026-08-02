import 'package:flutter/material.dart';
import 'package:medcollab_app/core/constants/app_enums.dart';
import 'package:medcollab_app/core/theme/app_colors.dart';
import 'package:medcollab_app/features/handoffs/data/models/handoff_model.dart';
import 'package:medcollab_app/features/handoffs/data/models/handoff_patient_model.dart';

/// Priority accent colours for handoff list and patient cards.
abstract final class HandoffPriorityColors {
  static Color forPatient(HandoffPatientModel patient) {
    if (patient.isFlagged || patient.status == PatientStatus.critical) {
      return AppColors.emergency;
    }
    return forStatus(patient.status);
  }

  static Color forStatus(PatientStatus status) {
    return switch (status) {
      PatientStatus.critical => AppColors.emergency,
      PatientStatus.deteriorating => AppColors.urgent,
      PatientStatus.monitoring => AppColors.warning,
      PatientStatus.improving => AppColors.primary,
      PatientStatus.stable => AppColors.success,
    };
  }

  static Color forHandoff(HandoffModel handoff) {
    if (handoff.hasFlaggedPatient) return AppColors.emergency;
    final critical = handoff.patients
        .where((p) => p.status == PatientStatus.critical)
        .isNotEmpty;
    if (critical) return AppColors.emergency;
    final deteriorating = handoff.patients
        .where((p) => p.status == PatientStatus.deteriorating)
        .isNotEmpty;
    if (deteriorating) return AppColors.urgent;
    final monitoring = handoff.patients
        .where((p) => p.status == PatientStatus.monitoring)
        .isNotEmpty;
    if (monitoring) return AppColors.warning;
    return AppColors.secondaryMuted;
  }

  static String statusLabel(PatientStatus status) => switch (status) {
        PatientStatus.stable => 'Stable',
        PatientStatus.monitoring => 'Monitoring',
        PatientStatus.critical => 'Critical',
        PatientStatus.improving => 'Improving',
        PatientStatus.deteriorating => 'Deteriorating',
      };

  static String handoffStatusLabel(HandoffStatus status) => switch (status) {
        HandoffStatus.draft => 'Draft',
        HandoffStatus.submitted => 'Pending',
        HandoffStatus.acknowledged => 'Active',
      };

  static String handoffLifecycleLabel(HandoffModel handoff) =>
      handoff.lifecycleLabel;

  static Color handoffStatusColor(HandoffStatus status) => switch (status) {
        HandoffStatus.draft => VocleColors.textMuted,
        HandoffStatus.submitted => VocleColors.warning,
        HandoffStatus.acknowledged => VocleColors.success,
      };

  static Color handoffLifecycleColor(HandoffModel handoff) {
    final label = handoff.lifecycleLabel;
    if (label == 'Not attended') return VocleColors.emergency;
    if (label == 'Completed') return VocleColors.success;
    return handoffStatusColor(handoff.status);
  }

  /// Soft chip background/foreground for handoff lifecycle.
  static (Color bg, Color fg, String label) statusChip(HandoffModel handoff) {
    final key = handoff.lifecycleLabel.toLowerCase();
    if (key.contains('not attended')) {
      return (const Color(0xFFFFF0F1), const Color(0xFFB91C1C), 'Not attended');
    }
    if (key.contains('completed') || key.contains('done')) {
      return (VocleColors.tealBg, const Color(0xFF00856F), 'Done');
    }
    return switch (handoff.status) {
      HandoffStatus.draft => (
          const Color(0xFFF3F4F6),
          const Color(0xFF6B7280),
          'Draft',
        ),
      HandoffStatus.submitted => (
          const Color(0xFFFFF7ED),
          const Color(0xFFB45309),
          'Pending',
        ),
      HandoffStatus.acknowledged => (
          const Color(0xFFEFF6FF),
          VocleColors.blue,
          'Active',
        ),
    };
  }
}
