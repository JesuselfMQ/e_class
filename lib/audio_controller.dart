import 'settings_controller.dart';
import 'package:flutter/widgets.dart';
import 'dart:math';
import 'file_paths.dart';
import 'songs.dart';
import 'package:audioplayers/audioplayers.dart';

class AudioController {
  AudioPlayer soundPlayer = AudioPlayer();

  AudioPlayer musicPlayer = AudioPlayer();

  String song = 'Audio/Music/${songs[Random().nextInt(songs.length)]}';

  SettingsController? _settings;

  ValueNotifier<AppLifecycleState>? _lifecycleNotifier;

  void attachLifecycleNotifier(
      ValueNotifier<AppLifecycleState> lifecycleNotifier) {
    _lifecycleNotifier?.removeListener(handleAppLifecycle);

    lifecycleNotifier.addListener(handleAppLifecycle);
    _lifecycleNotifier = lifecycleNotifier;
  }

  void attachSettings(SettingsController settingsController) {
    if (_settings == settingsController) {
      return;
    }

    final oldSettings = _settings;
    if (oldSettings != null) {
      oldSettings.musicVolume.removeListener(musicVolumeHandler);
      oldSettings.soundVolume.removeListener(soundVolumeHandler);
      oldSettings.musicEnabled.removeListener(musicEnabledHandler);
    }

    _settings = settingsController;

    settingsController.musicVolume.addListener(musicVolumeHandler);
    settingsController.soundVolume.addListener(soundVolumeHandler);
    settingsController.musicEnabled.addListener(musicEnabledHandler);

    if (settingsController.musicVolume.value != 0.00 && settingsController.musicEnabled.value) {
      playMusic();
    }
  }

  void dispose() {
    _lifecycleNotifier?.removeListener(handleAppLifecycle);
    stopAllSound();
    musicPlayer.dispose();
    soundPlayer.dispose();
  }

  Future<void> initialize() async {
    await AudioCache.instance.loadAll(songs
        .map((file) => path['music']! + file)
        .toList());
  }

  Future<void> playSfx(string) async {
    final soundVolume = _settings?.soundVolume.value ?? 1.00;
    final soundEnabled = _settings?.soundEnabled.value ?? true;
    if (soundVolume == 0.00) {
      return;
    }
    if (string.length < 4) {
      await soundPlayer.play(AssetSource('Audio/Syllables/$string.mp3'));
    } else {
      if (soundEnabled) {
        await soundPlayer.play(AssetSource('Audio/SFX/$string'));
      } else {
        return;
      }
    }
  }

  Future<void> changeSong() async {
    String oldSong = song;
    String newSong = '';
    do {
      newSong = 'Audio/Music/${songs[Random().nextInt(songs.length)]}';
    }
    while (newSong == oldSong);
    song = newSong;
    await playMusic();
  }

  void handleAppLifecycle() {
    switch (_lifecycleNotifier!.value) {
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        stopAllSound();
        break;
      case AppLifecycleState.resumed:
        if (_settings!.musicVolume.value != 0.00 && _settings!.musicEnabled.value) {
          resumeMusic();
        }
        break;
      case AppLifecycleState.inactive:
        break;
    }
  }

  void musicEnabledHandler() {
    if (_settings!.musicVolume.value == 0.00 || !_settings!.musicEnabled.value) {
      stopMusic();
    } else {
      resumeMusic();
    }
  }

  void musicVolumeHandler() {
    musicPlayer.setVolume(_settings!.musicVolume.value);
  }

  void soundVolumeHandler() {
    soundPlayer.setVolume(_settings!.soundVolume.value);
  }

  Future<void> playMusic() async {
    await musicPlayer.play(AssetSource(song));
    musicPlayer.onPlayerComplete.listen((_){
      musicPlayer.play(AssetSource(song));
    });
  }

  Future<void> resumeMusic() async {
    switch (musicPlayer.state) {
      case PlayerState.paused:
        try {
          await musicPlayer.resume();
        } catch (e) {
          await playMusic();
        }
        break;
      case PlayerState.stopped:
        await musicPlayer.resume();
        break;
      case PlayerState.playing:
        break;
      case PlayerState.completed:
        await playMusic();
        break;
      case PlayerState.disposed:
        break;
    }
  }

  void soundEnabledHandler() async {
      if (soundPlayer.state == PlayerState.playing) {
        await soundPlayer.stop();
      }
  }

  void stopAllSound() async {
    if (musicPlayer.state == PlayerState.playing) {
      await musicPlayer.stop();
    }
    await soundPlayer.stop();
  }

  void stopMusic() {
    if (musicPlayer.state == PlayerState.playing) {
      musicPlayer.pause();
    }
  }
}