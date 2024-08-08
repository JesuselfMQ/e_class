import 'package:flutter/material.dart';

/// Sets a background image that fills the screen.
class FillBackground extends StatelessWidget {
  final Widget child;

  final String background;

  const FillBackground(
      {required this.child, required this.background, super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Container(
            decoration: BoxDecoration(
                image: DecorationImage(
                    image: AssetImage(background), fit: BoxFit.fill)),
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