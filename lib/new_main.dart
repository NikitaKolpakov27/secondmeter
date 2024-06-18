import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:redux/redux.dart';
import 'package:secondmeter/actions.dart';
import 'package:secondmeter/redux_utils.dart';

import 'app_state.dart';

void main() {
  final Store<AppState> store = Store(reducer, initialState:
      AppState(timer: null, duration: Duration(), isTimerStarted: false)
  );

  runApp(StoreProvider(store: store, child: const MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  Timer? timer;
  Duration duration = Duration();
  bool isTimerStarted = false;


  @override
  void initState() {
    super.initState();
  }

  void addTime() {

    if (isTimerStarted) {
      const addSeconds = 1;
      setState(() {
        final newSeconds = duration.inSeconds + addSeconds;
        duration = Duration(seconds: newSeconds);
        isTimerStarted = true;
      });
    }

  }

  void stopTimer() {
    timer?.cancel();
    setState(() {
      isTimerStarted = false;
    });
  }

  void resetTimer() {
    timer?.cancel();
    setState(() {
      duration = Duration();
      isTimerStarted = false;
    });
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) => addTime());
  }

  // Форматирование времени (после 60 секунд идут минуты)
  Widget formatTime() {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));

    return Text(
      '$minutes:$seconds',
      style: const TextStyle(fontSize: 32),
    );
  }

  @override
  Widget build(BuildContext context) {
    final Store<AppState> store = StoreProvider.of<AppState>(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              'Секундометр',
              style: TextStyle(fontSize: 35),
            ),
            const Divider(
              endIndent: double.infinity,
            ),
            formatTime(),

            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FloatingActionButton(
                  onPressed: store.dispatch(Play()),
                  child: const Icon(Icons.play_arrow),
                ),
                
                StoreConnector<AppState, AppState>(
                    converter: (store) => store.state,
                    builder: (context, vm) => Text('new duration: ${store.state.duration}'),
                ),

                FloatingActionButton(
                  onPressed: store.dispatch(Reset()),
                  child: const Icon(Icons.lock_reset),
                ),

                FloatingActionButton(
                  onPressed: store.dispatch(Stop()),
                  child: const Icon(Icons.stop),
                ),
              ],
            )
          ],
        ),
      ),
    );
  }
}
