import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'decoration.dart';
import 'file_paths.dart';
import 'phonetic_data.dart';
import 'scroll_behavior.dart';
import 'size_config.dart';
import 'utils.dart';

class PhoneticSelectionScreen extends StatelessWidget with PhoneticData {
  const PhoneticSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = SizeConfig(context);
    final utils = Utils(size, context);
    final controller = ScrollController();
    final phonetic = Queue.of(phoneticComponents);
    const len = 102;
    return FillBackground(
        file: 'selection.jpg',
        child: ScrollConfiguration(
          behavior: MyCustomScrollBehavior(),
          child: Column(
            children: [
              Expanded(
                  child: GridView.count(
                      controller: controller,
                      scrollDirection: Axis.horizontal,
                      crossAxisCount: 2,
                      children: [
                    for (var i = 0; i < len; i++) ...[
                      if (i % 4 == 0 || i % 4 == 3)
                        getPhoneticElementWidget(phonetic, utils),
                      if (i % 4 == 1 || i % 4 == 2) const SizedBox.shrink(),
                    ]
                  ])),
              utils.arrowBackButton(() => GoRouter.of(context).pop())
            ],
          ),
        ));
  }

  Widget getPhoneticElementWidget(Queue<String> phonetic, Utils utils) {
    final element = phonetic.removeFirst();
    return Stack(children: [
      utils.getImage('${ui}note.png', 26, 34),
      SyllableButton(element.toUpperCase(), utils.size, 16,
          onPressed: () => utils.context?.go('/phonetic/session/$element'))
    ]);
  }
}
