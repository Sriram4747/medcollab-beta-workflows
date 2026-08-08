import 'package:flutter_test/flutter_test.dart';
import 'package:medcollab_app/core/utils/phone_utils.dart';

void main() {
  group('PhoneUtils.validateLocalNumber', () {
    test('accepts valid Indian mobile', () {
      expect(PhoneUtils.validateLocalNumber('9812345670'), isNull);
      expect(PhoneUtils.validateLocalNumber('7012345678'), isNull);
    });

    test('rejects repeated digits', () {
      expect(PhoneUtils.validateLocalNumber('9999999999'), isNotNull);
      expect(PhoneUtils.validateLocalNumber('8888888888'), isNotNull);
    });

    test('rejects short numbers', () {
      expect(PhoneUtils.validateLocalNumber('99999999'), isNotNull);
    });
  });

  group('PhoneUtils.extractInviteCode', () {
    test('from join path URL', () {
      expect(
        PhoneUtils.extractInviteCode(
          'https://medcollab.up.railway.app/join/A3K7BX',
        ),
        'A3K7BX',
      );
    });

    test('from deep link', () {
      expect(
        PhoneUtils.extractInviteCode('medcollab:///join/xyz123'),
        'XYZ123',
      );
    });

    test('from raw code', () {
      expect(PhoneUtils.extractInviteCode('a3k7bx'), 'A3K7BX');
    });
  });
}
