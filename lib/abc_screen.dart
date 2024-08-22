import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'decoration.dart';
import 'phonetic_data.dart';
import 'utils.dart';
import 'scroll_behavior.dart';
import 'size_config.dart';

class AbecedaryScreen extends StatelessWidget with PhoneticData {
  const AbecedaryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final size = SizeConfig(context);
    final utils = Utils(size, context);
    final ScrollController controller = ScrollController();
    const len = 98;
    return FillBackground(
        backgroundFile: "selection.jpg",
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
                        utils.getPhoneticElementWidget(),
                      if (i % 4 == 1 || i % 4 == 2) const SizedBox.shrink(),
                    ]
                  ])),
              utils.getArrowBackButton(() => GoRouter.of(context).pop())
            ],
          ),
        ));
  }
}
