import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'confetti.dart';
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
    counter.startCounter(score);
    return FillBackground(
        file: "lose.jpg",
        child: Stack(children: [
          Column(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ValueListenableBuilder(
                      valueListenable: counter.color,
                      builder: (_, color, __) => Image.asset(
                          "${points}points_${color}_on.png",
                          width: size.safeBlockHorizontal * 12,
                          height: size.safeBlockVertical * 24),
                    ),
                    gap,
                    ValueListenableBuilder(
                      valueListenable: counter.counter,
                      builder: (_, value, __) => Text("Puntos: $value",
                          style: TextStyle(
                            fontSize: size.safeBlockHorizontal * 10,
                            fontFamily: 'Ginthul',
                          )),
                    )
                  ],
                ),
              ),
              utils.arrowBackButton(() => context.go('/')),
            ],
          ),
          Align(
              alignment: const Alignment(0, 0.4),
              child: IconButton(
                  onPressed: () => context.replace('/game'),
                  icon: Image.asset("${ui}retry.png",
                      width: size.safeBlockHorizontal * 15,
                      height: size.safeBlockVertical * 30))),
          // This is the confetti animation that is overlaid on top of the
          // screen when the counter reaches the score value.
          SizedBox.expand(
            child: ValueListenableBuilder(
              valueListenable: counter.hasFinished,
              builder: (_, value, child) => Visibility(
                visible: value,
                child: IgnorePointer(
                  child: Confetti(
                    isStopped: !value,
                  ),
                ),
              ),
            ),
          ),
        ]));
  }
}
