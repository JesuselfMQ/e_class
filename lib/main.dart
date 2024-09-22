import 'package:device_preview/device_preview.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

import 'app_lifecycle.dart';
import 'audio_controller.dart';
import 'router.dart';
import 'settings.dart';

void main() async {
  // Initialize the binding between the framework and the platform's widgets library.
  WidgetsFlutterBinding.ensureInitialized();

  // Put game into full screen mode on mobile devices.
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);

  // Lock the game to landscape mode on mobile devices.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);

  runApp(DevicePreview(
      enabled: !kReleaseMode, builder: (context) => const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLifecycleObserver(
        child: MultiProvider(
            // Set up objects that will be available throughout the whole game.
            providers: [
          // App's settings.
          ChangeNotifierProvider<SettingsController>(
            create: (context) => SettingsController(),
          ),
          // Audio.
          ProxyProvider2<AppLifecycleStateNotifier, SettingsController,
              AudioController>(
            create: (context) => AudioController()..initialize(),
            update: (context, lifecycleNotifier, settings, audio) {
              if (audio == null) throw ArgumentError.notNull();
              audio.attachDependencies(lifecycleNotifier, settings);
              return audio;
            },
            dispose: (context, audio) => audio.dispose(),
            // Ensure that the AudioController is created on startup,
            // so music starts immediately.
            lazy: false,
          ),
        ],
            child: Builder(builder: (context) {
              return MaterialApp.router(
                title: 'E-Class',
                locale: DevicePreview.locale(context),
                builder: DevicePreview.appBuilder,
                routeInformationProvider: router.routeInformationProvider,
                routeInformationParser: router.routeInformationParser,
                routerDelegate: router.routerDelegate,
              );
            })));
  }
}
