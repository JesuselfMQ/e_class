import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';

import 'decoration.dart';
import 'file_paths.dart';
import 'phonetic_data.dart';
import 'settings_display_widgets.dart';
import 'size_config.dart';

/// Contains methods that return widgets that use screen size information.
class Utils with PhoneticData {
  SizeConfig size;

  BuildContext? context;

  late final Queue<String>? phonetic;

  Utils(this.size, [this.context]);

  /// Returns a centered image or image button if onSelected parameter is provided.
  Widget getImage(String path, double percentWidth, double percentHeight,
          {double horizontal = 0,
          double vertical = 0,
          AlignmentGeometry? alignment,
          void Function()? onSelected,
          GifController? gif,
          BoxFit? fit}) =>
      AlignedImage(
          image: path,
          width: size.safeBlockHorizontal * percentWidth,
          height: size.safeBlockVertical * percentHeight,
          alignment: alignment ?? Alignment(horizontal, vertical),
          onSelected: onSelected,
          gif: gif,
          fit: fit);

  Widget arrowBackButton(void Function()? onPressed, {bool aligned = false}) {
    var button = IconButton(
        onPressed: onPressed,
        icon: Image.asset('${ui}arrow_button_back.png',
            width: size.safeBlockHorizontal * 9,
            height: size.safeBlockVertical * 14));
    return aligned
        ? Align(alignment: Alignment.bottomCenter, child: button)
        : button;
  }

  Widget responsiveBox(double width, double height, Widget child) =>
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
    return SettingsLine(title, size,
        onSelected: onSelected,
        onChangedSlider: onChangedSlider,
        sliderValue: sliderValue,
        iconName: iconName,
        iconHeight: iconHeight,
        iconWidth: iconWidth);
  }
}
