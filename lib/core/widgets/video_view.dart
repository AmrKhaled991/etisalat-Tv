import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';

/// Shared video display widget for both phone and TV.
///
/// Wraps [VideoPlayer] in [RepaintBoundary] to isolate video
/// repaints from the rest of the widget tree.
class VideoView extends StatelessWidget {
  const VideoView({super.key, required this.controller, this.onTap});

  final VideoPlayerController controller;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    if (!controller.value.isInitialized) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }

    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: RepaintBoundary(
        child: AspectRatio(
          aspectRatio: controller.value.aspectRatio,
          child: VideoPlayer(controller),
        ),
      ),
    );
  }
}
