import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';

class DashedContainer extends StatelessWidget {
  final Widget child;
  final double strokeWidth;
  final Color color;
  final List<double> dashPattern;
  final double borderRadius;

  const DashedContainer({
    super.key,
    required this.child,
    this.strokeWidth = 1,
    this.color = Colors.black,
    this.dashPattern = const [5, 5],
    this.borderRadius = 0,
  });

  @override
  Widget build(BuildContext context) {
    return CustomPaint(
      painter: _DashedPainter(
        strokeWidth: strokeWidth,
        color: color,
        dashPattern: dashPattern,
        borderRadius: borderRadius,
      ),
      child: child,
    );
  }
}

class _DashedPainter extends CustomPainter {
  final double strokeWidth;
  final Color color;
  final List<double> dashPattern;
  final double borderRadius;

  _DashedPainter({
    required this.strokeWidth,
    required this.color,
    required this.dashPattern,
    required this.borderRadius,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..style = PaintingStyle.stroke;

    final RRect rrect = RRect.fromLTRBR(
      strokeWidth / 2,
      strokeWidth / 2,
      size.width - strokeWidth / 2,
      size.height - strokeWidth / 2,
      Radius.circular(borderRadius),
    );

    final Path path = Path()..addRRect(rrect);

    for (final PathMetric metric in path.computeMetrics()) {
      double distance = 0.0;
      bool draw = true;
      int i = 0;
      while (distance < metric.length) {
        final double len = dashPattern[i % dashPattern.length];
        if (draw) {
          canvas.drawPath(
            metric.extractPath(distance, min(distance + len, metric.length)),
            paint,
          );
        }
        distance += len;
        draw = !draw;
        i++;
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
