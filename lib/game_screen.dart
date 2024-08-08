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
    final utils = Utils(size);
    return FillBackground(
        background: '${backgroung}game.jpg',
        child: Stack(children: [
          Column(children: [
            Expanded(child: getGameHud(utils)),
            Expanded(
                flex: 2,
                child: ValueListenableBuilder(
                    valueListenable: displaySyllables,
                    builder: (_, display, __) =>
                        getSyllablesDisplay(display, utils))),
            utils.getArrowBackButton(() => goToMenu())
          ]),
          for (var i = 0; i < 5; i++) animation.getPointsTransition(size, i)
        ]));
  }

  Widget getGameHud(Utils utils) => GridView.count(
        childAspectRatio: size.aspectRatio * 1.4,
        crossAxisCount: 3,
        children: [
          Row(
              children: List.generate(
                  5,
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
                  "${ui}play_sound_button.png",
                  10,
                  16,
                  () => audio.playSfx(sound)))
        ],
      );

  Widget getSyllablesDisplay(List<String> display, Utils utils) =>
      GridView.count(
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
                    onPressed: () => onSyllablePressed(display[index]))
          ]);
        }),
      );
}

/// Styled button for displaying syllables.
class SyllableButton extends StatelessWidget {
  final void Function()? onPressed;

  final String syllable;

  final SizeConfig size;

  const SyllableButton(
      {required this.syllable,
      required this.size,
      required this.onPressed,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: TextButton(
            onPressed: onPressed,
            child: Text(syllable,
                style: TextStyle(
                    fontSize: size.safeBlockVertical * 12.1359,
                    fontFamily: 'Ginthul',
                    foreground: Paint()
                      ..style = PaintingStyle.fill
                      ..strokeWidth = 4
                      ..color = const Color.fromRGBO(69, 69, 69, 1)))));
  }
}
