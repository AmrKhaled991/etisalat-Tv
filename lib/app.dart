import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:etisalatdemotv/core/theme/app_theme.dart';
import 'package:etisalatdemotv/core/services/playback_service.dart';
import 'package:etisalatdemotv/features/video/presentation/view/phone/phone_player_screen.dart';
import 'package:etisalatdemotv/features/splash/splash_screen.dart';
import 'package:etisalatdemotv/features/video/presentation/view/tv/tv_player_screen.dart';
import 'package:etisalatdemotv/features/video/presentation/controller/player_viewmodel.dart';

/// Root application widget.
///
/// Uses [ChangeNotifierProvider] to expose [PlayerViewModel]
/// to the entire widget tree. Routes to splash → player based
/// on device type.
class App extends StatefulWidget {
  const App({super.key, required this.isTV});

  final bool isTV;

  @override
  State<App> createState() => _AppState();
}

class _AppState extends State<App> {
  bool _showSplash = true;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => PlayerViewModel(
        playbackService: PlaybackService(),
      )..initialize(),
      child: MaterialApp(
        title: 'E& Video Player',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.darkTheme,
        home: _showSplash
            ? SplashScreen(
                onComplete: () => setState(() => _showSplash = false),
              )
            : widget.isTV
                ? const TvPlayerScreen()
                : const PhonePlayerScreen(),
      ),
    );
  }
}
