import 'package:buddymentor/features/mentee/dashboard/screens/mentee_circular_map/data/sample_learning_map.dart';
import 'package:buddymentor/features/mentee/dashboard/screens/mentee_circular_map/widgets/learning_map_widget.dart';
import 'package:buddymentor/shared/widgets/app_bar/custom_appbar.dart';
import 'package:flutter/material.dart';

class MenteeMapScreen extends StatelessWidget {
  const MenteeMapScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Use full screen width — widget itself keeps a 2px safe margin
    final double mapSize = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: "Skilling Map",
        subtitle: "Explore your program structure",
      ),
      body: Column(
        children: [
          Expanded(
            child: Center(
              child: LearningMapWidget(
                canvasSize: mapSize,
                subject: sampleSubject,
              ),
            ),
          ),

          const SizedBox(height: 12),

          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              _LegendItem(color: Color(0xFF3CB371), label: "Complete"),
              _LegendItem(color: Color(0xFF3A5BA0), label: "In Progress"),
              _LegendItem(color: Color(0xFFD4A72C), label: "Pending"),
              _LegendItem(color: Color(0xFFD3D6DB), label: "Locked"),
            ],
          ),

          const SizedBox(height: 16),
        ],
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(color: color, shape: BoxShape.circle),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(fontSize: 12, color: Colors.grey.shade700),
        ),
      ],
    );
  }
}