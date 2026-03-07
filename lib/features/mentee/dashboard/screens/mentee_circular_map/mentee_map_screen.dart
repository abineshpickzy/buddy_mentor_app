import 'package:buddymentor/shared/widgets/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'models/learning_item.dart';
import 'widgets/half_moon_learning_map.dart';

class MenteeMapScreen extends StatelessWidget {
  const MenteeMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Simulated backend data
    final List<LearningItem> learningItems = [
      LearningItem(
          title: "Peptalk", status: LearningStatus.complete),
      LearningItem(
          title: "Standards & Practice", status: LearningStatus.complete),
      LearningItem(
          title: "Lessons Learned", status: LearningStatus.inProgress),
      LearningItem(
          title: "Drill", status: LearningStatus.pending),
      LearningItem(
          title: "Science & Math", status: LearningStatus.locked),
      LearningItem(
          title: "Curiosity Seeker", status: LearningStatus.pending),
      LearningItem(
          title: "Tech Diary", status: LearningStatus.complete),
    ];

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      appBar: CustomAppBar(
        title: " Learning Map",
        subtitle: "Visualize Your Learning Journey",
      ),
      body: Column(
        children: [
          HalfMoonLearningMap(items: learningItems),
          const SizedBox(height: 40),
          _buildLegend(),
        ],
      ),
    );
  }

  Widget _buildLegend() {
    Widget legendItem(Color color, String text) {
      return Row(
        children: [
          CircleAvatar(radius: 6, backgroundColor: color),
          const SizedBox(width: 6),
          Text(text),
          const SizedBox(width: 20),
        ],
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        legendItem(const Color(0xFF5DBB9D), "Complete"),
        legendItem(const Color(0xFF4C6EDB), "In Progress"),
        legendItem(const Color(0xFFF4B740), "Pending"),
        legendItem(const Color(0xFFD3D3D3), "Locked"),
      ],
    );
  }
}
