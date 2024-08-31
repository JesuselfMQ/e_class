import 'dart:async';
import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'audio_controller.dart';
import 'decoration.dart';
import 'examples_names.dart';
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
    with TickerProviderStateMixin, PhoneticData {
  late AnimationController controller = AnimationController(
    // original // 4 seconds
    duration: const Duration(seconds: 1),
    vsync: this,
  );

  late SizeConfig size;

  late Utils utils;

  late final Animation<double> sizeAnimation;

  late final AudioController audio;

  late final Queue<List<String>> exampleImages;

  late final List<String> syllableGroup;

  late final Queue<String> selectedVowelsFileNames;

  final GifController gif = GifController(autoPlay: false);

  ValueNotifier<double> teacherImageOpacity = ValueNotifier(0);

  ValueNotifier<Map<String, String>> currentExample = ValueNotifier({"": ""});

  ValueNotifier<String>? currentVowel;

  double clipRectWidth = 0.0;

  @override
  void initState() {
    super.initState();
    audio = context.read<AudioController>();
    exampleImages = Queue.of(
        // create function for this loop list
        [
          for (var i = 0; i < 5; i++)
            [
              "${widget.phoneticElement}$i.png",
              names[widget.phoneticElement]?[i] ?? ""
            ]
        ]);
    currentExample.value = {exampleImages.first[0]: exampleImages.first[1]};
    selectedVowelsFileNames = getPhoneticFileName(widget.phoneticElement);
    currentVowel = selectedVowelsFileNames.isEmpty
        ? null
        : ValueNotifier(selectedVowelsFileNames.first);
    sizeAnimation = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: controller,
        curve: Curves.easeInOut,
      ),
    );
    // original 2 seconds
    Timer(const Duration(seconds: 0), () {
      controller.forward(from: 0).then((_) => teacherImageOpacity.value = 1);
    });
  }

  @override
  void dispose() {
    controller.dispose();
    teacherImageOpacity.dispose();
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
              valueListenable: teacherImageOpacity,
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
            //exampleImage(),
            //exampleText(),
            utils.getImage("${ui}arrow.png", 10, 16,
                horizontal: 0.8, onSelected: () => nextImage()),
          ],
        ));
  }

  int temp() {
    if (widget.phoneticElement == "i") {
    }
    return 5;
  }

  Widget phoneticElementImage() {
    var isEnding = (ending + ["iv", "uv", "vy"]).contains(widget.phoneticElement);
    var isGrouped = grouped.contains(widget.phoneticElement);
    var singleVowel = (ending + diphthongs + grouped + ["gu"]).contains(widget.phoneticElement);
    var phoneticDisplay = (ending + diphthongs).contains(widget.phoneticElement)
        ? "${widget.phoneticElement.replaceAll("v", "")}-single"
        : widget.phoneticElement;
    var phoneticImage = utils.getImage("$phonetic$phoneticDisplay.gif",
        getWidth(), isGrouped ? 11 : 14.5, //if y h19.5 if grouped width 8 and height 11 ... if dipthong w4 and h15 if m w6
        fit: singleVowel ? null : BoxFit.fill, horizontal: -0.8);
    return GestureDetector(
        onTap: () => greet(),
        child: currentVowel == null
            ? phoneticImage
            : phoneticGroup(phoneticImage));
  }

  double getWidth() {
    var isGrouped = (grouped + ["gu"]).contains(widget.phoneticElement);
    var isDiphtong = (diphthongs + ending..remove("vm")).contains(widget.phoneticElement);
    var width = 0.0;
    if (widget.phoneticElement == "vm") {
      width = 6;
    } else if (isDiphtong) {
      width = 4;
    } else if (isGrouped) {
      width = 8;
    } else {
      width = 10; // why it was 14.5?
    }
    return width;
  }

  Widget phoneticGroup(Widget phoneticImage) {
    var isGrouped = grouped.contains(widget.phoneticElement);
    var vowel = ValueListenableBuilder(
        valueListenable: currentVowel!,
        builder: (_, value, __) {
          // height value second was 16 then 22
          return utils.getImage("$phonetic$value.gif", 4, 14.5, fit: BoxFit.fill); // width 4 and height 12 for gu ... height 14.5 for group
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

  Widget exampleText() {
    return ValueListenableBuilder(
        valueListenable: currentExample,
        builder: (_, value, __) {
          return SyllableButton(value[value.keys.single]!, size, 20,
              vertical: 0.75, white: true, onPressed: () => greet());
        });
  }

  Widget exampleImage() {
    return ValueListenableBuilder(
        valueListenable: currentExample,
        builder: (_, value, __) => utils.getImage(
            "${ui}chalk/${value.keys.single}", 30, 40,
            fit: BoxFit.fill, vertical: -0.4));
  }

  void greet([int delay = 0]) {
    print(clipRectWidth);
    clipRectWidth += 1;
  }

  void nextSyllable() {}

  void nextImage() {
    exampleImages.addLast(exampleImages.removeFirst());
    currentExample.value = {exampleImages.first[0]: exampleImages.first[1]};
    if (selectedVowelsFileNames.isNotEmpty) {
      selectedVowelsFileNames.addLast(selectedVowelsFileNames.removeFirst());
    }
    currentVowel?.value = selectedVowelsFileNames.first;
  }
}
