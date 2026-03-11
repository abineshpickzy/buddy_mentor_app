import 'dart:math';
import 'package:flutter/material.dart';

class ChapterSessions extends StatelessWidget {
  const ChapterSessions({super.key});

  void _handleTap(TapDownDetails details, List sessions) {
    final center = const Offset(160, 160);
    final tapOffset = details.localPosition - center;
    final distance = tapOffset.distance;
    
    if (distance > 56 && distance < 160) {
      final angle = (atan2(tapOffset.dy, tapOffset.dx) + pi/2) % (2*pi);
      final sectionIndex = (angle / (2*pi / sessions.length)).floor();
      
      print('Tapped on: ${sessions[sectionIndex]["title"]}');
    }
  }

  @override
  Widget build(BuildContext context) {
    final sessions = [
      {"title": "Pep Talk", "color": Color(0xff4B6F67), "status": "locked"},
      {"title": "Session Title", "color": Color(0xff6B4F6B), "status": "locked"},
      {"title": "Standard & Practice", "color": Color(0xff4A7E99), "status": "locked"},
      {"title": "Lessons Learnt", "color": Color(0xffA9D0C9), "status": "inprogress"},
      {"title": "Drill", "color": Color(0xffB89C45), "status": "pending"},
      {"title": "Science & Math", "color": Color(0xffCDBBD9), "status": "inprogress"},
      {"title": "Curiosity Seeker", "color": Color(0xff4D88A5), "status": "locked"},
      {"title": "Tech Diary", "color": Color(0xff9B4F7F), "status": "locked"},
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Learning Map"),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),

          const Text(
            "Explore your program structure",
            style: TextStyle(color: Colors.grey),
          ),

          const SizedBox(height: 30),

          Expanded(
            child: Center(
              child: GestureDetector(
                onTapDown: (details) => _handleTap(details, sessions),
                child: CustomPaint(
                  size: const Size(320, 320),
                  painter: LearningMapPainter(sessions),
                ),
              ),
            ),
          ),

          _buildLegend(),

          const SizedBox(height: 20)
        ],
      ),
    );
  }

  Widget _buildLegend() {
    Widget item(Color color, String text) {
      return Row(
        children: [
          CircleAvatar(radius: 6, backgroundColor: color),
          const SizedBox(width: 6),
          Text(text)
        ],
      );
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      margin: const EdgeInsets.symmetric(horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: const [
          BoxShadow(color: Colors.black12, blurRadius: 10)
        ],
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          item(Colors.green, "Complete"),
          item(Colors.blue, "In Progress"),
          item(Colors.orange, "Pending"),
          item(Colors.grey, "Locked"),
        ],
      ),
    );
  }
}

class LearningMapPainter extends CustomPainter {
  final List sessions;

  LearningMapPainter(this.sessions);

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);

    final radius = size.width / 2;
    final innerRadius = radius * .35;

    final sweep = 2 * pi / sessions.length;

    final rect = Rect.fromCircle(center: center, radius: radius);

    for (int i = 0; i < sessions.length; i++) {
      final paint = Paint()
        ..color = sessions[i]["color"]
        ..style = PaintingStyle.fill;

      final startAngle = -pi / 2 + (sweep * i);

      final path = Path()
        ..moveTo(center.dx, center.dy)
        ..arcTo(rect, startAngle, sweep, false)
        ..close();

      canvas.drawPath(path, paint);

      _drawText(
        canvas,
        sessions[i]["title"],
        center,
        radius * .70,
        startAngle + sweep / 2,
      );
    }

    final innerPaint = Paint()..color = Colors.white;

    canvas.drawCircle(center, innerRadius, innerPaint);
  }

  void _drawText(
      Canvas canvas, String text, Offset center, double radius, double angle) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: const TextStyle(
          fontSize: 11,
          color: Colors.black,
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(maxWidth: 80);

    final offset = Offset(
      center.dx + radius * cos(angle) - textPainter.width / 2,
      center.dy + radius * sin(angle) - textPainter.height / 2,
    );

    textPainter.paint(canvas, offset);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}