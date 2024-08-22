import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'decoration.dart';
import 'file_paths.dart';
import 'phonetic_data.dart';
import 'settings_display_widgets.dart';
import 'size_config.dart';

/// Contains methods that return widgets that use screen size information.
class Utils with PhoneticData {
  SizeConfig size;

  BuildContext? context;

  final Queue<String> phonetic = Queue.of(PhoneticData.phoneticLearningOrder);

  Utils(this.size, [this.context]);

  /// Returns a centered image or image button if onSelected parameter is provided.
  Widget getCenteredImage(
          String path, double percentWidth, double percentHeight,
          [void Function()? onSelected]) =>
      AlignedImage(
          image: path,
          width: size.safeBlockHorizontal * percentWidth,
          height: size.safeBlockVertical * percentHeight,
          onSelected: onSelected);

  Widget getArrowBackButton(void Function()? onPressed) => IconButton(
      onPressed: onPressed,
      icon: Image.asset("${ui}arrow_button_back.png",
          width: size.safeBlockHorizontal * 9,
          height: size.safeBlockVertical * 14));

  Widget getSetting(String title,
      {void Function()? onSelected,
      void Function(double value)? onChangedSlider,
      double? sliderValue,
      String? iconName,
      double? iconWidth,
      double? iconHeight}) {
    var imagesizeRequired = iconWidth != null && iconHeight != null;
    return imagesizeRequired
        ? SettingsLine(title, size,
            onSelected: onSelected,
            onChangedSlider: onChangedSlider,
            sliderValue: sliderValue,
            iconName: iconName,
            iconHeight: iconHeight,
            iconWidth: iconWidth)
        : SettingsLine(title, size,
            onSelected: onSelected,
            onChangedSlider: onChangedSlider,
            sliderValue: sliderValue,
            iconName: iconName);
  }

  Widget getPhoneticElementWidget() {
    final element = phonetic.removeFirst();
    return Stack(children: [
      getCenteredImage("${ui}note.png", 26, 34),
      SyllableButton(
          syllable: element.toUpperCase(),
          size: size,
          fontSize: 16,
          onPressed: () => context?.go('/phonetic/session/$element'))
    ]);
  }
}
