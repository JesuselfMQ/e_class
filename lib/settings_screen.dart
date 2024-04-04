import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'settings_controller.dart';
import 'responsive_screen.dart';
import 'size_config.dart';
import 'audio_controller.dart';
import 'widget_builder.dart' as wb;
import 'file_paths.dart';

class SettingsScreen extends StatefulWidget {

  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    const double fontScaleFactor = 8;
    const int iconSize = 5;
    final settings = context.watch<SettingsController>();
    final audio = context.watch<AudioController>();
    final gap = SizedBox(height: SizeConfig.blockSizeVertical * 0.5);

    return Scaffold(
      body: Container(
        decoration: wb.WidgetBuilder().getBackground('${path['background']}settings_background.jpg'),
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
                fontSize: SizeConfig().getSize(12),
                height: 1,
              ),
            ),
            gap,
            Material(
              type: MaterialType.transparency,
              child: SettingsLine(
                'Letras',
                Image.asset(
                  '${path['ui']}letter.png',
                  width: SizeConfig.blockSizeHorizontal * iconSize,
                  height: SizeConfig.blockSizeVertical * iconSize,
                ),
                fontScaleFactor,
                onSelected: () => context.go('/settings/consonants')
              )
            ),
            gap,
            ValueListenableBuilder(
              valueListenable: settings.soundEnabled,
              builder: (context, soundEnabled, child) => Material(
                type: MaterialType.transparency,
                child: SettingsLine(
                  'Sonido',
                  Image.asset(
                    soundEnabled ? '${path['ui']}speaker_on.png' : '${path['ui']}speaker_off.png',
                    width: SizeConfig.blockSizeHorizontal * iconSize,
                    height: SizeConfig.blockSizeVertical * iconSize,
                  ),
                  fontScaleFactor,
                  onSelected: () => settings.toggleSoundEnabled()
                ),
              ),
            ),
            gap,
            Material(
              type: MaterialType.transparency,
              child: SettingsLine(
                'Cambiar Canción',
                Image.asset('${path['ui']}music_note.png',
                width: SizeConfig.blockSizeHorizontal * iconSize,
                height: SizeConfig.blockSizeVertical * iconSize,
                ),
                fontScaleFactor,
                onSelected: () => audio.changeSong(),
              ),
            ),
            gap,
            ValueListenableBuilder(
              valueListenable: settings.soundVolume,
              builder: (context, soundVolume, child) => Material(
                type: MaterialType.transparency,
                child: SettingsLine(
                  'Volumen Sonidos',
                  Slider(
                    value: settings.soundVolume.value,
                    max: 1.00,
                    min: 0.00,
                    divisions: 50,
                    onChanged: (double value) {
                      setState(() {
                        if (value == 0.00) {
                          if (settings.soundEnabled.value) {
                            settings.toggleSoundEnabled();
                          }
                        } else {
                          if (!settings.soundEnabled.value) {
                            settings.toggleSoundEnabled();
                          }
                        }
                        settings.changeSoundVolume(value);
                      });
                    }
                  ),
                  fontScaleFactor,
                  onSelected: () {},
                )
              )
            ),
            gap,
            ValueListenableBuilder(
              valueListenable: settings.musicVolume,
              builder: (context, musicVolume, child) => Material(
                type: MaterialType.transparency,
                child: SettingsLine(
                  'Volumen Música',
                  Slider(
                    value: settings.musicVolume.value,
                    max: 1.00,
                    min: 0.00,
                    divisions: 50,
                    onChanged: (double value) {
                      setState(() {
                        settings.changeMusicVolume(value);
                      });
                    }
                  ),
                  fontScaleFactor,
                  onSelected: () {},
                )
              )
            )
          ],
        ),
        rectangularMenuArea: IconButton(
          onPressed: () => GoRouter.of(context).pop(),
          icon: Image.asset('${path['ui']}arrow_button_back.png',
            width: SizeConfig.blockSizeHorizontal * 7,
            height: SizeConfig.blockSizeVertical * 14
            )
          )
        ),
      ),
    );
  }
}

class SettingsLine extends StatelessWidget {
  final String title;

  final Widget icon;

  final double fonScaleFactor;

  final VoidCallback? onSelected;

  const SettingsLine(this.title, this.icon,this.fonScaleFactor, {this.onSelected, super.key});

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      highlightShape: BoxShape.rectangle,
      onTap: onSelected,
      child: Padding(
        padding: EdgeInsets.zero,
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
                  fontSize: SizeConfig().getSize(fonScaleFactor),
                ),
              ),
            ),
            icon,
          ],
        ),
      ),
    );
  }
}