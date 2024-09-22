import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'audio_controller.dart';
import 'decoration.dart';
import 'example_names.dart';
import 'file_paths.dart';
import 'phonetic_data.dart';
import 'size_config.dart';
import 'utils.dart';

class LearningSessionScreen extends StatefulWidget {
  final String phoneticElement;

  const LearningSessionScreen({required this.phoneticElement, super.key});

  @override
  State<LearningSessionScreen> createState() => _LearningSessionScreenState();
}

class _LearningSessionScreenState extends State<LearningSessionScreen>
    with SingleTickerProviderStateMixin, PhoneticData {
  late AnimationController controller;

  late SizeConfig size;

  late Utils utils;

  late final AudioController audio;

  late final Animation<double> sizeAnimation;

  late final Queue<List<String>> exampleImages;

  late final Queue<String> selectedVowels;

  final GifController gif = GifController(autoPlay: false);

  ValueNotifier<double> teacherOpacity = ValueNotifier(0);

  ValueNotifier<Map<String, String>> currentExample = ValueNotifier({"": ""});

  ValueNotifier<String>? currentVowel;

  double clipRectWidth = 0.0;

  @override
  void initState() {
    super.initState();
    audio = context.read<AudioController>();
    controller = AnimationController(
      duration: const Duration(milliseconds: 10),
      vsync: this,
    );

    sizeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ),
    );
    createExampleImages();
    createDisplayPhonetic();
    startAnimation();
  }

  void createExampleImages() {
    int limit;

    if (["gu", "qu"].contains(widget.phoneticElement)) {
      limit = 2;
    } else if (diphthongs.contains(widget.phoneticElement)) {
      limit = 4;
    } else {
      limit = 5;
    }

    exampleImages = Queue.of([
      for (var i = 0; i < limit; i++)
        [
          names[widget.phoneticElement]?[i] ?? "",
          "${widget.phoneticElement}$i.png"
        ]
    ]);
  }

  void createDisplayPhonetic() {
    currentExample.value = {exampleImages.first[0]: exampleImages.first[1]};
    selectedVowels = filterVowelsFileName(widget.phoneticElement);

    currentVowel =
        selectedVowels.isEmpty ? null : ValueNotifier(selectedVowels.first);
  }

  void startAnimation() {
    Timer(const Duration(seconds: 2), () {
      controller.forward(from: 0).then((_) => teacherOpacity.value = 1);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    teacherOpacity.dispose();
    currentExample.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = SizeConfig(context);
    utils = Utils(size);
    return FillBackground(
        backgroundFile: "session.jpg",
        child: Stack(children: [
          Align(
              alignment: const Alignment(0, -0.35), child: chalkBoardDisplay()),
          ValueListenableBuilder(
              valueListenable: teacherOpacity,
              builder: (_, value, __) => AnimatedOpacity(
                  opacity: value,
                  duration: const Duration(seconds: 1),
                  child: utils.getImage("${ui}teacher.gif", 21, 48.86,
                      horizontal: -1, vertical: 1, gif: gif))),
          utils.getArrowBackButton(() => GoRouter.of(context).pop(),
              aligned: true)
        ]));
  }

  Widget chalkBoardDisplay() {
    return utils.getResponsiveBox(
        75,
        78,
        Stack(
          fit: StackFit.expand,
          children: [
            ScaleTransition(
                scale: sizeAnimation,
                child: Image.asset("${ui}chalkboard.png", fit: BoxFit.fill)),
            phoneticElementImage(),
            exampleImage(),
            exampleWord(),
            utils.getImage("${ui}arrow.png", 10, 16,
                horizontal: 0.8, onSelected: () => nextElement()),
          ],
        ));
  }

  Widget phoneticElementImage() {
    var isGrouped = grouped.contains(widget.phoneticElement);
    var withVowel = (ending + diphthongs + grouped + ["gu"])
        .contains(widget.phoneticElement);
    var phoneticFilename =
        (ending + diphthongs).contains(widget.phoneticElement)
            ? "${widget.phoneticElement.replaceAll("v", "")}-single"
            : widget.phoneticElement;
    var phoneticImage = utils.getImage(
        "$phonetic$phoneticFilename.gif", getWidth(), isGrouped ? 11 : 14.5,
        fit: withVowel ? null : BoxFit.fill, horizontal: -0.8);
    return GestureDetector(
        onTap: () => greet(),
        child: currentVowel == null
            ? phoneticImage
            : getFullSyllable(phoneticImage));
  }

  double getWidth() {
    double width;
    var isGrouped = (grouped + ["gu"]).contains(widget.phoneticElement);
    var isDiphtong = (diphthongs + ending
          ..remove("vm"))
        .contains(widget.phoneticElement);
    if (widget.phoneticElement == "vm") {
      width = 6;
    } else if (isDiphtong) {
      width = 4;
    } else if (isGrouped) {
      width = 8;
    } else {
      width = 10;
    }
    return width;
  }

  Widget getFullSyllable(Widget phoneticImage) {
    var vowel = ValueListenableBuilder(
        valueListenable: currentVowel!,
        builder: (_, value, __) {
          return utils.getImage("$phonetic$value.gif", 4, 14.5,
              fit: BoxFit.fill);
        });
    return Padding(
      padding: EdgeInsets.only(left: 5.9 * size.safeBlockHorizontal),
      child: Row(
          children:
              (grouped + ["iv", "uv", "gu"]).contains(widget.phoneticElement)
                  ? [phoneticImage, vowel]
                  : [vowel, phoneticImage]),
    );
  }

  Widget exampleWord() {
    return ValueListenableBuilder(
        valueListenable: currentExample,
        builder: (_, value, __) {
          return SyllableButton(value.keys.single, size, 20,
              vertical: 0.75, white: true, onPressed: () => greet());
        });
  }

  Widget exampleImage() {
    return ValueListenableBuilder(
        valueListenable: currentExample,
        builder: (_, value, __) => utils.getImage(
            "${ui}chalk/${value[value.keys.single]!}", 30, 40,
            fit: BoxFit.fill, vertical: -0.4));
  }

  void greet([int delay = 0]) {
    print(clipRectWidth);
    clipRectWidth += 1;
  }

  void nextSyllable() {
    if (selectedVowels.isNotEmpty) {
      selectedVowels.addLast(selectedVowels.removeFirst());
    }
    currentVowel?.value = selectedVowels.first;
  }

  void nextImage() {
    exampleImages.addLast(exampleImages.removeFirst());
    currentExample.value = {exampleImages.first[0]: exampleImages.first[1]};
  }

  void nextElement() {
    nextImage();
    nextSyllable();
  }
}
