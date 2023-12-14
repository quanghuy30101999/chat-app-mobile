import 'dart:async';

import 'package:flutter/material.dart';

// ignore: must_be_immutable
class TimerWidget extends StatefulWidget {
  DateTime lastActive;
  TimerWidget({super.key, required this.lastActive});

  @override
  State<TimerWidget> createState() => _TimerWidgetState();
}

class _TimerWidgetState extends State<TimerWidget> {
  int minutes = 100;
  late Timer myTimer;
  int getTimeDifference() {
    DateTime currentTime = DateTime.now();
    Duration difference = currentTime.difference(widget.lastActive);
    int minutes = difference.inMinutes;
    return minutes;
  }

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  void _startTimer() {
    const oneSec = Duration(seconds: 1);
    myTimer = Timer.periodic(oneSec, (timer) {
      setState(() {
        minutes = getTimeDifference();
      });
    });
  }

  @override
  void dispose() {
    myTimer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (minutes < 60 && minutes > 0) {
      return Positioned(
        bottom: 0,
        right: 0,
        left: 5,
        child: Stack(
          children: [
            Container(
              height: 16,
              width: 60,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 210, 235, 210),
                border: Border.all(color: Colors.white, width: 2),
                borderRadius: const BorderRadius.all(Radius.circular(9.0)),
              ),
            ),
            Positioned(
              left: 4,
              top: -1.5,
              child: Text(
                "$minutes phút",
                style: const TextStyle(
                  fontSize: 12.5,
                  color: Colors.green,
                ),
              ),
            )
          ],
        ),
      );
    }
    if (minutes == 0) {
      return Positioned(
        bottom: 0,
        right: 0,
        child: Container(
          width: 15,
          height: 15,
          decoration: BoxDecoration(
            color: Colors.green,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
        ),
      );
    }
    return Container();
  }
}
