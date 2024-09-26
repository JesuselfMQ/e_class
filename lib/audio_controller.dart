import 'dart:collection';

import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/widgets.dart';

import 'app_lifecycle.dart';
import 'file_paths.dart';
import 'settings.dart';
import 'sounds.dart';

/// Allows playing music and sounds.
class AudioController with SoundFileNames {
  final AudioPlayer sfxPlayer = AudioPlayer();

  final AudioPlayer musicPlayer = AudioPlayer();

  late final Queue<String> _playlist;

  SettingsController? _settings;

  ValueNotifier<AppLifecycleState>? _lifecycleNotifier;

  /// Creates an instance that plays music and sound.
  AudioController() {
    _playlist = Queue.of(songs..shuffle());
    musicPlayer.onPlayerComplete.listen(_playCurrentSong);
  }

  /// Make sure the audio controller is listening to changes
  /// of both the app lifecycle (e.g. suspended app) and to changes
  /// of settings (e.g. muted sound).
  void attachDependencies(AppLifecycleStateNotifier lifecycleNotifier,
      SettingsController settingsController) {
    _attachLifecycleNotifier(lifecycleNotifier);
    _attachSettings(settingsController);
  }

  void dispose() {
    _lifecycleNotifier?.removeListener(_handleAppLifecycle);
    _stopAllSound();
    musicPlayer.dispose();
    sfxPlayer.dispose();
  }

  /// Preloads songs.
  Future<void> initialize() async {
    await AudioCache.instance
        .loadAll(songs.map((file) => '$music$file.mp3').toList());
  }

  /// Plays the next song in the playlist.
  void nextSong() {
    // Put the previous song to the end of the playlist.
    _playlist.addLast(_playlist.removeFirst());
    // Play the song at the beginning of the playlist.
    _playCurrentSong(null);
  }

  /// Plays a single sound effect.
  Future<void> playSfx(String? string) async {
    final soundsVolume = _settings?.soundsVolume.value ?? 1.00;
    if (soundsVolume == 0.00) {
      return;
    }
    if (string!.length < 4) {
      // Means the sound effect is a syllable, in that case,
      // it must be played regardless of the settings.
      await sfxPlayer.play(AssetSource('Audio/Syllables/$string.mp3'));
    } else {
      final soundsOn = _settings?.soundsOn.value ?? true;
      if (!soundsOn) {
        return;
      }
      await sfxPlayer.play(AssetSource('Audio/SFX/$string.mp3'));
    }
  }

  /// Enables the [AudioController] to listen to [AppLifecycleState] events,
  /// and therefore do things like stopping playback when the game
  /// goes into the background.
  void _attachLifecycleNotifier(
      ValueNotifier<AppLifecycleState> lifecycleNotifier) {
    _lifecycleNotifier?.removeListener(_handleAppLifecycle);

    lifecycleNotifier.addListener(_handleAppLifecycle);
    _lifecycleNotifier = lifecycleNotifier;
  }

  /// Enables the [AudioController] to track changes to settings.
  /// Namely, when any of [SettingsController.muted],
  /// [SettingsController.musicOn] or [SettingsController.soundsOn] changes,
  /// the audio controller will act accordingly.
  void _attachSettings(SettingsController settingsController) {
    if (_settings == settingsController) {
      // Already attached to this instance. Nothing to do.
      return;
    }

    // Remove handlers from the old settings controller if present
    final oldSettings = _settings;
    if (oldSettings != null) {
      oldSettings.musicOn.removeListener(_musicOnHandler);
      oldSettings.musicVolume.removeListener(_musicVolumeHandler);
      oldSettings.soundsOn.removeListener(_soundsOnHandler);
      oldSettings.soundsVolume.removeListener(_soundsVolumeHandler);
    }

    _settings = settingsController;

    // Add handlers to the new settings controller
    settingsController.musicOn.addListener(_musicOnHandler);
    settingsController.musicVolume.addListener(_musicVolumeHandler);
    settingsController.soundsOn.addListener(_soundsOnHandler);
    settingsController.soundsVolume.addListener(_soundsVolumeHandler);

    if (settingsController.musicVolume.value != 0.00 &&
        settingsController.musicOn.value) {
      _playCurrentSong(null);
    }
  }

  void _handleAppLifecycle() {
    switch (_lifecycleNotifier!.value) {
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        _stopAllSound();
        break;
      case AppLifecycleState.resumed:
        if (_settings!.musicVolume.value != 0.00 && _settings!.musicOn.value) {
          _resumeMusic();
        }
        break;
      case AppLifecycleState.inactive:
        // No need to react to this state change.
        break;
    }
  }

  void _musicOnHandler() {
    _settings!.musicOn.value ? _resumeMusic() : _stopMusic();
  }

  void _musicVolumeHandler() async {
    musicPlayer.setVolume(_settings!.musicVolume.value);
    if ((_settings!.musicVolume.value == 0.00 && _settings!.musicOn.value) ||
        !_settings!.musicOn.value) {
      await _settings!.toggleMusicOn();
    }
  }

  Future<void> _playCurrentSong(void _) async {
    await musicPlayer.play(AssetSource('$music${_playlist.first}.mp3'));
  }

  Future<void> _resumeMusic() async {
    switch (musicPlayer.state) {
      case PlayerState.paused:
        try {
          await musicPlayer.resume();
        } catch (e) {
          // Sometimes, resuming fails with an "Unexpected" error.
          await _playCurrentSong(null);
        }
        break;
      case PlayerState.stopped:
        await _playCurrentSong(null);
        break;
      case PlayerState.playing:
        break;
      case PlayerState.completed:
        await _playCurrentSong(null);
        break;
      case PlayerState.disposed:
        break;
    }
  }

  void _soundsOnHandler() {
    if (sfxPlayer.state == PlayerState.playing) {
      sfxPlayer.stop();
    }
  }

  void _soundsVolumeHandler() async {
    sfxPlayer.setVolume(_settings!.soundsVolume.value);
    if ((_settings!.soundsVolume.value == 0.00 && _settings!.soundsOn.value) ||
        !_settings!.soundsOn.value) {
      await _settings!.toggleSoundsOn();
    }
  }

  void _stopAllSound() {
    _stopMusic();
    sfxPlayer.stop();
  }

  void _stopMusic() {
    if (musicPlayer.state == PlayerState.playing) {
      musicPlayer.pause();
    }
  }
}
