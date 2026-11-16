import 'package:flutter/cupertino.dart' show CupertinoPageTransitionsBuilder;
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';
import 'app_design.dart';

class AppTheme {
  /// Display face — geometric, tight, used for headings and numbers.
  static TextStyle _display(double size, FontWeight weight, {double tracking = -0.5, double height = 1.2}) =>
      GoogleFonts.outfit(
        fontSize: size,
        fontWeight: weight,
        color: AppColors.textPrimary,
        letterSpacing: tracking,
        height: height,
      );

  /// Text face — humanist, comfortable at small sizes.
  static TextStyle _body(double size, FontWeight weight, {Color? color, double height = 1.45}) =>
      GoogleFonts.plusJakartaSans(
        fontSize: size,
        fontWeight: weight,
        color: color ?? AppColors.textPrimary,
        height: height,
      );

  static ThemeData get lightTheme {
    final base = ThemeData(
      useMaterial3: true,
      brightness: Brightness.light,
      primaryColor: AppColors.primary,
      scaffoldBackgroundColor: AppColors.background,
      splashFactory: InkSparkle.splashFactory,
      pageTransitionsTheme: const PageTransitionsTheme(
        builders: {
          TargetPlatform.android: CupertinoPageTransitionsBuilder(),
          TargetPlatform.iOS: CupertinoPageTransitionsBuilder(),
        },
      ),
      colorScheme: const ColorScheme.light(
        primary: AppColors.primary,
        secondary: AppColors.secondary,
        surface: AppColors.surface,
        error: AppColors.error,
        onPrimary: Colors.white,
        onSecondary: AppColors.primaryDark,
        onSurface: AppColors.textPrimary,
      ),
    );

    return base.copyWith(
      textTheme: TextTheme(
        displayLarge: _display(34, FontWeight.w800, tracking: -1.0, height: 1.1),
        displayMedium: _display(28, FontWeight.w800, tracking: -0.8, height: 1.15),
        displaySmall: _display(24, FontWeight.w800, tracking: -0.6),
        headlineLarge: _display(22, FontWeight.w800, tracking: -0.5),
        headlineMedium: _display(19, FontWeight.w800, tracking: -0.4),
        headlineSmall: _display(17, FontWeight.w700, tracking: -0.3),
        titleLarge: _body(16, FontWeight.w700),
        titleMedium: _body(14, FontWeight.w700),
        titleSmall: _body(13, FontWeight.w600),
        bodyLarge: _body(15, FontWeight.w400),
        bodyMedium: _body(13.5, FontWeight.w400, color: AppColors.textSecondary),
        bodySmall: _body(11.5, FontWeight.w400, color: AppColors.textMuted),
        labelLarge: _body(14, FontWeight.w700),
        labelMedium: _body(12, FontWeight.w600, color: AppColors.textSecondary),
        labelSmall: _body(10.5, FontWeight.w600, color: AppColors.textMuted),
      ),
      appBarTheme: AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        foregroundColor: AppColors.textPrimary,
        titleTextStyle: _display(18, FontWeight.w800, tracking: -0.4),
        iconTheme: const IconThemeData(color: AppColors.textPrimary, size: 22),
      ),
      cardTheme: CardThemeData(
        color: AppColors.surface,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(AppRadius.lg),
          side: const BorderSide(color: AppColors.border, width: 1),
        ),
        margin: EdgeInsets.zero,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.secondary,
          foregroundColor: AppColors.primaryDark,
          elevation: 0,
          shadowColor: Colors.transparent,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl, vertical: AppSpacing.lg),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
          textStyle: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w800),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.primary,
          side: const BorderSide(color: AppColors.borderStrong, width: 1.4),
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xxl, vertical: AppSpacing.lg),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.md)),
          textStyle: GoogleFonts.plusJakartaSans(fontSize: 15, fontWeight: FontWeight.w700),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: AppColors.surfaceAlt,
        contentPadding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.lg),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: const BorderSide(color: AppColors.border),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: const BorderSide(color: AppColors.primary, width: 1.6),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: const BorderSide(color: AppColors.error, width: 1.4),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(AppRadius.sm),
          borderSide: const BorderSide(color: AppColors.error, width: 1.6),
        ),
        labelStyle: _body(13.5, FontWeight.w600, color: AppColors.textSecondary),
        floatingLabelStyle: _body(12.5, FontWeight.w700, color: AppColors.primary),
        hintStyle: _body(13.5, FontWeight.w400, color: AppColors.textMuted),
      ),
      dividerTheme: const DividerThemeData(
        color: AppColors.divider,
        thickness: 1,
        space: AppSpacing.xxl,
      ),
      bottomSheetTheme: const BottomSheetThemeData(
        backgroundColor: Colors.white,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(top: Radius.circular(AppRadius.xl)),
        ),
      ),
      snackBarTheme: SnackBarThemeData(
        behavior: SnackBarBehavior.floating,
        backgroundColor: AppColors.primaryDark,
        contentTextStyle: _body(13.5, FontWeight.w600, color: Colors.white),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(AppRadius.sm)),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: AppColors.primary),
      splashColor: AppColors.primary.withValues(alpha: 0.06),
      highlightColor: Colors.transparent,
    );
  }
}
