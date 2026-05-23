import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:etisalatdemotv/core/theme/app_theme.dart';
import 'package:etisalatdemotv/core/utils/duration_formatter.dart';
import 'package:etisalatdemotv/features/video/presentation/controller/player_viewmodel.dart';

/// Mobile seek bar with drag-to-seek support.
///
/// Pauses position updates while user is dragging to prevent jitter.
/// Only calls seekTo on drag end.
class PhoneSeekBar extends StatefulWidget {
  const PhoneSeekBar({super.key});

  @override
  State<PhoneSeekBar> createState() => _PhoneSeekBarState();
}

class _PhoneSeekBarState extends State<PhoneSeekBar> {
  bool _isDragging = false;
  double _dragValue = 0;

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PlayerViewModel>();
    final position = _isDragging
        ? Duration(milliseconds: _dragValue.toInt())
        : vm.position;
    final duration = vm.duration;
    final maxVal = duration.inMilliseconds > 0
        ? duration.inMilliseconds.toDouble()
        : 1.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          SizedBox(
            width: 48,
            child: Text(
              DurationFormatter.format(position),
              style: TextStyle(
                color: AppTheme.onSurface,
                fontSize: AppTheme.timeFontSize(isTV: false),
              ),
            ),
          ),
          Expanded(
            child: SliderTheme(
              data: SliderThemeData(
                activeTrackColor: Colors.white,
                inactiveTrackColor: AppTheme.seekBarTrack,
                thumbColor: Colors.white,
                overlayColor: Colors.white.withValues(alpha: 0.2),
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                trackHeight: 3,
              ),
              child: Slider(
                value: position.inMilliseconds.toDouble().clamp(0, maxVal),
                max: maxVal,
                onChangeStart: (_) => setState(() => _isDragging = true),
                onChanged: (v) => setState(() => _dragValue = v),
                onChangeEnd: (v) {
                  vm.seekTo(Duration(milliseconds: v.toInt()));
                  setState(() => _isDragging = false);
                },
              ),
            ),
          ),
          SizedBox(
            width: 48,
            child: Text(
              DurationFormatter.format(duration),
              style: TextStyle(
                color: AppTheme.onSurfaceVariant,
                fontSize: AppTheme.timeFontSize(isTV: false),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
