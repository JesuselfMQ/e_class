import 'package:e_class/extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'animation.dart';
import 'audio_controller.dart';
import 'decoration.dart';
import 'file_paths.dart';
import 'my_value_listenable.dart';
import 'settings.dart';
import 'size_config.dart';
import 'syllable_handler.dart';
import 'utils.dart';

/// This widget defines the entirety of the screen that the player sees when
/// they are playing a game.
class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen>
    with SingleTickerProviderStateMixin {
  static const maxPoints = 5;

  int score = 0;
  int pointsIconCount = 0;
  bool _isInitialized = false;

  ValueNotifier<int> attempts = ValueNotifier(3);
  ValueNotifier<List<String>> syllables = ValueNotifier([]);
  ValueNotifier<List<String>> displaySyllables = ValueNotifier([]);
  ValueNotifier<String> syllableSound = ValueNotifier("");

  late final SyllableHandler syllableHandler;
  late final SettingsController settings;
  late final AudioController audio;
  late final PointsAnimationHandler animation;
  late SizeConfig size;
  late Utils utils;

  @override
  void dispose() {
    animation.dispose();
    attempts.dispose();
    syllables.dispose();
    displaySyllables.dispose();
    syllableSound.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (!_isInitialized) {
      _initGame();
      _isInitialized = true;
    }
  }

  void _initGame() async {
    animation = PointsAnimationHandler(this);

    settings = context.read<SettingsController>();
    audio = context.read<AudioController>();
    syllableHandler = SyllableHandler(settings);

    await syllableHandler.initialize();
    syllables.value = syllableHandler.filterAllSyllables();
    assignNewSyllables();
  }

  /// When the user press a syllable button.
  void onSyllablePressed(String syllable) {
    syllable == syllableSound.value ? handleWin() : handleLose();
  }

  void handleLose() {
    if (attempts.value > 1) {
      final loseSfx = audio.sfx["lose"]?.randomItem;
      audio.playSfx(loseSfx);
      // Subtract one attempt
      attempts.value -= 1;
    } else {
      goToLoseScreen();
    }
  }

  void handleWin() {
    final winSfx = audio.sfx["win"]?.randomItem;
    audio.playSfx(winSfx);
    if (pointsIconCount == maxPoints) {
      pointsIconCount = 0;
      animation.restartPointImages();
    }

    animation.startAnimation(pointsIconCount);
    // Increment score
    score += 1;
    pointsIconCount += 1;
    assignNewSyllables();
  }

  /// Selects new random syllables and update the display
  void assignNewSyllables() {
    displaySyllables.value = syllables.value.randomItems(10);
    syllableSound.value = displaySyllables.value.randomItem;
  }

  void goToLoseScreen() {
    context.go('/game/lose', extra: score);
  }

  /// Navigates back to the menu screen.
  void goToMenu() {
    settings.setMusicVolume(settings.oldMusicVolume);
    context.go('/');
  }

  @override
  Widget build(BuildContext context) {
    size = SizeConfig(context);
    utils = Utils(size);
    return FillBackground(
        backgroundFile: 'game.jpg',
        child: Stack(children: [
          Column(children: [
            Expanded(child: getGameHud()),
            Expanded(
                flex: 2,
                child: ValueListenableBuilder(
                    valueListenable: displaySyllables,
                    builder: (_, display, __) => getSyllablesDisplay(display))),
            utils.getArrowBackButton(() => goToMenu())
          ]),
          for (var i = 0; i < maxPoints; i++)
            animation.getPointsTransition(size, i)
        ]));
  }

  Widget getGameHud() => GridView.count(
        childAspectRatio: size.aspectRatio * 1.4,
        crossAxisCount: 3,
        children: [
          Row(
              children: List.generate(
                  maxPoints,
                  (int index) => ValueListenableBuilder2(
                      first: animation.pointsOn[index],
                      second: animation.transitionOn[index],
                      builder: (_, __, ___, ____) => utils.getCenteredImage(
                            animation.getPointsImageFilePath(index),
                            6,
                            30,
                          )))),
          ValueListenableBuilder(
              valueListenable: attempts,
              builder: (_, lives, __) =>
                  utils.getCenteredImage("${ui}lives_$lives.gif", 25, 25)),
          ValueListenableBuilder(
              valueListenable: syllableSound,
              builder: (_, sound, __) => utils.getCenteredImage(
                  "${ui}play_syllable_button.png",
                  10,
                  16,
                  () => audio.playSfx(sound)))
        ],
      );

  Widget getSyllablesDisplay(List<String> display) => GridView.count(
        childAspectRatio: size.aspectRatio * 0.85,
        crossAxisCount: 5,
        children: List.generate(10, (int index) {
          return Stack(children: [
            utils.getCenteredImage("${ui}note.png", 34, 36),
            display.isEmpty
                ? const Text("")
                : SyllableButton(
                    syllable: display[index],
                    size: size,
                    fontSize: 12,
                    onPressed: () => onSyllablePressed(display[index]))
          ]);
        }),
      );
}
