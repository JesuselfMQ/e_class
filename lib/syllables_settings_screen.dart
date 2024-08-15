import 'package:e_class/decoration.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'audio_controller.dart';
import 'file_paths.dart';
import 'phonetic_data.dart';
import 'responsive_screen.dart';
import 'settings.dart';
import 'size_config.dart';
import 'utils.dart';

class SyllablesSettingsScreen extends StatelessWidget with PhoneticData {
  const SyllablesSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final audio = context.read<AudioController>();
    final settings = context.read<SettingsController>();
    final size = SizeConfig(context);
    final utils = Utils(size);
    return FillBackground(
        backgroundFile: 'settings.jpg',
        child: ResponsiveScreen(
            squarishMainArea: ListView.builder(
                itemCount: allPhoneticComponents.length,
                itemBuilder: (context, index) {
                  String syllable = allPhoneticComponents[index];
                  return ValueListenableBuilder(
                      valueListenable: settings.syllablesPrefs[syllable]!,
                      builder: (context, syllableOn, child) => utils.getSetting(
                              syllable.toUpperCase(),
                              iconName: syllableOn
                                  ? '${ui}enable.png'
                                  : '${ui}disable.png',
                              iconWidth: 12,
                              iconHeight: 6, onSelected: () {
                            settings.toggleSyllableOn(syllable);
                            final shift = audio.sfx["shift"]?.join();
                            audio.playSfx(shift);
                          }));
                }),
            rectangularMenuArea:
                utils.getArrowBackButton(() => GoRouter.of(context).pop())));
  }
}
