import 'package:buddymentor/core/constants/app_colors.dart';
import 'package:buddymentor/features/mentee/program_purchase/controllers/program_overview_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class MenteeAnalyticsScreen extends ConsumerWidget {
  const MenteeAnalyticsScreen({super.key});

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
          icon: const Icon(Icons.arrow_back, color: Colors.black87),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: Row(
          children: [
        
            const SizedBox(width: 8),
            Text(
              'Analytics',
              style: GoogleFonts.inter(
                color: const Color(0xFF1A1A2E),
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
          ],
        ),
        centerTitle: false,
        titleSpacing: 0,
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(0.5),
          child: Divider(
            height: 0.5,
            thickness: 0.5,
            color: Colors.grey.shade200,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                  context.go('/menteeprofile');
              },
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: const BoxDecoration(
                  color: Color(0xFFE8EAF6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(
                   
                  Icons.person_outline,
                  size: 18,
                  color: Color(0xFF5C6280),
                ),
              ),
            ),
          ),
        ],
      ),
      body: programOverviewAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => _ErrorState(
          message: 'Error loading analytics',
          details: e.toString(),
          onRetry: () {},
        ),
        data: (overview) {
          if (overview == null) return const _EmptyState();

          final modules = overview.hierarchy.modules;
          final allChapters = modules.expand((m) => m.chapters).toList();
          final totalChapters = allChapters.length;
          final completedChapters =
              allChapters.where((c) => c.status == 2).length;

          final double progress =
              totalChapters == 0 ? 0.0 : completedChapters / totalChapters;

          final String chaptersLabel =
              '$completedChapters of $totalChapters Chapters Completed';

          final skills = _buildSkillStats(
            completedChapters: completedChapters,
            totalChapters: totalChapters,
          );

          return Column(
            children: [
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 16),
                  physics: const BouncingScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // ── Progress card ──────────────────────────────────
                      _ProgressCard(
                        progress: progress,
                        label: chaptersLabel,
                      ),
                      const SizedBox(height: 28),

                      // ── Section title ──────────────────────────────────
                      Text(
                        'Skill progress chapter',
                        style: GoogleFonts.inter(
                          fontSize: 16,
                          fontWeight: FontWeight.w700,
                          color: const Color(0xFF1A1A2E),
                        ),
                      ),
                      const SizedBox(height: 16),

                      // ── Skill rows ─────────────────────────────────────
                      ...skills.map(
                        (s) => _SkillProgressItem(
                          label: s.label,
                          progress: s.progress,
                        ),
                      ),
                      const SizedBox(height: 16),
                    ],
                  ),
                ),
              ),

              // ── Continue Learning button ───────────────────────────────
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                child: SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppColors.primary,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      elevation: 0,
                    ),
                    child: Text(
                      'Continue Learning',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  List<_SkillStat> _buildSkillStats({
    required int completedChapters,
    required int totalChapters,
  }) {
    if (totalChapters == 0) {
      return const [
        _SkillStat('Hours completed', 0.0),
        _SkillStat('Drill completed', 0.0),
        _SkillStat('sci & math completed', 0.0),
        _SkillStat('Curiosity seeker completed', 0.0),
        _SkillStat('Tech Diaries completed', 0.0),
      ];
    }

    final base = completedChapters / totalChapters;
    double clamp(double v) => v.clamp(0.0, 1.0);

    return [
      _SkillStat('Hours completed', clamp(base * 0.9)),
      _SkillStat('Drill completed', clamp(base * 1.1)),
      _SkillStat('sci & math completed', clamp(base * 0.5)),
      _SkillStat('Curiosity seeker completed', clamp(base * 0.5)),
      _SkillStat('Tech Diaries completed', clamp(base * 0.5)),
    ];
  }
}

// ─── Progress Card ──────────────────────────────────────────────────────────

class _ProgressCard extends StatelessWidget {
  final double progress;
  final String label;

  const _ProgressCard({required this.progress, required this.label});

  @override
  Widget build(BuildContext context) {
    final percentage = (progress * 100).round();

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        children: [
          // Ring
          SizedBox(
            width: 140,
            height: 140,
            child: Stack(
              alignment: Alignment.center,
              children: [
                SizedBox(
                  width: 140,
                  height: 140,
                  child: CircularProgressIndicator(
                    value: progress,
                    strokeWidth: 9,
                    strokeCap: StrokeCap.round,
                    backgroundColor: const Color(0xFFE5E7F1),
                    color: AppColors.primary,
                  ),
                ),
                Text(
                  '$percentage%',
                  style: GoogleFonts.inter(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                    color: const Color(0xFF1A1A2E),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          // Label below ring
          Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 13,
              color: Colors.grey.shade500,
            ),
          ),
        ],
      ),
    );
  }
}

// ─── Skill Progress Item ────────────────────────────────────────────────────
// Matches screenshot: NO card/shadow — just plain label + % row, thin bar, divider

class _SkillProgressItem extends StatelessWidget {
  final String label;
  final double progress;

  const _SkillProgressItem({required this.label, required this.progress});

  @override
  Widget build(BuildContext context) {
    final percentage = (progress * 100).round();

    return Padding(
      padding: const EdgeInsets.only(bottom: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Label + percentage
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                label,
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
              ),
              Text(
                '$percentage%',
                style: GoogleFonts.inter(
                  fontSize: 13,
                  color: Colors.black87,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Thin progress bar
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: const Color(0xFFEEEEEE),
              valueColor:
                  AlwaysStoppedAnimation<Color>(AppColors.primary),
              minHeight: 6,
            ),
          ),
          const SizedBox(height: 16),
          // Divider between items (matches screenshot)
          const Divider(height: 1, thickness: 0.5, color: Color(0xFFEEEEEE)),
          const SizedBox(height: 12),
        ],
      ),
    );
  }
}

// ─── Helpers ────────────────────────────────────────────────────────────────

class _SkillStat {
  final String label;
  final double progress;
  const _SkillStat(this.label, this.progress);
}

class _ErrorState extends StatelessWidget {
  final String message;
  final String details;
  final VoidCallback onRetry;

  const _ErrorState({
    required this.message,
    required this.details,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            Text(message,
                style: Theme.of(context).textTheme.titleMedium,
                textAlign: TextAlign.center),
            const SizedBox(height: 4),
            Text(details,
                style: Theme.of(context)
                    .textTheme
                    .bodySmall
                    ?.copyWith(color: Colors.grey[600]),
                textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(onPressed: onRetry, child: const Text('Retry')),
          ],
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(Icons.info_outline, size: 48, color: Colors.grey),
          SizedBox(height: 16),
          Text('No analytics data available'),
        ],
      ),
    );
  }
}