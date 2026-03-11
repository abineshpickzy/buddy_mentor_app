import 'package:buddymentor/features/mentee/dashboard/screens/mentee_circular_map/data/sample_learning_map.dart';
import 'package:buddymentor/features/mentee/dashboard/screens/mentee_circular_map/widgets/learning_map_widget.dart';
import 'package:buddymentor/shared/widgets/app_bar/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MenteeMapScreen extends StatefulWidget {
  const MenteeMapScreen({super.key});

  @override
  State<MenteeMapScreen> createState() => _MenteeMapScreenState();
}

class _MenteeMapScreenState extends State<MenteeMapScreen> {
  String selectedModule = "Structural Analysis";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      appBar: const CustomAppBar(
        title: "Learning Map",
        subtitle: "Explore your program structure",
      ),

      body: InteractiveViewer(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
          children: [

            /// CIRCULAR MAP
            Expanded(
              child: Center(
                child: TweenAnimationBuilder<double>(
                  duration: const Duration(milliseconds: 800),
                  tween: Tween(begin: 0.8, end: 1.0),
                  curve: Curves.easeOut,
                  builder: (context, value, child) {
                    return Transform.scale(
                      scale: value,
                      child: Opacity(
                        opacity: value,
                        child: LearningMapWidget(
                          subject: sampleSubject,
                          onChapterTap: (chapter, module) {
                            debugPrint(
                              "Clicked chapter: ${chapter.title}, Chapter ID: ${chapter.id}, Module: ${module.moduleName}}",
                            );
                            context.push('/menteemap/chaptersession');
                          },
                        ),
                      ),
                    );
                  },
                ),
              ),
            ),

            const SizedBox(height: 20),

            /// LEGEND
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: const [
                _LegendItem(color: Color(0xFF3CB371), label: "Complete"),
                _LegendItem(color: Color(0xFF3A5BA0), label: "In Progress"),
                _LegendItem(color: Color(0xFFD4A72C), label: "Pending"),
                _LegendItem(color: Color(0xFFD3D6DB), label: "Locked"),
              ],
            ),

            const SizedBox(height: 20),

            /// MODULE INFO CARD
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 18,
              ),
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                borderRadius: BorderRadius.circular(12),
                border: Border.all(
                  color: Colors.grey.shade300,
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  Text(
                    selectedModule,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  const SizedBox(height: 6),

                  Text(
                    "Tap to explore subtopics in this domain",
                    style: TextStyle(
                      color: Colors.grey.shade600,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 10),
          ],
          ),
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({
    required this.color,
    required this.label,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [

        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),

        const SizedBox(width: 6),

        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }
}