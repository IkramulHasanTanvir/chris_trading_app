import 'package:flutter/material.dart';
import 'package:flutter_task/core/services/theme_controller.dart';
import 'package:get/get.dart';

/// Application color palette — theme-aware for dark & light modes.
///
/// Brand green stays constant. Surfaces / text adapt to theme.
class AppColors {
  AppColors._();

  static bool get isDark {
    if (Get.isRegistered<ThemeController>()) {
      return ThemeController.to.isDarkMode;
    }
    return true;
  }

  // ─── Brand (same in both themes) ─────────────────────────────────
  static const Color primary = Color(0xFF279646);
  static const Color primaryDark = Color(0xFF1B7A38);
  static const Color primaryLight = Color(0xFF81C784);
  static const Color greenAccent = Color(0xFF00C853);
  static const Color greenAccentLight = Color(0xFF69F0AE);

  static const Color winBlue = Color(0xFF4A90D9);
  static const Color lossRed = Color(0xFFE05A5A);
  static const Color barGreen = Color(0xFF4CAF50);
  static const Color barRed = Color(0xFFE05A5A);
  static const Color error = Color(0xFFD32F2F);
  static const Color red = Colors.red;
  static const Color rating = Colors.amber;
  static const Color ratingInactive = Color(0xFFE0E0E0);
  static const Color bannerPeach = Color(0xFFF8CCAD);
  static const Color transparent = Colors.transparent;
  static const Color divider = Color(0xFFE0E0E0);

  /// Dark: white · Light: grey[800] — button / tile foreground.
  static Color get pureWhite =>
      isDark ? Colors.white : Colors.black;

  // ─── Theme-aware surfaces ────────────────────────────────────────
  /// Soft cool gray in light (not cream), deep navy in dark.
  static Color get background =>
      isDark ? const Color(0xFF191932) : const Color(0xFFEEF2F6);

  static Color get backgroundDark =>
      isDark ? const Color(0xFF0D1016) : const Color(0xFFE2E8F0);

  /// Cards / nav / elevated surfaces
  static Color get navBackground =>
      isDark ? const Color(0xFF191826) : const Color(0xFFFFFFFF);

  static Color get surface =>
      isDark ? const Color(0xFF191826) : const Color(0xFFFFFFFF);

  static Color get fillColor =>
      isDark ? const Color(0xFF2B2B36) : const Color(0xFFE8EDF2);

  /// Secondary button / tile background
  static Color get primaryBTN =>
      isDark ? const Color(0xFF2B2B34) : const Color(0xFFD0D7E0);

  /// Soft card border for light mode
  static Color get cardBorder =>
      isDark ? Colors.transparent : const Color(0xFFD8DEE6);

  /// Page / list card gradient
  static List<Color> get cardGradient => isDark
      ? const [Color(0xFF0B0F2A), Color(0xFF050816)]
      : const [Color(0xFFFFFFFF), Color(0xFFF7F9FC)];

  // ─── Theme-aware text ────────────────────────────────────────────
  /// Primary content text (replaces most old `Colors.white` defaults)
  static Color get onSurface =>
      isDark ? Colors.white : const Color(0xFF0F172A);

  /// Legacy name used across the app for foreground on surfaces.
  /// In light mode this is dark slate so text stays readable.
  static Color get white => onSurface;

  static Color get textPrimary =>
      isDark ? const Color(0xFFEEF2F6) : const Color(0xFF0F172A);

  static Color get textSecondary =>
      isDark ? const Color(0xFF9CA3AF) : const Color(0xFF64748B);

  static Color get textHint =>
      isDark ? const Color(0xFF6B7280) : const Color(0xFF94A3B8);

  static Color get textDark =>
      isDark ? const Color(0xFFE2E8F0) : const Color(0xFF0F172A);

  static Color get textGray => textSecondary;
  static Color get textLightGray => textHint;
  static Color get textMediumGray => textSecondary;
  static Color get textDarkGray =>
      isDark ? const Color(0xFFB4B4B4) : const Color(0xFF475569);

  static Color get textBlack87 =>
      isDark ? Colors.white70 : Colors.black87;

  static Color get grey600 =>
      isDark ? const Color(0xFF6C7278) : const Color(0xFF64748B);

  static Color get grey700 =>
      isDark ? Colors.grey[700]! : const Color(0xFF334155);

  // ─── Shadows ─────────────────────────────────────────────────────
  static Color get shadowLight =>
      Colors.black.withValues(alpha: isDark ? 0.05 : 0.04);
  static Color get shadowMedium =>
      Colors.black.withValues(alpha: isDark ? 0.08 : 0.06);
  static Color get shadowDark =>
      Colors.black.withValues(alpha: isDark ? 0.25 : 0.10);

  // ─── Shimmer ─────────────────────────────────────────────────────
  static Color get shimmerBase =>
      isDark ? const Color(0xFF2A2A3C) : const Color(0xFFE2E8F0);
  static Color get shimmerHighlight =>
      isDark ? const Color(0xFF3A3A50) : const Color(0xFFF8FAFC);
  static Color get shimmerContainer =>
      isDark ? const Color(0xFF222233) : const Color(0xFFF1F5F9);
}
