import 'dart:math';
import 'dart:ui' as ui;
import 'package:flutter/material.dart';
import '../models/learning_map_models.dart';
import '../painter/learning_map_painter.dart';
import 'package:go_router/go_router.dart';
import '../../../../program/chapter_sessions/screens/chapter_session_screen.dart';

class LearningMapWidget extends StatefulWidget {
  final Subject subject;
  /// Pass MediaQuery screenWidth so the wheel fills the full screen width.
  final double canvasSize;

  const LearningMapWidget({
    super.key,
    required this.subject,
    required this.canvasSize,
  });

  @override
  State<LearningMapWidget> createState() => _LearningMapWidgetState();
}

class _LearningMapWidgetState extends State<LearningMapWidget>
    with TickerProviderStateMixin {

  double _rotationAngle       = 0.0;
  double _expandProgress      = 0.0;
  int    _selectedModuleIndex = -1;
  double _savedRotationAngle  = 0.0;

  late AnimationController _rotationController;
  late AnimationController _expandController;
  late Animation<double>   _rotationAnimation;
  late Animation<double>   _expandAnimation;

  double _rotationFrom = 0.0;
  double _rotationTo   = 0.0;

  // ── Must match LearningMapPainter exactly ────────────────────
  static const double _expandedRadiusScale = 1.2;
  static const double _shrunkRadiusScale   = 0.85;
  static const double _expandedSweepBonus  = 0.55;
  static const double _centerExpandScale   = 1.15;
  // 2px padding: safeOuter × 1.2 = maxRadius − 2  → fits inside canvas
  static const double _padding             = 2.0;

  double _safeOuter(double maxRadius) =>
      (maxRadius - _padding) / _expandedRadiusScale;

  @override
  void initState() {
    super.initState();

    _rotationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    );
    _expandController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
    );

    _rotationAnimation = CurvedAnimation(
      parent: _rotationController,
      curve: Curves.easeInOutCubic,
    );
    _expandAnimation = CurvedAnimation(
      parent: _expandController,
      curve: Curves.easeOutBack,
    );

    _rotationController.addListener(() {
      setState(() {
        _rotationAngle = ui.lerpDouble(
          _rotationFrom,
          _rotationTo,
          _rotationAnimation.value,
        )!;
      });
    });

    _expandController.addListener(() {
      setState(() {
        _expandProgress = _expandAnimation.value;
      });
    });
  }

  @override
  void dispose() {
    _rotationController.dispose();
    _expandController.dispose();
    super.dispose();
  }

  (List<double>, List<double>) _computeLayout() {
    final int n            = widget.subject.modules.length;
    final double baseSweep = (2 * pi) / n;
    const double gap       = 0.01;

    List<double> sweeps = List.filled(n, 0);
    if (_selectedModuleIndex == -1 || _expandProgress == 0.0) {
      for (int i = 0; i < n; i++) sweeps[i] = baseSweep - gap;
    } else {
      final bonus  = _expandedSweepBonus * _expandProgress;
      final shrink = bonus / (n - 1);
      for (int i = 0; i < n; i++) {
        sweeps[i] = (i == _selectedModuleIndex)
            ? baseSweep - gap + bonus
            : baseSweep - gap - shrink;
      }
    }

    List<double> startAngles = List.filled(n, 0);
    startAngles[0] = 0.01 / 2;
    for (int i = 1; i < n; i++) {
      startAngles[i] = startAngles[i - 1] + sweeps[i - 1] + 0.01;
    }

    return (sweeps, startAngles);
  }

  double _radiusScale(int i) {
    if (_selectedModuleIndex == -1 || _expandProgress == 0) return 1.0;
    return (i == _selectedModuleIndex)
        ? 1.0 + _expandProgress * (_expandedRadiusScale - 1.0)
        : 1.0 + _expandProgress * (_shrunkRadiusScale - 1.0);
  }

  double _targetRotationForModule(int moduleIndex) {
    final int n            = widget.subject.modules.length;
    final double baseSweep = (2 * pi) / n;
    const double gap       = 0.01;
    const double bonus     = _expandedSweepBonus;
    final double shrink    = bonus / (n - 1);

    List<double> sweeps      = List.filled(n, 0);
    List<double> startAngles = List.filled(n, 0);

    for (int i = 0; i < n; i++) {
      sweeps[i] = (i == moduleIndex)
          ? baseSweep - gap + bonus
          : baseSweep - gap - shrink;
    }
    startAngles[0] = gap / 2;
    for (int i = 1; i < n; i++) {
      startAngles[i] = startAngles[i - 1] + sweeps[i - 1] + gap;
    }

    final double midAngle = startAngles[moduleIndex] + sweeps[moduleIndex] / 2;
    double target = -pi / 2 - midAngle;

    double diff = (target - _rotationAngle) % (2 * pi);
    if (diff >  pi) diff -= 2 * pi;
    if (diff < -pi) diff += 2 * pi;

    return _rotationAngle + diff;
  }

  void _onModuleTapped(int moduleIndex) {
    if (moduleIndex == _selectedModuleIndex) {
      _resetSelection();
      return;
    }
    _rotationController.stop();
    _expandController.stop();

    if (_selectedModuleIndex != -1) {
      _expandController.reverse().then((_) => _selectModule(moduleIndex));
    } else {
      _selectModule(moduleIndex);
    }
  }

  void _selectModule(int moduleIndex) {
    if (_selectedModuleIndex == -1) _savedRotationAngle = _rotationAngle;
    setState(() => _selectedModuleIndex = moduleIndex);
    _rotationFrom = _rotationAngle;
    _rotationTo   = _targetRotationForModule(moduleIndex);
    _rotationController.forward(from: 0);
    _expandController.forward(from: 0);
  }

  void _resetSelection() {
    _expandController.reverse().then((_) {
      _rotationFrom = _rotationAngle;
      _rotationTo   = _savedRotationAngle;
      _rotationController.forward(from: 0);
      setState(() => _selectedModuleIndex = -1);
    });
  }

  double _normalizeAngle(double angle) {
    double r = angle % (2 * pi);
    if (r < 0) r += 2 * pi;
    return r;
  }

  bool _angleInSector(double angle, double sectorStart, double sectorSweep) {
    final double a   = _normalizeAngle(angle);
    final double s   = _normalizeAngle(sectorStart);
    final double end = s + sectorSweep;
    if (end <= 2 * pi) return a >= s && a <= end;
    return a >= s || a <= (end - 2 * pi);
  }

  void _detectTap(Offset position) {
    final double size      = widget.canvasSize;
    final center           = Offset(size / 2, size / 2);
    final double maxRadius = size / 2;

    final dx       = position.dx - center.dx;
    final dy       = position.dy - center.dy;
    final distance = sqrt(dx * dx + dy * dy);

    final double safeOuter        = _safeOuter(maxRadius);
    final double baseCenterR      = safeOuter * 0.22;
    final double baseModuleOuter  = safeOuter * 0.60;
    final double baseChapterOuter = safeOuter;

    // 1. Center circle
    final double centerRadius =
        baseCenterR * (1.0 + _expandProgress * (_centerExpandScale - 1.0));

    if (distance <= centerRadius) {
      if (_selectedModuleIndex != -1) _resetSelection();
      return;
    }

    // 2. De-rotate tap into painter's coordinate space
    final double adjustedAngle =
        _normalizeAngle(atan2(dy, dx) - _rotationAngle);

    final (sweeps, startAngles) = _computeLayout();
    final int n = widget.subject.modules.length;

    // 3. Find tapped module sector
    int tappedModule = -1;
    for (int i = 0; i < n; i++) {
      if (_angleInSector(adjustedAngle, startAngles[i], sweeps[i])) {
        tappedModule = i;
        break;
      }
    }
    if (tappedModule == -1) return;

    final module        = widget.subject.modules[tappedModule];
    final double rScale = _radiusScale(tappedModule);

    // 4. Radii for this module
    final double moduleInner  = centerRadius + 5;
    final double moduleOuter  = baseModuleOuter  * rScale;
    final double chapterInner = moduleOuter + 5;
    final double chapterOuter = baseChapterOuter * rScale + 4; // +4 tolerance

    // 5. Module zone → select / deselect
    if (distance >= moduleInner && distance <= moduleOuter) {
      _onModuleTapped(tappedModule);
      return;
    }

    // 6. Chapter zone → identify band and print
    if (distance >= chapterInner && distance <= chapterOuter) {
      final int chCount = module.chapters.length;
      if (chCount == 0) return;

      final double actualOuter = baseChapterOuter * rScale;
      final double zoneWidth   = actualOuter - chapterInner;
      final double bandWidth   = zoneWidth / chCount;
      final double distInZone  = distance - chapterInner;
      final int chapterIndex   =
          (distInZone / bandWidth).floor().clamp(0, chCount - 1);

      final chapter = module.chapters[chapterIndex];
      debugPrint(
        '\n🟢 Chapter Tapped!'
        '\n   📚 Module  : ${module.moduleName}'
        '\n   📖 Chapter : ${chapter.title}\n'
        '\n   📘 ID      : ${chapter.id}\n'
        
      );
      
      // Navigate to chapter sessions with chapter data
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => ChapterSessions(
            chapterId: chapter.id,
            chapterName: chapter.title,
          ),
        ),
      );
      return;
    }

    // 7. Outside → deselect
    if (distance > chapterOuter) {
      if (_selectedModuleIndex != -1) _resetSelection();
    }
  }

  @override
  Widget build(BuildContext context) {
    final double size = widget.canvasSize;

    return GestureDetector(
      onTapDown: (details) => _detectTap(details.localPosition),
      child: SizedBox(
        width: size,
        height: size,
        child: CustomPaint(
          size: Size(size, size),
          painter: LearningMapPainter(
            widget.subject,
            rotationAngle:       _rotationAngle,
            expandProgress:      _expandProgress,
            selectedModuleIndex: _selectedModuleIndex,
          ),
        ),
      ),
    );
  }
}