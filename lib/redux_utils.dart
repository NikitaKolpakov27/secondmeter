import 'dart:async';
import 'package:secondmeter/app_state.dart';
import 'actions.dart';

AppState reducer(AppState state, dynamic action) {

  void addTime() {
    if (state.isTimerStarted) {
      final newSeconds = state.duration.inSeconds + 1;
      state.duration = Duration(seconds: newSeconds);
      state.isTimerStarted = true;
    }
  }

  if (action is Reset) {
    state.timer?.cancel();
    var newDuration = state.duration = Duration();
    var newTimerStatus = state.isTimerStarted = false;

    return AppState(timer: state.timer, duration: newDuration, isTimerStarted: newTimerStatus);

  } else if (action is Stop) {
    state.timer?.cancel();
    var newDuration = state.duration;
    var newTimerStatus = state.isTimerStarted = false;

    return AppState(timer: state.timer, duration: newDuration, isTimerStarted: newTimerStatus);

  } else if (action is Play) {
    state.timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());

    return AppState(timer: state.timer, duration: state.duration, isTimerStarted: state.isTimerStarted);
  }

  else {
    return state;
  }
}

