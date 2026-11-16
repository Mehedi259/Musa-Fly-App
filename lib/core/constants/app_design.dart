import 'package:flutter/material.dart';
import 'app_colors.dart';

/// Design tokens shared by every screen: spacing, radii, elevation, motion.
class AppSpacing {
  static const double xs = 4;
  static const double sm = 8;
  static const double md = 12;
  static const double lg = 16;
  static const double xl = 20;
  static const double xxl = 24;
  static const double xxxl = 32;

  /// Horizontal page gutter. Every screen uses this so sections line up.
  static const double page = 20;
}

class AppRadius {
  static const double xs = 8;
  static const double sm = 12;
  static const double md = 16;
  static const double lg = 22;
  static const double xl = 28;
  static const double xxl = 36;
  static const double pill = 999;
}

/// Two-layer shadows: a wide ambient layer plus a tight key-light layer.
/// A single blurred shadow reads as flat; the pair reads as a lifted surface.
class AppShadows {
  static const Color _ink = Color(0xFF0B1B33);

  /// Resting list cards.
  static List<BoxShadow> get soft => [
        BoxShadow(color: _ink.withValues(alpha: 0.04), blurRadius: 16, offset: const Offset(0, 4)),
        BoxShadow(color: _ink.withValues(alpha: 0.03), blurRadius: 3, offset: const Offset(0, 1)),
      ];

  /// Cards that should clearly sit above the page.
  static List<BoxShadow> get medium => [
        BoxShadow(color: _ink.withValues(alpha: 0.08), blurRadius: 28, offset: const Offset(0, 10)),
        BoxShadow(color: _ink.withValues(alpha: 0.04), blurRadius: 6, offset: const Offset(0, 2)),
      ];

  /// Floating elements: search card, sheets, sticky bars.
  static List<BoxShadow> get elevated => [
        BoxShadow(color: _ink.withValues(alpha: 0.14), blurRadius: 40, offset: const Offset(0, 18)),
        BoxShadow(color: _ink.withValues(alpha: 0.06), blurRadius: 8, offset: const Offset(0, 3)),
      ];

  /// Coloured glow under a saturated CTA.
  static List<BoxShadow> glow(Color c, {double opacity = 0.34}) => [
        BoxShadow(color: c.withValues(alpha: opacity), blurRadius: 22, offset: const Offset(0, 10)),
      ];

  static List<BoxShadow> get none => const [];
}

/// Motion: one easing curve and a small set of durations, so every
/// transition in the app feels like it came from the same hand.
class AppMotion {
  static const Curve ease = Curves.easeOutCubic;
  static const Curve emphasized = Cubic(0.2, 0.0, 0.0, 1.0);
  static const Curve spring = Curves.easeOutBack;

  static const Duration fast = Duration(milliseconds: 180);
  static const Duration base = Duration(milliseconds: 300);
  static const Duration slow = Duration(milliseconds: 480);

  /// Delay for the nth item in a staggered list reveal, capped so long
  /// lists don't crawl in.
  static Duration stagger(int index, {int step = 55, int cap = 8}) =>
      Duration(milliseconds: step * (index > cap ? cap : index));
}

class AppDecor {
  /// Standard white card: hairline border plus a soft lift.
  static BoxDecoration card({
    Color? color,
    double radius = AppRadius.lg,
    bool border = true,
    List<BoxShadow>? shadow,
  }) =>
      BoxDecoration(
        color: color ?? Colors.white,
        borderRadius: BorderRadius.circular(radius),
        border: border ? Border.all(color: AppColors.border, width: 1) : null,
        boxShadow: shadow ?? AppShadows.soft,
      );

  /// Card with a gold hairline — used to mark a featured or premium item.
  static BoxDecoration premiumCard({double radius = AppRadius.lg}) => BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(radius),
        border: Border.all(color: AppColors.secondary.withValues(alpha: 0.4), width: 1.2),
        boxShadow: AppShadows.medium,
      );

  /// Deep navy hero surface behind headers.
  static const BoxDecoration hero = BoxDecoration(gradient: AppColors.heroGradient);

  /// Tinted "soft" surface, e.g. an inset panel inside a card.
  static BoxDecoration soft(Color c, {double radius = AppRadius.sm}) => BoxDecoration(
        color: c.withValues(alpha: 0.09),
        borderRadius: BorderRadius.circular(radius),
      );
}

/// Shared text styles for things that repeat across screens.
class AppText {
  /// Prices use tabular figures so digits line up column to column.
  static const List<FontFeature> tabular = [FontFeature.tabularFigures()];
}
