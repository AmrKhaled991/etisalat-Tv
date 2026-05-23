import 'package:etisalatdemotv/core/utils/duration_formatter.dart';
import 'package:etisalatdemotv/features/video/presentation/view/phone/widgets/phone_seek_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'package:etisalatdemotv/features/video/presentation/controller/player_viewmodel.dart';
import 'package:etisalatdemotv/features/video/presentation/view/phone/widgets/phone_controls.dart';
import 'package:etisalatdemotv/core/widgets/video_view.dart';

/// Player screen optimized for mobile (Android phone & iOS).
///
/// - Landscape immersive mode
/// - Tap video to toggle controls
/// - Double-tap sides to seek ±10s
/// - Auto-hide controls after 3s
class PhonePlayerScreen extends StatefulWidget {
  const PhonePlayerScreen({super.key});

  @override
  State<PhonePlayerScreen> createState() => _PhonePlayerScreenState();
}

class _PhonePlayerScreenState extends State<PhonePlayerScreen> {
  // @override
  // void initState() {
  //   super.initState();
  //   SystemChrome.setPreferredOrientations([
  //     DeviceOrientation.landscapeLeft,
  //     DeviceOrientation.landscapeRight,
  //   ]);
  //   SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  //
  // }

  // @override
  // void dispose() {
  //   SystemChrome.setPreferredOrientations(DeviceOrientation.values);
  //   SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
  //   super.dispose();
  // }

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
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text(
                'Failed to load video',
                style: Theme.of(context).textTheme.bodyLarge,
              ),
              const SizedBox(height: 8),
              Text(
                vm.errorMessage,
                style: Theme.of(context).textTheme.bodyMedium,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
      );
    }

    if (!vm.isInitialized) {
      return const Scaffold(
        backgroundColor: Colors.black,
        body: Center(child: CircularProgressIndicator(strokeWidth: 2)),
      );
    }

    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: context.isLandscape
            ? Stack(
                fit: StackFit.expand,
                children: [
                  Center(
                    child: VideoView(
                      controller: vm.controller,
                      onTap: vm.toggleControls,
                    ),
                  ),
                  AnimatedOpacity(
                    opacity: vm.controlsVisible ? 1.0 : 0.0,
                    duration: const Duration(milliseconds: 300),
                    child: IgnorePointer(
                      ignoring: !vm.controlsVisible,
                      child: const PhoneControls(),
                    ),
                  ),
                ],
              )
            : Column(
                children: [
                  SizedBox(
                    width: context.screenWidth,
                    height: context.screenHeight * 0.3,
                    child: Stack(
                      fit: StackFit.expand,
                      children: [
                        Center(
                          child: VideoView(
                            controller: vm.controller,
                            onTap: vm.toggleControls,
                          ),
                        ),
                        AnimatedOpacity(
                          opacity: vm.controlsVisible ? 1.0 : 0.0,
                          duration: const Duration(milliseconds: 300),
                          child: IgnorePointer(
                            ignoring: !vm.controlsVisible,
                            child: const PhoneControls(),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}
