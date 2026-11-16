import 'package:flutter/material.dart';

/// MusaFly brand palette.
///
/// Built around a deep royal navy and a warm luxury gold. Neutrals are
/// very slightly blue-tinted so white cards read as "lifted" against the
/// page rather than merging into it.
class AppColors {
  // ───────────────────────── Brand ─────────────────────────
  static const Color primary = Color(0xFF1B4584); // Royal navy
  static const Color primaryDark = Color(0xFF0B1B33);
  static const Color primaryMid = Color(0xFF123060);
  static const Color primaryLight = Color(0xFF4787CF);
  static const Color primarySubtle = Color(0xFFEDF3FB);

  // ───────────────────────── Accent ─────────────────────────
  static const Color secondary = Color(0xFFE0A530); // Luxury gold
  static const Color secondaryLight = Color(0xFFF7D98A);
  static const Color secondaryDark = Color(0xFFB4811F);
  static const Color secondarySubtle = Color(0xFFFDF6E7);

  // ───────────────────────── Neutrals ─────────────────────────
  static const Color background = Color(0xFFF6F7FB);
  static const Color surface = Colors.white;
  static const Color surfaceAlt = Color(0xFFFBFCFE);
  static const Color cardBg = Colors.white;
  static const Color dark = Color(0xFF13161C);

  static const Color textPrimary = Color(0xFF101828);
  static const Color textSecondary = Color(0xFF5C6B82);
  static const Color textMuted = Color(0xFF98A4B8);

  static const Color border = Color(0xFFE6EBF3);
  static const Color borderStrong = Color(0xFFD5DEEB);
  static const Color divider = Color(0xFFF0F3F8);

  // ───────────────────────── Status ─────────────────────────
  static const Color success = Color(0xFF0E9F6E);
  static const Color successSubtle = Color(0xFFE7F7F1);
  static const Color error = Color(0xFFE02424);
  static const Color errorSubtle = Color(0xFFFDECEC);
  static const Color warning = Color(0xFFE0A530);
  static const Color info = Color(0xFF2E7CF6);
  static const Color whatsapp = Color(0xFF25D366);

  // ───────────────────────── Category accents ─────────────────────────
  static const Color catFlight = Color(0xFF1B4584);
  static const Color catTour = Color(0xFFF08C2E);
  static const Color catUmrah = Color(0xFF0E9F6E);
  static const Color catVisa = Color(0xFF7C5CF0);
  static const Color catDeal = Color(0xFFE2426E);

  // ───────────────────────── Gradients ─────────────────────────
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF1B4584), Color(0xFF0E2850)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Rich navy backdrop used behind headers and hero areas.
  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF0B1B33), Color(0xFF143468), Color(0xFF1B4584)],
    stops: [0.0, 0.55, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFF7D98A), Color(0xFFE0A530)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  /// Brighter gold for primary CTAs — reads as a lit surface.
  static const LinearGradient goldCta = LinearGradient(
    colors: [Color(0xFFF2C45C), Color(0xFFDE9C1F)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardOverlay = LinearGradient(
    colors: [Colors.transparent, Color(0xCC0B1B33)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );

  /// Scrim for text sitting on photography.
  static const LinearGradient imageScrim = LinearGradient(
    colors: [Color(0x00000000), Color(0x40000000), Color(0xD9000000)],
    stops: [0.3, 0.6, 1.0],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
