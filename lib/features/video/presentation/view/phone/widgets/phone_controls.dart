import 'package:etisalatdemotv/core/utils/duration_formatter.dart';
import 'package:etisalatdemotv/features/video/presentation/view/phone/widgets/horizontal_displaying.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:etisalatdemotv/core/theme/app_theme.dart';
import 'package:etisalatdemotv/features/video/presentation/controller/player_viewmodel.dart';
import 'package:etisalatdemotv/features/video/presentation/view/phone/widgets/phone_seek_bar.dart';

/// Control overlay for mobile (phone) screens.
///
/// - Double-tap sides to seek ±10 sec
/// - Play/Pause center button
/// - Gradient bottom bar with seek bar + control buttons
class PhoneControls extends StatelessWidget {
  const PhoneControls({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PlayerViewModel>();
    return Stack(
      children: [
        // ─── Gesture areas + center play/pause ───
        Row(
          children: [
            // Tap left → rewind
            Expanded(
              child: GestureDetector(
                onDoubleTap: () => vm.seekBackward(),
                behavior: HitTestBehavior.opaque,
                child: const SizedBox.expand(),
              ),
            ),
            // Center play/pause
            _ControlButton(
              icon: vm.isPlaying
                  ? Icons.pause_rounded
                  : Icons.play_arrow_rounded,
              onTap: vm.togglePlayPause,
              size: 56,
            ),
            // Tap right → forward
            Expanded(
              child: GestureDetector(
                onDoubleTap: () => vm.seekForward(),
                behavior: HitTestBehavior.opaque,
                child: const SizedBox.expand(),
              ),
            ),
          ],
        ),

        // ─── Bottom bar ───
        Align(
          alignment: Alignment.bottomCenter,
          child: Container(
            padding: const EdgeInsets.only(bottom: 16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [
                  Colors.black.withValues(alpha: 0.8),
                  Colors.transparent,
                ],
              ),
            ),
            child: context.isLandscape
                ? Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      const HorizontalDisplaying(),
                      const SizedBox(height: 8),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _ControlButton(
                            icon: Icons.replay_10_rounded,
                            onTap: () => vm.seekBackward(),
                          ),
                          const SizedBox(width: 32),
                          _ControlButton(
                            icon: vm.isPlaying
                                ? Icons.pause_rounded
                                : Icons.play_arrow_rounded,
                            onTap: vm.togglePlayPause,
                            size: 40,
                          ),
                          const SizedBox(width: 32),
                          _ControlButton(
                            icon: Icons.forward_10_rounded,
                            onTap: () => vm.seekForward(),
                          ),
                        ],
                      ),
                    ],
                  )
                : HorizontalDisplaying(),
          ),
        ),
      ],
    );
  }
}

class _ControlButton extends StatelessWidget {
  const _ControlButton({
    required this.icon,
    required this.onTap,
    this.size = 28,
  });

  final IconData icon;
  final VoidCallback onTap;
  final double size;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black.withValues(alpha: 0.3),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, size: size, color: AppTheme.onSurface),
      ),
    );
  }
}
