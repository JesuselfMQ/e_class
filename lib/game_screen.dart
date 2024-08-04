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

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {
  int score = 0;
  int iconCount = -1;
  bool _isInitialized = false;

  ValueNotifier<int> attempts = ValueNotifier(3);
  ValueNotifier<List<String>> syllables = ValueNotifier([]);
  ValueNotifier<List<String>> displaySyllables = ValueNotifier([]);
  ValueNotifier<String> syllableSound = ValueNotifier("");

  late final SyllableHandler syllableHandler;
  late final SettingsController settings;
  late final AudioController audio;
  late final AnimationHandler animation;


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
    animation = AnimationHandler(this);

    settings = context.watch<SettingsController>();
    audio = context.read<AudioController>();
    syllableHandler = SyllableHandler(settings);

    animation.moveController.addStatusListener((status) {
      if (status == AnimationStatus.completed) {
        animation.pointsOn[iconCount].value = true;
        animation.transitionOn[iconCount].value = false;
      }
    });

    await syllableHandler.initialize();
    syllables.value = syllableHandler.filterAllSyllables();
    displaySyllables.value = syllables.value.randomItems(10);
    syllableSound.value = displaySyllables.value.randomItem;
  }

  /// When the user press a syllable button.
  void onSyllablePressed(String syllable) {
    if (syllable == syllableSound.value) {
      final winSfx = audio.sfx["win"]?.randomItem;
      audio.playSfx(winSfx);
      if (iconCount == 4) {
        iconCount = -1;
        animation.color.addLast(animation.color.removeFirst());
        for (var i in animation.pointsOn) {
          i.value = false;
        }
      }
      // Increment score
      score += 1;
      iconCount += 1;
      animation.startAnimation(iconCount);
      // Select new random syllables and update the display
      List<String> newSyllables = syllables.value.randomItems(10);
      displaySyllables.value = newSyllables;
      syllableSound.value = displaySyllables.value.randomItem;
    } else {
      if (attempts.value > 1) {
        final loseSfx = audio.sfx["lose"]?.randomItem;
        audio.playSfx(loseSfx);
        // Subtract one attempt
        attempts.value -= 1;
      } else {
        goToMenu();
      }
    }
  }

  /// Navigates back to the menu screen.
  void goToMenu() {
    settings.toggleMusicOn();
    GoRouter.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final size = SizeConfig(context);
    animation.init(size);
    return FillBackground(
        background: '${backgroung}game_background.jpg',
        child: Stack(children: [
          Column(children: [
            Expanded(
                child: GridView.count(
              childAspectRatio: size.aspectRatio * 1.4,
              crossAxisCount: 3,
              children: [
                Row(children: [
                  ...List.generate(
                      5,
                      (int index) => ValueListenableBuilder2(
                          first: animation.pointsOn[index],
                          second: animation.transitionOn[index],
                          builder: (_, __, ___, ____) => getGameUiElement(
                              animation.getImage(index),
                              size,
                              6,
                              30,)))
                ]),
                ValueListenableBuilder(
                    valueListenable: attempts,
                    builder: (_, lives, __) => getGameUiElement(
                        "${ui}lives_$lives.gif", size, 25, 25)),
                ValueListenableBuilder(
                    valueListenable: syllableSound,
                    builder: (_, sound, __) => getGameUiElement(
                        "${ui}play_sound_button.png",
                        size,
                        10,
                        16,
                        null,
                        () => audio.playSfx(sound)))
              ],
            )),
            Expanded(
                flex: 2,
                child: ValueListenableBuilder(
                    valueListenable: displaySyllables,
                    builder: (_, display, __) => GridView.count(
                            childAspectRatio: size.aspectRatio * 0.85,
                            crossAxisCount: 5,
                            children: <Widget>[
                              ...List.generate(10, (int index) {
                                return Stack(children: [
                                  getGameUiElement(
                                      "${ui}note.png", size, 34, 36),
                                  displaySyllables.value.isEmpty
                                      ? const Text("")
                                      : SyllableButton(
                                          syllable:
                                              displaySyllables.value[index],
                                          size: size,
                                          onPressed: () => onSyllablePressed(
                                              displaySyllables.value[index]))
                                ]);
                              }),
                            ]))),
            getArrowBackButton(size, () => goToMenu())
          ]),
          for (var i = 0; i < 5; i++)
            ValueListenableBuilder(
                valueListenable: animation.transitionOn[i],
                builder: (_, __, ___) => animation.transitionOn[i].value
                    ? animation.getTransition(i)
                    : const SizedBox.shrink())
        ]));
  }
}
