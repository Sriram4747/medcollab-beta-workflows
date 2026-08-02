import 'package:flutter/material.dart';

/// Vocle radii — [VOCLE_UI_REDESIGN_CURSOR_BRIEF.md] §4.
abstract final class AppRadius {
  static const BorderRadius chip = BorderRadius.all(Radius.circular(4));
  static const BorderRadius button = BorderRadius.all(Radius.circular(8));
  static const BorderRadius card = BorderRadius.all(Radius.circular(12));
  static const BorderRadius sheet = BorderRadius.all(Radius.circular(16));
  static const BorderRadius pill = BorderRadius.all(Radius.circular(999));
  static const BorderRadius avatar = BorderRadius.all(Radius.circular(999));
  static const BorderRadius groupIcon = BorderRadius.all(Radius.circular(10));

  /// Scalar helpers when a [BorderRadius] is not needed.
  static const double chipValue = 4;
  static const double buttonValue = 8;
  static const double cardValue = 12;
  static const double sheetValue = 16;
  static const double groupIconValue = 10;
  static const double subgroupIconValue = 9;
}

/// Vocle layout spacing — [VOCLE_UI_REDESIGN_CURSOR_BRIEF.md] §4.
///
/// Prefer these on redesign screens. Legacy [AppSpacing] (xxs/xs/sm…) remains
/// in `app_spacing.dart` for existing call sites until later steps migrate.
abstract final class AppGaps {
  static const double screenH = 16;
  static const double cardV = 12;
  static const double cardH = 14;
  static const double sectionGap = 16;
  static const double itemGap = 6;
}
