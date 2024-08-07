import 'package:e_class/file_paths.dart';
import 'package:flutter/material.dart';

import 'size_config.dart';

/// Stores useful image information.
class ImageData {
  final String path;
  // Alignment data.
  final double horizontalAlignment;
  final double verticalAlignment;
  // Size data
  final SizeConfig sizeConfig;
  static const int widthPercentMenuImage = 20;
  static const int heightPercentMenuImage = 40;
  static const int widthPercentMenuButton = 11;
  static const int heightPercentMenuButton = 18;
  final int widthPercent;
  final int heightPercent;
  late final double width;
  late final double height;
  final VoidCallback? onSelected;

  ImageData(this.path, this.horizontalAlignment, this.verticalAlignment,
      this.sizeConfig, this.widthPercent, this.heightPercent,
      [this.onSelected]) {
    width = sizeConfig.safeBlockHorizontal * widthPercent;
    height = sizeConfig.safeBlockVertical * heightPercent;
  }

  factory ImageData.menuImage(String path, double horizontalAlignment,
      double verticalAlignment, SizeConfig sizeConfig,
      [VoidCallback? onSelected]) {
    return ImageData(animated + path, horizontalAlignment, verticalAlignment,
        sizeConfig, widthPercentMenuImage, heightPercentMenuImage, onSelected);
  }

  factory ImageData.menuButton(String path, double horizontalAlignment,
      double verticalAlignment, SizeConfig sizeConfig,
      [VoidCallback? onSelected]) {
    return ImageData(
        ui + path,
        horizontalAlignment,
        verticalAlignment,
        sizeConfig,
        widthPercentMenuButton,
        heightPercentMenuButton,
        onSelected);
  }
}
