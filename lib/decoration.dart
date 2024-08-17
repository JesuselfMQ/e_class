import 'package:flutter/material.dart';

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
          width: MediaQuery.of(context).size.width,
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
  final double? horizontal;
  final double? vertical;
  final double width;
  final double height;
  final VoidCallback? onSelected;

  const AlignedImage(
      {required this.image,
      this.horizontal,
      this.vertical,
      required this.width,
      required this.height,
      this.onSelected,
      super.key});

  @override
  Widget build(BuildContext context) {
    var icon = Image.asset(image, width: width, height: height);
    return Align(
        alignment: horizontal == null || vertical == null
            // Align center by default.
            ? Alignment.center
            : Alignment(horizontal!, vertical!),
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