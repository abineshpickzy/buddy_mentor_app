// lib/features/mentee/program_purchase/presentation/chapter_sessions.dart
//
// Same circular wheel as before – now navigates to SessionContentPage
// when an unlocked segment is tapped.

import 'dart:math';
import 'package:buddymentor/features/mentee/program/chapter_sessions/screens/session_content_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:buddymentor/features/mentee/program_purchase/controllers/program_overview_controller.dart';



class ChapterSessions extends ConsumerWidget {
  final String chapterId;
  final String chapterName;

 
  const ChapterSessions({
    super.key,
    required this.chapterId,
    required this.chapterName,
   
  });

  // ── Tap handler ─────────────────────────────────────────────────────────
  void _handleTap(
    TapDownDetails details,
    BuildContext context,
    List<Map<String, dynamic>> sessionsList,
  ) {
    const center = Offset(160, 160);
    final tapOffset = details.localPosition - center;
    final distance = tapOffset.distance;

    if (distance > 56 && distance < 160) {
      final angle =
          (atan2(tapOffset.dy, tapOffset.dx) + pi / 2) % (2 * pi);
      final sectionIndex =
          (angle / (2 * pi / sessionsList.length)).floor();
      final tapped = sessionsList[sectionIndex];

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

      // ── Navigate to SessionContentPage ─────────────────────────
      Navigator.of(context).push(
        MaterialPageRoute(
          builder: (_) => SessionContentPage(
            chapterId: chapterId,
            chapterName: chapterName,
            sessionId: tapped['id'] as String,
            sessionName: tapped['title'] as String,
            initialTabIndex: sectionIndex,
          ),
        ),
      );
    }
  }



  // ── Data → UI mapping ──────────────────────────────────────────────────
  Widget _buildSessionsFromData(
      BuildContext context, dynamic programOverview) {
    List<Map<String, dynamic>> sessionsList = [];

    for (final module in programOverview.hierarchy.modules) {
      for (final chapter in module.chapters) {
        if (chapter.id == chapterId) {
          sessionsList =
              chapter.sessions.map<Map<String, dynamic>>((session) {
            Color sessionColor;
            String status;

            if (session.isLocked) {
              status = 'locked';
              sessionColor = Colors.grey.shade400;
            } else {
              switch (session.status) {
                case 2:
                  status = 'completed';
                  sessionColor = Colors.green.shade400;
                  break;
                case 1:
                  status = 'inprogress';
                  sessionColor = const Color(0xff4A7E99);
                  break;
                case 0:
                default:
                  status = 'pending';
                  sessionColor = const Color(0xffB89C45);
                  break;
              }
            }

            return {
              'id': session.id,          // ← needed for navigation
              'title': session.name,
              'color': sessionColor,
              'status': status,
            };
          }).toList();
          break;
        }
      }
      if (sessionsList.isNotEmpty) break;
    }

    if (sessionsList.isEmpty) {
      return _buildNoDataState(context);
    }

    return _buildSessionsUI(context, sessionsList);
  }

  Widget _buildErrorState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 16),
          const Text('Error loading sessions'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }

  Widget _buildNoDataState(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.info_outline, size: 48, color: Colors.grey),
          const SizedBox(height: 16),
          const Text('No sessions found for this chapter'),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Go Back'),
          ),
        ],
      ),
    );
  }

  Widget _buildSessionsUI(
      BuildContext context, List<Map<String, dynamic>> sessionsList) {
    return Column(
      children: [
        const SizedBox(height: 16),
        const Text(
          'Tap a segment to explore your sessions',
          style: TextStyle(color: Colors.grey, fontSize: 13),
        ),
        const SizedBox(height: 100),
        Center(
          child: GestureDetector(
            onTapDown: (details) =>
                _handleTap(details, context, sessionsList),
            child: CustomPaint(
              size: const Size(320, 320),
              painter: SessionMapPainter(sessionsList, chapterName),
            ),
          ),
        ),
        const SizedBox(height: 32),
        _buildLegend(),
        const SizedBox(height: 24),
      ],
    );
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final programOverviewAsync = ref.watch(programOverviewProvider);

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.chevron_left,
              color: Colors.black87, size: 28),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          chapterName,
          style:
              Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
        ),
        centerTitle: true,
      ),
      body: programOverviewAsync.when(
        loading: () =>
            const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _buildErrorState(context),
        data: (programOverview) {
          if (programOverview == null) {
            return _buildNoDataState(context);
          }
          return _buildSessionsFromData(context, programOverview);
        },
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
          decoration:
              BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(text,
            style: const TextStyle(
                fontSize: 12, color: Colors.black87)),
      ],
    );
  }
}

// ─────────────────────────────────────────────────────────────────────────────
//  SessionMapPainter  (unchanged from original)
// ─────────────────────────────────────────────────────────────────────────────

class SessionMapPainter extends CustomPainter {
  final List<Map<String, dynamic>> sessions;
  final String centerText;

  SessionMapPainter(this.sessions, [this.centerText = 'Chapter Name']);

  Color _effectiveColor(Map<String, dynamic> session) {
    final status = session["status"] as String;
    final base = session["color"] as Color;
    if (status == "locked") {
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
    const gapAngle = 0.025;

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

      final status = sessions[i]["status"] as String;
      final midAngle = startAngle + sweepAngle / 2;
      final textRadius = radius * 0.68;
      final iconOffset = Offset(
        center.dx + textRadius * cos(midAngle),
        center.dy + textRadius * sin(midAngle),
      );

      _drawLabel(canvas, sessions[i]["title"] as String, iconOffset, status);
    }

    final shadowPaint = Paint()
      ..color = Colors.black.withOpacity(0.08)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(center, innerRadius + 2, shadowPaint);

    final innerPaint = Paint()..color = Colors.white;
    canvas.drawCircle(center, innerRadius, innerPaint);

    _drawCenterText(canvas, center, centerText);
  }

  void _drawLabel(
      Canvas canvas, String text, Offset center, String status) {
    final isLocked = status == 'locked';

    if (isLocked) {
      final iconPainter = TextPainter(
        text: const TextSpan(
            text: '🔒', style: TextStyle(fontSize: 12)),
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
                offset: Offset(0, 1)),
          ],
        ),
      ),
      textAlign: TextAlign.center,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(maxWidth: 72);

    final offset = Offset(
      center.dx - textPainter.width / 2,
      center.dy -
          textPainter.height / 2 +
          (isLocked ? 8 : 0),
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