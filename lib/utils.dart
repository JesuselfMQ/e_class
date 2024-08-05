import 'package:e_class/extensions.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';

import 'file_paths.dart';
import 'size_config.dart';

/// Sets a background that fills the screen.
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
    return Align(
        alignment: horizontal.isNull || vertical.isNull
            ? Alignment.center
            : Alignment(horizontal!, vertical!),
        child: onSelected.isNull
            ? Image.asset(image, width: width, height: height)
            : IconButton(
                onPressed: onSelected,
                icon: Image.asset(
                  image,
                  width: width,
                  height: height,
                )));
  }
}

/// Audio slider with responsive size.
class AudioSlider extends StatelessWidget {
  final double value;

  final void Function(double)? onChanged;

  final SizeConfig size;

  const AudioSlider(this.value, this.size, this.onChanged, {super.key});

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
        data: SliderTheme.of(context).copyWith(
          overlayShape: SliderComponentShape.noOverlay,
          trackHeight: size.safeBlockVertical * 0.9998,
          thumbShape: RoundSliderThumbShape(
              enabledThumbRadius: size.safeBlockHorizontal * 1.25),
        ),
        child: SizedBox(
            width: size.safeBlockHorizontal * 20,
            child: Slider(
              value: value,
              onChanged: onChanged,
              max: 1.00,
              min: 0.00,
              divisions: 50,
            )));
  }
}

/// Styled button for displaying syllables.
class SyllableButton extends StatelessWidget {
  final void Function()? onPressed;

  final String syllable;

  final SizeConfig size;

  const SyllableButton(
      {required this.syllable,
      required this.size,
      required this.onPressed,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
        child: TextButton(
            onPressed: onPressed,
            child: Text(syllable,
                style: TextStyle(
                    fontSize: size.safeBlockVertical * 12.1359,
                    fontFamily: 'Ginthul',
                    foreground: Paint()
                      ..style = PaintingStyle.fill
                      ..strokeWidth = 4
                      ..color = const Color.fromRGBO(69, 69, 69, 1)))));
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

Widget getGameUiElement(
    String path, SizeConfig size, double percentWidth, double percentHeight,
    [void Function()? onSelected]) {
  return AlignedImage(
      image: path,
      width: size.safeBlockHorizontal * percentWidth,
      height: size.safeBlockVertical * percentHeight,
      onSelected: onSelected);
}

Widget getArrowBackButton(SizeConfig size, void Function()? onPressed) {
  return IconButton(
      onPressed: onPressed,
      icon: Image.asset("${ui}arrow_button_back.png",
          width: size.safeBlockHorizontal * 9,
          height: size.safeBlockVertical * 14));
}
