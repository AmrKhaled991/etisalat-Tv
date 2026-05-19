import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:etisalatdemotv/core/theme/app_theme.dart';
import 'package:etisalatdemotv/features/video/presentation/controller/player_viewmodel.dart';
import 'package:etisalatdemotv/features/video/presentation/view/tv/widgets/focus_button.dart';
import 'package:etisalatdemotv/features/video/presentation/view/tv/widgets/tv_seek_bar.dart';

/// Control overlay for Android TV.
///
/// All interaction is D-pad driven via [FocusTraversalGroup].
/// Larger icons/fonts for 10-foot UI viewing distance.
class TvControls extends StatelessWidget {
  const TvControls({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PlayerViewModel>();

    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.bottomCenter,
          end: Alignment.topCenter,
          colors: [
            Colors.black.withValues(alpha: 0.85),
            Colors.black.withValues(alpha: 0.4),
            Colors.transparent,
          ],
          stops: const [0.0, 0.5, 1.0],
        ),
      ),
      child: FocusTraversalGroup(
        policy: OrderedTraversalPolicy(),

        child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            // Seek bar
            FocusTraversalOrder(
              order: const NumericFocusOrder(0),
              child: Padding(
                padding: EdgeInsets.symmetric(
                  horizontal: AppTheme.controlsPadding(isTV: true),
                ),
                child: const TvSeekBar(),
              ),
            ),

            SizedBox(height: AppTheme.controlsPadding(isTV: true)),

            // Button row with ordered focus traversal
            FocusTraversalOrder(
              order: const NumericFocusOrder(1),

              child: FocusTraversalGroup(
                policy: OrderedTraversalPolicy(),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    FocusTraversalOrder(
                      order: const NumericFocusOrder(0),
                      child: FocusButton(
                        icon: Icons.replay_10_rounded,
                        onPressed: () => vm.seekBackward(),
                        size: AppTheme.iconSize(isTV: true),
                        semanticLabel: 'Rewind 10 seconds',
                      ),
                    ),
                    SizedBox(width: AppTheme.controlsPadding(isTV: true) * 2),
                    FocusTraversalOrder(
                      order: const NumericFocusOrder(1),

                      child: FocusButton(
                        icon: vm.isPlaying
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                        onPressed: vm.togglePlayPause,
                        autofocus: true,
                        size: AppTheme.iconSize(isTV: true) * 1.3,
                        semanticLabel: vm.isPlaying ? 'Pause' : 'Play',
                      ),
                    ),
                    SizedBox(width: AppTheme.controlsPadding(isTV: true) * 2),
                    FocusTraversalOrder(
                      order: const NumericFocusOrder(2),
                      child: FocusButton(
                        icon: Icons.forward_10_rounded,
                        onPressed: () => vm.seekForward(),
                        size: AppTheme.iconSize(isTV: true),
                        semanticLabel: 'Forward 10 seconds',
                      ),
                    ),
                  ],
                ),
              ),
            ),

            SizedBox(height: AppTheme.controlsPadding(isTV: true) * 2),
          ],
        ),
      ),
    );
  }
}
