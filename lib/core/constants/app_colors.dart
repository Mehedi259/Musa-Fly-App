import 'package:flutter/material.dart';

class AppColors {
  // Brand Identity Colors
  static const Color primary = Color(0xFF204D90); // Deep Royal Navy Blue
  static const Color primaryDark = Color(0xFF0D1F3A);
  static const Color primaryLight = Color(0xFF4787CF);
  static const Color primarySubtle = Color(0xFFE8F0F9);

  // Accent Colors
  static const Color secondary = Color(0xFFE6AB35); // Warm Luxury Gold / Amber
  static const Color secondaryLight = Color(0xFFF3DDAF);
  static const Color secondaryDark = Color(0xFFB8892A);

  // Background and Neutral Grays
  static const Color background = Color(0xFFF8FAFC);
  static const Color surface = Colors.white;
  static const Color cardBg = Colors.white;
  static const Color dark = Color(0xFF1A1A1A);
  static const Color textPrimary = Color(0xFF0F172A);
  static const Color textSecondary = Color(0xFF64748B);
  static const Color textMuted = Color(0xFF94A3B8);
  static const Color border = Color(0xFFE2E8F0);
  static const Color divider = Color(0xFFF1F5F9);

  // Status Colors
  static const Color success = Color(0xFF10B981);
  static const Color error = Color(0xFFEF4444);
  static const Color warning = Color(0xFFF59E0B);
  static const Color info = Color(0xFF3B82F6);
  static const Color whatsapp = Color(0xFF25D366);

  // Gradients
  static const LinearGradient primaryGradient = LinearGradient(
    colors: [Color(0xFF204D90), Color(0xFF132E56)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient heroGradient = LinearGradient(
    colors: [Color(0xFF204D90), Color(0xFF1A3E73), Color(0xFFE6AB35)],
    stops: [0.0, 0.7, 1.0],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient goldGradient = LinearGradient(
    colors: [Color(0xFFF3DDAF), Color(0xFFE6AB35)],
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
  );

  static const LinearGradient cardOverlay = LinearGradient(
    colors: [Colors.transparent, Color(0xCC0D1F3A)],
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
  );
}
