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
  late List<double> moveX;
  final Queue<String> color = Queue.of(pointColors);

  late AnimationController controller;
  late AnimationController moveController;
  late Animation<double> sizeAnimation;
  late Animation<double> rotateAnimation;
  late List<Animation<Offset>> moveAnimations;
  late SizeConfig size;

  AnimationHandler(TickerProvider vsync) {
    controller = AnimationController(
      duration: const Duration(milliseconds: 2500),
      vsync: vsync,
    );
    moveController = AnimationController(
      duration: const Duration(seconds: 1),
      vsync: vsync,
    );
    rotateAnimation = Tween<double>(begin: 0.0, end: 4.998).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  void init(SizeConfig size) {
    this.size = size;
    moveX = [-1.42, -1.22, -1.02, -0.86, -0.68];
    moveAnimations = [
      for (var i in moveX)
        Tween<Offset>(begin: Offset.zero, end: Offset(i, -0.68)).animate(
          CurvedAnimation(
            parent: moveController,
            curve: Curves.easeInOut,
          ),
        )
    ];
    sizeAnimation =
        Tween<double>(begin: 0.0, end: size.safeBlockHorizontal * 0.0118)
            .animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  void dispose() {
    controller.dispose();
    moveController.dispose();
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
      await Future.delayed(const Duration(milliseconds: 500));
      moveController.forward(from: 0.0).then((_) {
        controller.reset();
        moveController.reset();
      });
    });
  }

  Widget getTransition(int count) {
    return Center(
        child: SlideTransition(
      position: moveAnimations[count],
      child: RotationTransition(
        turns: rotateAnimation,
        child: ScaleTransition(
          scale: sizeAnimation,
          child: Image.asset("$points${color.first}/points_on.png"),
        ),
      ),
    ));
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
