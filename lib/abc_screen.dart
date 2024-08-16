import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'decoration.dart';
import 'file_paths.dart';
import 'phonetic_data.dart';
import 'utils.dart';
import 'size_config.dart';

class AbecedaryScreen extends StatelessWidget with PhoneticData {
  const AbecedaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = SizeConfig(context);
    final utils = Utils(size);
    return FillBackground(
        backgroundFile: "abc.jpg",
        child: GridView.count(
          mainAxisSpacing: 20.0,
          crossAxisSpacing: 30.0,
          shrinkWrap: true,
          primary: false,
          physics: const NeverScrollableScrollPhysics(),
          scrollDirection: Axis.horizontal,
            crossAxisCount: 2,
            children: List.generate(phoneticLearningOrder.length, (int index) {
              return Stack(children: [
                utils.getCenteredImage("${ui}note.png", 20, 24),
                SyllableButton(
                    syllable: phoneticLearningOrder[index].toUpperCase(),
                    size: size,
                    onPressed: () => context.go('/phonetic/:letter'))
              ]);
            })));
  }
}
