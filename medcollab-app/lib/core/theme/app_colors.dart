import 'package:flutter/material.dart';

/// Vocle color tokens — [VOCLE_UI_REDESIGN_CURSOR_BRIEF.md] §2.
///
/// Source of truth for the redesign sprint. Prefer these names in new UI work.
abstract final class AppColors {
  // ── Brand ────────────────────────────────────────────────────────────────
  static const Color navyPrimary = Color(0xFF0D1B3E);
  static const Color navySecondary = Color(0xFF162952);
  static const Color tealPrimary = Color(0xFF00C2A8);
  static const Color tealDark = Color(0xFF00A88F);
  static const Color tealTint = Color(0xFFE8FBF8);

  // ── Surfaces ─────────────────────────────────────────────────────────────
  static const Color backgroundApp = Color(0xFFF5F7FA);
  static const Color surfaceCard = Color(0xFFFFFFFF);
  static const Color surfaceInput = Color(0xFFF5F7FA);

  // ── Text ─────────────────────────────────────────────────────────────────
  static const Color textPrimary = Color(0xFF0D1B3E);
  static const Color textSecondary = Color(0xFF5A6A85);
  static const Color textMuted = Color(0xFF9CA8B8);
  static const Color textOnDark = Color(0xFFFFFFFF);
  static const Color textOnDarkMuted = Color(0x8DFFFFFF);

  // ── Borders ──────────────────────────────────────────────────────────────
  static const Color borderDefault = Color(0xFFE4E8EF);
  static const Color borderLight = Color(0xFFF0F2F5);

  // ── Semantic — Emergency ─────────────────────────────────────────────────
  static const Color emergencyRed = Color(0xFFDC2626);
  static const Color emergencyTint = Color(0xFFFEE2E2);
  static const Color emergencyBorder = Color(0xFFFCA5A5);

  // ── Semantic — Status ────────────────────────────────────────────────────
  static const Color statusSuccess = Color(0xFF059669);
  static const Color statusSuccTint = Color(0xFFD1FAE5);
  static const Color statusWarning = Color(0xFFD97706);
  static const Color statusWarnTint = Color(0xFFFEF3C7);
  static const Color statusPending = Color(0xFFE8740A);
  static const Color statusPendTint = Color(0xFFFFF3E0);
  static const Color statusError = Color(0xFFDC2626);
  static const Color statusErrorTint = Color(0xFFFEE2E2);
  static const Color statusNeutral = Color(0xFF5A6A85);
  static const Color statusNeutTint = Color(0xFFF1F2F4);

  // ── Compatibility aliases (pre-redesign call sites) ───────────────────────
  static const Color primary = tealPrimary;
  static const Color primaryDark = tealDark;
  static const Color primaryContainer = tealTint;
  static const Color onPrimaryContainer = navyPrimary;
  static const Color primaryMuted = tealTint;
  static const Color primaryLight = tealTint;

  static const Color secondary = navyPrimary;
  static const Color secondaryMuted = navySecondary;

  static const Color accent = statusPending;
  static const Color accentMuted = statusPendTint;

  static const Color background = backgroundApp;
  static const Color surface = surfaceCard;
  static const Color surfaceMuted = surfaceInput;
  static const Color surfaceVariant = borderLight;

  static const Color textTertiary = textMuted;
  static const Color textOnPrimary = textOnDark;

  static const Color success = statusSuccess;
  static const Color successMuted = statusSuccTint;
  static const Color warning = statusWarning;
  static const Color error = statusError;
  static const Color errorMuted = statusErrorTint;
  static const Color emergency = emergencyRed;
  static const Color urgent = statusPending;

  static const Color available = statusSuccess;
  static const Color onCall = statusWarning;
  static const Color inOt = statusNeutral;
  static const Color offDuty = textMuted;
  static const Color busy = statusError;

  static const Color border = borderDefault;
  static const Color borderStrong = Color(0xFFC5CDD8);
  static const Color divider = borderLight;
  static const Color shadow = Color(0x08000000);

  static const Color bubbleMine = navyPrimary;
  static const Color bubbleOther = surfaceCard;
  static const Color bubbleBorderMine = navyPrimary;
  static const Color bubbleBorderOther = borderDefault;
}

/// Availability status → color (brief §2). Accepts API `status` string values.
Color availabilityStatusColor(String status) {
  switch (status) {
    case 'available':
      return AppColors.statusSuccess;
    case 'on_call':
      return AppColors.statusWarning;
    case 'in_ot':
      return AppColors.statusNeutral;
    case 'in_icu':
      return AppColors.statusError;
    case 'on_rounds':
      return AppColors.tealPrimary;
    case 'off_duty':
      return AppColors.textMuted;
    case 'do_not_disturb':
      return AppColors.statusNeutral;
    case 'offline':
      return AppColors.textMuted;
    default:
      return AppColors.textMuted;
  }
}

/// Handoff list accent bar (left 4px) — brief §2.
Color handoffAccentColor(String status) {
  switch (status) {
    case 'submitted':
      return AppColors.statusPending;
    case 'acknowledged':
      return AppColors.statusSuccess;
    case 'draft':
      return AppColors.textMuted;
    default:
      return AppColors.statusError;
  }
}

/// Handoff status badge chip colors — brief §2.
({Color bg, Color text}) handoffBadgeColors(String status) {
  switch (status) {
    case 'submitted':
      return (bg: AppColors.statusPendTint, text: const Color(0xFF9A4F0A));
    case 'acknowledged':
      return (bg: AppColors.statusSuccTint, text: const Color(0xFF065F46));
    case 'draft':
      return (bg: AppColors.statusNeutTint, text: const Color(0xFF374151));
    default:
      return (bg: AppColors.statusErrorTint, text: const Color(0xFF991B1B));
  }
}

/// Temporary aliases used by the interim redesign pass — map onto brief tokens.
abstract final class VocleColors {
  static const Color navy = AppColors.navyPrimary;
  static const Color teal = AppColors.tealPrimary;
  static const Color tealDark = AppColors.tealDark;
  static const Color tealBg = AppColors.tealTint;
  static const Color emergency = AppColors.emergencyRed;
  static const Color emergencyBg = AppColors.emergencyTint;
  static const Color success = AppColors.statusSuccess;
  static const Color warning = AppColors.statusWarning;
  static const Color blue = Color(0xFF1A6FBF);
  static const Color pageBg = AppColors.backgroundApp;
  static const Color surface = AppColors.surfaceCard;
  static const Color border = AppColors.borderDefault;
  static const Color textPrimary = AppColors.textPrimary;
  static const Color textSecondary = AppColors.textSecondary;
  static const Color textMuted = AppColors.textMuted;
}

abstract final class VocleRadius {
  static const double card = 12;
  static const double chip = 20;
  static const double button = 8;
  static const double avatar = 50;
  static const double icon = 8;
}

abstract final class VocleShadows {
  static const BoxShadow card = BoxShadow(
    color: Color(0x08000000),
    blurRadius: 8,
    offset: Offset(0, 2),
  );
  static const BoxShadow emergency = BoxShadow(
    color: Color(0x4DDC2626),
    blurRadius: 16,
    offset: Offset(0, 4),
  );
}
