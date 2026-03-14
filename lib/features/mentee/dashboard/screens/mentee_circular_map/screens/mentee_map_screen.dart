import 'package:buddymentor/features/mentee/program_purchase/controllers/program_overview_controller.dart';
import 'package:buddymentor/features/mentee/dashboard/screens/mentee_circular_map/data/sample_learning_map.dart';
import 'package:buddymentor/features/mentee/dashboard/screens/mentee_circular_map/widgets/learning_map_widget.dart';
import 'package:buddymentor/features/mentee/dashboard/screens/mentee_circular_map/utils/program_overview_converter.dart';
import 'package:buddymentor/shared/widgets/app_bar/custom_appbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../dashboard/screens/mentee_circular_map/data/sample_learning_map.dart';

class MenteeMapScreen extends ConsumerWidget {
  const MenteeMapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final programOverviewAsync = ref.watch(programOverviewProvider);
    final double mapSize = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: const CustomAppBar(
        title: "Skilling Map",
        subtitle: "Explore your program structure",
      ),
      body: programOverviewAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _buildBody(mapSize, sampleSubject, null),
        data: (programOverview) {
          if (programOverview == null) {
            return _buildBody(mapSize, sampleSubject, null);
          }
          final subject = ProgramOverviewConverter.convertToSubject(programOverview);
          return _buildBody(mapSize, subject, programOverview);
        },
      ),
    );
  }

  Widget _buildBody(double mapSize, dynamic subject, dynamic programOverview) {
    return Column(
      children: [
        // ── Legend at top ──────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 10.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: const [
              _LegendItem(color: Color(0xFF3CB371), label: "Complete"),
              _LegendItem(color: Color(0xFF3A5BA0), label: "In Progress"),
              _LegendItem(color: Color(0xFFD4A72C), label: "Pending"),
              _LegendItem(color: Color(0xFFD3D6DB), label: "Locked"),
            ],
          ),
        ),

        // ── Circle map ─────────────────────────────────────────
        Expanded(
          child: Center(
            child: Transform.scale(
              scale: 1.15,
              child: LearningMapWidget(
                canvasSize: mapSize,
                subject: subject,
              ),
            ),
          ),
        ),

        // ── Bottom info card ───────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 20),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 8,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Row(
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        subject?.subject ?? "Select a module",
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: Color(0xFF1A1A2E),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Tap to explore subtopics in this domain",
                        style: TextStyle(
                          fontSize: 13,
                          color: Colors.grey.shade500,
                        ),
                      ),
                    ],
                  ),
                ),
                Icon(Icons.chevron_right_rounded,
                    color: Colors.grey.shade400, size: 22),
              ],
            ),
          ),
        ),
      ],
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