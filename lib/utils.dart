import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';

import 'decoration.dart';
import 'file_paths.dart';
import 'settings_display_widgets.dart';

/// Contains methods that return widgets that use screen size information.
class ResponsiveUtils {
  static late MediaQueryData _mediaQueryData;
  static late double _screenWidth;
  static late double _screenHeight;
  static late double _safeAreaHorizontal;
  static late double _safeAreaVertical;
  late double safeBlockHorizontal;
  late double safeBlockVertical;
  late double aspectRatio;
  BuildContext context;

  ResponsiveUtils(this.context) {
    _mediaQueryData = MediaQuery.of(context);
    _screenWidth = _mediaQueryData.size.width;
    _screenHeight = _mediaQueryData.size.height;
    aspectRatio = _screenWidth / _screenHeight;
    _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (_screenWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical = (_screenHeight - _safeAreaVertical) / 100;
  }

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
          width: safeBlockHorizontal * percentWidth,
          height: safeBlockVertical * percentHeight,
          alignment: alignment ?? Alignment(horizontal, vertical),
          onSelected: onSelected,
          gif: gif,
          fit: fit);

  Widget arrowBackButton(void Function()? onPressed, {bool aligned = false}) {
    var button = IconButton(
        onPressed: onPressed,
        icon: Image.asset('${ui}arrow_button_back.png',
            width: safeBlockHorizontal * 9, height: safeBlockVertical * 14));
    return aligned
        ? Align(alignment: Alignment.bottomCenter, child: button)
        : button;
  }

  Widget responsiveBox(double width, double height, Widget child) =>
      ResponsiveSizedBox(
          safeBlockHorizontal * width, safeBlockVertical * height,
          child: child);

  Widget getSetting(String title,
      {void Function()? onSelected,
      void Function(double value)? onChangedSlider,
      double? sliderValue,
      String? iconName,
      double? iconWidth,
      double? iconHeight}) {
    double? width;
    double? height;
    final needSlider = sliderValue != null && onChangedSlider != null;
    if (!needSlider) {
      width = iconWidth != null
          ? iconWidth * safeBlockHorizontal
          : 5 * safeBlockHorizontal;
      height = iconHeight != null
          ? iconHeight * safeBlockVertical
          : 8 * safeBlockHorizontal;
    }
    return SettingsLine(title,
        onSelected: onSelected,
        fontSize: 8 * safeBlockVertical,
        slider: needSlider
            ? SettingsSlider(
                sliderValue,
                safeBlockHorizontal * 20,
                safeBlockVertical * 0.9998,
                safeBlockHorizontal * 1.25,
                onChangedSlider)
            : null,
        iconName: iconName,
        iconHeight: height,
        iconWidth: width);
  }

  /// Returns the specified percent of the screen's height in pixels.
  double getHeight(double percent) => safeBlockVertical * percent;
}
