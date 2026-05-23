import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'package:etisalatdemotv/features/video/presentation/controller/player_viewmodel.dart';
import 'package:etisalatdemotv/features/video/presentation/view/tv/widgets/tv_controls.dart';
import 'package:etisalatdemotv/features/video/presentation/view/phone/widgets/video_view.dart';

/// Player screen optimized for Android TV and web keyboard navigation.
///
/// Key differences from phone:
/// - No orientation lock (TV = always landscape)
/// - No touch gestures — D-pad / arrow-key focus only
/// - Arrow keys explicitly mapped to [DirectionalFocusIntent] so that
///   web browsers (which don't auto-map arrows like Android TV does) work.
/// - Handles media remote keys globally (play/pause)
/// - Larger UI for 10-foot viewing distance
class TvPlayerScreen extends StatefulWidget {
  const TvPlayerScreen({super.key});

  @override
  State<TvPlayerScreen> createState() => _TvPlayerScreenState();
}

class _TvPlayerScreenState extends State<TvPlayerScreen> {
  /// Scope wrapping TvControls — automatically remembers the last focused
  /// child, so calling [_controlsScope.requestFocus()] after controls
  /// re-appear restores the exact button the user was on before they hid.
  final FocusScopeNode _controlsScope = FocusScopeNode(
    debugLabel: 'TvControlsScope',
  );

  @override
  void initState() {
    super.initState();
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  }

  @override
  void dispose() {
    _controlsScope.dispose();
    super.dispose();
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

    // Shortcuts maps arrow keys → DirectionalFocusIntent so that on web
    // (and any platform that doesn't natively bind arrow keys to D-pad
    // focus traversal) the user can move focus left/right/up/down.
    //
    // Key event priority:
    //  1. TvSeekBar.onKeyEvent returns `handled` for ←/→ when focused → seeks
    //  2. FocusButton.onKeyEvent returns `ignored` for ←/→ → falls through
    //  3. Shortcuts catches ←/→ → DirectionalFocusIntent → moves focus
    return Shortcuts(
      shortcuts: const <ShortcutActivator, Intent>{
        SingleActivator(LogicalKeyboardKey.arrowLeft): DirectionalFocusIntent(
          TraversalDirection.left,
        ),
        SingleActivator(LogicalKeyboardKey.arrowRight): DirectionalFocusIntent(
          TraversalDirection.right,
        ),
        SingleActivator(LogicalKeyboardKey.arrowUp): DirectionalFocusIntent(
          TraversalDirection.up,
        ),
        SingleActivator(LogicalKeyboardKey.arrowDown): DirectionalFocusIntent(
          TraversalDirection.down,
        ),
      },
      child: Scaffold(
        backgroundColor: Colors.black,
        body: Focus(
          // Outer focus node: shows controls on any key press and restores
          // focus to the last selected button inside the controls scope.
          onKeyEvent: (node, event) {
            if (event is KeyDownEvent) {
              vm.showControls();
              // Wait one frame so controls are visible, then restore the
              // last focused child inside _controlsScope.
              WidgetsBinding.instance.addPostFrameCallback((_) {
                if (_controlsScope.canRequestFocus) {
                  _controlsScope.requestFocus();
                }
              });
            }
            return KeyEventResult.ignored; // let children + Shortcuts handle it
          },
          child: Stack(
            fit: StackFit.expand,
            children: [
              Center(child: VideoView(controller: vm.controller)),
              AnimatedOpacity(
                opacity: vm.controlsVisible ? 1.0 : 0.0,
                duration: const Duration(milliseconds: 300),
                child: IgnorePointer(
                  ignoring: !vm.controlsVisible,
                  // FocusScope with our named node — remembers last focused child
                  child: FocusScope(
                    node: _controlsScope,
                    child: const TvControls(),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
