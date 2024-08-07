import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'phonetic_data.dart';

/// A class that holds settings like [soundsVolume] or [musicOn],
/// and saves them to a SharedPreferences persistence storage.
class SettingsController with ChangeNotifier, PhoneticData {
  double oldMusicVolume = 0.0;

  /// Music player volume (range from 0.00 to 1.00).
  ValueNotifier<double> musicVolume = ValueNotifier(0.80);

  /// Sounds player volume (range from 0.00 to 1.00).
  ValueNotifier<double> soundsVolume = ValueNotifier(1.00);

  /// Syllable preferences. (whether they're enabled or disabled).
  Map<String, ValueNotifier<bool>> syllablesPrefs = {};

  /// Whether or not the music is on.
  ValueNotifier<bool> musicOn = ValueNotifier(true);

  /// Whether or not the sound effects (sfx) are on.
  ValueNotifier<bool> soundsOn = ValueNotifier(true);

  /// Creates a new instance of [SettingsController].
  SettingsController() {
    _loadSettings();
  }

  /// Loads all the syllables preferences.
  Future<Map<String, ValueNotifier<bool>>> getSyllablesPrefs() async {
    final prefs = await SharedPreferences.getInstance();
    return {
      // Getting preferences boolean values (from whether a consonant is enabled (true) or not (false), default: false).
      for (String key in allPhoneticComponents)
        key: ValueNotifier(prefs.getBool(key) ?? false)
    };
  }

  void toggleSyllableOn(String syllable) async {
    final prefs = await SharedPreferences.getInstance();
    var oldPref = prefs.getBool(syllable) ?? false;
    await prefs.setBool(syllable, !oldPref);
    syllablesPrefs[syllable]!.value = !oldPref;
  }

  void setMusicVolume(double value) async {
    oldMusicVolume = musicVolume.value;
    musicVolume.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('musicVolume', value);
    notifyListeners();
  }

  void setSoundsVolume(double value) async {
    soundsVolume.value = value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setDouble('soundsVolume', value);
    notifyListeners();
  }

  Future<void> toggleMusicOn() async {
    musicOn.value = !musicOn.value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('musicOn', musicOn.value);
    notifyListeners();
  }

  Future<void> toggleSoundsOn() async {
    soundsOn.value = !soundsOn.value;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('soundsOn', soundsOn.value);
    notifyListeners();
  }

  /// Asynchronously load values from the SharedPreferences instance.
  void _loadSettings() async {
    final prefs = await SharedPreferences.getInstance();
    musicVolume.value = prefs.getDouble('musicVolume') ?? 0.80;
    soundsVolume.value = prefs.getDouble('soundsVolume') ?? 1.00;
    musicOn.value = prefs.getBool('musicOn') ?? true;
    soundsOn.value = prefs.getBool('soundsOn') ?? true;
    syllablesPrefs = {
      for (String key in allPhoneticComponents)
        key: ValueNotifier(prefs.getBool(key) ?? false)
    };
    notifyListeners();
  }
}
