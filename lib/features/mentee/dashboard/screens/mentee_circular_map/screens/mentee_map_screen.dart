import 'package:buddymentor/features/mentee/program_purchase/controllers/program_overview_controller.dart';
import 'package:buddymentor/features/mentee/dashboard/screens/mentee_circular_map/data/sample_learning_map.dart';
import 'package:buddymentor/features/mentee/dashboard/screens/mentee_circular_map/widgets/learning_map_widget.dart';
import 'package:buddymentor/features/mentee/dashboard/screens/mentee_circular_map/utils/program_overview_converter.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../../../../dashboard/screens/mentee_circular_map/data/sample_learning_map.dart';

class MenteeMapScreen extends ConsumerWidget {
  const MenteeMapScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final programOverviewAsync = ref.watch(programOverviewProvider);
    final double mapSize = MediaQuery.of(context).size.width;

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Text(
          'skilling map',
          style: GoogleFonts.inter(
            color: const Color(0xFF1A1A2E),
            fontSize: 18,
            fontWeight: FontWeight.w700,
          ),
        ),
        centerTitle: true,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Divider(
            height: 0.5,
            thickness: 0.5,
            color: Colors.grey.shade200,
          ),
        ),
      ),
      body: programOverviewAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (error, stack) => _buildBody(mapSize, sampleSubject, null),
        data: (programOverview) {
          if (programOverview == null) {
            return _buildBody(mapSize, sampleSubject, null);
          }
          final subject =
              ProgramOverviewConverter.convertToSubject(programOverview);
          return _buildBody(mapSize, subject, programOverview);
        },
      ),
    );
  }

  Widget _buildBody(double mapSize, dynamic subject, dynamic programOverview) {
    return Column(
      children: [

        // ── Subtitle ───────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.only(top: 10, bottom: 6),
          child: Text(
            'Explore your program structure',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Colors.grey,
            ),
          ),
        ),

        // ── Legend ─────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              _LegendItem(color: Color(0xFF3CB371), label: 'Complete'),
              SizedBox(width: 16),
              _LegendItem(color: Color(0xFF3A5BA0), label: 'In Progress'),
              SizedBox(width: 16),
              _LegendItem(color: Color(0xFFD4A72C), label: 'Pending'),
              SizedBox(width: 16),
              _LegendItem(color: Color(0xFFD3D6DB), label: 'Locked'),
            ],
          ),
        ),

 SizedBox(height: 70,),
// ── Circle map ─────────────────────────────────────────
SizedBox(
  height: mapSize, // or any fixed value like 360
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
 SizedBox(height: 50,),
        // ── Bottom info card ───────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
          child: Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: Colors.grey.shade200),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.06),
                  blurRadius: 10,
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
                        subject?.subject ?? 'Select a module',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF1A1A2E),
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        'Tap to explore subtopics in this domain',
                        style: GoogleFonts.inter(
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

// ─── Legend Item ─────────────────────────────────────────────────────────────

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 9,
          height: 9,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
          ),
        ),
        const SizedBox(width: 5),
        Text(
          label,
          style: GoogleFonts.inter(
            fontSize: 11.5,
            color: Colors.grey.shade700,
          ),
        ),
      ],
    );
  }
}