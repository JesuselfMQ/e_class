import 'package:audioplayers/audioplayers.dart';
import 'dart:collection';
import 'settings_controller.dart';
import 'package:flutter/widgets.dart';
import 'dart:math';
import 'sounds.dart';
import 'songs.dart';

class AudioController {
  final AudioPlayer _musicPlayer;

  final List<AudioPlayer> _sfxPlayers;

  int _currentSfxPlayer = 0;

  final Random _random = Random();

  final Queue<Song> _playlist;

  SettingsController? _settings;

  ValueNotifier<AppLifecycleState>? _lifecycleNotifier;

  AudioController({int polyphony = 1})
      : assert(polyphony >= 1),
        _musicPlayer = AudioPlayer(),
        _sfxPlayers = Iterable.generate(
                polyphony, (i) => AudioPlayer(playerId: 'sfxPlayer#$i'))
            .toList(growable: false),
        _playlist = Queue.of(List<Song>.of(songs)..shuffle()) {
          _musicPlayer.onPlayerComplete.listen(_changeSong);
        }

  void attachLifecycleNotifier(
      ValueNotifier<AppLifecycleState> lifecycleNotifier) {
    _lifecycleNotifier?.removeListener(_handleAppLifecycle);

    lifecycleNotifier.addListener(_handleAppLifecycle);
    _lifecycleNotifier = lifecycleNotifier;
  }

  void attachSettings(SettingsController settingsController) {
    if (_settings == settingsController) {
      return;
    }

    final oldSettings = _settings;
    if (oldSettings != null) {
      oldSettings.muted.removeListener(_mutedHandler);
      oldSettings.musicEnabled.removeListener(_musicEnabledHandler);
      oldSettings.soundEnabled.removeListener(_soundEnabledHandler);
    }

    _settings = settingsController;

    settingsController.muted.addListener(_mutedHandler);
    settingsController.musicEnabled.addListener(_musicEnabledHandler);
    settingsController.soundEnabled.addListener(_soundEnabledHandler);

    if (!settingsController.muted.value && settingsController.musicEnabled.value) {
      _startMusic();
    }
  }

  void dispose() {
    _lifecycleNotifier?.removeListener(_handleAppLifecycle);
    _stopAllSound();
    _musicPlayer.dispose();
    for (final player in _sfxPlayers) {
      player.dispose();
    }
  }

  Future<void> initialize() async {
    await AudioCache.instance.loadAll(SfxType.values
        .expand(soundTypeToFilename)
        .map((path) => 'Audio/SFX/$path')
        .toList());
  }

  Future<void> playSfx([SfxType type = SfxType.none, String syllable = '']) async {
    final muted = _settings?.muted.value ?? true;
    if (muted) {
      return;
    }
    final soundsOn = _settings?.soundEnabled.value ?? false;
    if (!soundsOn) {
      return;
    }

    if(syllable != '') {
      final currentPlayer = _sfxPlayers[_currentSfxPlayer];
      await currentPlayer.play(AssetSource('Audio/Syllables/$syllable.mp3'));
      return;
    }

    final options = soundTypeToFilename(type);
    final filename = options[_random.nextInt(options.length)];

    final currentPlayer = _sfxPlayers[_currentSfxPlayer];
    currentPlayer.play(AssetSource('SFX/$filename'));
    _currentSfxPlayer = (_currentSfxPlayer + 1) % _sfxPlayers.length;
  }

  void _changeSong(void _) {
    _playlist.addLast(_playlist.removeFirst());
    _playFirstSongInPlaylist();
  }

  void _handleAppLifecycle() {
    switch (_lifecycleNotifier!.value) {
      case AppLifecycleState.paused:
      case AppLifecycleState.detached:
      case AppLifecycleState.hidden:
        _stopAllSound();
        break;
      case AppLifecycleState.resumed:
        if (!_settings!.muted.value && _settings!.musicEnabled.value) {
          _resumeMusic();
        }
        break;
      case AppLifecycleState.inactive:
        break;
    }
  }

  void _musicEnabledHandler() {
    if (_settings!.musicEnabled.value) {
      // Music got turned on.
      if (!_settings!.muted.value) {
        _resumeMusic();
      }
    } else {
      // Music got turned off.
      _stopMusic();
    }
  }

  void _mutedHandler() {
    if (_settings!.muted.value) {
      // All sound just got muted.
      _stopAllSound();
    } else {
      // All sound just got un-muted.
      if (_settings!.musicEnabled.value) {
        _resumeMusic();
      }
    }
  }

  Future<void> _playFirstSongInPlaylist() async {
    await _musicPlayer.play(AssetSource('Audio/Music/${_playlist.first.filename}'));
  }

  Future<void> _resumeMusic() async {
    switch (_musicPlayer.state) {
      case PlayerState.paused:
      try {
          await _musicPlayer.resume();
        } catch (e) {
          await _playFirstSongInPlaylist();
        }
        break;
      case PlayerState.stopped:
        await _playFirstSongInPlaylist();
        break;
      case PlayerState.playing:
        break;
      case PlayerState.completed:
        await _playFirstSongInPlaylist();
        break;
      case PlayerState.disposed:
        break;
    }
  }

  void _soundEnabledHandler() {
    for (final player in _sfxPlayers) {
      if (player.state == PlayerState.playing) {
        player.stop();
      }
    }
  }

  void _startMusic() {
    _playFirstSongInPlaylist();
  }

  void _stopAllSound() {
    if (_musicPlayer.state == PlayerState.playing) {
      _musicPlayer.pause();
    }
    for (final player in _sfxPlayers) {
      player.stop();
    }
  }

  void _stopMusic() {
    if (_musicPlayer.state == PlayerState.playing) {
      _musicPlayer.pause();
    }
  }

}