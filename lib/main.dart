import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'router.dart';
import 'settings_controller.dart';
import 'app_lifecycle.dart';
import 'package:device_preview/device_preview.dart';
import 'audio_controller.dart';

void main() async {

  WidgetsFlutterBinding.ensureInitialized();
  // Put game into full screen mode on mobile devices.
  await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
  // Lock the game to portrait mode on mobile devices.
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.landscapeRight,
    DeviceOrientation.landscapeLeft,
  ]);

  runApp(
    DevicePreview(
        enabled: !kReleaseMode,
        builder: (context) => const MyApp()
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLifecycleObserver(
      child: MultiProvider(
        providers: [
          ChangeNotifierProvider<SettingsController>(
            lazy: false,
            create: (context) => SettingsController(),
          ),
          ProxyProvider2<SettingsController, ValueNotifier<AppLifecycleState>,AudioController>(
            lazy: false,
            create: (context) => AudioController()..initialize(),
            update: (context, settings, lifecycleNotifier, audio) {
              if (audio == null) throw ArgumentError.notNull();
              audio.attachSettings(settings);
              audio.attachLifecycleNotifier(lifecycleNotifier);
              audio.musicPlayer.setVolume(settings.musicVolume.value);
              if (settings.musicVolume.value == 0.00) {
                audio.musicPlayer.stop();
              } else {
                audio.musicPlayer.resume();
              }
              return audio;
            },
            dispose: (context, audio) => audio.dispose()
          )
        ],
        child: Builder(builder: (context) {
          return MaterialApp.router(
            locale: DevicePreview.locale(context),
            builder: DevicePreview.appBuilder,
            routeInformationProvider: router.routeInformationProvider,
            routeInformationParser: router.routeInformationParser,
            routerDelegate: router.routerDelegate,
            title: 'Guess the Syllable',
            theme: ThemeData(
              primarySwatch: Colors.blue,
            ),
          );
        })
      )
    );
  }
}