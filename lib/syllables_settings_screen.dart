import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'audio_controller.dart';
import 'file_paths.dart';
import 'phonetic_data.dart';
import 'responsive_screen.dart';
import 'settings.dart';
import 'settings_screen.dart';
import 'size_config.dart';
import 'utils.dart';

class SyllablesSettingsScreen extends StatelessWidget with PhoneticData {
  const SyllablesSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final audio = context.read<AudioController>();
    final settings = context.read<SettingsController>();
    final size = SizeConfig(context);
    return FillBackground(
        background: '${backgroung}settings_background.jpg',
        child: ResponsiveScreen(
            squarishMainArea: ListView.builder(
                itemCount: allPhoneticComponents.length,
                itemBuilder: (context, index) {
                  String syllable = allPhoneticComponents[index];
                  return ValueListenableBuilder(
                      valueListenable: settings.syllablesPrefs[syllable]!,
                      builder: (context, syllableOn, child) => SettingsLine(
                              syllable.toUpperCase(),
                              iconName: syllableOn
                                  ? '${ui}enable.png'
                                  : '${ui}disable.png',
                              iconWidth: 12,
                              iconHeight: 6,
                              size, onSelected: () {
                            settings.toggleSyllableOn(syllable);
                            final shift = audio.sfx["shift"]?.join();
                            audio.playSfx(shift);
                          }));
                }),
            rectangularMenuArea:
                getArrowBackButton(size, () => GoRouter.of(context).pop())));
  }
}