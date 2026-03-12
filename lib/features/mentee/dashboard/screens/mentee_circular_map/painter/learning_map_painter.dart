import 'dart:math';
import 'package:buddymentor/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import '../models/learning_map_models.dart';

class LearningMapPainter extends CustomPainter {
  final Subject subject;
  final double rotationAngle;
  final double expandProgress;
  final int selectedModuleIndex;

  LearningMapPainter(
    this.subject, {
    this.rotationAngle = 0.0,
    this.expandProgress = 0.0,
    this.selectedModuleIndex = -1,
  });

  static const double _expandedRadiusScale = 1.2;
  static const double _shrunkRadiusScale   = 0.85;
  static const double _expandedSweepBonus  = 0.55;
  static const double _centerExpandScale   = 1.15;

  // 2px padding so at peak expansion (×1.2) the ring stays inside canvas:
  // safeOuter × 1.2 = maxRadius − 2  ✓
  static const double _padding = 2.0;

  double _safeOuter(double maxRadius) =>
      (maxRadius - _padding) / _expandedRadiusScale;

  @override
  void paint(Canvas canvas, Size size) {
    final center    = Offset(size.width / 2, size.height / 2);
    final maxRadius = min(size.width, size.height) / 2;

    final double safeOuter = _safeOuter(maxRadius);

    final double baseCenterRadius    = safeOuter * 0.22;
    final double baseModuleOuter     = safeOuter * 0.60;
    final double baseChapterOuter    = safeOuter;

    final double centerRadius =
        baseCenterRadius * (1.0 + expandProgress * (_centerExpandScale - 1.0));
    final double moduleInnerRadius = centerRadius + 5;

    final paint = Paint()..style = PaintingStyle.fill;

    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = Colors.white.withOpacity(0.1);

    final shadowPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.black.withOpacity(0.1)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    final int n            = subject.modules.length;
    final double baseSweep = (2 * pi) / n;
    const double gap       = 0.01;

    List<double> sweeps = List.filled(n, 0);
    if (selectedModuleIndex == -1 || expandProgress == 0.0) {
      for (int i = 0; i < n; i++) sweeps[i] = baseSweep - gap;
    } else {
      final bonus  = _expandedSweepBonus * expandProgress;
      final shrink = bonus / (n - 1);
      for (int i = 0; i < n; i++) {
        sweeps[i] = (i == selectedModuleIndex)
            ? baseSweep - gap + bonus
            : baseSweep - gap - shrink;
      }
    }

    List<double> startAngles = List.filled(n, 0);
    startAngles[0] = gap / 2;
    for (int i = 1; i < n; i++) {
      startAngles[i] = startAngles[i - 1] + sweeps[i - 1] + gap;
    }

    // ── ROTATABLE LAYER ──────────────────────────────────────────
    canvas.save();
    canvas.translate(center.dx, center.dy);
    canvas.rotate(rotationAngle);
    canvas.translate(-center.dx, -center.dy);

    for (int i = 0; i < n; i++) {
      final module     = subject.modules[i];
      final startAngle = startAngles[i];
      final sweep      = sweeps[i];

      final bool isSelected   = i == selectedModuleIndex;
      final bool hasSelection = selectedModuleIndex != -1;

      double radiusScale = 1.0;
      if (hasSelection && expandProgress > 0) {
        radiusScale = isSelected
            ? 1.0 + expandProgress * (_expandedRadiusScale - 1.0)
            : 1.0 + expandProgress * (_shrunkRadiusScale - 1.0);
      }

      final moduleOuterRadius  = baseModuleOuter  * radiusScale;
      final chapterOuterRadius = baseChapterOuter * radiusScale;
      final chapterInnerRadius = moduleOuterRadius + 5;

      final double opacity = _o(
          (hasSelection && !isSelected) ? 1.0 - expandProgress * 0.4 : 1.0);

      // MODULE arc
      final modulePath = _arcPath(
          center, moduleInnerRadius, moduleOuterRadius, startAngle, sweep);

      canvas.drawPath(
        _arcPath(center.translate(1, 1), moduleInnerRadius,
            moduleOuterRadius, startAngle, sweep),
        shadowPaint,
      );

      paint.shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          AppColors.secondary.withOpacity(opacity),
          AppColors.secondary.withOpacity(opacity * 0.8),
        ],
      ).createShader(
          Rect.fromCircle(center: center, radius: moduleOuterRadius));
      canvas.drawPath(modulePath, paint);
      canvas.drawPath(modulePath, strokePaint);

      if (isSelected && expandProgress > 0) {
        canvas.drawPath(
          modulePath,
          Paint()
            ..style = PaintingStyle.stroke
            ..strokeWidth = 2.5 * expandProgress
            ..color = Colors.white.withOpacity(_o(0.6 * expandProgress)),
        );
      }

      // MODULE text
      _drawRotatedText(
        canvas: canvas,
        text: module.moduleName,
        center: center,
        radius: (moduleInnerRadius + moduleOuterRadius) / 2,
        angle: startAngle + sweep / 2,
        fontSize: (isSelected
                ? 9.0 + expandProgress * 3.0
                : 9.0 - expandProgress * 2.0)
            .clamp(5.0, 14.0),
        opacity: opacity,
        maxWidth: isSelected ? 90 : 60,
        isSelected: isSelected,
        expandProgress: expandProgress,
      );

