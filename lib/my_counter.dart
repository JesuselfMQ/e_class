import 'dart:async';

import 'package:flutter/material.dart';

class MyCounter {
  ValueNotifier<int> counter = ValueNotifier<int>(0);
  Timer? _timer;

  void startTimer(int targetValue) {
    Timer(const Duration(milliseconds: 500), () {
      _timer = Timer.periodic(const Duration(milliseconds: 150), (timer) {
        if (counter.value < targetValue) {
          counter.value++;
        } else {
          _timer?.cancel();
        }
      });
    });
  }
}
