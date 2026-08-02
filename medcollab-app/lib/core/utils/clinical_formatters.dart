import 'package:flutter/material.dart';
import 'package:medcollab_app/core/constants/app_enums.dart';
import 'package:medcollab_app/core/theme/app_colors.dart';

/// Time-of-day greeting for the clinical workspace home screen.
String clinicalGreeting(DateTime now) {
  final hour = now.hour;
  if (hour >= 5 && hour < 12) return 'Good morning';
  if (hour >= 12 && hour < 17) return 'Good afternoon';
  if (hour >= 17 && hour < 21) return 'Good evening';
  return 'Good night';
}

String availabilityLabel(AvailabilityStatus status) {
  return switch (status) {
    AvailabilityStatus.available => 'Available',
    AvailabilityStatus.onCall => 'On call',
    AvailabilityStatus.inOt => 'In OT',
    AvailabilityStatus.inIcu => 'In ICU',
    AvailabilityStatus.onRounds => 'On rounds',
    AvailabilityStatus.offDuty => 'Off duty',
    AvailabilityStatus.doNotDisturb => 'Do not disturb',
    AvailabilityStatus.offline => 'Offline',
  };
}

/// Subtitle for availability picker rows (Profile bottom sheet).
String availabilitySubtitle(AvailabilityStatus status) {
  return switch (status) {
    AvailabilityStatus.available => 'Visible to your team',
    AvailabilityStatus.onCall => 'Reachable for emergencies',
    AvailabilityStatus.inOt => 'In operating theatre',
    AvailabilityStatus.inIcu => 'Actively managing critical patient',
    AvailabilityStatus.onRounds => 'On ward rounds',
    AvailabilityStatus.offDuty => 'Not reachable',
    AvailabilityStatus.doNotDisturb => 'Notifications muted',
    AvailabilityStatus.offline => 'Not connected on Vocle',
  };
}

/// Dot / chip color for availability status chips across Home and Profile.
Color availabilityColor(AvailabilityStatus status) {
  return availabilityStatusColor(status.value);
}
