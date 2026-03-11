import 'package:buddymentor/core/constants/app_colors.dart';
import 'package:buddymentor/features/mentee/dashboard/screens/mentee_program_timeline/models/timeline_model.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class MenteeTimelineScreen extends StatelessWidget {
  const MenteeTimelineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    int completedCount = items.where((e) => e.status == "completed").length;
    double progress = completedCount / items.length;

    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ── AppBar style header ─────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Align(
                    alignment: Alignment.centerLeft,
                    child: IconButton(
                      icon: const Icon(Icons.chevron_left, size: 28, color: Colors.black87),
                      onPressed: () => context.pop(),
                    ),
                  ),
                  const Text(
                    'Program Timeline',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.black87,
                    ),
                  ),
                ],
              ),
            ),

            // ── Subtitle ────────────────────────────────────────────
            const Padding(
              padding: EdgeInsets.only(left: 20),
              child: Text(
                '16-week structured journey',
                style: TextStyle(fontSize: 13, color: Colors.grey),
              ),
            ),

            const SizedBox(height: 20),

            // ── Timeline list ────────────────────────────────────────
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                itemCount: items.length,
                itemBuilder: (context, index) {
                  final item = items[index];
                  final isLast = index == items.length - 1;

                  return IntrinsicHeight(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // ── Left: dot + line ────────────────────────
                        SizedBox(
                          width: 40,
                          child: Column(
                            children: [
                              const SizedBox(height: 14),
                              _buildDot(item.status),
                              if (!isLast)
                                Expanded(
                                  child: Container(
                                    width: 2,
                                    color: _getLineColor(item.status),
                                  ),
                                ),
                            ],
                          ),
                        ),

                        // ── Right: card ─────────────────────────────
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(bottom: 16),
                            child: _buildCard(context, item),
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDot(String status) {
    if (status == 'completed') {
      return Container(
        width: 26,
        height: 26,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check, size: 14, color: Colors.white),
      );
    }

    if (status == 'inprogress') {
      return Container(
        width: 26,
        height: 26,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primary, width: 3),
        ),
        child: Center(
          child: Container(
            width: 8,
            height: 8,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
        ),
      );
    }

    // locked / pending
    return Container(
      width: 26,
      height: 26,
      decoration: BoxDecoration(
        color: Colors.grey.shade200,
        shape: BoxShape.circle,
      ),
      child: Icon(Icons.lock_outline, size: 12, color: Colors.grey.shade400),
    );
  }

  Widget _buildCard(BuildContext context, TimelineItem item) {
    final bool isLocked = item.status == 'locked' || item.status == 'pending';
    final bool isInProgress = item.status == 'inprogress';
    final bool isCompleted = item.status == 'completed';

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
      decoration: BoxDecoration(
        color: isLocked ? const Color(0xFFF7F8FA) : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isInProgress
              ? AppColors.primary.withOpacity(0.4)
              : Colors.grey.shade200,
        ),
      ),
      child: GestureDetector(
        onTap: isLocked ? (){
              ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Complete pending chapters ! or wait for unlock next week !'),
            behavior: SnackBarBehavior.floating,
            duration: const Duration(seconds: 2),
          ),
        );
        } : () {
            context.push('/menteemap');
        },
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Week ${item.week}',
              style: TextStyle(
                fontSize: 12,
                color: isLocked ? Colors.grey.shade400 : Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: isLocked ? Colors.grey.shade400 : Colors.black87,
              ),
            ),
            if (isCompleted) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Completed',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
            if (isInProgress) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.primary.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'In Progress',
                  style: TextStyle(
                    fontSize: 11,
                    fontWeight: FontWeight.w600,
                    color: AppColors.primary,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color _getLineColor(String status) {
    if (status == 'completed' || status == 'inprogress') {
      return AppColors.primary;
    }
    return Colors.grey.shade300;
  }
}