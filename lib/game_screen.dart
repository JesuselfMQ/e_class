import 'settings_controller.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import "dart:math";
import 'syllables.dart';
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

  double syllablesFontSize = 60;
  
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

  void onSyllablePressed(String syllable) {
    print(MediaQuery.of(context).size.width);
    print(MediaQuery.of(context).size.height);
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
                childAspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 1.7 ),
                crossAxisCount: 3,
                children: [
                  Align(alignment: Alignment.center, child: Image.asset('assets/white/points_$imageScore.png', width: 360, height: 180)),
                  Align(alignment: Alignment.center, child: Image.asset('assets/white/lives_$attempts.png', width: 200, height: 180)),
                  Align(alignment: Alignment.center, 
                    child: IconButton(
                      icon: Image.asset('assets/play_sound_button.png', width: 150, height: 130),
                      onPressed: () {
                        playSound();
                      },
                    )
                  )
                ],
              )
            ),
            Expanded(
              flex: 3,
              child: GridView.count(
                crossAxisCount: 4,
                childAspectRatio: MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height / 1.3 ),
                children: <Widget>[
                  ...List.generate(syllables2Display.length, (index) {
                    return Stack(
                      children: [
                        Center(
                          child: Image.asset('assets/note.png', alignment: Alignment.center),
                        ),
                        Center(
                          child: TextButton(
                            onPressed: () => onSyllablePressed(syllables2Display[index]),
                            child: Text(syllables2Display[index], style: TextStyle(fontSize: syllablesFontSize, fontWeight: FontWeight.bold, fontFamily: 'Heirany Slight', foreground: Paint()
                              ..style = PaintingStyle.fill
                              ..strokeWidth = 4
                              ..color = Colors.black
                            ))
                          )
                        )
                      ]
                    );
                  }),
                ]
              )
            ),
            Padding(
              padding: const EdgeInsets.all(10.0),
              child: IconButton(
                onPressed: () => GoRouter.of(context).go('/'),
                icon: Image.asset('assets/arrow_button_back.png', width: 70, height: 60)
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