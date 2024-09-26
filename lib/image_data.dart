import 'package:flutter/material.dart';

import 'file_paths.dart';

/// Stores useful image information.
class ImageData {
  final String path;
  // Alignment data.
  final double horizontalAlignment;
  final double verticalAlignment;
  // Size data
  static const int widthMenuImage = 20;
  static const int heightMenuImage = 40;
  static const int widthMenuButton = 11;
  static const int heightMenuButton = 18;
  final int width;
  final int height;
  final VoidCallback? onSelected;

  ImageData(this.path, this.horizontalAlignment, this.verticalAlignment,
      this.width, this.height,
      [this.onSelected]);

  factory ImageData.menuImage(
      String path, double horizontalAlignment, double verticalAlignment,
      [VoidCallback? onSelected]) {
    return ImageData(animated + path, horizontalAlignment, verticalAlignment,
        widthMenuImage, heightMenuImage, onSelected);
  }

  factory ImageData.menuButton(
      String path, double horizontalAlignment, double verticalAlignment,
      [VoidCallback? onSelected]) {
    return ImageData(ui + path, horizontalAlignment, verticalAlignment,
        widthMenuButton, heightMenuButton, onSelected);
  }
}
