import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'file_paths.dart';
import 'size_config.dart';

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

/// Value listenable of two values.
class ValueListenableBuilder2<A, B> extends StatelessWidget {
  const ValueListenableBuilder2(
      {required this.first,
      required this.second,
      required this.builder,
      this.child,
      super.key});

  final ValueListenable<A> first;
  final ValueListenable<B> second;
  final Widget? child;
  final Widget Function(BuildContext context, A a, B b, Widget? child) builder;

  @override
  Widget build(BuildContext context) => ValueListenableBuilder<A>(
        valueListenable: first,
        builder: (_, a, __) {
          return ValueListenableBuilder<B>(
            valueListenable: second,
            builder: (context, b, __) {
              return builder(context, a, b, child);
            },
          );
        },
      );
}

class Utils {
  SizeConfig size;

  Utils(this.size);

  Widget getCenteredImage(
      String path, double percentWidth, double percentHeight,
      [void Function()? onSelected]) {
    return AlignedImage(
        image: path,
        width: size.safeBlockHorizontal * percentWidth,
        height: size.safeBlockVertical * percentHeight,
        onSelected: onSelected);
  }

  Widget getArrowBackButton(void Function()? onPressed) {
    return IconButton(
        onPressed: onPressed,
        icon: Image.asset("${ui}arrow_button_back.png",
            width: size.safeBlockHorizontal * 9,
            height: size.safeBlockVertical * 14));
  }
}
