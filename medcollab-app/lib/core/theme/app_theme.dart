import 'package:flutter/material.dart';
import 'package:medcollab_app/core/theme/app_colors.dart';
import 'package:medcollab_app/core/theme/app_design_system.dart';
import 'package:medcollab_app/core/theme/app_radius.dart';
import 'package:medcollab_app/core/theme/app_spacing.dart';
import 'package:medcollab_app/core/theme/app_text_styles.dart';

/// Material theme wired to Vocle redesign tokens (Cursor brief Step 1).
abstract final class AppTheme {
  static ThemeData get light {
    const colorScheme = ColorScheme(
      brightness: Brightness.light,
      primary: AppColors.tealPrimary,
      onPrimary: AppColors.textOnDark,
      primaryContainer: AppColors.tealTint,
      onPrimaryContainer: AppColors.navyPrimary,
      secondary: AppColors.navyPrimary,
      onSecondary: AppColors.textOnDark,
      secondaryContainer: AppColors.navySecondary,
      onSecondaryContainer: AppColors.textOnDark,
      tertiary: AppColors.statusPending,
      onTertiary: AppColors.textOnDark,
      error: AppColors.emergencyRed,
      onError: AppColors.textOnDark,
      surface: AppColors.surfaceCard,
      onSurface: AppColors.textPrimary,
      onSurfaceVariant: AppColors.textSecondary,
      outline: AppColors.borderDefault,
      outlineVariant: AppColors.borderLight,
      shadow: AppColors.shadow,
      surfaceContainerHighest: AppColors.surfaceInput,
      surfaceContainerHigh: AppColors.surfaceCard,
      surfaceContainer: AppColors.backgroundApp,
    );

    return ThemeData(
      useMaterial3: true,
      colorScheme: colorScheme,
      scaffoldBackgroundColor: AppColors.backgroundApp,
      fontFamily: 'Roboto',
      textTheme: AppTextStyles.textTheme,
      iconTheme: const IconThemeData(
        color: AppColors.textSecondary,
        size: AppDesignSystem.iconMd,
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: AppDesignSystem.appBarHeight,
        backgroundColor: AppColors.surfaceCard,
        foregroundColor: AppColors.textPrimary,
        titleTextStyle: AppTextStyles.screenTitle,
        surfaceTintColor: Colors.transparent,
        centerTitle: false,
        iconTheme: const IconThemeData(
          color: AppColors.textSecondary,
          size: AppDesignSystem.iconMd,
        ),
        actionsIconTheme: const IconThemeData(
          color: AppColors.textSecondary,
          size: AppDesignSystem.iconMd,
        ),
      ),
      navigationBarTheme: NavigationBarThemeData(
        elevation: 0,
        height: AppSpacing.minTouchTarget + 8,
        backgroundColor: AppColors.navyPrimary,
        indicatorColor: AppColors.tealPrimary.withValues(alpha: 0.14),
        surfaceTintColor: Colors.transparent,
        labelTextStyle: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return AppTextStyles.caption.copyWith(
              color: AppColors.tealPrimary,
              fontWeight: FontWeight.w500,
              fontSize: 9,
            );
          }
          return AppTextStyles.caption.copyWith(
            color: Colors.white.withValues(alpha: 0.35),
            fontSize: 9,
          );
        }),
        iconTheme: WidgetStateProperty.resolveWith((states) {
          if (states.contains(WidgetState.selected)) {
            return const IconThemeData(
              color: AppColors.tealPrimary,
              size: AppDesignSystem.iconMd,
            );
          }
          return IconThemeData(
            color: Colors.white.withValues(alpha: 0.35),
            size: AppDesignSystem.iconMd,
          );
        }),
      ),
      bottomAppBarTheme: const BottomAppBarTheme(
        elevation: 0,
        color: AppColors.navyPrimary,
        surfaceTintColor: Colors.transparent,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        margin: EdgeInsets.zero,
        color: AppColors.surfaceCard,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.card,
          side: BorderSide(color: AppColors.borderDefault, width: 0.5),
        ),
      ),
      listTileTheme: ListTileThemeData(
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppGaps.cardH,
          vertical: AppSpacing.xs,
        ),
        minVerticalPadding: AppSpacing.xs,
        iconColor: AppColors.textSecondary,
        textColor: AppColors.textPrimary,
        titleTextStyle: AppTextStyles.cardTitle,
        subtitleTextStyle: AppTextStyles.caption,
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.borderLight,
        thickness: 0.5,
        space: 1,
      ),
      iconButtonTheme: IconButtonThemeData(
        style: IconButton.styleFrom(
          minimumSize: const Size(
            AppSpacing.minTouchTarget,
            AppSpacing.minTouchTarget,
          ),
          tapTargetSize: MaterialTapTargetSize.shrinkWrap,
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceCard,
        contentPadding: const EdgeInsets.symmetric(
          horizontal: AppGaps.cardH,
          vertical: 14,
        ),
        border: OutlineInputBorder(
          borderRadius: AppRadius.card,
          borderSide: const BorderSide(color: AppColors.borderDefault),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: AppRadius.card,
          borderSide: const BorderSide(color: AppColors.borderDefault),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: AppRadius.card,
          borderSide: const BorderSide(
            color: AppColors.tealPrimary,
            width: 1.5,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: AppRadius.card,
          borderSide: const BorderSide(color: AppColors.emergencyRed),
        ),
        labelStyle: AppTextStyles.body,
        hintStyle: AppTextStyles.body.copyWith(color: AppColors.textMuted),
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.navyPrimary,
          foregroundColor: AppColors.textOnDark,
          elevation: 0,
          minimumSize: const Size(double.infinity, 52),
          padding: const EdgeInsets.symmetric(
            horizontal: AppGaps.screenH,
            vertical: AppSpacing.sm,
          ),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.card),
          textStyle: AppTextStyles.labelLarge.copyWith(
            color: AppColors.textOnDark,
          ),
        ),
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.navyPrimary,
          foregroundColor: AppColors.textOnDark,
          elevation: 0,
          minimumSize: const Size(double.infinity, 52),
          padding: const EdgeInsets.symmetric(
            horizontal: AppGaps.screenH,
            vertical: AppSpacing.sm,
          ),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.card),
          textStyle: AppTextStyles.labelLarge.copyWith(
            color: AppColors.textOnDark,
          ),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.navyPrimary,
          side: const BorderSide(color: AppColors.borderDefault),
          minimumSize: const Size(0, 52),
          padding: const EdgeInsets.symmetric(
            horizontal: AppGaps.screenH,
            vertical: AppSpacing.sm,
          ),
          shape: const RoundedRectangleBorder(borderRadius: AppRadius.card),
          textStyle: AppTextStyles.labelLarge,
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.tealDark,
          minimumSize: const Size(0, AppSpacing.minTouchTarget),
          textStyle: AppTextStyles.labelLarge,
        ),
      ),
      floatingActionButtonTheme: const FloatingActionButtonThemeData(
        backgroundColor: AppColors.tealPrimary,
        foregroundColor: AppColors.textOnDark,
        elevation: 0,
        highlightElevation: 0,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.card),
      ),
      chipTheme: ChipThemeData(
        backgroundColor: AppColors.surfaceCard,
        selectedColor: AppColors.navyPrimary,
        labelStyle: AppTextStyles.badge,
        secondaryLabelStyle: AppTextStyles.badge.copyWith(
          color: AppColors.textOnDark,
        ),
        side: const BorderSide(color: AppColors.borderDefault, width: 0.5),
        shape: const RoundedRectangleBorder(borderRadius: AppRadius.pill),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.sm,
          vertical: AppSpacing.xs,
        ),
      ),
      searchBarTheme: SearchBarThemeData(
        elevation: WidgetStateProperty.all(0),
        backgroundColor: WidgetStateProperty.all(AppColors.surfaceCard),
        side: WidgetStateProperty.all(
          const BorderSide(color: AppColors.borderDefault, width: 0.5),
        ),
        shape: WidgetStateProperty.all(
          const RoundedRectangleBorder(borderRadius: AppRadius.card),
        ),
        padding: WidgetStateProperty.all(
          const EdgeInsets.symmetric(horizontal: AppSpacing.sm),
        ),
        constraints: const BoxConstraints(
          minHeight: AppDesignSystem.searchBarHeight,
        ),
        textStyle: WidgetStateProperty.all(AppTextStyles.bodyLarge),
        hintStyle: WidgetStateProperty.all(
          AppTextStyles.body.copyWith(color: AppColors.textMuted),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        elevation: 0,
        shape: const RoundedRectangleBorder(
          borderRadius: AppRadius.button,
          side: BorderSide(color: AppColors.borderDefault, width: 0.5),
        ),
        backgroundColor: AppColors.navyPrimary,
        contentTextStyle: AppTextStyles.body.copyWith(
          color: AppColors.textOnDark,
        ),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(
        color: AppColors.tealPrimary,
        linearTrackColor: AppColors.borderLight,
      ),
      dialogTheme: const DialogThemeData(
        elevation: 0,
        backgroundColor: AppColors.surfaceCard,
        shape: RoundedRectangleBorder(
          borderRadius: AppRadius.card,
          side: BorderSide(color: AppColors.borderDefault, width: 0.5),
        ),
        titleTextStyle: AppTextStyles.screenTitle,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        elevation: 0,
        backgroundColor: AppColors.surfaceCard,
        shape: RoundedRectangleBorder(borderRadius: AppRadius.sheet),
      ),
    );
  }
}
