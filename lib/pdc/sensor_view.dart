import 'package:flutter/cupertino.dart';
import 'package:flutter_head_unit/pdc/radio.dart';

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
          const SizedBox(height: 150),
          CustomPaint(
            painter: OpenPainter(),
          ),
          Image.asset(
            'assets/images/top_view.png',
            scale: 4,
          )
        ],
      ),
    );
  }
}
