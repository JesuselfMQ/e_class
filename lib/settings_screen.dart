import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'audio_controller.dart';
import 'decoration.dart';
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
        file: 'settings.jpg',
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
                  fontSize: size.getHeight(12),
                  height: 1,
                ),
              ),
              gap,
              utils.getSetting('Sílabas',
                  iconName: '${ui}letter.png',
                  onSelected: () => context.go('/settings/syllables')),
              gap,
              ValueListenableBuilder(
                valueListenable: settings.soundsOn,
                builder: (_, soundsOn, __) => utils.getSetting('Sonido',
                    iconName: soundsOn
                        ? '${ui}speaker_on.png'
                        : '${ui}speaker_off.png', onSelected: () {
                  final shift = audio.sfx['shift']?.join();
                  audio.playSfx(shift);
                  settings.toggleSoundsOn();
                }),
              ),
              gap,
              utils.getSetting(
                'Cambiar Canción',
                iconName: '${ui}music_note.png',
                onSelected: () => audio.nextSong(),
              ),
              gap,
              ValueListenableBuilder(
                valueListenable: settings.soundsVolume,
                builder: (_, soundsVolume, __) => utils.getSetting(
                    'Volumen Sonidos',
                    sliderValue: settings.soundsVolume.value,
                    onChangedSlider: (double value) =>
                        settings.setSoundsVolume(value)),
              ),
              gap,
              ValueListenableBuilder(
                valueListenable: settings.musicVolume,
                builder: (_, musicVolume, __) => utils.getSetting(
                    'Volumen Música',
                    sliderValue: settings.musicVolume.value,
                    onChangedSlider: (double value) =>
                        settings.setMusicVolume(value)),
              )
            ],
          ),
          rectangularMenuArea:
              utils.arrowBackButton(() => GoRouter.of(context).pop()),
        ));
  }
}
