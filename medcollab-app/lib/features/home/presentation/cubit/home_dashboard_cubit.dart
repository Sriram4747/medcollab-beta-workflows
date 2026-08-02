import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:medcollab_app/core/constants/app_enums.dart';
import 'package:medcollab_app/core/error/app_exception.dart';
import 'package:medcollab_app/core/storage/bookmark_service.dart';
import 'package:medcollab_app/core/storage/recent_items_service.dart';
import 'package:medcollab_app/features/channels/data/repositories/channel_repository.dart';
import 'package:medcollab_app/features/handoffs/data/repositories/handoff_repository.dart';
import 'package:medcollab_app/features/home/data/dashboard_preferences_service.dart';
import 'package:medcollab_app/features/home/presentation/cubit/home_dashboard_state.dart';
import 'package:medcollab_app/features/notifications/data/models/notification_model.dart';
import 'package:medcollab_app/features/notifications/data/repositories/notification_repository.dart';
import 'package:medcollab_app/features/spaces/data/models/channel_model.dart';
import 'package:medcollab_app/features/spaces/data/repositories/space_repository.dart';

class HomeDashboardCubit extends Cubit<HomeDashboardState> {
  HomeDashboardCubit({
    required SpaceRepository spaceRepository,
    required HandoffRepository handoffRepository,
    required ChannelRepository channelRepository,
    required NotificationRepository notificationRepository,
    required RecentItemsService recentItemsService,
    required BookmarkService bookmarkService,
    required DashboardPreferencesService dashboardPreferencesService,
    required this.currentUserId,
  })  : _spaceRepository = spaceRepository,
        _handoffRepository = handoffRepository,
        _channelRepository = channelRepository,
        _notificationRepository = notificationRepository,
        _recentItemsService = recentItemsService,
        _bookmarkService = bookmarkService,
        _dashboardPreferencesService = dashboardPreferencesService,
        super(const HomeDashboardState()) {
    load();
  }

  final SpaceRepository _spaceRepository;
  final HandoffRepository _handoffRepository;
  final ChannelRepository _channelRepository;
  final NotificationRepository _notificationRepository;
  final RecentItemsService _recentItemsService;
  final BookmarkService _bookmarkService;
  final DashboardPreferencesService _dashboardPreferencesService;
  final String currentUserId;

