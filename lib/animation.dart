import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';

import 'file_paths.dart';
import 'utils.dart';

/// Manages animations like rotating, repositioning and resizing,
/// specifically the one's made for when earning points in games.
class PointsAnimationHandler {
  List<ValueNotifier<bool>> pointsOn =
      List.generate(5, (_) => ValueNotifier(false));
  List<ValueNotifier<bool>> transitionOn =
      List.generate(5, (_) => ValueNotifier(false));

  static const Duration moveAnimationDuration = Duration(milliseconds: 1000);
  static const double moveAlignmentEndY = -0.85;
  static const Alignment moveAlignmentStart = Alignment.center;
  static const List<double> moveAlignmentEndX = [
    -1,
    -0.88,
    -0.75,
    -0.63,
    -0.51
  ];

  final Queue<String> starColors = Queue.of(colors);

  late AnimationController controller;
  late Animation<double> sizeAnimation;
  late Animation<double> rotateAnimation;

  ValueNotifier<Alignment> moveAlignment = ValueNotifier(moveAlignmentStart);

  PointsAnimationHandler(TickerProvider vsync) {
    controller = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: vsync,
    );
    rotateAnimation = Tween<double>(begin: 0, end: 6).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ),
    );
    sizeAnimation = Tween<double>(begin: 0, end: 1).animate(
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
    controller.forward(from: 0).then((_) async {
      await Future.delayed(const Duration(milliseconds: 400));
      moveAlignment.value =
          Alignment(moveAlignmentEndX[index], moveAlignmentEndY);
      Timer(moveAnimationDuration, () => finishAndRestartAnimation(index));
    });
  }

  void finishAndRestartAnimation(int index) {
    pointsOn[index].value = true;
    transitionOn[index].value = false;
    moveAlignment.value = moveAlignmentStart;
  }

  Widget getPointsTransition(int index, ResponsiveUtils utils) {
    return ValueListenableBuilder(
      valueListenable: transitionOn[index],
      builder: (_, __, ___) => transitionOn[index].value
          ? ValueListenableBuilder(
              valueListenable: moveAlignment,
              builder: (_, __, child) => AnimatedAlign(
                  duration: moveAnimationDuration,
                  alignment: moveAlignment.value,
                  child: child),
              child: utils.responsiveBox(
                6,
                12,
                RotationTransition(
                  turns: rotateAnimation,
                  child: ScaleTransition(
                    scale: sizeAnimation,
                    child: Image.asset(
                        '${points}points_${starColors.first}_on.png'),
                  ),
                ),
              ),
            )
          : const SizedBox.shrink(),
    );
  }

  /// Gets the file name of the points image.
  String getPointsImageFilePath(int index) {
    if (transitionOn[index].value) {
      return '${ui}empty.png';
    }
    return pointsOn[index].value
        ? '${points}points_${starColors.first}.gif'
        : '${points}points.png';
  }

  void restartPointImages() {
    starColors.addLast(starColors.removeFirst());
    for (var i in pointsOn) {
      i.value = false;
    }
  }
}
