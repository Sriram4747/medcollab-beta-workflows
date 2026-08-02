import 'package:flutter_test/flutter_test.dart';
import 'package:medcollab_app/core/chat/active_chat_tracker.dart';
import 'package:medcollab_app/core/constants/app_enums.dart';
import 'package:medcollab_app/core/theme/app_colors.dart';
import 'package:medcollab_app/core/utils/clinical_formatters.dart';

void main() {
  group('ActiveChatTracker', () {
    tearDown(() {
      final id = ActiveChatTracker.instance.channelId;
      if (id != null) ActiveChatTracker.instance.leave(id);
    });

    test('tracks enter / leave / isViewing', () {
      final tracker = ActiveChatTracker.instance;
      expect(tracker.isViewing('abc'), isFalse);
      tracker.enter('abc');
      expect(tracker.isViewing('abc'), isTrue);
      expect(tracker.isViewing('xyz'), isFalse);
      tracker.leave('abc');
      expect(tracker.isViewing('abc'), isFalse);
    });
  });

  group('AvailabilityStatus.offline', () {
    test('parses and labels Offline', () {
      expect(
        AvailabilityStatus.fromString('offline'),
        AvailabilityStatus.offline,
      );
      expect(availabilityLabel(AvailabilityStatus.offline), 'Offline');
      expect(
        availabilityStatusColor('offline'),
        AppColors.textMuted,
      );
    });
  });
}
