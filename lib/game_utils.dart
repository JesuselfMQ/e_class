import 'package:flutter/material.dart';

import 'size_config.dart';
import 'utils.dart';

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

Widget getGameUiElement(
    String path, SizeConfig size, double percentWidth, double percentHeight,
    [void Function()? onSelected]) {
  return AlignedImage(
      image: path,
      width: size.safeBlockHorizontal * percentWidth,
      height: size.safeBlockVertical * percentHeight,
      onSelected: onSelected);
}