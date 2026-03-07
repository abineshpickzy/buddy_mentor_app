import 'package:flutter/material.dart';

enum LearningStatus {
  complete,
  inProgress,
  pending,
  locked,
}

class LearningItem {
  final String title;
  final LearningStatus status;

  LearningItem({
    required this.title,
    required this.status,
  });

  Color get color {
    switch (status) {
      case LearningStatus.complete:
        return const Color(0xFF5DBB9D); // Green
      case LearningStatus.inProgress:
        return const Color(0xFF4C6EDB); // Blue
      case LearningStatus.pending:
        return const Color(0xFFF4B740); // Yellow
      case LearningStatus.locked:
        return const Color(0xFFD3D3D3); // Grey
    }
  }
}
