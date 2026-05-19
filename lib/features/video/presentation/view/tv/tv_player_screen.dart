import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:etisalatdemotv/features/video/presentation/controller/player_viewmodel.dart';
import 'package:etisalatdemotv/features/video/presentation/view/tv/widgets/tv_controls.dart';
import 'package:etisalatdemotv/features/video/presentation/view/phone/widgets/video_view.dart';

/// Player screen optimized for Android TV.
///
/// Key differences from phone:
/// - No orientation lock (TV = always landscape)
/// - No touch gestures — D-pad focus only
/// - Handles media remote keys globally (play/pause)
/// - Larger UI for 10-foot viewing distance
class TvPlayerScreen extends StatefulWidget {
  const TvPlayerScreen({super.key});

  @override
  State<TvPlayerScreen> createState() => _TvPlayerScreenState();
}

class _TvPlayerScreenState extends State<TvPlayerScreen> {
  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }



  @override
  Widget build(BuildContext context) {
    final vm = context.watch<PlayerViewModel>();

    if (vm.hasError) {
      return Scaffold(
        backgroundColor: Colors.black,
        body: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, size: 64, color: Colors.red),
              const SizedBox(height: 24),
              Text(
                'Failed to load video',
                style: Theme.of(
                  context,
                ).textTheme.bodyLarge?.copyWith(fontSize: 24),
              ),
            ],
          ),
        ),
      );
    }

    if (!vm.isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(strokeWidth: 3)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        fit: StackFit.expand,
        children: [
          Center(child: VideoView(controller: vm.controller)),
          AnimatedOpacity(
            opacity: vm.controlsVisible ? 1.0 : 0.0,
            duration: const Duration(milliseconds: 300),
            child: IgnorePointer(
              ignoring: !vm.controlsVisible,
              child: const TvControls(),
            ),
          ),
        ],
      ),
    );
  }
}
