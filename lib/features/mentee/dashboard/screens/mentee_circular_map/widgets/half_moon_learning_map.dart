import 'dart:math';
import 'package:flutter/material.dart';
import '../models/learning_item.dart';

class HalfMoonLearningMap extends StatelessWidget {
  final List<LearningItem> items;

  const HalfMoonLearningMap({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 200,
      child: CustomPaint(
        painter: _HalfMoonPainter(items),
      ),
    );
  }
}

class _HalfMoonPainter extends CustomPainter {
  final List<LearningItem> items;

  _HalfMoonPainter(this.items);

  @override
  void paint(Canvas canvas, Size size) {
    // 🔹 Reduce radius slightly to give left/right padding
    final radius = size.width * 0.42;
    final center = Offset(size.width / 2, size.height);

    final total = items.length;
    final sweepAngle = pi / total;

    for (int i = 0; i < total; i++) {
      final startAngle = pi + (i * sweepAngle);

      final rect = Rect.fromCircle(center: center, radius: radius);

      final fillPaint = Paint()
        ..color = items[i].color
        ..style = PaintingStyle.fill;

      // Draw slice
      canvas.drawArc(
        rect,
        startAngle,
        sweepAngle,
        true,
        fillPaint,
      );

      // Draw white divider stroke
      final borderPaint = Paint()
        ..color = Colors.white
        ..strokeWidth = 1.5
        ..style = PaintingStyle.stroke;

      canvas.drawArc(
        rect,
        startAngle,
        sweepAngle,
        true,
        borderPaint,
      );

      // Draw wrapped text inside slice
      _drawWrappedRotatedText(
        canvas,
        items[i].title,
        startAngle + sweepAngle / 2,
        radius * 0.75, // move text closer to edge
        sweepAngle,
        center,
      );
    }

    // 🔹 Center circle
    final centerPaint = Paint()
      ..color = const Color(0xFF5DBB9D);

    canvas.drawCircle(center, 16, centerPaint);
  }

  void _drawWrappedRotatedText(
    Canvas canvas,
    String text,
    double angle,
    double textRadius,
    double sweepAngle,
    Offset center,
  ) {
    // Calculate available width for text in the slice
    final availableWidth = textRadius * sweepAngle * 0.8;
    
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 10,
          fontWeight: FontWeight.w600,
          height: 1.1,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
      maxLines: 2,
    );

    textPainter.layout(maxWidth: availableWidth);

    // Position text in the middle of the slice
    final textPosition = Offset(
      center.dx + textRadius * cos(angle),
      center.dy + textRadius * sin(angle),
    );

    canvas.save();
    canvas.translate(textPosition.dx, textPosition.dy);
    
    // Rotate text to follow slice angle
    double textRotation = angle + pi / 2;
    
    // Adjust rotation for better readability on left side
    // if (angle > pi * 1.5) {
    //   textRotation += pi;
    // }
    
    canvas.rotate(textRotation);

    // Center the text perfectly
    textPainter.paint(
      canvas,
      Offset(
        -textPainter.width / 2,
        -textPainter.height / 1,
      ),
    );

    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
