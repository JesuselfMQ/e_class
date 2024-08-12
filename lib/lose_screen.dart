import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'decoration.dart';
import 'file_paths.dart';
import 'my_counter.dart';
import 'size_config.dart';
import 'utils.dart';

class LoseScreen extends StatelessWidget {
  final int score;

  final MyCounter counter;

  const LoseScreen({required this.score, required this.counter, super.key});

  @override
  Widget build(BuildContext context) {
    final size = SizeConfig(context);
    final utils = Utils(size);
    final gap = SizedBox(width: size.safeBlockHorizontal * 4);
    counter.startTimer(score);
    return FillBackground(
        background: "${background}lose.jpg",
        child: Column(
          children: [
            Expanded(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset("${points}points_blue_on.png",
                      width: size.safeBlockHorizontal * 12,
                      height: size.safeBlockVertical * 24),
                  gap,
                  ValueListenableBuilder(
                    valueListenable: counter.counter,
                    builder: (context, value, child) => Text("Puntos: $value",
                        style: TextStyle(
                          fontSize: size.safeBlockHorizontal * 10,
                          fontFamily: 'Ginthul',
                        )),
                  )
                ],
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: utils.getArrowBackButton(() => context.go('/')),
            )
          ],
        ));
  }
}
