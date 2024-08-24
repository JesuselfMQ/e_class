import 'package:flutter/material.dart';
import 'package:gif_view/gif_view.dart';

import 'file_paths.dart';
import 'size_config.dart';

/// Sets a background image that fills the screen.
class FillBackground extends StatelessWidget {
  final Widget child;

  final String backgroundFile;

  const FillBackground(
      {required this.child, required this.backgroundFile, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(background + backgroundFile),
                    fit: BoxFit.fill)),
            child: child));
  }
}

/// Aligns a simple image or an image button.
class AlignedImage extends StatelessWidget {
  final String image;
  final double horizontal;
  final double vertical;
  final double width;
  final double height;
  final VoidCallback? onSelected;
  final GifController? gif;

  const AlignedImage(
      {required this.image,
      required this.horizontal,
      required this.vertical,
      required this.width,
      required this.height,
      this.onSelected,
      this.gif,
      super.key});

  @override
  Widget build(BuildContext context) {
    var icon = gif != null
        ? GifView.asset(image,
            width: width, height: height, frameRate: 5, controller: gif)
        : Image.asset(image, width: width, height: height);
    return Align(
        alignment: Alignment(horizontal, vertical),
        child: onSelected == null
            ? icon
            : IconButton(onPressed: onSelected, icon: icon));
  }
}

/// Styled button for displaying syllables.
class SyllableButton extends StatelessWidget {
  final void Function()? onPressed;

  final String syllable;

  final SizeConfig size;

  final double fontSize;

  const SyllableButton(
      {required this.syllable,
      required this.size,
      required this.onPressed,
      required this.fontSize,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: TextButton(
            onPressed: onPressed,
            child: Text(syllable,
                style: TextStyle(
                    fontSize: size.getPercentHeight(fontSize),
                    fontFamily: 'Ginthul',
                    foreground: Paint()
                      ..style = PaintingStyle.fill
                      ..strokeWidth = 4
                      ..color = const Color.fromRGBO(69, 69, 69, 1)))));
  }
}

class ResponsiveSizedBox extends StatelessWidget {
  final double width;

  final double height;

  final Widget child;

  const ResponsiveSizedBox(this.width, this.height,
      {super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return SizedBox(width: width, height: height, child: child);
  }
}
