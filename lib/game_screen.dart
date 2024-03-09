import 'settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import "dart:math";
import 'syllables.dart';
import 'size_config.dart';
import 'audio_controller.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> {
  late AudioController audioController;

  int score = 0;
  int attempts = 3;
  int imageScore = 0;
  
  var syllables;
  var syllables2Display;
  var syllableSound;

  @override
  void initState() {
  super.initState();
  audioController = AudioController();
  _initGame();
}

  void _initGame() async {
  syllables = await generateSpanishSyllables();
  syllables2Display = getRandomSyllables(syllables);
  syllableSound = syllables2Display[Random().nextInt(syllables2Display.length)];
  setState(() {});
  }

  void playSound({bool isWinning = false}) async {
    bool isSoundEnabled = await SettingsController().getSoundSetting();
    if (!isSoundEnabled) return;
    if (isWinning) {
      audioController.playWinningSound();
    } else {
      audioController.playSyllableSound(syllableSound);
    }
  }

  double getFitMode() {
    return 1.0;
  }

  void onSyllablePressed(String syllable) {
    print(SizeConfig.blockSizeHorizontal);
    print(SizeConfig.blockSizeVertical);
    if (syllable == syllableSound) {
      // Play winning sound
      playSound(isWinning: true);
      if (imageScore == 5) {
        imageScore = 0;
      }
      // Increment score
      setState(() {
        score += 1;
        imageScore += 1;
      });

      // Select new random syllables and update the display
      List<String> newSyllables = getRandomSyllables(syllables);
      setState(() {
        syllables2Display = newSyllables;
        syllableSound = newSyllables[Random().nextInt(newSyllables.length)];
      });
    } else {
      if (attempts > 1) {
        // Subtract one attempt
        setState(() {
          attempts -= 1;
        });
      } else {
        // Navigate back to the Menu Screen
        GoRouter.of(context).go('/');
      }
    }
  }


  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/game_background.jpg"),
            fit: BoxFit.fill,
          )
        ),
        child: Column(
          children:[
            Expanded(
              child: GridView.count(
                childAspectRatio: SizeConfig.aspectRatio * 1.4,
                crossAxisCount: 3,
                padding: EdgeInsets.zero,
                children: [
                  Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/white/points_$imageScore.png',
                      width: SizeConfig.blockSizeHorizontal * 30,
                      height: SizeConfig.blockSizeVertical * 30
                    )
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      'assets/white/lives_$attempts.png',
                      width: SizeConfig.blockSizeHorizontal * 18,
                      height: SizeConfig.blockSizeVertical * 18
                    )
                  ),
                  Align(
                    alignment: Alignment.center, 
                    child: IconButton(
                      icon: Image.asset(
                        'assets/play_sound_button.png',
                        fit: BoxFit.fill,
                        width: SizeConfig.blockSizeHorizontal * 8,
                        height: SizeConfig.blockSizeVertical * 16
                      ),
                      onPressed: () {
                        playSound();
                      },
                    )
                  )
                ],
              )
            ),
            Expanded(
              flex: 2,
              child: GridView.count(
                childAspectRatio: SizeConfig.aspectRatio * 0.8,
                crossAxisCount: 5,
                padding: EdgeInsets.zero,
                children: <Widget>[
                  ...List.generate(syllables2Display.length, (index) {
                    return Stack(
                      children: [
                        Center(
                          child: Image.asset(
                            'assets/note.png',
                            alignment: Alignment.center,
                            width: SizeConfig.blockSizeHorizontal * 33.9750,
                            height: SizeConfig.blockSizeVertical * 36.4077
                          )
                        ),
                        Center(
                          child: TextButton(
                            onPressed: () => onSyllablePressed(syllables2Display[index]),
                            child: Text(
                              syllables2Display[index],
                              style: TextStyle(
                                fontSize: SizeConfig.blockSizeVertical * 12.1359,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Heirany Slight',
                                foreground: Paint()
                                ..style = PaintingStyle.fill
                                ..strokeWidth = 4
                                ..color = Colors.black
                              )
                            )
                          )
                        )
                      ]
                    );
                  }),
                ]
              )
            ),
            Padding(
              padding: EdgeInsets.zero,
              child: IconButton(
                onPressed: () => GoRouter.of(context).go('/'),
                icon: Image.asset(
                  'assets/arrow_button_back.png',
                  width: SizeConfig.blockSizeHorizontal * 8,
                  height: SizeConfig.blockSizeVertical * 16
                )
              )
            )
          ]
        )
      )
    );
  }
}

class TempScreen extends StatefulWidget {
  const TempScreen({super.key});

  @override
  State<TempScreen> createState() => _TempScreenState();
}

class _TempScreenState extends State<TempScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/menu_background.png"),
            fit: BoxFit.fill,
          ),
        ),
        child: const Center( child: Text('E   C L A S S',
          style: TextStyle(
            fontFamily: 'Fifth Grader',
            fontSize: 340,
          ),
        )
      ))
    );
  }
}