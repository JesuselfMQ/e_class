import 'consonants_settings_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'main_menu_screen.dart';
import 'game_screen.dart';
import 'settings_screen.dart';

final GoRouter router = GoRouter(
  routes: [
    GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) {
        return const MainMenuScreen();
      },
      routes: [
        GoRoute(
          path: 'game',
          builder: (BuildContext context, GoRouterState state) => const GameScreen(),
        ),
        GoRoute(
          path: 'settings',
          builder: (BuildContext context, GoRouterState state) {
            double aspectRatio = MediaQuery.of(context).size.width / (MediaQuery.of(context).size.height);
            double arrowIconSize = (aspectRatio / 0.0163).round().toDouble();
            return SettingsScreen(arrowIconSize: arrowIconSize);
          },
        ),
        GoRoute(
          path: 'consonants',
          builder: (BuildContext context, GoRouterState state) => const ConsonantsSettingsScreen()
        ),
      ]  
    )
  ]
);

