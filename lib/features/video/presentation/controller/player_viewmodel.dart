import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

import 'package:etisalatdemotv/core/services/playback_service.dart';

class PlayerViewModel extends ChangeNotifier {
  PlayerViewModel({required PlaybackService playbackService})
    : _playbackService = playbackService;

  final PlaybackService _playbackService;

  late VideoPlayerController _controller;
  VideoPlayerController get controller => _controller;

  // ─── State ───

  bool _isInitialized = false;
  bool get isInitialized => _isInitialized;

  bool _isPlaying = false;
  bool get isPlaying => _isPlaying;

  Duration _position = Duration.zero;
  Duration get position => _position;

  Duration _duration = Duration.zero;
  Duration get duration => _duration;

  bool _hasError = false;
  bool get hasError => _hasError;

  String _errorMessage = '';
  String get errorMessage => _errorMessage;

  bool _controlsVisible = true;
  bool get controlsVisible => _controlsVisible;

  Timer? _hideTimer;

  // ─── Throttles ───

  Duration _lastReportedPosition = Duration.zero;
  DateTime? _lastSeekTime;
  DateTime? _lastSaveTime;

  bool _isSeeking = false;

  // ─── Initialization ───

  Future<void> initialize() async {
    try {
      _controller = VideoPlayerController.asset('assets/video/test4.mp4');

      await _controller.initialize();

      final lastPos = await _playbackService.getLastPosition();

      if (lastPos > 0) {
        await _controller.seekTo(Duration(milliseconds: lastPos));
      }

      // await Future.delayed(const Duration(milliseconds: 5000));

      _controller.addListener(_onVideoUpdate);

      _duration = _controller.value.duration;
      _position = _controller.value.position;
      _isInitialized = true;

      notifyListeners();
    } catch (e) {
      _hasError = true;
      _errorMessage = e.toString();
      notifyListeners();
    }
  }

  // ─── Playback Controls ───

  void togglePlayPause() {
    if (!_isInitialized) return;

    if (_controller.value.isPlaying) {
      _controller.pause();

      _playbackService.forceSavePosition(
        _controller.value.position.inMilliseconds,
      );
    } else {
      _controller.play();
      _startHideTimer();
    }
    notifyListeners();
  }

  Future<void> seekForward({int seconds = 10}) async {
    if (!_isInitialized || _isSeeking) return;

    final now = DateTime.now();

    if (_lastSeekTime != null &&
        now.difference(_lastSeekTime!) < const Duration(milliseconds: 300)) {
      return;
    }

    _lastSeekTime = now;
    _isSeeking = true;

    try {
      final target = _controller.value.position + Duration(seconds: seconds);

      final clamped = target > _controller.value.duration
          ? _controller.value.duration
          : target;

      await _controller.seekTo(clamped);
    } finally {
      _isSeeking = false;
    }

    _resetHideTimer();
  }

  Future<void> seekBackward({int seconds = 10}) async {
    if (!_isInitialized || _isSeeking) return;

    final now = DateTime.now();

    if (_lastSeekTime != null &&
        now.difference(_lastSeekTime!) < const Duration(milliseconds: 300)) {
      return;
    }

    _lastSeekTime = now;
    _isSeeking = true;

    try {
      final target = _controller.value.position - Duration(seconds: seconds);

      final clamped = target < Duration.zero ? Duration.zero : target;

      await _controller.seekTo(clamped);
    } finally {
      _isSeeking = false;
    }

    _resetHideTimer();
  }

  Future<void> seekTo(Duration position) async {
    if (!_isInitialized) return;
    await _controller.seekTo(position);
  }

  // ─── Controls Visibility ───

  void showControls() {
    _controlsVisible = true;
    notifyListeners();
    _resetHideTimer();
  }

  void hideControls() {
    _controlsVisible = false;
    _hideTimer?.cancel();
    notifyListeners();
  }

  void toggleControls() {
    _controlsVisible ? hideControls() : showControls();
  }

  // ─── Video Listener ───

  void _onVideoUpdate() {
    final value = _controller.value;

    _isPlaying = value.isPlaying;
    _duration = value.duration;

    final diff = (value.position - _lastReportedPosition).inMilliseconds.abs();

    if (diff >= 500) {
      _position = value.position;
      _lastReportedPosition = value.position;
      notifyListeners();
    }

    final now = DateTime.now();

    if (value.isPlaying) {
      if (_lastSaveTime == null ||
          now.difference(_lastSaveTime!) > const Duration(seconds: 5)) {
        _lastSaveTime = now;

        _playbackService.savePosition(value.position.inMilliseconds);
      }
    }
  }

  // ─── Controls Timer ───

  void _startHideTimer() {
    _hideTimer?.cancel();

    _hideTimer = Timer(const Duration(seconds: 3), () {
      if (_isPlaying) {
        _controlsVisible = false;
        notifyListeners();
      }
    });
  }

  void _resetHideTimer() {
    if (_controlsVisible) _startHideTimer();
  }

  // ─── Cleanup ───

  @override
  void dispose() {
    try {
      if (_isInitialized) {
        _playbackService.forceSavePosition(
          _controller.value.position.inMilliseconds,
        );

        _controller.removeListener(_onVideoUpdate);
        _controller.dispose();
      }
    } catch (_) {}

    _hideTimer?.cancel();

    SystemChrome.setPreferredOrientations(DeviceOrientation.values);
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);

    super.dispose();
  }
}
