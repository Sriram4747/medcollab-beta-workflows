import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:medcollab_app/features/home/data/dashboard_preferences_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('DashboardPreferencesService', () {
    late DashboardPreferencesService service;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      service = DashboardPreferencesService(
        preferences: await SharedPreferences.getInstance(),
      );
    });

    test('default prefs hide inbox widgets (lean Home)', () async {
      final prefs = await service.load();

      expect(
        prefs.firstWhere((p) => p.id == DashboardWidgetId.recentDms).isVisible,
        isFalse,
      );
      expect(
        prefs
            .firstWhere((p) => p.id == DashboardWidgetId.patientDiscussions)
            .isVisible,
        isFalse,
      );
      expect(
        prefs.firstWhere((p) => p.id == DashboardWidgetId.emergency).isVisible,
        isTrue,
      );
      expect(
        prefs
            .firstWhere((p) => p.id == DashboardWidgetId.assignedHandoffs)
            .isVisible,
        isTrue,
      );
      expect(
        prefs
            .firstWhere((p) => p.id == DashboardWidgetId.quickActions)
            .isVisible,
        isTrue,
      );
    });

    test('load returns defaults when storage is empty', () async {
      final loaded = await service.load();
      expect(loaded.length, DashboardPreferencesService.defaultPreferences.length);
    });

    test('reset restores v4 lean defaults', () async {
      final noisy = DashboardPreferencesService.defaultPreferences
          .map(
            (p) => p.copyWith(isVisible: true),
          )
          .toList();
      await service.save(noisy);
      await service.reset();

      final afterReset = await service.load();
      expect(
        afterReset
            .firstWhere((p) => p.id == DashboardWidgetId.recentDms)
            .isVisible,
        isFalse,
      );
    });

    test('load merges new widgets from newer app versions', () async {
      SharedPreferences.setMockInitialValues({
        'medcollab_dashboard_widgets_v4': jsonEncode([
          {'id': 'emergency', 'isVisible': true},
        ]),
      });
      final fresh = DashboardPreferencesService(
        preferences: await SharedPreferences.getInstance(),
      );
      final loaded = await fresh.load();

      expect(loaded.any((p) => p.id == DashboardWidgetId.todayShift), isTrue);
      expect(loaded.any((p) => p.id == DashboardWidgetId.emergency), isTrue);
    });

    test('load falls back to defaults on corrupt JSON', () async {
      SharedPreferences.setMockInitialValues({
        'medcollab_dashboard_widgets_v4': 'not-json',
      });
      final fresh = DashboardPreferencesService(
        preferences: await SharedPreferences.getInstance(),
      );
      final loaded = await fresh.load();

      expect(loaded, DashboardPreferencesService.defaultPreferences);
    });
  });
}
