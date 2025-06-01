import 'package:shared_preferences/shared_preferences.dart';

class SettingsService {
  static const String _temperatureKey = 'temperature';
  static const String _shortModeKey = 'shortMode';

  late SharedPreferences _prefs;

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  double getTemperature() {
    return _prefs.getDouble(_temperatureKey) ?? 0.7;
  }

  bool getShortMode() {
    return _prefs.getBool(_shortModeKey) ?? false;
  }

  Future<void> setTemperature(double value) async {
    await _prefs.setDouble(_temperatureKey, value);
  }

  Future<void> setShortMode(bool value) async {
    await _prefs.setBool(_shortModeKey, value);
  }
}