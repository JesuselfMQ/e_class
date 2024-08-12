import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'game_screen.dart';
import 'lose_screen.dart';
import 'main_menu_screen.dart';
import 'my_counter.dart';
import 'settings_screen.dart';
import 'syllables_settings_screen.dart';

/// The router describes the game's navigational hierarchy, from the main
/// screen through settings screens all the way to each individual game.
final GoRouter router = GoRouter(routes: [
  GoRoute(
      path: '/',
      builder: (BuildContext context, GoRouterState state) =>
          const MainMenuScreen(),
      routes: [
        GoRoute(
            path: 'game',
            builder: (BuildContext context, GoRouterState state) =>
                const GameScreen(),
            routes: [
              GoRoute(
                  path: 'lose',
                  builder: (BuildContext context, GoRouterState state) {
                    final score = state.extra as int;
                      return LoseScreen(score: score, counter: MyCounter(),);})
            ]),
        GoRoute(
            path: 'settings',
            builder: (BuildContext context, GoRouterState state) =>
                const SettingsScreen(),
            routes: [
              GoRoute(
                  path: 'syllables',
                  builder: (BuildContext context, GoRouterState state) =>
                      const SyllablesSettingsScreen())
            ]),
      ])
]);
