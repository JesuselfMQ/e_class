import 'package:flutter/material.dart';

import 'size_config.dart';

class SettingsLine extends StatelessWidget {
  final String title;

  final SizeConfig size;

  final String? iconName;

  final double fontSize;

  final double iconWidth;

  final double iconHeight;

  final void Function(double value)? onChangedSlider;

  final double? sliderValue;

  final void Function()? onSelected;

  const SettingsLine(this.title, this.size,
      {this.onSelected,
      this.onChangedSlider,
      this.sliderValue,
      this.iconName,
      this.fontSize = 8,
      this.iconWidth = 5,
      this.iconHeight = 8,
      super.key});

  @override
  Widget build(BuildContext context) {
    bool sliderRequired = sliderValue != null && onChangedSlider != null;
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
                    fontSize: size.getPercentHeight(fontSize),
                  ),
                ),
              ),
              sliderRequired
                  ? SettingsSlider(sliderValue!, onChangedSlider, size)
                  : Image.asset(
                      iconName!,
                      width: size.safeBlockHorizontal * iconWidth,
                      height: size.safeBlockVertical * iconHeight,
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

  final SizeConfig size;

  const SettingsSlider(this.value, this.onChanged, this.size, {super.key});

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
