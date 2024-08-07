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
                        'Volumen Sonidos',
                        slider: AudioSlider(settings.soundsVolume.value, size,
                            (double value) => settings.setSoundsVolume(value)),
                        size,
                      )),
              gap,
              ValueListenableBuilder(
                  valueListenable: settings.musicVolume,
                  builder: (_, musicVolume, __) => SettingsLine(
                        'Volumen Música',
                        size,
                        slider: AudioSlider(settings.musicVolume.value, size,
                            (double value) => settings.setMusicVolume(value)),
                      ))
            ],
          ),
          rectangularMenuArea:
              getArrowBackButton(size, () => GoRouter.of(context).pop()),
        ));
  }
}

class SettingsLine extends StatelessWidget {
  final String title;

  final String? iconName;

  final double percent;

  final double iconWidth;

  final double iconHeight;

  final Widget? slider;

  final VoidCallback? onSelected;

  final SizeConfig size;

  const SettingsLine(this.title, this.size,
      {this.onSelected,
      this.slider,
      this.iconName,
      this.percent = 8,
      this.iconWidth = 5,
      this.iconHeight = 8,
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
                    fontSize: size.getPercentHeight(percent),
                  ),
                ),
              ),
              slider ??
                  Image.asset(
                    iconName!,
                    width: size.safeBlockHorizontal * iconWidth,
                    height: size.safeBlockVertical * iconHeight,
                  ),
            ],
          ),
        ));
  }
}
