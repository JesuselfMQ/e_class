import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import "dart:math";
import 'syllables.dart';
import 'size_config.dart';
import 'audio_controller.dart';
import 'sounds.dart';
import 'widget_builder.dart' as wb;
import 'file_paths.dart';

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
  
  late List<String> syllables = [];
  late List<String> syllables2Display = [];
  late String syllableSound = '';

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

  void onSyllablePressed(String syllable) {
    if (syllable == syllableSound) {
      final audioController = context.read<AudioController>();
      audioController.playSfx(win[Random().nextInt(3)]);
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

        final audioController = context.read<AudioController>();
        audioController.playSfx(lose);

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
        decoration: wb.WidgetBuilder().getBackground('${path['background']}game_background.jpg'),
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
                      '${path['ui']}points_$imageScore.png',
                      width: SizeConfig.blockSizeHorizontal * 30,
                      height: SizeConfig.blockSizeVertical * 30
                    )
                  ),
                  Align(
                    alignment: Alignment.center,
                    child: Image.asset(
                      '${path['ui']}lives_$attempts.gif',
                      width: SizeConfig.blockSizeHorizontal * 25,
                      height: SizeConfig.blockSizeVertical * 25
                    )
                  ),
                  Align(
                    alignment: Alignment.center, 
                    child: IconButton(
                      icon: Image.asset(
                        '${path['ui']}play_sound_button.png',
                        fit: BoxFit.fill,
                        width: SizeConfig.blockSizeHorizontal * 8,
                        height: SizeConfig.blockSizeVertical * 16
                      ),
                      onPressed: () {
                        final audioController = context.read<AudioController>();
                        audioController.playSfx(syllableSound);
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
                  ...List.generate(10, (index) {
                    return Stack(
                      children: [
                        Center(
                          child: Image.asset(
                            '${path['ui']}note.png',
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
                                fontFamily: 'Ginthul',
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
                  '${path['ui']}arrow_button_back.png',
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