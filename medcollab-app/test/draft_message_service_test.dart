import 'package:flutter_test/flutter_test.dart';
import 'package:medcollab_app/core/storage/draft_message_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DraftMessageService', () {
    late DraftMessageService service;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      service = DraftMessageService();
    });

    test('saves and retrieves channel draft', () async {
      await service.saveDraft('ch-1', 'Hello ward');
      expect(await service.getDraft('ch-1'), 'Hello ward');
      expect(await service.hasDraft('ch-1'), isTrue);
    });

    test('thread drafts use separate keys from root draft', () async {
      await service.saveDraft('ch-1', 'root text');
      await service.saveDraft('ch-1', 'thread reply', threadId: 'msg-9');

      expect(await service.getDraft('ch-1'), 'root text');
      expect(await service.getDraft('ch-1', threadId: 'msg-9'), 'thread reply');
    });

    test('empty draft removes key', () async {
      await service.saveDraft('ch-1', 'draft');
      await service.saveDraft('ch-1', '   ');

      expect(await service.getDraft('ch-1'), isNull);
      expect(await service.hasDraft('ch-1'), isFalse);
    });

    test('draftChannelIds skips thread keys', () async {
      await service.saveDraft('alpha', 'note');
      await service.saveDraft('beta', 'thread only', threadId: 't1');

      final ids = await service.draftChannelIds();
      expect(ids, {'alpha'});
    });

    test('clearDraft removes stored text', () async {
      await service.saveDraft('ch-2', 'pending');
      await service.clearDraft('ch-2');

      expect(await service.getDraft('ch-2'), isNull);
    });
  });
}
