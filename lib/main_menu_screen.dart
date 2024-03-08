import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

///import 'responsive_screen.dart';

class MainMenuScreen extends StatelessWidget {
  const MainMenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                alignment: const Alignment(0.0,0.3),
                child: IconButton(
                  onPressed: () => context.go('/game'),
                  icon: const ImageIcon(
                    AssetImage('assets/play_button.png'),
                    size: 100,
                  )
                )
              ),
              Align(
                alignment: const Alignment(0.9,0.9),
                child: IconButton(
                  onPressed: () => context.go('/settings'),
                  icon: const ImageIcon(
                    AssetImage('assets/settings_button.png'),
                    size: 100,
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