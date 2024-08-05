import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';

import 'file_paths.dart';
import 'image_data.dart';
import 'settings.dart';
import 'size_config.dart';
import 'utils.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final settings = context.read<SettingsController>();
    final size = SizeConfig(context);
    final images = [
      ImageData.menuImage("star.gif", -0.68, -0.7, size),
      ImageData.menuImage("star.gif", 0.68, -0.7, size),
      ImageData.menuImage("flower.gif", 0.5, 1.38, size),
      ImageData.menuImage("cat.gif", 0.0, 1.18, size),
      ImageData.menuImage("cloud.gif", 1.00, -0.75, size),
      ImageData.menuImage("line.gif", 1.05, 0.0, size),
      ImageData("${decoration}kid.gif", -1.10, 1.10, size, 30, 45),
      ImageData.menuButton(
          "play_button.png", 0.0, 0.4, size, () => goToGame(context, settings)),
      ImageData.menuButton(
          "settings_button.png", 0.9, 0.9, size, () => context.go('/settings'))
    ];
    return FillBackground(
      background: '${backgroung}menu_background.jpg',
      child: Stack(
        children: images
            .map((data) => AlignedImage(
                image: data.path,
                horizontal: data.horizontalAlignment,
                vertical: data.verticalAlignment,
                width: data.width,
                height: data.height,
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
