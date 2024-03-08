import 'package:audioplayers/audioplayers.dart';

class AudioController {
  final AudioPlayer _audioPlayer = AudioPlayer();

  Future<void> playSyllableSound(String syllable) async {
      // Assuming you have syllable sounds named by the syllable in your assets
      await _audioPlayer.play(AssetSource('Audio/Syllables/$syllable.mp3'));
  }

  Future<void> playWinningSound() async {
      await _audioPlayer.play(AssetSource('Audio/win.mp3'));
  }
}