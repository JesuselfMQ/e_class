import 'package:flutter/material.dart';

class SettingsLine extends StatelessWidget {
  final String title;

  final String? iconName;

  final double fontSize;

  final double? iconWidth;

  final double? iconHeight;

  final SettingsSlider? slider;

  final void Function()? onSelected;

  const SettingsLine(this.title,
      {this.onSelected,
      this.slider,
      this.iconName,
      this.fontSize = 8,
      this.iconWidth,
      this.iconHeight,
      super.key});

  @override
  Widget build(BuildContext context) {
    return Material(
        type: MaterialType.transparency,
        child: InkResponse(
          highlightShape: BoxShape.rectangle,
          onTap: onSelected ?? () {},
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Expanded(
                child: Text(
                  title,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontFamily: 'Ginthul',
                    fontSize: fontSize,
                  ),
                ),
              ),
              slider != null
                  ? slider!
                  : Image.asset(
                      iconName!,
                      width: iconWidth,
                      height: iconHeight,
                    ),
            ],
          ),
        ));
  }
}

/// Slider with responsive size.
class SettingsSlider extends StatelessWidget {
  final double value;

  final void Function(double)? onChanged;

  final double width;

  final double height;

  final double radius;

  const SettingsSlider(
      this.value, this.width, this.height, this.radius, this.onChanged,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return SliderTheme(
        data: SliderTheme.of(context).copyWith(
          overlayShape: SliderComponentShape.noOverlay,
          trackHeight: height,
          thumbShape: RoundSliderThumbShape(enabledThumbRadius: radius),
        ),
        child: SizedBox(
            width: width,
            child: Slider(
              value: value,
              onChanged: onChanged,
              max: 1.00,
              min: 0.00,
              divisions: 50,
            )));
  }
}
