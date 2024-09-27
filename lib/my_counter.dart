import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:provider/provider.dart';

import 'audio_controller.dart';
import 'file_paths.dart';

class MyCounter {
  ValueNotifier<int> count = ValueNotifier<int>(0);

  ValueNotifier<bool> hasFinished = ValueNotifier<bool>(false);

  ValueNotifier<String> color = ValueNotifier<String>('pink');

  Timer? _timer;

  Timer? imageTimer;

  bool hasPlayedCelebrateSfx = false;

  late final AudioController audio;

  final Queue<String> starColors = Queue.of(colors);

  MyCounter(BuildContext context) {
    audio = context.read<AudioController>();
  }

  void startCounter(int targetValue) {
    Timer(const Duration(milliseconds: 250), () {
      _timer = Timer.periodic(const Duration(milliseconds: 150), (_) {
        if (count.value < targetValue) {
          count.value++;
        } else {
          hasFinished.value = true;
          playCelebrateSfxOnce();
          _timer?.cancel();
        }
      });
      imageTimer = Timer.periodic(const Duration(milliseconds: 150), (_) {
        if (!hasFinished.value) {
          color.value = starColors.first;
          starColors.addLast(starColors.removeFirst());
        } else {
          imageTimer?.cancel();
        }
      });
    });
  }

  void playCelebrateSfxOnce() {
    if (!hasPlayedCelebrateSfx) {
      audio.playSfx(audio.sfx['celebration']!.single);
      hasPlayedCelebrateSfx = true;
    }
  }
}
