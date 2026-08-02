import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medcollab_app/core/theme/app_colors.dart';

void main() {
  group('availabilityStatusColor', () {
    test('maps known API status strings', () {
      expect(availabilityStatusColor('available'), AppColors.statusSuccess);
      expect(availabilityStatusColor('on_call'), AppColors.statusWarning);
      expect(availabilityStatusColor('in_icu'), AppColors.statusError);
      expect(availabilityStatusColor('on_rounds'), AppColors.tealPrimary);
      expect(availabilityStatusColor('offline'), AppColors.textMuted);
    });

    test('unknown status falls back to muted', () {
      expect(availabilityStatusColor('vacation'), AppColors.textMuted);
    });
  });

  group('handoffAccentColor', () {
    test('maps lifecycle statuses for list accent bar', () {
      expect(handoffAccentColor('submitted'), AppColors.statusPending);
      expect(handoffAccentColor('acknowledged'), AppColors.statusSuccess);
      expect(handoffAccentColor('draft'), AppColors.textMuted);
    });
  });

  group('handoffBadgeColors', () {
    test('returns chip bg/text pairs', () {
      final pending = handoffBadgeColors('submitted');
      expect(pending.bg, AppColors.statusPendTint);
      expect(pending.text, const Color(0xFF9A4F0A));

      final active = handoffBadgeColors('acknowledged');
      expect(active.bg, AppColors.statusSuccTint);
    });
  });
}
