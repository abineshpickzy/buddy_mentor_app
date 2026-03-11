import 'dart:math';
import 'package:flutter/material.dart';
import '../models/learning_map_models.dart';
import '../painter/learning_map_painter.dart';

class LearningMapWidget extends StatefulWidget {
  final Subject subject;
  final Function(Chapter, Module) onChapterTap;

  const LearningMapWidget({
    super.key,
    required this.subject,
    required this.onChapterTap,
  });

  @override
  State<LearningMapWidget> createState() => _LearningMapWidgetState();
}

class _LearningMapWidgetState extends State<LearningMapWidget> {
  Size? canvasSize;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final size =
            min(constraints.maxWidth, constraints.maxHeight) * 0.95;

        canvasSize = Size(size, size);

        return GestureDetector(
          onTapUp: (details) {
            _detectTap(details.localPosition);
          },
          child: CustomPaint(
            size: canvasSize!,
            painter: LearningMapPainter(widget.subject),
          ),
        );
      },
    );
  }

  void _detectTap(Offset position) {
    if (canvasSize == null) return;

    final center = Offset(canvasSize!.width / 2, canvasSize!.height / 2);
    final maxRadius = min(canvasSize!.width, canvasSize!.height) / 2;
    
    final moduleInnerRadius = maxRadius * 0.25 + 8;
    final moduleOuterRadius = maxRadius * 0.65;
    final chapterInnerRadius = moduleOuterRadius + 5;
    final chapterOuterRadius = maxRadius * 0.95;

    final dx = position.dx - center.dx;
    final dy = position.dy - center.dy;

    final distance = sqrt(dx * dx + dy * dy);
    final angle = (atan2(dy, dx) + 2 * pi) % (2 * pi);

    final moduleSweep = (2 * pi) / widget.subject.modules.length;
    final moduleIndex = (angle / moduleSweep).floor();

    if (moduleIndex < 0 || moduleIndex >= widget.subject.modules.length) return;

    final module = widget.subject.modules[moduleIndex];

    // Check if tap is in chapter area (outer ring)
    if (distance >= chapterInnerRadius && distance <= chapterOuterRadius) {
      final chapterSweep = moduleSweep / module.chapters.length;
      final localAngle = angle - moduleIndex * moduleSweep;
      final chapterIndex = (localAngle / chapterSweep).floor();

      if (chapterIndex < module.chapters.length) {
        widget.onChapterTap(module.chapters[chapterIndex], module);
      }
    }
    // If tap is in module area, don't trigger callback (or add module callback if needed)
  }
}