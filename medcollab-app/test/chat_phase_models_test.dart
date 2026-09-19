import 'package:flutter_test/flutter_test.dart';
import 'package:medcollab_app/core/constants/app_enums.dart';
import 'package:medcollab_app/features/auth/data/models/notification_preferences_model.dart';
import 'package:medcollab_app/features/messages/data/models/message_reply_to.dart';
import 'package:medcollab_app/features/messages/data/models/user_lookup_result.dart';

void main() {
  group('MessageReplyTo', () {
    test('parses snapshot and builds preview labels', () {
      final reply = MessageReplyTo.fromJson({
        'messageId': 'abc123',
        'senderName': 'Dr Priya',
        'text': 'Labs pending',
        'type': 'text',
      });
      expect(reply.messageId, 'abc123');
      expect(reply.previewLabel, 'Labs pending');
      expect(reply.type, MessageType.text);
    });

    test('empty messageId is ignored by parser', () {
      expect(parseMessageReplyTo({'messageId': null}), isNull);
      expect(parseMessageReplyTo({}), isNull);
    });

    test('media types get friendly labels when text empty', () {
      final photo = MessageReplyTo.fromMessage(
        messageId: '1',
        senderName: 'Dr A',
        type: MessageType.image,
      );
      expect(photo.previewLabel, 'Photo');
    });
  });

  group('NotificationPreferencesModel', () {
    test('defaults message requests to off (opt-in)', () {
      const prefs = NotificationPreferencesModel();
      expect(prefs.allowMessageRequestsFromAnyone, isFalse);
      expect(prefs.readReceiptsEnabled, isTrue);
    });

    test('round-trips allowMessageRequestsFromAnyone', () {
      final prefs = NotificationPreferencesModel.fromJson({
        'allowMessageRequestsFromAnyone': true,
      });
      expect(prefs.allowMessageRequestsFromAnyone, isTrue);
      expect(prefs.toJson()['allowMessageRequestsFromAnyone'], isTrue);
    });
  });

  group('UserLookupResult', () {
    test('acceptsMessageRequests falls back to canMessage', () {
      final json = {
        'user': {'_id': 'u1', 'name': 'Dr Test'},
        'relationship': 'known',
        'canMessage': true,
      };
      final result = UserLookupResult.fromJson(json);
      expect(result.canMessage, isTrue);
      expect(result.acceptsMessageRequests, isTrue);
    });
  });
}
