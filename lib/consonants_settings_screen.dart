import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'responsive_screen.dart';
import 'package:go_router/go_router.dart';
import 'size_config.dart';

class ConsonantsSettingsScreen extends StatefulWidget {
  const ConsonantsSettingsScreen({super.key});

  @override
  _ConsonantsSettingsScreenState createState() => _ConsonantsSettingsScreenState();
}

class _ConsonantsSettingsScreenState extends State<ConsonantsSettingsScreen> {
  // Assuming consonants is a list of all the consonants you want to manage
  List<String> consonants = ["a", "e", "i", "o", "u"] + "lrmpstndcbvfjgñyzhkwxq".split('') + ["bl", "br", "cl", "cr", "dr", "fl", "fr", "gl", "gr", "pl", "pr", "tr", "tl", "ch", "ll", "gu", "rr", "vl", "vn", "vs", "vr", "vm", "iv", "uv", "vy"];

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/settings_background.jpg"),
            fit: BoxFit.fill,
          ),
        ),
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
                  child: _ConsonantSettingsLine(
                    SwitchListTile(
                      title: Text(consonant.toUpperCase(),
                        style: TextStyle(
                          fontFamily: 'Heirany Slight',
                          fontSize: SizeConfig.blockSizeVertical * 8,
                        ),
                      ),
                      value: snapshot.data!,
                      onChanged: (bool value) {
                        _saveConsonantSetting(consonant, value);
                      }
                    )
                  )
                );
              }
            );
          }
        ),
        rectangularMenuArea: IconButton(
          onPressed: () => GoRouter.of(context).go('/settings'),
          icon: Image.asset('assets/arrow_button_back.png',
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

  void _saveConsonantSetting(String consonant, bool value) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(consonant, value);
    // Trigger a rebuild to reflect changes
    setState(() {});
  }
}

class _ConsonantSettingsLine extends StatelessWidget {

  final Widget tile;

  const _ConsonantSettingsLine(this.tile);

  @override
  Widget build(BuildContext context) {
    return InkResponse(
      highlightShape: BoxShape.rectangle,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: tile
            ),
          ],
        ),
      ),
    );
  }
}