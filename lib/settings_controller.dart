import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController with ChangeNotifier {

  ValueNotifier<bool> soundEnabled = ValueNotifier(true);

  void toggleSoundEnabled() async {
    soundEnabled.value = !soundEnabled.value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('soundEnabled', soundEnabled.value);
    notifyListeners();
  }

  SettingsController() {
    _loadSettings();
  }

  void _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    soundEnabled.value = prefs.getBool('soundEnabled') ?? true;
    notifyListeners();
  }

  Future<bool> getSoundSetting() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('soundEnabled') ?? true;
  }

}