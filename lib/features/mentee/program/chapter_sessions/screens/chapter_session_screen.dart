import 'dart:math';
import 'package:flutter/material.dart';
import 'package:buddymentor/core/constants/app_colors.dart';

class ChapterSessions extends StatelessWidget {
  const ChapterSessions({super.key});

  final List<Map<String, dynamic>> sessions = const [
    {"title": "Pep Talk", "color": Color(0xff4B6F67), "status": "locked"},
    {"title": "Session Title", "color": Color(0xff6B4F6B), "status": "locked"},
    {"title": "Standard & Practice", "color": Color(0xff4A7E99), "status": "locked"},
    {"title": "Lessons Learnt", "color": Color(0xffA9D0C9), "status": "inprogress"},
    {"title": "Drill", "color": Color(0xffB89C45), "status": "pending"},
    {"title": "Science & Math", "color": Color(0xffCDBBD9), "status": "inprogress"},
    {"title": "Curiosity Seeker", "color": Color(0xff4D88A5), "status": "locked"},
    {"title": "Tech Diary", "color": Color(0xff9B4F7F), "status": "locked"},
  ];

  void _handleTap(TapDownDetails details, BuildContext context) {
    const center = Offset(160, 160);
    final tapOffset = details.localPosition - center;
    final distance = tapOffset.distance;

    if (distance > 56 && distance < 160) {
      final angle = (atan2(tapOffset.dy, tapOffset.dx) + pi / 2) % (2 * pi);
      final sectionIndex = (angle / (2 * pi / sessions.length)).floor();
      final tapped = sessions[sectionIndex];

      if (tapped["status"] == "locked") {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${tapped["title"]} is locked'),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 1),
          ),
        );
        return;
      }

      // TODO: navigate to session
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Opening: ${tapped["title"]}'),
          behavior: SnackBarBehavior.floating,
          duration: const Duration(seconds: 1),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left, color: Colors.black87, size: 28),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title:  Text(
          'Learning Map',
          style: Theme.of(context).textTheme.headlineMedium?.copyWith(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              
          )
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),

          const Text(
            'Tap a segment to explore your program',
            style: TextStyle(color: Colors.grey, fontSize: 13),
          ),

          const SizedBox(height: 100),

          // ── Wheel ─────────────────────────────────────────────────
          Center(
            child: GestureDetector(
              onTapDown: (details) => _handleTap(details, context),
              child: CustomPaint(
                size: const Size(320, 320),
                painter: LearningMapPainter(sessions),
              ),
            ),
          ),

          const SizedBox(height: 32),

          // ── Legend ────────────────────────────────────────────────
          _buildLegend(),

          const SizedBox(height: 24),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20),
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 10,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            _legendItem(Colors.green, 'Done'),
            _legendItem(Colors.blue, 'In Progress'),
            _legendItem(Colors.orange, 'Pending'),
            _legendItem(Colors.grey.shade400, 'Locked'),
          ],
        ),
      ),
    );
  }

  Widget _legendItem(Color color, String text) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(text, style: const TextStyle(fontSize: 12, color: Colors.black87)),
      ],
    );
  }
}

class LearningMapPainter extends CustomPainter {
  final List<Map<String, dynamic>> sessions;

  LearningMapPainter(this.sessions);

  // Returns the effective color based on status
  Color _effectiveColor(Map<String, dynamic> session) {
    final status = session["status"] as String;
    final base = session["color"] as Color;
    if (status == "locked") {
      // Desaturate to grey-ish
      return Color.lerp(base, Colors.grey.shade400, 0.65)!;
    }
    if (status == "completed") return Colors.green.shade400;
    if (status == "inprogress") return base;
    if (status == "pending") return Color.lerp(base, Colors.orange, 0.4)!;
    return base;
  }

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2;
    final innerRadius = radius * 0.35;
    final sweep = 2 * pi / sessions.length;
    const gapAngle = 0.025; // gap between segments

    final rect = Rect.fromCircle(center: center, radius: radius);

    for (int i = 0; i < sessions.length; i++) {
      final startAngle = -pi / 2 + (sweep * i) + gapAngle / 2;
      final sweepAngle = sweep - gapAngle;

      final color = _effectiveColor(sessions[i]);

      final paint = Paint()
        ..color = color
        ..style = PaintingStyle.fill;

      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..arcTo(rect, startAngle, sweepAngle, false)
        ..close();

      canvas.drawPath(path, paint);

      // Status icon overlay for locked
      final status = sessions[i]["status"] as String;
      final midAngle = startAngle + sweepAngle / 2;
      final textRadius = radius * 0.68;
      final iconOffset = Offset(
        center.dx + textRadius * cos(midAngle),
        center.dy + textRadius * sin(midAngle),
      );

      // Draw label
      _drawLabel(canvas, sessions[i]["title"] as String, iconOffset, status);
    }

    // ── Inner white circle ─────────────────────────────────────
    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.08)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(center, innerRadius + 2, shadowPaint);

    final innerPaint = Paint()..color = Colors.white;
    canvas.drawCircle(center, innerRadius, innerPaint);

    // Center label
    _drawCenterText(canvas, center, 'Chapter Name');
  }

  void _drawLabel(Canvas canvas, String text, Offset center, String status) {
    final isLocked = status == 'locked';

    // Lock icon for locked segments
    if (isLocked) {
      final iconPainter = TextPainter(
        text: const TextSpan(
          text: '🔒',
          style: TextStyle(fontSize: 12),
        ),
        textDirection: TextDirection.ltr,
      );
      iconPainter.layout();
      iconPainter.paint(
        canvas,
        Offset(center.dx - iconPainter.width / 2,
            center.dy - iconPainter.height / 2 - 8),
      );
    }

    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w600,
          color: isLocked ? Colors.white60 : Colors.white,
          shadows: const [
            Shadow(
              color: Colors.black26,
              blurRadius: 3,
              offset: Offset(0, 1),
            ),
          ],
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(maxWidth: 72);

    final offset = Offset(
      center.dx - textPainter.width / 2,
      center.dy - textPainter.height / 2 + (isLocked ? 8 : 0),
    );

    textPainter.paint(canvas, offset);
  }

  void _drawCenterText(Canvas canvas, Offset center, String text) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Color(0xFF2D4383),
          height: 1.3,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );
    textPainter.layout(maxWidth: 80);
    textPainter.paint(
      canvas,
      Offset(
        center.dx - textPainter.width / 2,
        center.dy - textPainter.height / 2,
      ),
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}