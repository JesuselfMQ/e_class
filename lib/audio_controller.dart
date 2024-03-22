import 'package:audioplayers/audioplayers.dart';
import 'dart:math';

class AudioController {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> playSyllableSound(String syllable) async {
      // Assuming you have syllable sounds named by the syllable in your assets
      await _audioPlayer.play(AssetSource('Audio/Syllables/$syllable.mp3'));
  }

  Future<void> playWinningSound() async {
      int randomNumber = Random().nextInt(2);
      await _audioPlayer.play(AssetSource('Audio/win_$randomNumber.mp3'));
  }

  Future<void> playLosingSound() async {
      await _audioPlayer.play(AssetSource('Audio/lose.mp3'));
  }

  Future<void> playSwitchSound() async {
    await _audioPlayer.play(AssetSource('Audio/switch.mp3'));
  }

  Future<void> playMenuMusic() async {
    await _audioPlayer.play(AssetSource('Audio/taylorswift-x-hozier-forest-gtr-by-prorefx.mp3'));
  }

}