import 'dart:async';
import 'package:flutter/material.dart';

bool stop = false;

class Countdown extends StatefulWidget {
  const Countdown({Key? key}) : super(key: key);

  @override
  CountdownState createState() => CountdownState();
}

class CountdownState extends State<Countdown> {
  static const initTime = 60;
  int seconds = initTime;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    startTimer();
    // reset();
  }

  void startTimer() {
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (seconds > 0) {
        setState(() {
          seconds--;
        });
      } else {
        stopTimer(reset: false);
      }
    });
  }

  void stopTimer({bool reset = true}) {
    if (reset) {
      resetTimer();
    }
    timer?.cancel();
  }

  void resetTimer() {
    setState(() => seconds = initTime);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5),
      child: Container(
          color: Colors.transparent,
          height: 30,
          width: 100,
          child: Center(child: buildTime())),
    );
  }

  Widget buildTime() {
    // final seconds = twoDigits(duration.inSeconds.remainder(60));
    return Text(
      '$seconds',
      style: const TextStyle(fontSize: 25, color: Colors.white),
    );
  }
}
