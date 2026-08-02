import 'package:equatable/equatable.dart';
import 'package:medcollab_app/core/storage/recent_items_service.dart';
import 'package:medcollab_app/features/handoffs/data/models/handoff_model.dart';
import 'package:medcollab_app/features/home/data/dashboard_preferences_service.dart';
import 'package:medcollab_app/features/spaces/data/models/channel_model.dart';
import 'package:medcollab_app/features/spaces/data/models/space_model.dart';

class HomeDashboardState extends Equatable {
  const HomeDashboardState({
    this.isLoading = true,
    this.error,
    this.spaces = const [],
    this.handoffs = const [],
    this.unreadNotifications = 0,
    this.unreadMentions = 0,
    this.pendingHandoffs = 0,
    this.unreadThreads = 0,
    this.inviteCount = 0,
    this.bookmarkCount = 0,
    this.recentSpaces = const [],
    this.recentChannels = const [],
    this.pinnedItems = const [],
    this.assignedHandoffs = const [],
    this.todayHandoffs = const [],
    this.patientDiscussions = const [],
    this.recentDms = const [],
    this.hospitalAnnouncements = const [],
    this.departmentAnnouncements = const [],
    this.widgetPreferences = DashboardPreferencesService.defaultPreferences,
  });

  final bool isLoading;
  final String? error;
  final List<SpaceModel> spaces;
  final List<HandoffModel> handoffs;
  final int unreadNotifications;
  final int unreadMentions;
  final int pendingHandoffs;
  final int unreadThreads;
  final int inviteCount;
  final int bookmarkCount;
  final List<RecentSpaceItem> recentSpaces;
  final List<RecentChannelItem> recentChannels;
  final List<PinnedHomeItem> pinnedItems;
  final List<HandoffModel> assignedHandoffs;
  final List<HandoffModel> todayHandoffs;
  final List<PatientDiscussionPreview> patientDiscussions;
  final List<ChannelModel> recentDms;
  final List<AnnouncementPreview> hospitalAnnouncements;
  final List<AnnouncementPreview> departmentAnnouncements;
  final List<DashboardWidgetPreference> widgetPreferences;

  int get pendingTaskCount =>
      unreadMentions + unreadThreads + pendingHandoffs + inviteCount;

  HomeDashboardState copyWith({
    bool? isLoading,
    String? error,
    List<SpaceModel>? spaces,
    List<HandoffModel>? handoffs,
    int? unreadNotifications,
    int? unreadMentions,
    int? pendingHandoffs,
    int? unreadThreads,
    int? inviteCount,
    int? bookmarkCount,
    List<RecentSpaceItem>? recentSpaces,
    List<RecentChannelItem>? recentChannels,
    List<PinnedHomeItem>? pinnedItems,
    List<HandoffModel>? assignedHandoffs,
    List<HandoffModel>? todayHandoffs,
    List<PatientDiscussionPreview>? patientDiscussions,
    List<ChannelModel>? recentDms,
    List<AnnouncementPreview>? hospitalAnnouncements,
    List<AnnouncementPreview>? departmentAnnouncements,
    List<DashboardWidgetPreference>? widgetPreferences,
  }) {
    return HomeDashboardState(
      isLoading: isLoading ?? this.isLoading,
      error: error,
      spaces: spaces ?? this.spaces,
      handoffs: handoffs ?? this.handoffs,
      unreadNotifications: unreadNotifications ?? this.unreadNotifications,
      unreadMentions: unreadMentions ?? this.unreadMentions,
      pendingHandoffs: pendingHandoffs ?? this.pendingHandoffs,
      unreadThreads: unreadThreads ?? this.unreadThreads,
      inviteCount: inviteCount ?? this.inviteCount,
      bookmarkCount: bookmarkCount ?? this.bookmarkCount,
      recentSpaces: recentSpaces ?? this.recentSpaces,
      recentChannels: recentChannels ?? this.recentChannels,
      pinnedItems: pinnedItems ?? this.pinnedItems,
      assignedHandoffs: assignedHandoffs ?? this.assignedHandoffs,
      todayHandoffs: todayHandoffs ?? this.todayHandoffs,
      patientDiscussions: patientDiscussions ?? this.patientDiscussions,
      recentDms: recentDms ?? this.recentDms,
      hospitalAnnouncements:
          hospitalAnnouncements ?? this.hospitalAnnouncements,
      departmentAnnouncements:
          departmentAnnouncements ?? this.departmentAnnouncements,
      widgetPreferences: widgetPreferences ?? this.widgetPreferences,
    );
  }

  @override
  List<Object?> get props => [
        isLoading,
        error,
        spaces,
        handoffs,
        unreadNotifications,
        unreadMentions,
        pendingHandoffs,
        unreadThreads,
        inviteCount,
        bookmarkCount,
        recentSpaces,
        recentChannels,
        pinnedItems,
        assignedHandoffs,
        todayHandoffs,
        patientDiscussions,
        recentDms,
        hospitalAnnouncements,
        departmentAnnouncements,
        widgetPreferences,
      ];
}

class PatientDiscussionPreview extends Equatable {
  const PatientDiscussionPreview({
    required this.spaceName,
    required this.channelName,
    required this.text,
    required this.spaceId,
    required this.channelId,
    this.senderName,
    this.sentAt,
  });

  final String spaceName;
  final String channelName;
  final String text;
  final String spaceId;
  final String channelId;
  final String? senderName;
  final DateTime? sentAt;

  @override
  List<Object?> get props => [
        spaceName,
        channelName,
        text,
        spaceId,
        channelId,
        senderName,
        sentAt,
      ];
}

class AnnouncementPreview extends Equatable {
  const AnnouncementPreview({
    required this.spaceName,
    required this.channelName,
    required this.text,
    required this.spaceId,
    required this.channelId,
    this.sentAt,
  });

  final String spaceName;
  final String channelName;
  final String text;
  final String spaceId;
  final String channelId;
  final DateTime? sentAt;

  @override
  List<Object?> get props =>
      [spaceName, channelName, text, spaceId, channelId, sentAt];
}
