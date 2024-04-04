import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'size_config.dart';
import 'widget_builder.dart' as wb;
import 'file_paths.dart';
import 'package:provider/provider.dart';
import 'settings_controller.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double verticalScaleFactor = 20;
    double horizontalScaleFactor = 13;
    final settings = context.watch<SettingsController>();
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
        decoration: wb.WidgetBuilder().getBackground('${path['background']}menu_background.jpg'),
        child: Center(
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              wb.WidgetBuilder().getImageButton(
                '${path['decoration']}star.gif',-0.68, -0.7,
                SizeConfig.blockSizeHorizontal * 20,
                SizeConfig.blockSizeVertical * 40),
              wb.WidgetBuilder().getImageButton(
                '${path['decoration']}star.gif',0.68, -0.7,
                SizeConfig.blockSizeHorizontal * 20,
                SizeConfig.blockSizeVertical * 40),
              wb.WidgetBuilder().getImageButton(
                '${path['decoration']}flower.gif',0.5, 1.18,
                SizeConfig.blockSizeHorizontal * 20,
                SizeConfig.blockSizeVertical * 40),
              wb.WidgetBuilder().getImageButton(
                '${path['decoration']}cat.gif',0.0, 1.12,
                SizeConfig.blockSizeHorizontal * 20,
                SizeConfig.blockSizeVertical * 40),
              wb.WidgetBuilder().getImageButton(
                '${path['decoration']}cloud.gif',1.00, -0.75,
                SizeConfig.blockSizeHorizontal * 20,
                SizeConfig.blockSizeVertical * 40),
              wb.WidgetBuilder().getImageButton(
                '${path['decoration']}girl.gif',-1.00, 1.00,
                SizeConfig.blockSizeHorizontal * 20,
                SizeConfig.blockSizeVertical * 40),
              wb.WidgetBuilder().getImageButton(
                '${path['ui']}play_button.png',0.0,0.4,
                SizeConfig.blockSizeHorizontal * horizontalScaleFactor,
                SizeConfig.blockSizeVertical * verticalScaleFactor,
                onSelected: () {
                  if (settings.musicEnabled.value) {
                    settings.toggleMusicEnabled();  
                  }
                  context.go('/game');
                }
              ),
              wb.WidgetBuilder().getImageButton(
                '${path['ui']}settings_button.png',0.9,0.9,
                SizeConfig.blockSizeHorizontal * horizontalScaleFactor,
                SizeConfig.blockSizeVertical * verticalScaleFactor,
                onSelected: () => context.go('/settings')
              )
            ],
          ),
        )
      ),
    );
  }
}