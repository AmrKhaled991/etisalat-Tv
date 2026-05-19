import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:etisalatdemotv/core/theme/app_theme.dart';
import 'package:etisalatdemotv/core/utils/duration_formatter.dart';
import 'package:etisalatdemotv/features/video/presentation/controller/player_viewmodel.dart';

/// TV seek bar with two interaction modes:
///
/// **Normal**: shows progress, receives focus via D-pad.
/// **Seek mode**: press OK → ←/→ seeks ±10s → OK/Back exits.
class TvSeekBar extends StatefulWidget {
  const TvSeekBar({super.key});

  @override
  State<TvSeekBar> createState() => _TvSeekBarState();
}

class _TvSeekBarState extends State<TvSeekBar> {
  bool _isFocused = false;

  @override
  void dispose() {
    super.dispose();
  }

  KeyEventResult _onKey(FocusNode node, KeyEvent event) {
    if (event is! KeyDownEvent) return KeyEventResult.ignored;
    final vm = context.read<PlayerViewModel>();
    final key = event.logicalKey;

    if (key == LogicalKeyboardKey.arrowRight) {
      vm.seekForward();
      return KeyEventResult.handled;
    }
    if (key == LogicalKeyboardKey.arrowLeft) {
      vm.seekBackward();
      return KeyEventResult.handled;
    }
   
    return KeyEventResult.ignored;
  }

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PlayerViewModel>();
    final progress = vm.duration.inMilliseconds > 0
        ? vm.position.inMilliseconds / vm.duration.inMilliseconds
        : 0.0;

    return Focus(
      onFocusChange: (focused) {
        setState(() {
          _isFocused = focused;
        });
        if (focused) vm.showControls();
      },
      onKeyEvent: _onKey,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: EdgeInsets.symmetric(
          horizontal: AppTheme.controlsPadding(isTV: true),
          vertical: 8,
        ),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: _isFocused ? AppTheme.focusGlow : Colors.transparent,
            width: 2,
          ),
          color: _isFocused
              ? AppTheme.surfaceVariant.withValues(alpha: 0.6)
              : Colors.transparent,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Text(
                  DurationFormatter.format(vm.position),
                  style: TextStyle(
                    color: AppTheme.onSurface,
                    fontSize: AppTheme.timeFontSize(isTV: true),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: LinearProgressIndicator(
                      value: progress.clamp(0.0, 1.0),
                      minHeight: 8,
                      backgroundColor: AppTheme.seekBarTrack,
                      valueColor: const AlwaysStoppedAnimation<Color>(
                        AppTheme.primary,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Text(
                  DurationFormatter.format(vm.duration),
                  style: TextStyle(
                    color: AppTheme.onSurfaceVariant,
                    fontSize: AppTheme.timeFontSize(isTV: true),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
