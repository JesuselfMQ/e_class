import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'size_config.dart';

///import 'responsive_screen.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    double iconScaleFactor = 20;
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/menu_background.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: Center(
          child: Stack(
            fit: StackFit.expand,
            children: <Widget>[
              Align(
                alignment: const Alignment(-0.6, -0.4),
                child: Image.asset(
                  'assets/star.gif',
                  width: SizeConfig.blockSizeHorizontal * 6.9444,
                  height: SizeConfig.blockSizeVertical * 17
                ),
              ),
              Align(
                alignment: const Alignment(-0.45, -0.5),
                child: Image.asset(
                  'assets/star_2.gif',
                  width: SizeConfig.blockSizeHorizontal * 6.9444,
                  height: SizeConfig.blockSizeVertical * 17
                ),
              ),
              Align(
                alignment: const Alignment(0.0,0.4),
                child: IconButton(
                  onPressed: () => context.go('/game'),
                  icon: Image.asset('assets/play_button.png',
                    width: SizeConfig.blockSizeHorizontal * (iconScaleFactor / SizeConfig.aspectRatio),
                    height: SizeConfig.blockSizeVertical * iconScaleFactor,
                  )
                )
              ),
              Align(
                alignment: const Alignment(0.9,0.9),
                child: IconButton(
                  onPressed: () => context.go('/settings'),
                  icon: Image.asset('assets/settings_button.png',
                    width: SizeConfig.blockSizeHorizontal * (iconScaleFactor / SizeConfig.aspectRatio),
                    height: SizeConfig.blockSizeVertical * iconScaleFactor,
                  )
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}