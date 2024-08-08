import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'audio_controller.dart';
import 'file_paths.dart';
import 'responsive_screen.dart';
import 'settings.dart';
import 'size_config.dart';
import 'utils.dart';

class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = SizeConfig(context);
    final utils = Utils(size);
    final settings = context.read<SettingsController>();
    final audio = context.read<AudioController>();
    final gap = SizedBox(height: size.safeBlockVertical * 0.5);

    return FillBackground(
        background: '${backgroung}settings.jpg',
        child: ResponsiveScreen(
          squarishMainArea: ListView(
            children: [
              gap,
              Text(
                'Ajustes',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Ginthul',
                  fontWeight: FontWeight.bold,
                  fontSize: size.getPercentHeight(12),
                  height: 1,
                ),
              ),
              gap,
              SettingsLine(
                  'Silabas',
                  iconName: '${ui}letter.png',
                  size,
                  onSelected: () => context.go('/settings/syllables')),
              gap,
              ValueListenableBuilder(
                valueListenable: settings.soundsOn,
                builder: (_, soundsOn, __) => SettingsLine(
                    'Sonido',
                    iconName: soundsOn
                        ? '${ui}speaker_on.png'
                        : '${ui}speaker_off.png',
                    size, onSelected: () {
                  final shift = audio.sfx["shift"]?.join();
                  audio.playSfx(shift);
                  settings.toggleSoundsOn();
                }),
              ),
              gap,
              SettingsLine(
                'Cambiar Canción',
                iconName: '${ui}music_note.png',
                size,
                onSelected: () => audio.nextSong(),
              ),
              gap,
              ValueListenableBuilder(
                valueListenable: settings.soundsVolume,
                builder: (_, soundsVolume, __) => SettingsLine(
                    'Volumen Sonidos', size,
                    sliderValue: settings.soundsVolume.value,
                    onChangedSlider: (double value) =>
                        settings.setSoundsVolume(value)),
              ),
              gap,
              ValueListenableBuilder(
                valueListenable: settings.musicVolume,
                builder: (_, musicVolume, __) => SettingsLine(
                    'Volumen Música', size,
                    sliderValue: settings.musicVolume.value,
                    onChangedSlider: (double value) =>
                        settings.setMusicVolume(value)),
              )
            ],
          ),
          rectangularMenuArea:
              utils.getArrowBackButton(() => GoRouter.of(context).pop()),
        ));
  }
}

class SettingsLine extends StatelessWidget {
  final String title;

  final String? iconName;

  final double percent;

  final double iconWidth;

  final double iconHeight;

  final void Function(double value)? onChangedSlider;

  final double? sliderValue;

  final void Function()? onSelected;

  final SizeConfig size;

  const SettingsLine(this.title, this.size,
      {this.onSelected,
      this.onChangedSlider,
      this.sliderValue,
      this.iconName,
      this.percent = 8,
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
                    fontSize: size.getPercentHeight(percent),
                  ),
                ),
              ),
              sliderRequired
                  ? MySlider(sliderValue!, size, onChangedSlider)
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
class MySlider extends StatelessWidget {
  final double value;

  final void Function(double)? onChanged;

  final SizeConfig size;

  const MySlider(this.value, this.size, this.onChanged, {super.key});

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
