import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'size_config.dart';
import 'widget_builder.dart' as wb;
import 'file_paths.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double verticalScaleFactor = 20;
    double horizontalScaleFactor = verticalScaleFactor / 2;
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
                SizeConfig.blockSizeHorizontal,
                SizeConfig.blockSizeVertical,20,40),
              wb.WidgetBuilder().getImageButton(
                '${path['decoration']}star.gif',0.68, -0.7,
                SizeConfig.blockSizeHorizontal,
                SizeConfig.blockSizeVertical,20,40),
              wb.WidgetBuilder().getImageButton(
                '${path['decoration']}flower.gif',0.5, 1.15,
                SizeConfig.blockSizeHorizontal,
                SizeConfig.blockSizeVertical,20,40),
              wb.WidgetBuilder().getImageButton(
                '${path['ui']}play_button.png',0.0,0.4,
                SizeConfig.blockSizeHorizontal,
                SizeConfig.blockSizeVertical,
                horizontalScaleFactor,
                verticalScaleFactor,
                onSelected: () => context.go('/game')),
              wb.WidgetBuilder().getImageButton(
                '${path['ui']}settings_button.png',0.9,0.9,
                SizeConfig.blockSizeHorizontal,
                SizeConfig.blockSizeVertical,
                horizontalScaleFactor,
                verticalScaleFactor,
                onSelected: () => context.go('/settings'))
            ],
          ),
        )
      ),
    );
  }
}