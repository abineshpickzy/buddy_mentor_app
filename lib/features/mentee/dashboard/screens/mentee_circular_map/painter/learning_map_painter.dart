import 'dart:math';
import 'package:buddymentor/core/constants/app_colors.dart';
import 'package:flutter/material.dart';
import '../models/learning_map_models.dart';


class LearningMapPainter extends CustomPainter {
  final Subject subject;

  LearningMapPainter(this.subject);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final maxRadius = min(size.width, size.height) / 2;

    final centerRadius = maxRadius * 0.25;
    final moduleInnerRadius = centerRadius + 5;
    final moduleOuterRadius = maxRadius * 0.70;

    final chapterInnerRadius = moduleOuterRadius + 5;
    final chapterOuterRadius = maxRadius * 1.10;

    final paint = Paint()..style = PaintingStyle.fill;

    // Enhanced stroke paint with softer appearance
    final strokePaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 1.5
      ..color = Colors.white.withOpacity(0.3);

    // Shadow paint for depth
    final shadowPaint = Paint()
      ..style = PaintingStyle.fill
      ..color = Colors.black.withOpacity(0.1)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);

    /// CENTER SUBJECT with gradient and shadow
    // Draw shadow first
    canvas.drawCircle(center.translate(2, 2), centerRadius, shadowPaint);
    
    // Create gradient for center
    final centerGradient = RadialGradient(
      colors: [Colors.grey.shade50, Colors.grey.shade200],
      stops: const [0.0, 1.0],
    );
    
    paint.shader = centerGradient.createShader(
      Rect.fromCircle(center: center, radius: centerRadius),
    );
    
    canvas.drawCircle(center, centerRadius, paint);
    
    // Subtle border for center
    final centerBorderPaint = Paint()
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2
      ..color = Colors.grey.shade500;
    canvas.drawCircle(center, centerRadius, centerBorderPaint);

    final textPainter = TextPainter(
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
    );

    textPainter.layout(maxWidth: centerRadius * 1.5);

    textPainter.paint(
      canvas,
      center - Offset(textPainter.width / 2, textPainter.height / 2),
    );

    /// MODULE RING with brand colors
    final moduleSweep = (2 * pi) / subject.modules.length;
    final moduleGap = 0.01;
    final actualModuleSweep = moduleSweep - moduleGap;

    for (int i = 0; i < subject.modules.length; i++) {
      final startAngle = i * moduleSweep + moduleGap / 2;
      final module = subject.modules[i];
      
      // Secondary theme color for modules
      final moduleColor = AppColors.secondary;
      
      // Create gradient for module
      final moduleGradient = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          moduleColor,
          moduleColor.withOpacity(0.8),
        ],
      );
      
      final modulePath = Path()
        ..arcTo(
          Rect.fromCircle(center: center, radius: moduleOuterRadius),
          startAngle,
          actualModuleSweep,
          false,
        )
        ..arcTo(
          Rect.fromCircle(center: center, radius: moduleInnerRadius),
          startAngle + actualModuleSweep,
          -actualModuleSweep,
          false,
        )
        ..close();

      // Draw module shadow
      final moduleShadowPath = Path()
        ..arcTo(
          Rect.fromCircle(center: center.translate(1, 1), radius: moduleOuterRadius),
          startAngle,
          actualModuleSweep,
          false,
        )
        ..arcTo(
          Rect.fromCircle(center: center.translate(1, 1), radius: moduleInnerRadius),
          startAngle + actualModuleSweep,
          -actualModuleSweep,
          false,
        )
        ..close();
      
      canvas.drawPath(moduleShadowPath, shadowPaint);
      
      // Apply gradient to paint
      paint.shader = moduleGradient.createShader(
        Rect.fromCircle(center: center, radius: moduleOuterRadius),
      );
      
      canvas.drawPath(modulePath, paint);
      canvas.drawPath(modulePath, strokePaint);

      /// MODULE TEXT with better typography
      final midAngle = startAngle + actualModuleSweep / 2;
      final textRadius = (moduleInnerRadius + moduleOuterRadius) / 2;

      final textOffset = Offset(
        center.dx + cos(midAngle) * textRadius,
        center.dy + sin(midAngle) * textRadius,
      );

      final moduleText = TextPainter(
        text: TextSpan(
          text: module.moduleName,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
            fontSize: 9,
            letterSpacing: 0.3,
          ),
        ),
        textDirection: TextDirection.ltr,
        textAlign: TextAlign.center,
      );

      moduleText.layout(maxWidth: 70);

      canvas.save();
      canvas.translate(textOffset.dx, textOffset.dy);

      double textAngle = midAngle;

      if (textAngle > pi / 2 && textAngle < 3 * pi / 2) {
        textAngle += pi;
      }

      canvas.rotate(textAngle);

      moduleText.paint(
        canvas,
        Offset(-moduleText.width / 2, -moduleText.height / 2),
      );

      canvas.restore();

      /// CHAPTERS with complementary color
      final chapterSweep = actualModuleSweep / module.chapters.length;
      
      // Primary theme color for chapters
      final chapterColor = AppColors.primary;
      final chapterGradient = LinearGradient(
        begin: Alignment.centerLeft,
        end: Alignment.centerRight,
        colors: [
          chapterColor,
          chapterColor.withOpacity(0.9),
        ],
      );

      for (int j = 0; j < module.chapters.length; j++) {
        final chapterStart = startAngle + j * chapterSweep;
        final chapter = module.chapters[j];

        final chapterPath = Path()
          ..arcTo(
            Rect.fromCircle(center: center, radius: chapterOuterRadius),
            chapterStart,
            chapterSweep,
            false,
          )
          ..arcTo(
            Rect.fromCircle(center: center, radius: chapterInnerRadius),
            chapterStart + chapterSweep,
            -chapterSweep,
            false,
          )
          ..close();

        // Apply chapter gradient
        paint.shader = chapterGradient.createShader(
          Rect.fromCircle(center: center, radius: chapterOuterRadius),
        );
        
        canvas.drawPath(chapterPath, paint);

        /// CHAPTER TEXT with improved readability
        if (chapterSweep > 0.05) {
          final chapterMidAngle = chapterStart + chapterSweep / 2;
          final chapterTextRadius = (chapterInnerRadius + chapterOuterRadius) / 2;

          final chapterTextOffset = Offset(
            center.dx + cos(chapterMidAngle) * chapterTextRadius,
            center.dy + sin(chapterMidAngle) * chapterTextRadius,
          );

          final chapterText = TextPainter(
            text: TextSpan(
              text: chapter.title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w500,
                fontSize: 7,
                letterSpacing: 0.2,
              ),
            ),
            textDirection: TextDirection.ltr,
            textAlign: TextAlign.center,
          );

          chapterText.layout(maxWidth: 50);

          canvas.save();
          canvas.translate(chapterTextOffset.dx, chapterTextOffset.dy);

          double chapterTextAngle = chapterMidAngle;
          if (chapterTextAngle > pi / 2 && chapterTextAngle < 3 * pi / 2) {
            chapterTextAngle += pi;
          }

          canvas.rotate(chapterTextAngle);

          chapterText.paint(
            canvas,
            Offset(-chapterText.width / 2, -chapterText.height / 2),
          );

          canvas.restore();
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}