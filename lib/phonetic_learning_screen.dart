import 'package:flutter/material.dart';

import 'decoration.dart';
import 'file_paths.dart';
import 'size_config.dart';
import 'utils.dart';

class LearningSessionScreen extends StatelessWidget {
  final String phoneticElement;

  const LearningSessionScreen({required this.phoneticElement, super.key});

  @override
  Widget build(BuildContext context) {
    final size = SizeConfig(context);
    final utils = Utils(size);
    return FillBackground(
        backgroundFile: "session.jpg",
        child: Stack(
            children: [utils.getCenteredImage("${ui}chalkboard.png", 50, 40)]));
  }
}
