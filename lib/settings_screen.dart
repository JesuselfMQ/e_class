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
  static const _gap = SizedBox(height: 60);
  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context); 
    final settings = context.watch<SettingsController>();

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
            const Text(
              'Ajustes',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontFamily: 'Heirany Slight',
                fontWeight: FontWeight.bold,
                fontSize: 100,
                height: 1,
              ),
            ),
            _gap,
            ValueListenableBuilder<bool>(
              valueListenable: settings.soundEnabled,
              builder: (context, soundEnabled, child) => _SettingsLine(
                'Sonido',
                Icon(soundEnabled ? Icons.graphic_eq : Icons.volume_off, size: 50),
                onSelected: () => settings.toggleSoundEnabled(),
              ),
            ),
            _gap,
            _SettingsLine('Consonantes',
              const Icon(Icons.font_download, size: 50),
              onSelected: () => context.go('/consonants')
            )
          ],
        ),
        rectangularMenuArea: IconButton(
          onPressed: () => GoRouter.of(context).pop(),
          icon: Image.asset('assets/arrow_button_back.png',
            width: SizeConfig.blockSizeVertical * 12,
            height: SizeConfig.blockSizeVertical * 16,
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
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(
                  fontFamily: 'Heirany Slight',
                  fontSize: 60,
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
