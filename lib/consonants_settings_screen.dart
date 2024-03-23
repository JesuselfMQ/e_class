import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'responsive_screen.dart';
import 'package:go_router/go_router.dart';
import 'size_config.dart';
import 'widget_builder.dart' as wb;
import 'settings_screen.dart' as ss;
import 'file_paths.dart';

class ConsonantsSettingsScreen extends StatefulWidget {
  const ConsonantsSettingsScreen({super.key});

  @override
  ConsonantsSettingsScreenState createState() => ConsonantsSettingsScreenState();
}

class ConsonantsSettingsScreenState extends State<ConsonantsSettingsScreen> {
  // Assuming consonants is a list of all the consonants you want to manage
  List<String> consonants = ["a", "e", "i", "o", "u"] + "lrmpstndcbvfjgñyzhkwxq".split('') + ["bl", "br", "cl", "cr", "dr", "fl", "fr", "gl", "gr", "pl", "pr", "tr", "tl", "ch", "ll", "gu", "rr", "vl", "vn", "vs", "vr", "vm", "iv", "uv", "vy"];

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
        decoration: wb.WidgetBuilder().getBackground('${path['background']}settings_background.jpg'),
      child: ResponsiveScreen(
        squarishMainArea: ListView.builder(
          itemCount: consonants.length,
          itemBuilder: (context, index) {
            String consonant = consonants[index];
            return FutureBuilder<bool>(
              future: _getConsonantSetting(consonant),
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                return const CircularProgressIndicator();
                }
                return Material(
                  type: MaterialType.transparency,
                  child: ss.SettingsLine(
                    consonant.toUpperCase(),
                    Image.asset(
                      snapshot.data! ? '${path['ui']}enable.png' : '${path['ui']}disable.png',
                      width: SizeConfig.blockSizeHorizontal * 12,
                      height: SizeConfig.blockSizeVertical * 6,
                    ), 8,
                    onSelected: () => _saveConsonantSetting(consonant)
                  )
                );
              }
            );
          }
        ),
        rectangularMenuArea: IconButton(
          onPressed: () => GoRouter.of(context).go('/settings'),
          icon: Image.asset('${path['ui']}arrow_button_back.png',
            width: SizeConfig.blockSizeHorizontal * 7,
            height: SizeConfig.blockSizeVertical * 14
          )
        )
      )
      )
    );
  }

  Future<bool> _getConsonantSetting(String consonant) async {
    final prefs = await SharedPreferences.getInstance();
    // Default to true if not set
    return prefs.getBool(consonant) ?? true;
  }

  void _saveConsonantSetting(String consonant) async {
    final prefs = await SharedPreferences.getInstance();
    final consonantValue = prefs.getBool(consonant) ?? true;
    await prefs.setBool(consonant, !consonantValue);
    // Trigger a rebuild to reflect changes
    setState(() {});
  }
}