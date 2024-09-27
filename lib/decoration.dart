import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';

import 'file_paths.dart';
import 'utils.dart';

/// Sets a background image that fills the screen.
class FillBackground extends StatelessWidget {
  final Widget child;

  final String file;

  const FillBackground({required this.child, required this.file, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(background + file), fit: BoxFit.fill)),
            child: child));
  }
}

/// Aligns a simple image or an image button.
class AlignedImage extends StatelessWidget {
  final String image;
  final AlignmentGeometry alignment;
  final double width;
  final double height;
  final VoidCallback? onSelected;
  final GifController? gif;
  final BoxFit? fit;

  const AlignedImage(
      {required this.image,
      required this.alignment,
      required this.width,
      required this.height,
      this.onSelected,
      this.gif,
      this.fit,
      super.key});

  @override
  Widget build(BuildContext context) {
    var icon = gif != null
        ? GifView.asset(image,
            width: width, height: height, frameRate: 5, controller: gif)
        : Image.asset(image, width: width, height: height, fit: fit);
    var child = onSelected == null
        ? icon
        : IconButton(onPressed: onSelected, icon: icon);
    return Align(alignment: alignment, child: child);
  }
}

class SyllableButton extends StatelessWidget {
  final void Function()? onPressed;

  final String syllable;

  final ResponsiveUtils utils;

  final double fontSize;

  final double horizontal;

  final double vertical;

  final bool white;

  /// Styled button for displaying syllables in the game.
  const SyllableButton(this.syllable, this.utils, this.fontSize,
      {required this.onPressed,
      this.horizontal = 0,
      this.vertical = 0,
      this.white = false,
      super.key});

  @override
  Widget build(BuildContext context) {
    var color = white
        ? const Color.fromRGBO(204, 205, 207, 1)
        : const Color.fromRGBO(69, 69, 69, 1);
    var button = TextButton(
        onPressed: onPressed,
        child: Text(syllable,
            style: TextStyle(
                fontSize: utils.getHeight(fontSize),
                fontFamily: 'Ginthul',
                foreground: Paint()
                  ..style = PaintingStyle.fill
                  ..strokeWidth = 4
                  ..color = color)));
    return Align(alignment: Alignment(horizontal, vertical), child: button);
  }
}

class ResponsiveSizedBox extends StatelessWidget {
  final double width;

  final double height;

  final Widget child;

  final bool centered;

  const ResponsiveSizedBox(
    this.width,
    this.height, {
    required this.child,
    this.centered = false,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    var box = SizedBox(width: width, height: height, child: child);
    return centered ? Center(child: box) : box;
  }
}
