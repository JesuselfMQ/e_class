import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SettingsController with ChangeNotifier {

  ValueNotifier<bool> soundEnabled = ValueNotifier(true);

  ValueNotifier<bool> musicEnabled = ValueNotifier(true);

  ValueNotifier<bool> muted = ValueNotifier(false);

  SettingsController() {
    _loadSettings();
  }

  void _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    soundEnabled.value = prefs.getBool('soundEnabled') ?? true;
    musicEnabled.value = prefs.getBool('musicEnabled') ?? true;
    muted.value = prefs.getBool('muted') ?? false;
    notifyListeners();
  }

  void toggleSoundEnabled() async {
    soundEnabled.value = !soundEnabled.value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('soundEnabled', soundEnabled.value);
    notifyListeners();
  }

  void toggleMusicEnabled() async {
    musicEnabled.value = !musicEnabled.value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('musicEnabled', musicEnabled.value);
    notifyListeners();
  }

  void toggleMuted() async {
    muted.value = !muted.value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('muted', muted.value);
    notifyListeners();
  }

  Future<bool> getSoundSetting() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('soundEnabled') ?? true;
  }

  Future<bool> getMusicSetting() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('musicEnabled') ?? true;
  }

  Future<bool> getMutedSetting() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool('muted') ?? true;
  }

}