import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medcollab_app/core/constants/app_enums.dart';
import 'package:medcollab_app/core/theme/app_colors.dart';
import 'package:medcollab_app/features/handoffs/presentation/utils/handoff_priority_colors.dart';

void main() {
  group('HandoffPriorityColors', () {
    test('forStatus maps patient severity to palette', () {
      expect(
        HandoffPriorityColors.forStatus(PatientStatus.critical),
        AppColors.emergency,
      );
      expect(
        HandoffPriorityColors.forStatus(PatientStatus.stable),
        AppColors.success,
      );
      expect(
        HandoffPriorityColors.forStatus(PatientStatus.deteriorating),
        AppColors.urgent,
      );
    });

    test('statusLabel returns human-readable copy', () {
      expect(
        HandoffPriorityColors.statusLabel(PatientStatus.monitoring),
        'Monitoring',
      );
      expect(
        HandoffPriorityColors.handoffStatusLabel(HandoffStatus.submitted),
        'Pending',
      );
    });

    test('handoffStatusColor matches redesign tokens', () {
      expect(
        HandoffPriorityColors.handoffStatusColor(HandoffStatus.acknowledged),
        VocleColors.success,
      );
      expect(
        HandoffPriorityColors.handoffStatusColor(HandoffStatus.submitted),
        VocleColors.warning,
      );
    });
  });
}
