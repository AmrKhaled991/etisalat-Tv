import 'package:shared_preferences/shared_preferences.dart';


class PlaybackStorage {
  PlaybackStorage._();

  static const _positionKey = 'last_playback_position_ms';

  static Future<void> savePosition(int milliseconds) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setInt(_positionKey, milliseconds);
  }

  static Future<int> getLastPosition() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_positionKey) ?? 0;
  }

  static Future<void> clearPosition() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_positionKey);
  }
}
