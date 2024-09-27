import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import 'confetti.dart';
import 'decoration.dart';
import 'file_paths.dart';
import 'my_counter.dart';
import 'utils.dart';

class LoseScreen extends StatelessWidget {
  final int score;

  final MyCounter counter;

  const LoseScreen({required this.score, required this.counter, super.key});

  @override
  Widget build(BuildContext context) {
    final utils = ResponsiveUtils(context);
    final gap = SizedBox(width: utils.safeBlockHorizontal * 4);
    counter.startCounter(score);
    return FillBackground(
        file: 'lose.jpg',
        child: Stack(children: [
          Column(
            children: [
              Expanded(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ValueListenableBuilder(
                      valueListenable: counter.color,
                      builder: (_, color, __) => utils.getImage(
                          '${points}points_${color}_on.png', 12, 24),
                    ),
                    gap,
                    ValueListenableBuilder(
                      valueListenable: counter.count,
                      builder: (_, count, __) => Text('Puntos: $count',
                          style: TextStyle(
                            fontSize: utils.safeBlockHorizontal * 10,
                            fontFamily: 'Ginthul',
                          )),
                    )
                  ],
                ),
              ),
              utils.arrowBackButton(() => context.go('/')),
            ],
          ),
          utils.getImage('${ui}retry.png', 15, 30,
              vertical: 0.4, onSelected: () => context.replace('/game')),
          celebration(),
        ]));
  }

  /// This is the confetti animation that is overlaid on top of the
  /// screen when the counter reaches the score value.
  Widget celebration() {
    return SizedBox.expand(
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
    );
  }
}
