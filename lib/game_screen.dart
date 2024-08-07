import 'package:e_class/extensions.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'animation.dart';
import 'audio_controller.dart';
import 'file_paths.dart';
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
    displaySyllables.value = syllables.value.randomItems(10);
    syllableSound.value = displaySyllables.value.randomItem;
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
      goToMenu();
    }
  }

  void handleWin() {
    final winSfx = audio.sfx["win"]?.randomItem;
    audio.playSfx(winSfx);
    if (pointsIconCount == 5) {
      pointsIconCount = 0;
      animation.restartPointImages();
    }

    animation.startAnimation(pointsIconCount);
    // Increment score
    score += 1;
    pointsIconCount += 1;
    // Select new random syllables and update the display
    List<String> newSyllables = syllables.value.randomItems(10);
    displaySyllables.value = newSyllables;
    syllableSound.value = displaySyllables.value.randomItem;
  }

  /// Navigates back to the menu screen.
  void goToMenu() {
    settings.setMusicVolume(settings.oldMusicVolume);
    GoRouter.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    size = SizeConfig(context);
    return FillBackground(
        background: '${backgroung}game.jpg',
        child: Stack(children: [
          Column(children: [
            Expanded(
                child: GridView.count(
              childAspectRatio: size.aspectRatio * 1.4,
              crossAxisCount: 3,
              children: [
                Row(
                    children: List.generate(
                        5,
                        (int index) => getGameUiElement(
                            size,
                            6,
                            30,
                            [
                              animation.pointsOn[index],
                              animation.transitionOn[index],
                            ],
                            count: index,
                            animation: animation))),
                getGameUiElement(size, 25, 25, [attempts],
                    lives: attempts.value),
                getGameUiElement(size, 10, 10, [syllableSound],
                    onSelected: () => audio.playSfx(syllableSound.value))
              ],
            )),
            Expanded(
                flex: 2,
                child: ValueListenableBuilder(
                    valueListenable: displaySyllables,
                    builder: (_, display, __) => GridView.count(
                          childAspectRatio: size.aspectRatio * 0.85,
                          crossAxisCount: 5,
                          children: List.generate(10, (int index) {
                            return Stack(children: [
                              getGameUiElement(size, 34, 36, [], note: true),
                              display.isEmpty
                                  ? const Text("")
                                  : SyllableButton(
                                      syllable: displaySyllables.value[index],
                                      size: size,
                                      onPressed: () => onSyllablePressed(
                                          displaySyllables.value[index]))
                            ]);
                          }),
                        ))),
            getArrowBackButton(size, () => goToMenu()),
          ]),
          for (var i = 0; i < 5; i++) animation.getPointsTransition(size, i)
        ]));
  }
}
