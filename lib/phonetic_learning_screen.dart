import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'audio_controller.dart';
import 'decoration.dart';
import 'file_paths.dart';
import 'size_config.dart';
import 'utils.dart';

class LearningSessionScreen extends StatefulWidget {
  final String phoneticElement;

  const LearningSessionScreen({required this.phoneticElement, super.key});

  @override
  State<LearningSessionScreen> createState() => _LearningSessionScreenState();
}

class _LearningSessionScreenState extends State<LearningSessionScreen>
    with TickerProviderStateMixin {
  late AnimationController controller = AnimationController(
    duration: const Duration(seconds: 2),
    vsync: this,
  );

  late final Animation<double> sizeAnimation;

  late final AudioController audio;

  ValueNotifier<double> teacherImageOpacity = ValueNotifier(0);

  @override
  void initState() {
    super.initState();
    audio = context.read<AudioController>();
    sizeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ),
    );
    controller.forward(from: 0).then((_) => teacherImageOpacity.value = 1);
  }

  @override
  void dispose() {
    controller.dispose();
    teacherImageOpacity.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = SizeConfig(context);
    final utils = Utils(size);
    final gif = GifController(autoPlay: false);
    return FillBackground(
        backgroundFile: "session.jpg",
        child: Stack(children: [
          Align(
            alignment: const Alignment(0, -0.35),
            child: utils.getResponsiveBox(
                75,
                78,
                ScaleTransition(
                    scale: sizeAnimation,
                    child:
                        Image.asset("${ui}chalkboard.png", fit: BoxFit.fill))),
          ),
          ValueListenableBuilder(
              valueListenable: teacherImageOpacity,
              builder: (_, value, __) => AnimatedOpacity(
                  opacity: value,
                  duration: const Duration(seconds: 1),
                  child: utils.getImage("${ui}teacher.gif", 21, 48.86,
                      horizontal: -1, vertical: 1, gif: gif))),
          utils.getImage("${ui}play_syllable_button.png", 10, 20,
              horizontal: 0.8, vertical: 0, onSelected: () => greet()),
          utils.getArrowBackButton(() => GoRouter.of(context).pop(),
              aligned: true)
        ]));
  }

  void greet([int delay = 0]) {}
}
