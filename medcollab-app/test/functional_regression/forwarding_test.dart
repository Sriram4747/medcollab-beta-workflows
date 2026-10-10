import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medcollab_app/core/di/app_dependencies.dart';
import 'package:medcollab_app/core/error/app_exception.dart';
import 'package:medcollab_app/core/constants/app_enums.dart';
import 'package:medcollab_app/features/auth/data/models/user_model.dart';
import 'package:medcollab_app/features/channels/data/repositories/channel_repository.dart';
import 'package:medcollab_app/features/messages/data/models/message_model.dart';
import 'package:medcollab_app/features/messages/presentation/widgets/forward_message_sheet.dart';
import 'package:medcollab_app/features/spaces/data/models/channel_model.dart';
import 'package:medcollab_app/features/spaces/data/models/space_model.dart';
import 'package:medcollab_app/features/spaces/data/repositories/space_repository.dart';

import 'fakes/chat_fakes.dart';

class _ForwardChannels extends ChannelRepository {
  _ForwardChannels() : super(apiClient: isolatedApiClient());
  @override
  Future<List<ChannelModel>> getMyDMs() async => const [
    ChannelModel(id: 'destination-dm', name: 'Doctor Ben', type: ChannelType.direct),
  ];
}

class _ForwardSpaces extends SpaceRepository {
  _ForwardSpaces() : super(apiClient: isolatedApiClient());
  @override
  Future<List<SpaceModel>> getMySpaces() async => const [
    SpaceModel(id: 'space-synthetic', name: 'Synthetic ward', channels: [
      ChannelModel(id: 'source-channel', name: 'Source channel'),
      ChannelModel(id: 'destination-group', name: 'Team group'),
    ]),
  ];
}

void main() {
  testWidgets('FR-LINK-01: forwarding retains payload and sheet on failure', (tester) async {
    final messages = FakeMessageRepository();
    final deps = AppDependencies.instance;
    deps.channelRepository = _ForwardChannels();
    deps.spaceRepository = _ForwardSpaces();
    deps.messageRepository = messages;
    const source = MessageModel(
      id: 'source-message',
      channelId: 'source-channel',
      sender: UserModel(id: 'doctor-a', name: 'Doctor A'),
      content: MessageContent(
        text: 'Synthetic shift note',
        mediaUrl: 'https://synthetic.invalid/file.jpg',
      ),
    );
    final sent = <String>[];
    var fail = true;
    messages.onSendText = (text, replyTo) async {
      sent.add(text);
      if (fail) {
        fail = false;
        throw const ServerException('Synthetic forward failure');
      }
      return const MessageModel(
        id: 'forwarded-message',
        channelId: 'destination-group',
        sender: UserModel(id: 'doctor-b', name: 'Doctor B'),
        content: MessageContent(text: 'Forwarded'),
      );
    };
    await tester.pumpWidget(MaterialApp(home: Scaffold(body: Builder(
      builder: (context) => TextButton(
        onPressed: () => showForwardMessageSheet(
          context, message: source, sourceChannelId: 'source-channel',
        ),
        child: const Text('Forward source'),
      ),
    ))));
    await tester.tap(find.text('Forward source'));
    await tester.pumpAndSettle();
    expect(find.text('Doctor Ben'), findsOneWidget);
    expect(find.text('#Team group'), findsOneWidget);
    expect(find.text('#Source channel'), findsNothing,
        reason: 'The source must not be a forwarding target');

    await tester.tap(find.text('#Team group'));
    await tester.pumpAndSettle();
    expect(sent.length, 1);
    expect(find.text('Forward message'), findsOneWidget,
        reason: 'A failed send keeps the target sheet open for retry');
    expect(find.text('Synthetic forward failure'), findsOneWidget);
    await tester.tap(find.text('#Team group'));
    await tester.pumpAndSettle();
    expect(sent.length, 2);
    expect(messages.textSendCount, 2);
    expect(find.text('Forward message'), findsNothing);
    expect(messages.sentChannelIds, ['destination-group', 'destination-group']);
    expect(sent.last, contains('Forwarded from Doctor A'));
    expect(sent.last, contains('vocle://c/source-channel/m/source-message'));
    expect(sent.last, contains('Synthetic shift note'));
    expect(sent.last, contains('https://synthetic.invalid/file.jpg'));
    expect(sent.first, sent.last,
        reason: 'Retry must preserve exact source attribution and media URL');
  });
}