  Future<void> load() async {
    emit(state.copyWith(isLoading: true, error: null));
    try {
      final spaces = await _spaceRepository.getMySpaces();
      final handoffs = await _handoffRepository.getMyHandoffs();
      final notificationsPage =
          await _notificationRepository.getNotifications(limit: 50);
      final recentSpaces = await _recentItemsService.getRecentSpaces();
      final recentChannels = await _recentItemsService.getRecentChannels();
      final pinnedItems = await _recentItemsService.getPinnedItems();
      final bookmarks = await _bookmarkService.getAll();
      final widgetPreferences = await _dashboardPreferencesService.load();

      // DMs require Sprint 8 backend (`GET /api/channels/dm`). Do not fail Home.
      List<ChannelModel> recentDms = const [];
      try {
        recentDms = await _channelRepository.getMyDMs();
      } catch (_) {
        recentDms = const [];
      }

      final notifications = notificationsPage.notifications;

      final pendingHandoffs = handoffs
          .where(
            (h) =>
                h.status == HandoffStatus.submitted &&
                h.toUser.id == currentUserId,
          )
          .length;

      final assignedHandoffs = handoffs
          .where(
            (handoff) =>
                handoff.toUser.id == currentUserId &&
                handoff.status != HandoffStatus.draft,
          )
          .toList()
        ..sort(
          (a, b) => (b.lastUpdated ?? b.shiftDate ?? DateTime(0)).compareTo(
            a.lastUpdated ?? a.shiftDate ?? DateTime(0),
          ),
        );

      final now = DateTime.now();
      final todayHandoffs = assignedHandoffs.where((handoff) {
        final date = handoff.shiftDate;
        return date != null &&
            date.year == now.year &&
            date.month == now.month &&
            date.day == now.day;
      }).toList();

      final unreadMentions = notifications
          .where(
              (n) => !n.read && n.category == AppNotificationCategory.mention)
          .length;

      final unreadThreads = notifications
          .where((n) => !n.read && n.category == AppNotificationCategory.reply)
          .length;

      final inviteCount = notifications
          .where((n) => !n.read && n.category == AppNotificationCategory.invite)
          .length;

      final hospitalAnnouncements = <AnnouncementPreview>[];
      final departmentAnnouncements = <AnnouncementPreview>[];
      final patientDiscussions = <PatientDiscussionPreview>[];
      for (final space in spaces) {
        for (final channel in space.channels) {
          if (channel.type == ChannelType.announcements &&
              channel.lastMessage?.text != null) {
            final preview = AnnouncementPreview(
              spaceName: space.name,
              channelName: channel.displayName,
              text: channel.lastMessage!.text!,
              spaceId: space.id,
              channelId: channel.id,
              sentAt: channel.lastMessage!.sentAt,
            );
            if (space.type == SpaceType.hospital) {
              hospitalAnnouncements.add(preview);
            } else if (space.type == SpaceType.department) {
              departmentAnnouncements.add(preview);
            }
          } else if (channel.type != ChannelType.direct &&
              channel.lastMessage?.text != null) {
            patientDiscussions.add(
              PatientDiscussionPreview(
                spaceName: space.name,
                channelName: channel.displayName,
                text: channel.lastMessage!.text!,
                spaceId: space.id,
                channelId: channel.id,
                senderName: channel.lastMessage!.senderName,
                sentAt: channel.lastMessage!.sentAt,
              ),
            );
          }
        }
      }
      int newestFirst(DateTime? a, DateTime? b) {
        final at = a ?? DateTime.fromMillisecondsSinceEpoch(0);
        final bt = b ?? DateTime.fromMillisecondsSinceEpoch(0);
        return bt.compareTo(at);
      }

      hospitalAnnouncements.sort(
        (a, b) => newestFirst(a.sentAt, b.sentAt),
      );
      departmentAnnouncements.sort(
        (a, b) => newestFirst(a.sentAt, b.sentAt),
      );
      patientDiscussions.sort(
        (a, b) => newestFirst(a.sentAt, b.sentAt),
      );

      emit(
        state.copyWith(
          isLoading: false,
          spaces: spaces,
          handoffs: handoffs,
          unreadNotifications: notificationsPage.unreadCount,
          unreadMentions: unreadMentions,
          pendingHandoffs: pendingHandoffs,
          unreadThreads: unreadThreads,
          inviteCount: inviteCount,
          bookmarkCount: bookmarks.length,
          recentSpaces: recentSpaces,
          recentChannels: recentChannels,
          pinnedItems: pinnedItems,
          assignedHandoffs: assignedHandoffs.take(5).toList(),
          todayHandoffs: todayHandoffs,
          patientDiscussions: patientDiscussions.take(5).toList(),
          recentDms: recentDms.take(5).toList(),
          hospitalAnnouncements: hospitalAnnouncements.take(5).toList(),
          departmentAnnouncements: departmentAnnouncements.take(5).toList(),
          widgetPreferences: widgetPreferences,
        ),
      );
    } on AppException catch (e) {
      emit(state.copyWith(isLoading: false, error: e.message));
    } catch (_) {
      emit(state.copyWith(isLoading: false, error: 'Could not load workspace'));
    }
  }

  Future<void> saveWidgetPreferences(
    List<DashboardWidgetPreference> preferences,
  ) async {
    await _dashboardPreferencesService.save(preferences);
    emit(state.copyWith(widgetPreferences: List.of(preferences)));
  }

  Future<void> resetWidgetPreferences() async {
    await _dashboardPreferencesService.reset();
    emit(
      state.copyWith(
        widgetPreferences: List.of(
          DashboardPreferencesService.defaultPreferences,
        ),
      ),
    );
  }
}
