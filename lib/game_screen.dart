import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import "dart:math";
import 'syllables.dart';
import 'size_config.dart';
import 'audio_controller.dart';
import 'settings_controller.dart';
import 'sounds.dart';
import 'widget_builder.dart' as wb;
import 'file_paths.dart';
import 'package:gif_view/gif_view.dart';

class GameScreen extends StatefulWidget {
  const GameScreen({super.key});

  @override
  State<GameScreen> createState() => _GameScreenState();
}

class _GameScreenState extends State<GameScreen> with TickerProviderStateMixin {

  int score = 0;
  int attempts = 3;
  int imageScore = 0;
  bool isTransitioning = false;
  
  late List<String> syllables = [];
  late List<String> syllables2Display = [];
  late String syllableSound = '';

  @override
  void initState() {
    super.initState();
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
      audioController.playSfx(win[Random().nextInt(win.length)]);
      if (imageScore == 5) {
        imageScore = 0;
      }
      // Increment score
      setState(() {
        score += 1;
        imageScore += 1;
        isTransitioning = true;
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
        final settings = Provider.of<SettingsController>(context, listen: false);
        settings.toggleMusicEnabled();
        GoRouter.of(context).go('/');
      }
    }
  }

  Widget getTransitionImage(controller,points, blockHorizontal) {
    if (isTransitioning) {
      return Positioned(
        top: 0,
        left: blockHorizontal * 3,
        child: GifView.asset(
          '${path['ui']}points_transition_$points.gif',
          controller: controller,
          width: SizeConfig.blockSizeHorizontal * 56.9519,
          height: SizeConfig.blockSizeVertical * 65.3826,
        ),
      );
    } else {
      return const Text('');
    }
  }

  double getScaleFactor(int tries) {
    if (tries == 3) {
      return 30;
    } else {
      return 25;
    }
  }

  String getImagePath(points) {
    if(isTransitioning) {
      return '${path['ui']}points_transition_$points.png';
    } else {
      if (points == 0) {
        return '${path['ui']}points_$points.png';
      } else {
        return '${path['ui']}points_$points.gif';
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final settings = context.watch<SettingsController>();
    final controller = GifController(
      loop: false,
      onFinish: () {
        isTransitioning = false;
        setState(() {});
      }
    );
    if (syllables2Display.isEmpty) {
      return const CircularProgressIndicator();
    } else {
      return Scaffold(
        body: Container(
          decoration: wb.WidgetBuilder().getBackground('${path['background']}game_background.jpg'),
          child: Stack(
            children:[
              Column(
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
                            getImagePath(imageScore),
                            width: SizeConfig.blockSizeHorizontal * 30,
                            height: SizeConfig.blockSizeVertical * 30
                          )
                        ),
                        Align(
                          alignment: Alignment.center,
                          child: Image.asset(
                            '${path['ui']}lives_$attempts.gif',
                            width: SizeConfig.blockSizeHorizontal * getScaleFactor(attempts),
                            height: SizeConfig.blockSizeVertical * getScaleFactor(attempts)
                          )
                        ),
                        Align(
                          alignment: Alignment.center, 
                          child: IconButton(
                            icon: Image.asset(
                              '${path['ui']}play_sound_button.png',
                              fit: BoxFit.fill,
                              width: SizeConfig.blockSizeHorizontal * 10,
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
                        ...List.generate(10, (int index) {
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
                                      ..color = const Color.fromRGBO(69, 69, 69, 1)
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
                      onPressed: () {
                        settings.toggleMusicEnabled();
                        GoRouter.of(context).go('/');
                      },
                      icon: Image.asset(
                        '${path['ui']}arrow_button_back.png',
                        width: SizeConfig.blockSizeHorizontal * 8,
                        height: SizeConfig.blockSizeVertical * 16
                      )
                    )
                  )
                ]
              ),
              getTransitionImage(controller,imageScore, SizeConfig.blockSizeHorizontal),
            ]
          )
        )
      );
    }
  }
}