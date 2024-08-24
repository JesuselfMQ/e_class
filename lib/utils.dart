import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';
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
  Widget getImage(
          String path, double percentWidth, double percentHeight,
          {double horizontal = 0,
          double vertical = 0,
          void Function()? onSelected, GifController? gif}) =>
      AlignedImage(
          image: path,
          width: size.safeBlockHorizontal * percentWidth,
          height: size.safeBlockVertical * percentHeight,
          horizontal: horizontal,
          vertical: vertical,
          onSelected: onSelected,
          gif: gif);

  Widget getArrowBackButton(void Function()? onPressed,
      {bool aligned = false}) {
    var button = IconButton(
        onPressed: onPressed,
        icon: Image.asset("${ui}arrow_button_back.png",
            width: size.safeBlockHorizontal * 9,
            height: size.safeBlockVertical * 14));
    return aligned
        ? Align(alignment: Alignment.bottomCenter, child: button)
        : button;
  }

  Widget getResponsiveBox(double width, double height, Widget child) =>
      ResponsiveSizedBox(
          size.safeBlockHorizontal * width, size.safeBlockVertical * height,
          child: child);

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
      getImage("${ui}note.png", 26, 34),
      SyllableButton(
          syllable: element.toUpperCase(),
          size: size,
          fontSize: 16,
          onPressed: () => context?.go('/phonetic/session/$element'))
    ]);
  }
}
