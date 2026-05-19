import 'package:flutter/material.dart';

/// Utility for formatting [Duration] to display-friendly strings.
class DurationFormatter {
  DurationFormatter._();

  /// Formats a [Duration] as `MM:SS` (e.g., `02:35`).
  static String format(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds = duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '$minutes:$seconds';
  }
}
extension MediaQueryValues on BuildContext {

  double get screenWidth => MediaQuery.sizeOf(this).width;
  double get screenHeight => MediaQuery.sizeOf(this).height;
  
  
  Orientation get orientation => MediaQuery.orientationOf(this);
  bool get isLandscape => orientation == Orientation.landscape;
  
  EdgeInsets get padding => MediaQuery.paddingOf(this);
}