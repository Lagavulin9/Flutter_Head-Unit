import 'dart:math' as math;
import 'package:flutter/material.dart';

class OpenPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    var setProperties = [
      {
        'startAngle': -4 * math.pi / 24,
        'sweepAngle': -4 * math.pi / 24,
      },
      {
        'startAngle': -9 * math.pi / 24,
        'sweepAngle': -6 * math.pi / 24,
      },
      {
        'startAngle': -16 * math.pi / 24,
        'sweepAngle': -4 * math.pi / 24,
      },
    ];

    for (var setProps in setProperties) {
      const factor = 3.0;
      final sizes = [100, 75, 50].map((e) => e * factor).toList();
      final offsets = List.generate(sizes.length, (index) => -sizes[index] / 2);
      final offsetsAndSizes = List.generate(
          sizes.length,
          (index) =>
              Offset(offsets[index], offsets[index]) &
              Size(sizes[index], sizes[index]));
      for (int i = 0; i < offsetsAndSizes.length; i++) {
        canvas.drawArc(
          offsetsAndSizes[i],
          setProps['startAngle']!,
          setProps['sweepAngle']!,
          false,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 5 * factor
            ..color = Colors.amber,
        );
      }
    }

    // canvas.drawArc(Offset(-50, -50) & Size(100, 100), -4 * math.pi / 24,
    //     -4 * math.pi / 24, false, paint1);
    // canvas.drawArc(Offset(-37.5, -37.5) & Size(75, 75), -4 * math.pi / 24,
    //     -4 * math.pi / 24, false, paint1);
    // canvas.drawArc(Offset(-25, -25) & Size(50, 50), -4 * math.pi / 24,
    //     -4 * math.pi / 24, false, paint2);

    // canvas.drawArc(Offset(-50, -50) & Size(100, 100), -9 * math.pi / 24,
    //     -6 * math.pi / 24, false, paint2);
    // canvas.drawArc(Offset(-37.5, -37.5) & Size(75, 75), -9 * math.pi / 24,
    //     -6 * math.pi / 24, false, paint2);
    // canvas.drawArc(Offset(-25, -25) & Size(50, 50), -9 * math.pi / 24,
    //     -6 * math.pi / 24, false, paint1);

    // canvas.drawArc(Offset(-50, -50) & Size(100, 100), -16 * math.pi / 24,
    //     -4 * math.pi / 24, false, paint1);
    // canvas.drawArc(Offset(-37.5, -37.5) & Size(75, 75), -16 * math.pi / 24,
    //     -4 * math.pi / 24, false, paint1);
    // canvas.drawArc(Offset(-25, -25) & Size(50, 50), -16 * math.pi / 24,
    //     -4 * math.pi / 24, false, paint2);
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => true;
}
