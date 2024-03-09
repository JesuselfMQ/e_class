import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import 'settings_controller.dart';
import 'responsive_screen.dart';
import 'size_config.dart';

class SettingsScreen extends StatefulWidget {

  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    final settings = context.watch<SettingsController>();
    final _gap = SizedBox(height: SizeConfig.blockSizeVertical * 0.5);

    return Scaffold(
      backgroundColor: const Color.fromRGBO(255, 218, 33, 1),
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/settings_background.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: ResponsiveScreen(
        squarishMainArea: ListView(
          children: [
            _gap,
            Text(
              'Ajustes',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Heirany Slight',
                fontWeight: FontWeight.bold,
                fontSize: SizeConfig.blockSizeVertical * 16,
                height: 1,
              ),
            ),
            _gap,
            ValueListenableBuilder<bool>(
              valueListenable: settings.soundEnabled,
              builder: (context, soundEnabled, child) => Material(
                type: MaterialType.transparency,
                  child: _SettingsLine(
                  'Sonido',
                  Icon(soundEnabled ? Icons.graphic_eq : Icons.volume_off, size: SizeConfig.blockSizeVertical * 8),
                  onSelected: () {
                    settings.toggleSoundEnabled();
                  },
                )
              ),
            ),
            _gap,
            Material(
              type: MaterialType.transparency,
              child: _SettingsLine('Consonantes',
                Icon(Icons.font_download, size: SizeConfig.blockSizeVertical * 8),
                onSelected: () => context.go('/settings/consonants')
              )
            )
          ],
        ),
        rectangularMenuArea: IconButton(
          onPressed: () => GoRouter.of(context).pop(),
          icon: Image.asset('assets/arrow_button_back.png',
            width: SizeConfig.blockSizeHorizontal * 7,
            height: SizeConfig.blockSizeVertical * 14
            )
          )
        ),
      ),
    );
  }
}

class _SettingsLine extends StatelessWidget {
  final String title;

  final Widget icon;

  final VoidCallback? onSelected;

  const _SettingsLine(this.title, this.icon, {this.onSelected});

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
                  fontFamily: 'Heirany Slight',
                  fontSize: SizeConfig.blockSizeVertical * 10,
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
