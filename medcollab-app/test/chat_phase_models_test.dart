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
    test('canMessage does not imply canRequest (open DM vs request)', () {
      final known = UserLookupResult.fromJson({
        'user': {'_id': 'u1', 'name': 'Dr Test'},
        'relationship': 'known',
        'canMessage': true,
      });
      expect(known.canMessage, isTrue);
      expect(known.canRequest, isFalse);
      expect(known.acceptsMessageRequests, isFalse);

      final requestable = UserLookupResult.fromJson({
        'user': {'_id': 'u2', 'name': 'Dr Other'},
        'relationship': 'group_member',
        'canMessage': false,
        'canRequest': true,
        'sharesGroup': true,
      });
      expect(requestable.canMessage, isFalse);
      expect(requestable.canRequest, isTrue);
      expect(requestable.acceptsMessageRequests, isTrue);
    });

    test('acceptsMessageRequests aliases canRequest from legacy field', () {
      final legacy = UserLookupResult.fromJson({
        'user': {'_id': 'u3', 'name': 'Dr Legacy'},
        'relationship': 'stranger',
        'canMessage': false,
        'acceptsMessageRequests': true,
      });
      expect(legacy.canRequest, isTrue);
      expect(legacy.acceptsMessageRequests, isTrue);
    });
  });
}
