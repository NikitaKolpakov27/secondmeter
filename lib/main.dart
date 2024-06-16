import 'dart:async';
import 'dart:ffi';

import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
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
                  onPressed: startTimer,
                  child: const Icon(Icons.play_arrow),
                ),

                FloatingActionButton(
                  onPressed: resetTimer,
                  child: const Icon(Icons.lock_reset),
                ),

                FloatingActionButton(
                  onPressed: stopTimer,
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
