import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'decoration.dart';
import 'file_paths.dart';
import 'image_data.dart';
import 'settings.dart';
import 'utils.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.read<SettingsController>();
    final utils = ResponsiveUtils(context);
    final images = [
      ImageData('${animated}kid.gif', -1.10, 1.10, 30, 45),
      ImageData.menuImage('star.gif', -0.68, -0.7),
      ImageData.menuImage('star.gif', 0.68, -0.7),
      ImageData.menuImage('flower.gif', 0.5, 1.38),
      ImageData.menuImage('cat.gif', 0.0, 1.18),
      ImageData.menuImage('cloud.gif', 1.00, -0.75),
      ImageData.menuButton(
          'play_button.png', -0.3, 0.4, () => goToGame(context, settings)),
      ImageData.menuButton(
          'settings_button.png', 0.9, 0.9, () => context.go('/settings')),
      ImageData.menuButton(
          'abc_button.png', 0.3, 0.4, () => context.go('/phonetic')),
    ];
    return FillBackground(
      file: 'menu.jpg',
      child: Stack(
        children: images
            .map((data) => AlignedImage(
                image: data.path,
                alignment:
                    Alignment(data.horizontalAlignment, data.verticalAlignment),
                width: data.width * utils.safeBlockHorizontal,
                height: data.height * utils.safeBlockVertical,
                onSelected: data.onSelected))
            .toList(),
      ),
    );
  }

  void goToGame(BuildContext context, SettingsController settings) {
    settings.setMusicVolume(0.0);
    context.go('/game');
  }
}
