import 'package:flutter/widgets.dart';

/// Device's screen information.
class SizeConfig {
  static late MediaQueryData _mediaQueryData;
  late double screenWidth;
  late double screenHeight;
  static late double blockSizeHorizontal;
  static late double blockSizeVertical;
  static late double _safeAreaHorizontal;
  static late double _safeAreaVertical;
  late double safeBlockHorizontal;
  late double safeBlockVertical;
  late double aspectRatio;

  SizeConfig(BuildContext context) {
    _mediaQueryData = MediaQuery.of(context);
    screenWidth = _mediaQueryData.size.width;
    screenHeight = _mediaQueryData.size.height;
    aspectRatio = screenWidth / screenHeight;
    blockSizeHorizontal = screenWidth / 100;
    blockSizeVertical = screenHeight / 100;
    _safeAreaHorizontal =
        _mediaQueryData.padding.left + _mediaQueryData.padding.right;
    _safeAreaVertical =
        _mediaQueryData.padding.top + _mediaQueryData.padding.bottom;
    safeBlockHorizontal = (screenWidth - _safeAreaHorizontal) / 100;
    safeBlockVertical = (screenHeight - _safeAreaVertical) / 100;
  }

  /// Returns the specified percent of the screen height.
  double getFontSize(double percent) {
    return safeBlockVertical * percent;
  }
}
