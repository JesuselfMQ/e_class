import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';

import 'file_paths.dart';
import 'size_config.dart';

class AnimationHandler {
  List<ValueNotifier<bool>> pointsOn = [
    ...List.generate(5, (_) => ValueNotifier(false))
  ];
  List<ValueNotifier<bool>> transitionOn = [
    ...List.generate(5, (_) => ValueNotifier(false))
  ];
  final Queue<String> color = Queue.of(pointColors);

  late AnimationController controller;
  late Animation<double> sizeAnimation;
  late Animation<double> rotateAnimation;

  final List<double> moveAlignmentEndX = [-1.0, -0.88, -0.75, -0.63, -0.51];
  final double moveAlignmentEndY = -0.85;
  final Alignment moveAlignmentStart = Alignment.center;
  late ValueNotifier<Alignment> moveAlignment;

  AnimationHandler(TickerProvider vsync) {
    controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: vsync,
    );
    moveAlignment = ValueNotifier(moveAlignmentStart);
    rotateAnimation = Tween<double>(begin: 0.0, end: 4.998).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ),
    );
    sizeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  void dispose() {
    controller.dispose();
    for (var i in pointsOn) {
      i.dispose();
    }
    for (var i in transitionOn) {
      i.dispose();
    }
  }

  void startAnimation(int index) {
    transitionOn[index].value = true;
    controller.forward(from: 0.0).then((_) async {
      await Future.delayed(const Duration(milliseconds: 1000));
      moveAlignment.value =
          Alignment(moveAlignmentEndX[index], moveAlignmentEndY);
      Timer(const Duration(milliseconds: 2000), () {
        pointsOn[index].value = true;
        transitionOn[index].value = false;
        moveAlignment.value = moveAlignmentStart;
      });
    });
  }

  Widget getTransition(SizeConfig size) {
    return ValueListenableBuilder(
      valueListenable: moveAlignment,
      builder: (_, __, child) => AnimatedAlign(
          duration: const Duration(milliseconds: 1000),
          alignment: moveAlignment.value,
          child: child),
      child: SizedBox(
        width: 6 * size.safeBlockHorizontal,
        height: 12 * size.safeBlockVertical,
        child: RotationTransition(
          turns: rotateAnimation,
          child: ScaleTransition(
            scale: sizeAnimation,
            child: Image.asset("$points${color.first}/points_on.png"),
          ),
        ),
      ),
    );
  }

  /// Gets the file name of the points image.
  String getImage(int index) {
    if (transitionOn[index].value) {
      return "${ui}empty.png";
    }
    String fileExtension;
    pointsOn[index].value ? fileExtension = ".gif" : fileExtension = ".png";
    return '$points${color.first}/points$fileExtension';
  }
}
