import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController with ChangeNotifier {

  ValueNotifier<double> musicVolume = ValueNotifier(0.80);

  ValueNotifier<bool> musicEnabled = ValueNotifier(true);

  ValueNotifier<bool> soundEnabled = ValueNotifier(true);

  ValueNotifier<double> soundVolume = ValueNotifier(1.00);

  SettingsController() {
    _loadSettings();
  }

  void _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    musicVolume.value = prefs.getDouble('musicVolume') ?? 0.80;
    soundVolume.value = prefs.getDouble('soundVolume') ?? 1.00;
    musicEnabled.value = prefs.getBool('musicEnabled') ?? true;
    soundEnabled.value = prefs.getBool('soundEnabled') ?? true;
    notifyListeners();
  }

  void changeMusicVolume(value) async {
    musicVolume.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('musicVolume', value);
    notifyListeners();
  }

  void changeSoundVolume(value) async {
    soundVolume.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('soundVolume', value);
    notifyListeners();
  }

  void toggleMusicEnabled() async {
    musicEnabled.value = !musicEnabled.value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('musicEnabled', musicEnabled.value);
    notifyListeners();
  }

  void toggleSoundEnabled() async {
    soundEnabled.value = !soundEnabled.value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('soundEnabled', soundEnabled.value);
    notifyListeners();
  }

  Future<bool> getMusicEnabled() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('musicEnabled') ?? true;
  }
}