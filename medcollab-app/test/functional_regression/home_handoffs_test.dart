import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:medcollab_app/core/constants/app_enums.dart';
import 'package:medcollab_app/core/storage/bookmark_service.dart';
import 'package:medcollab_app/core/storage/recent_items_service.dart';
import 'package:medcollab_app/features/auth/data/models/user_model.dart';
import 'package:medcollab_app/features/channels/data/repositories/channel_repository.dart';
import 'package:medcollab_app/features/handoffs/data/models/handoff_model.dart';
import 'package:medcollab_app/features/handoffs/data/repositories/handoff_repository.dart';
import 'package:medcollab_app/features/home/data/dashboard_preferences_service.dart';
import 'package:medcollab_app/features/home/presentation/cubit/home_dashboard_cubit.dart';
import 'package:medcollab_app/features/home/presentation/widgets/doctor_workspace_widgets.dart';
import 'package:medcollab_app/features/notifications/data/models/notification_model.dart';
import 'package:medcollab_app/features/notifications/data/repositories/notification_repository.dart';
import 'package:medcollab_app/features/spaces/data/models/channel_model.dart';
import 'package:medcollab_app/features/spaces/data/models/space_model.dart';
import 'package:medcollab_app/features/spaces/data/repositories/space_repository.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'fakes/chat_fakes.dart';

const _doctorA = UserModel(id: 'doctor-a', name: 'Doctor A');
const _doctorB = UserModel(id: 'doctor-b', name: 'Doctor B');
const _doctorC = UserModel(id: 'doctor-c', name: 'Doctor C');

class _Spaces extends SpaceRepository {
  _Spaces() : super(apiClient: isolatedApiClient());
  @override
  Future<List<SpaceModel>> getMySpaces() async => const [];
}

class _Channels extends ChannelRepository {
  _Channels() : super(apiClient: isolatedApiClient());
  @override
  Future<List<ChannelModel>> getMyDMs() async => const [];
}

class _Notifications extends NotificationRepository {
  _Notifications() : super(apiClient: isolatedApiClient());
  @override
  Future<NotificationsPageResult> getNotifications({
    bool unreadOnly = false, String? before, String? type, int limit = 30,
  }) async => const NotificationsPageResult(notifications: [], hasMore: false, unreadCount: 0);
}

class _Handoffs extends HandoffRepository {
  _Handoffs() : super(apiClient: isolatedApiClient());
  List<HandoffModel> server = [];
  int reads = 0;
  @override
  Future<List<HandoffModel>> getMyHandoffs({
    String? spaceId, String type = 'all', HandoffStatus? status,
  }) async {
    reads++;
    return List.of(server);
  }
}

HandoffModel _handoff(String id, UserModel assignee, HandoffStatus status,
    DateTime shiftDate) => HandoffModel(
  id: id,
  spaceId: 'space-synthetic-1',
  channelId: 'channel-synthetic-1',
  fromUser: _doctorA,
  toUser: assignee,
  shiftDate: shiftDate,
  shiftType: ShiftType.morning,
  shiftSummary: 'Synthetic shift $id',
  status: status,
);

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  testWidgets('FR-HOME-02: assigned, shift and task cards follow refreshed handoffs', (tester) async {
    SharedPreferences.setMockInitialValues({});
    final storage = await SharedPreferences.getInstance();
    final handoffs = _Handoffs();
    final now = DateTime.now();
    final today = DateTime(now.year, now.month, now.day, 12);
    handoffs.server = [
      _handoff('assigned', _doctorB, HandoffStatus.submitted, today),
      _handoff('other-doctor', _doctorC, HandoffStatus.submitted, today),
      _handoff('draft', _doctorB, HandoffStatus.draft, today),
    ];
    final dashboard = HomeDashboardCubit(
      spaceRepository: _Spaces(),
      handoffRepository: handoffs,
      channelRepository: _Channels(),
      notificationRepository: _Notifications(),
      recentItemsService: RecentItemsService(prefs: storage),
      bookmarkService: BookmarkService(prefs: storage),
      dashboardPreferencesService: DashboardPreferencesService(preferences: storage),
      currentUserId: _doctorB.id,
    );
    addTearDown(dashboard.close);
    await dashboard.load();
    expect(dashboard.state.isLoading, isFalse);
    expect(dashboard.state.error, isNull);
    expect(dashboard.state.assignedHandoffs.map((h) => h.id), ['assigned']);
    expect(dashboard.state.todayHandoffs.map((h) => h.id), ['assigned']);
    expect(dashboard.state.pendingHandoffs, 1);
    expect(dashboard.state.pendingTaskCount, 1);
    Future<void> renderCards() async {
      await tester.pumpWidget(MaterialApp(home: Scaffold(body: SingleChildScrollView(
        child: Column(children: [
          TodayShiftWidget(handoffs: dashboard.state.todayHandoffs, onOpenHandoffs: () {}),
          AssignedHandoffsWidget(handoffs: dashboard.state.assignedHandoffs),
          PendingTasksWidget(state: dashboard.state),
        ]),
      ))));
    }
    await renderCards();
    expect(find.text('Synthetic shift assigned'), findsOneWidget);
    expect(find.text('Handoffs awaiting action'), findsOneWidget);
    expect(find.text('No pending handoffs'), findsNothing);

    handoffs.server = [
      _handoff('assigned', _doctorB, HandoffStatus.acknowledged, today),
      _handoff('other-doctor', _doctorC, HandoffStatus.submitted, today),
    ];
    await dashboard.load(silent: true);
    expect(dashboard.state.assignedHandoffs, isEmpty);
    expect(dashboard.state.todayHandoffs, isEmpty);
    expect(dashboard.state.pendingHandoffs, 0);
    expect(dashboard.state.pendingTaskCount, 0);
    await renderCards();
    expect(find.text('No shift assignment for today'), findsOneWidget);
    expect(find.text('No pending handoffs'), findsOneWidget);
    expect(find.text('All caught up'), findsOneWidget);

    handoffs.server = [
      _handoff('assigned', _doctorC, HandoffStatus.submitted, today),
    ];
    await dashboard.load(silent: true);
    expect(dashboard.state.assignedHandoffs, isEmpty,
        reason: 'Reassigned handoff belongs to the new assignee');
    expect(dashboard.state.todayHandoffs, isEmpty);
    expect(dashboard.state.pendingTaskCount, 0);
    expect(handoffs.reads, greaterThanOrEqualTo(3));
  });
}