      // CHAPTER radial bands
      final int chCount = module.chapters.length;
      if (chCount == 0) continue;

      final double chOpacity = _o(
          (hasSelection && !isSelected) ? 1.0 - expandProgress * 0.5 : 1.0);

      final double zoneWidth = chapterOuterRadius - chapterInnerRadius;
      final double bandWidth = zoneWidth / chCount;

      for (int j = 0; j < chCount; j++) {
        final double bandInner = chapterInnerRadius + j * bandWidth;
        final double bandOuter = bandInner + bandWidth;
        final chapter          = module.chapters[j];

        final bandPath =
            _arcPath(center, bandInner, bandOuter, startAngle, sweep);

        paint.shader = null;
        paint.color  = AppColors.primary.withOpacity(chOpacity);
        canvas.drawPath(bandPath, paint);
        canvas.drawPath(bandPath, strokePaint);

        final bool showText = (isSelected && expandProgress > 0.3) ||
            (!hasSelection && bandWidth > 6);

        if (showText) {
          _drawRotatedText(
            canvas: canvas,
            text: chapter.title,
            center: center,
            radius: (bandInner + bandOuter) / 2,
            angle: startAngle + sweep / 2,
            fontSize: (isSelected ? 7.0 + expandProgress * 3.0 : 7.0)
                .clamp(4.0, 12.0),
            opacity: isSelected ? _o(expandProgress) : chOpacity,
            maxWidth: isSelected ? 65 + expandProgress * 20 : 50,
            isChapter: true,
          );
        }
      }
    }

    canvas.restore();

    // FIXED LAYER — center circle
    canvas.drawCircle(center.translate(2, 2), centerRadius, shadowPaint);

    paint.shader = RadialGradient(
      colors: [Colors.grey.shade50, Colors.grey.shade200],
    ).createShader(Rect.fromCircle(center: center, radius: centerRadius));
    canvas.drawCircle(center, centerRadius, paint);

    canvas.drawCircle(
      center,
      centerRadius,
      Paint()
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2
        ..color = Colors.grey.shade500,
    );

    final subjectPainter = TextPainter(
      text: TextSpan(
        text: subject.subject,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w900,
          color: AppColors.textDark,
          letterSpacing: 0.5,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
      maxLines: 3,
      ellipsis: '…',
    );
    subjectPainter.layout(maxWidth: centerRadius * 1.5);
    subjectPainter.paint(
      canvas,
      center - Offset(subjectPainter.width / 2, subjectPainter.height / 2),
    );
  }

  double _o(double v) => v.clamp(0.0, 1.0);

  Path _arcPath(Offset center, double inner, double outer,
      double startAngle, double sweep) {
    final outerRect  = Rect.fromCircle(center: center, radius: outer);
    final innerRect  = Rect.fromCircle(center: center, radius: inner);
    final outerStart = Offset(
      center.dx + outer * cos(startAngle),
      center.dy + outer * sin(startAngle),
    );
    final innerEnd = Offset(
      center.dx + inner * cos(startAngle + sweep),
      center.dy + inner * sin(startAngle + sweep),
    );
    final innerStart = Offset(
      center.dx + inner * cos(startAngle),
      center.dy + inner * sin(startAngle),
    );
    return Path()
      ..moveTo(outerStart.dx, outerStart.dy)
      ..arcTo(outerRect, startAngle, sweep, false)
      ..lineTo(innerEnd.dx, innerEnd.dy)
      ..arcTo(innerRect, startAngle + sweep, -sweep, false)
      ..lineTo(innerStart.dx, innerStart.dy)
      ..close();
  }

  void _drawRotatedText({
    required Canvas canvas,
    required String text,
    required Offset center,
    required double radius,
    required double angle,
    required double fontSize,
    required double opacity,
    required double maxWidth,
    bool isChapter = false,
    bool isSelected = false,
    double expandProgress = 0.0,
  }) {
    final offset = Offset(
      center.dx + cos(angle) * radius,
      center.dy + sin(angle) * radius,
    );

    final tp = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: Colors.white.withOpacity(_o(opacity)),
          fontWeight: FontWeight.w600,
          fontSize: fontSize,
          letterSpacing: 0.3,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: TextAlign.center,
      maxLines: 3,
      ellipsis: '…',
    );
    tp.layout(maxWidth: maxWidth);

    canvas.save();
    canvas.translate(offset.dx, offset.dy);

    double a;
    if (isChapter) {
      a = angle + pi / 2;
    } else if (isSelected && expandProgress > 0) {
      a = -rotationAngle;
    } else {
      a = angle;
    }

    canvas.rotate(a);
    tp.paint(canvas, Offset(-tp.width / 2, -tp.height / 2));
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant LearningMapPainter old) =>
      old.rotationAngle != rotationAngle ||
      old.expandProgress != expandProgress ||
      old.selectedModuleIndex != selectedModuleIndex ||
      old.subject != subject;
}