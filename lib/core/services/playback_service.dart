import 'package:etisalatdemotv/core/services/playback_storage.dart';

/// Service that handles playback data operations.
///
/// Acts as the single source of truth for playback persistence.
/// Includes built-in throttling to prevent excessive disk writes
/// during continuous playback.
class PlaybackService {
  DateTime _lastSaveTime = DateTime(2000);
  static const _throttleDuration = Duration(seconds: 5);

  /// Saves position with throttling — at most once per 5 seconds.
  /// Call this from the controller listener during playback.
  Future<void> savePosition(int milliseconds) async {
    final now = DateTime.now();
    if (now.difference(_lastSaveTime) < _throttleDuration) return;
    _lastSaveTime = now;
    await PlaybackStorage.savePosition(milliseconds);
  }

  /// Forces an immediate save, bypassing throttle.
  /// Use on pause, background, or dispose.
  Future<void> forceSavePosition(int milliseconds) async {
    _lastSaveTime = DateTime.now();
    await PlaybackStorage.savePosition(milliseconds);
  }

  /// Returns the last saved position in milliseconds (0 if none).
  Future<int> getLastPosition() {
    return PlaybackStorage.getLastPosition();
  }
}
