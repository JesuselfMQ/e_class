import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'settings_controller.dart';
import 'responsive_screen.dart';
import 'size_config.dart';
import 'audio_controller.dart';
import 'widget_builder.dart' as wb;
import 'file_paths.dart';
import 'sounds.dart';

class SettingsScreen extends StatefulWidget {

  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {

  AudioController audioController = AudioController();

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final settings = context.watch<SettingsController>();
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
                fontSize: SizeConfig.blockSizeVertical * 16,
                height: 1,
              ),
            ),
            gap,
            ValueListenableBuilder<bool>(
              valueListenable: settings.soundEnabled,
              builder: (context, soundEnabled, child) => Material(
                type: MaterialType.transparency,
                  child: SettingsLine(
                  'Sonido',
                  Icon(soundEnabled ? Icons.graphic_eq : Icons.volume_off, size: SizeConfig.blockSizeVertical * 8), 10,
                  onSelected: () {
                    settings.toggleSoundEnabled();
                    final audioController = context.read<AudioController>();
                    audioController.playSfx(SfxType.shift);
                  }
                )
              ),
            ),
            gap,
            ValueListenableBuilder(
              valueListenable: settings.musicEnabled,
              builder: (context, musicEnabled, child) => Material(
                type: MaterialType.transparency,
                child: SettingsLine(
                  'Música',
                  Icon(musicEnabled ? Icons.music_note_outlined : Icons.music_off_outlined, size: SizeConfig.blockSizeVertical * 8), 10,
                  onSelected: () {
                    settings.toggleMusicEnabled();
                    final audioController = context.read<AudioController>();
                    audioController.playSfx(SfxType.shift);
                  }
                )
              )
            ),
            gap,
            Material(
              type: MaterialType.transparency,
              child: SettingsLine('Consonantes',
                Icon(Icons.font_download, size: SizeConfig.blockSizeVertical * 8), 10,
                onSelected: () => context.go('/settings/consonants')
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

  const SettingsLine(this.title, this.icon,this.fonScaleFactor, {this.onSelected});

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
                  fontSize: SizeConfig.blockSizeVertical * fonScaleFactor,
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
