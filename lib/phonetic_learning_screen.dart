import 'dart:async';

import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'audio_controller.dart';
import 'decoration.dart';
import 'file_paths.dart';
import 'phonetic_element.dart';
import 'utils.dart';

class LearningSessionScreen extends StatefulWidget {
  final String _phoneticElement;

  const LearningSessionScreen({required String phoneticElement, super.key})
      : _phoneticElement = phoneticElement;

  @override
  State<LearningSessionScreen> createState() => _LearningSessionScreenState();
}

class _LearningSessionScreenState extends State<LearningSessionScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController controller;

  late ResponsiveUtils utils;

  late final AudioController audio;

  late final PhoneticElement selected;

  late final Animation<double> sizeAnimation;

  late final ValueNotifier<String>? currentVowel;

  final ValueNotifier<Map<String, String>> currentExample =
      ValueNotifier({'': ''});

  final GifController gif = GifController(autoPlay: false);

  final ValueNotifier<double> teacherOpacity = ValueNotifier(0);

  double clipRectWidth = 0.0;

  @override
  void initState() {
    super.initState();
    selected = PhoneticElement(widget._phoneticElement);
    audio = context.read<AudioController>();
    initDisplayValues();
    initAnimation();
  }

  void initDisplayValues() {
    currentExample.value = {
      selected.examples.first[0]: selected.examples.first[1]
    };
    currentVowel = selected.usingVowels
        ? ValueNotifier(selected.filteredVowels.first)
        : null;
  }

  void initAnimation() {
    controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    sizeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ),
    );
    Timer(const Duration(seconds: 0), () {
      controller.forward(from: 0).then((_) => teacherOpacity.value = 1);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    teacherOpacity.dispose();
    currentExample.dispose();
    currentVowel?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    utils = ResponsiveUtils(context);
    return FillBackground(
        file: 'session.jpg',
        child: Stack(children: [
          Align(
              alignment: const Alignment(0, -0.35), child: chalkBoardDisplay()),
          ValueListenableBuilder(
              valueListenable: teacherOpacity,
              builder: (_, value, __) => AnimatedOpacity(
                  opacity: value,
                  duration: const Duration(seconds: 1),
                  child: utils.getImage('${ui}teacher.gif', 21, 48.86,
                      horizontal: -1, vertical: 1, gif: gif))),
          utils.arrowBackButton(() => GoRouter.of(context).pop(), aligned: true)
        ]));
  }

  Widget chalkBoardDisplay() {
    return utils.responsiveBox(
        75,
        78,
        Stack(
          fit: StackFit.expand,
          children: [
            ScaleTransition(
                scale: sizeAnimation,
                child: Image.asset('${ui}chalkboard.png', fit: BoxFit.fill)),
            phoneticElement(),
            exampleImage(),
            exampleWord(),
            utils.getImage('${ui}arrow.png', 10, 16,
                horizontal: 0.8, onSelected: () => nextElement()),
          ],
        ));
  }

  Widget phoneticElement() {
    var phoneticImage = utils.getImage('$phonetic${selected.filename}.gif',
        getWidth(), selected.isGrouped ? 11 : 17,
        fit: selected.usingVowels ? null : BoxFit.fill, horizontal: -0.8);
    return GestureDetector(
        onTap: () => greet(),
        child: selected.usingVowels
            ? getFullSyllable(phoneticImage)
            : phoneticImage);
  }

  double getWidth() {
    double width = 10;
    if (selected.isDiphthong || selected.isEnding) {
      width = 4.5;
    } else if (selected.isGrouped) {
      width = 8;
    }
    return width;
  }

  Widget getFullSyllable(Widget phoneticImage) {
    var vowel = ValueListenableBuilder(
        valueListenable: currentVowel!,
        builder: (_, value, __) {
          return utils.getImage('$phonetic$value.gif', 4, 15.5,
              fit: BoxFit.fill);
        });
    return Padding(
      padding: EdgeInsets.only(left: 5.9 * utils.safeBlockHorizontal),
      child: Row(
          children: selected.isEnding || selected.element == 'vy'
              ? [vowel, phoneticImage]
              : [phoneticImage, vowel]),
    );
  }

  Widget exampleWord() {
    return ValueListenableBuilder(
        valueListenable: currentExample,
        builder: (_, value, __) {
          return SyllableButton(value.keys.single, utils, 20,
              vertical: 0.75, white: true, onPressed: () => greet());
        });
  }

  Widget exampleImage() {
    return ValueListenableBuilder(
        valueListenable: currentExample,
        builder: (_, value, __) => utils.getImage(
            '${ui}chalk/${value[value.keys.single]}', 30, 40,
            fit: BoxFit.fill, vertical: -0.4));
  }

  void greet([int delay = 0]) {
    // TO DO:
  }

  void nextSyllable() {
    selected.filteredVowels.addLast(selected.filteredVowels.removeFirst());
    currentVowel!.value = selected.filteredVowels.first;
  }

  void nextImage() {
    selected.examples.addLast(selected.examples.removeFirst());
    currentExample.value = {
      selected.examples.first[0]: selected.examples.first[1]
    };
  }

  void nextElement() {
    nextImage();
    if (selected.usingVowels) nextSyllable();
  }
}
