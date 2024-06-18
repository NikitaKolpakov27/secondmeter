import 'dart:async';
import 'package:flutter/cupertino.dart';

class AppState {
  Timer? timer;
  Duration duration = Duration();
  bool isTimerStarted = false;

  AppState({required this.timer, required this.duration, required this.isTimerStarted});

}