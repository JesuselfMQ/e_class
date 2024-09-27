import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'audio_controller.dart';
import 'decoration.dart';
import 'file_paths.dart';
import 'phonetic_data.dart';
import 'responsive_screen.dart';
import 'settings.dart';
import 'utils.dart';

class SyllablesSettingsScreen extends StatelessWidget with PhoneticData {
  const SyllablesSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final audio = context.read<AudioController>();
    final settings = context.read<SettingsController>();
    final utils = ResponsiveUtils(context);
    final shift = audio.sfx['shift']!.single;
    return FillBackground(
        file: 'settings.jpg',
        child: ResponsiveScreen(
            squarishMainArea: ListView.builder(
                itemCount: phoneticComponents.length,
                itemBuilder: (_, index) {
                  var syllable = phoneticComponents[index];
                  return ValueListenableBuilder(
                      valueListenable: settings.syllablesPrefs[syllable]!,
                      builder: (_, syllableOn, __) => utils.getSetting(
                              syllable.toUpperCase(),
                              iconName: syllableOn
                                  ? '${ui}enable.png'
                                  : '${ui}disable.png',
                              iconWidth: 12,
                              iconHeight: 6, onSelected: () {
                            settings.toggleSyllableOn(syllable);
                            audio.playSfx(shift);
                          }));
                }),
            rectangularMenuArea:
                utils.arrowBackButton(() => GoRouter.of(context).pop())));
  }
}
