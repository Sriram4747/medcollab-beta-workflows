import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

enum DashboardWidgetId {
  todayShift,
  availability,
  assignedHandoffs,
  pendingTasks,
  patientDiscussions,
  recentDms,
  quickActions,
  emergency,
  hospitalAnnouncements,
  departmentAnnouncements,
}

extension DashboardWidgetIdLabel on DashboardWidgetId {
  String get label => switch (this) {
        DashboardWidgetId.todayShift => "Today's shift",
        DashboardWidgetId.availability => 'Current availability',
        DashboardWidgetId.assignedHandoffs => 'Assigned handoffs',
        DashboardWidgetId.pendingTasks => 'Pending tasks',
        DashboardWidgetId.patientDiscussions => 'Recent patient discussions',
        DashboardWidgetId.recentDms => 'Recent DMs',
        DashboardWidgetId.quickActions => 'Quick actions',
        DashboardWidgetId.emergency => 'Emergency button',
        DashboardWidgetId.hospitalAnnouncements => 'Hospital announcements',
        DashboardWidgetId.departmentAnnouncements => 'Department announcements',
      };
}

class DashboardWidgetPreference {
  const DashboardWidgetPreference({
    required this.id,
    this.isVisible = true,
  });

  factory DashboardWidgetPreference.fromJson(Map<String, dynamic> json) {
    final rawId = json['id'] as String?;
    final id = DashboardWidgetId.values.cast<DashboardWidgetId?>().firstWhere(
          (value) => value?.name == rawId,
          orElse: () => null,
        );
    if (id == null) {
      throw const FormatException('Unknown dashboard widget');
    }
    return DashboardWidgetPreference(
      id: id,
      isVisible: json['isVisible'] as bool? ?? true,
    );
  }

  final DashboardWidgetId id;
  final bool isVisible;

  DashboardWidgetPreference copyWith({bool? isVisible}) {
    return DashboardWidgetPreference(
      id: id,
      isVisible: isVisible ?? this.isVisible,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id.name,
        'isVisible': isVisible,
      };
}

/// Stores the doctor's Home widget visibility and ordering on this device.
class DashboardPreferencesService {
  DashboardPreferencesService({SharedPreferences? preferences})
      : _preferences = preferences;

  SharedPreferences? _preferences;

  static const _key = 'medcollab_dashboard_widgets_v4';

  /// Vocle Home (v4 / redesign Steps 3): navy header owns shift + availability.
  /// Body defaults: emergency → pending handoffs → quick actions (2 cards).
  /// Inbox/announcement widgets stay off by default.
  static const defaultPreferences = [
    DashboardWidgetPreference(id: DashboardWidgetId.todayShift),
    DashboardWidgetPreference(id: DashboardWidgetId.availability),
    DashboardWidgetPreference(id: DashboardWidgetId.emergency),
    DashboardWidgetPreference(id: DashboardWidgetId.assignedHandoffs),
    DashboardWidgetPreference(id: DashboardWidgetId.quickActions),
    DashboardWidgetPreference(
      id: DashboardWidgetId.pendingTasks,
      isVisible: false,
    ),
    DashboardWidgetPreference(
      id: DashboardWidgetId.patientDiscussions,
      isVisible: false,
    ),
    DashboardWidgetPreference(
      id: DashboardWidgetId.recentDms,
      isVisible: false,
    ),
    DashboardWidgetPreference(
      id: DashboardWidgetId.hospitalAnnouncements,
      isVisible: false,
    ),
    DashboardWidgetPreference(
      id: DashboardWidgetId.departmentAnnouncements,
      isVisible: false,
    ),
  ];

  Future<List<DashboardWidgetPreference>> load() async {
    _preferences ??= await SharedPreferences.getInstance();
    final raw = _preferences!.getString(_key);
    if (raw == null) return List.of(defaultPreferences);

    try {
      final decoded = jsonDecode(raw) as List<dynamic>;
      final saved = decoded
          .whereType<Map<String, dynamic>>()
          .map(DashboardWidgetPreference.fromJson)
          .toList();

      // Append widgets introduced by newer app versions.
      for (final preference in defaultPreferences) {
        if (!saved.any((item) => item.id == preference.id)) {
          saved.add(preference);
        }
      }
      return saved;
    } catch (_) {
      return List.of(defaultPreferences);
    }
  }

  Future<void> save(List<DashboardWidgetPreference> preferences) async {
    _preferences ??= await SharedPreferences.getInstance();
    await _preferences!.setString(
      _key,
      jsonEncode(preferences.map((item) => item.toJson()).toList()),
    );
  }

  Future<void> reset() => save(List.of(defaultPreferences));
}
