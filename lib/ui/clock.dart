import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:intl/intl.dart';

class Clock extends StatefulWidget {
  const Clock({super.key, required this.size});

  final double size;

  @override
  State<Clock> createState() => _ClockState();
}

class _ClockState extends State<Clock> {
  Timer? timer;
  late String formatted;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    formatted = DateFormat("EEE MMM dd  HH:mm").format(DateTime.now());
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      updateTime();
    });
  }

  void updateTime() {
    setState(() {
      formatted = DateFormat("EEE MMM dd  HH:mm").format(DateTime.now());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      formatted,
      style: TextStyle(fontSize: widget.size, fontWeight: FontWeight.bold),
    );
  }
}
