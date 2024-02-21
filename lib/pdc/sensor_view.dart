import 'dart:math' as math;
import 'package:flutter/cupertino.dart';

class SensorView extends StatefulWidget {
  const SensorView({super.key});

  @override
  State<SensorView> createState() => _SensorViewState();
}

class _SensorViewState extends State<SensorView> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Transform.rotate(
                angle: math.pi / 4,
                origin: Offset(-50, 60),
                child: Icon(
                  CupertinoIcons.radiowaves_left,
                  size: 150,
                ),
              ),
              Transform.rotate(
                angle: math.pi / 2,
                origin: Offset(-15, 0),
                child: Icon(
                  CupertinoIcons.radiowaves_left,
                  size: 150,
                ),
              ),
              Transform.rotate(
                angle: 3 * math.pi / 4,
                origin: Offset(-38, 12),
                child: Icon(
                  CupertinoIcons.radiowaves_left,
                  size: 150,
                ),
              )
            ],
          ),
          Image.asset(
            'assets/images/top_view.png',
            scale: 2.5,
          )
        ],
      ),
    );
  }
}
