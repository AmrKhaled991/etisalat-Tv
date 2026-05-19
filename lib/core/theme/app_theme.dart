import 'package:flutter/material.dart';

/// App-wide theme configuration.
///
/// Uses a dark cinema-style theme that feels natural for a video
/// player on both mobile and TV screens.
class AppTheme {
  AppTheme._();

  // ──────────────────────────────────────────────
  // Colors
  // ──────────────────────────────────────────────

  static const Color primary = Color(0xFFf30013);
  static const Color surface = Color(0xFF121212);
  static const Color surfaceVariant = Color(0xFF1E1E1E);
  static const Color onSurface = Color(0xFFFFFFFF);
  static const Color onSurfaceVariant = Color(0xFFB0B0B0);
  static const Color focusGlow = Color(0xFF00C896);
  static const Color seekBarTrack = Color(0xFF3A3A3A);
  static const Color seekBarBuffered = Color(0xFF5A5A5A);
  static const Color error = Color(0xFFCF6679);

  // ──────────────────────────────────────────────
  // Sizing tokens — scale up for TV (10-foot UI)
  // ──────────────────────────────────────────────

  /// Returns multiplied size based on whether we're on TV.
  static double scaledSize(double base, {required bool isTV}) {
    return isTV ? base * 1.5 : base;
  }

  /// Icon size for control buttons.
  static double iconSize({required bool isTV}) =>
      scaledSize(32.0, isTV: isTV);

  /// Font size for time labels.
  static double timeFontSize({required bool isTV}) =>
      scaledSize(14.0, isTV: isTV);

  /// Padding around controls.
  static double controlsPadding({required bool isTV}) =>
      scaledSize(16.0, isTV: isTV);

  /// Border radius for focus indicators.
  static double focusBorderRadius({required bool isTV}) =>
      scaledSize(12.0, isTV: isTV);

  // ──────────────────────────────────────────────
  // Theme Data
  // ──────────────────────────────────────────────

  static ThemeData get darkTheme {
    return ThemeData(
      brightness: Brightness.dark,
      scaffoldBackgroundColor: surface,
      colorScheme: const ColorScheme.dark(
        primary: primary,
        surface: surface,
        onSurface: onSurface,
        error: error,
      ),
      iconTheme: const IconThemeData(color: onSurface),
      textTheme: const TextTheme(
        bodyLarge: TextStyle(color: onSurface),
        bodyMedium: TextStyle(color: onSurfaceVariant),
        labelLarge: TextStyle(
          color: onSurface,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
