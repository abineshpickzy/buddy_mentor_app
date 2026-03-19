import 'package:buddymentor/core/constants/app_colors.dart';
import 'package:buddymentor/features/mentee/dashboard/widgets/profile_sidebar.dart';
import 'package:buddymentor/features/mentee/program_purchase/controllers/program_overview_controller.dart';
import 'package:buddymentor/features/mentee/dashboard/screens/mentee_program_timeline/models/timeline_model.dart';
import 'package:buddymentor/features/mentee/dashboard/screens/mentee_program_timeline/widgets/timeline_empty_state.dart';
import 'package:buddymentor/shared/widgets/icons/sidebar_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class MenteeTimelineScreen extends ConsumerWidget {
  const MenteeTimelineScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final programOverviewAsync = ref.watch(programOverviewProvider);
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: Colors.white,
      drawer: const ProfileSidebar(),
      appBar: _TimelineAppBar(
        onMenuTap: () => scaffoldKey.currentState?.openDrawer(),
        onProfileTap: () => context.push('/menteeprofile'),
      ),
      body: SafeArea(
        top: false,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

        

            const SizedBox(height: 8),

            // ── Timeline list ─────────────────────────────────
            Expanded(
              child: programOverviewAsync.when(
                loading: () =>
                    const Center(child: CircularProgressIndicator()),
                error: (error, stack) => TimelineEmptyState.error(
                  onRetry: () => ref.invalidate(programOverviewProvider),
                ),
                data: (programOverview) {
                  if (programOverview == null) {
                    return TimelineEmptyState.noProgram(
                      onRetry: () => context.go('/programs'),
                    );
                  }
                  return _buildProgramTimeline(context, programOverview);
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ── Dot ────────────────────────────────────────────────────

  Widget _buildDot(String status) {
    if (status == 'completed') {
      return Container(
        width: 28,
        height: 28,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check, size: 14, color: Colors.white),
      );
    }

    if (status == 'inprogress') {
      return Container(
        width: 28,
        height: 28,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primary, width: 3),
        ),
        child: Center(
          child: Container(
            width: 9,
            height: 9,
            decoration: const BoxDecoration(
              color: AppColors.primary,
              shape: BoxShape.circle,
            ),
          ),
        ),
      );
    }

    // locked
    return Container(
      width: 28,
      height: 28,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.grey.shade300, width: 1.5),
      ),
      child: Icon(Icons.lock_outline,
          size: 13, color: Colors.grey.shade400),
    );
  }

  // ── Card ───────────────────────────────────────────────────

  Widget _buildCard(BuildContext context, TimelineItem item) {
    final bool isLocked =
        item.status == 'locked' || item.status == 'pending';
    final bool isInProgress = item.status == 'inprogress';
    final bool isCompleted = item.status == 'completed';

    return GestureDetector(
      onTap: isLocked
          ? () {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                      'Complete pending chapters or wait for unlock!'),
                  behavior: SnackBarBehavior.floating,
                  duration: Duration(seconds: 2),
                ),
              );
            }
          : () => context.push('/menteemap'),
      child: Container(
        padding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isLocked ? const Color(0xFFF7F8FA) : Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: isInProgress
                ? AppColors.primary.withOpacity(0.35)
                : isCompleted
                    ? Colors.grey.shade200
                    : Colors.grey.shade200,
            width: isInProgress ? 1.5 : 0.8,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Week ${item.week}',
              style: TextStyle(
                fontSize: 12,
                color: isLocked
                    ? Colors.grey.shade400
                    : Colors.grey.shade500,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.title,
              style: TextStyle(
                fontWeight: FontWeight.w600,
                fontSize: 14,
                color: isLocked
                    ? Colors.grey.shade400
                    : const Color(0xFF1A1A2E),
              ),
            ),
            if (isCompleted) ...[
              const SizedBox(height: 8),
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 3),
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
                padding: const EdgeInsets.symmetric(
                    horizontal: 10, vertical: 3),
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

  // ── Program timeline ───────────────────────────────────────

  Widget _buildProgramTimeline(BuildContext context, programOverview) {
    final modules = programOverview.hierarchy.modules;

    return ListView.builder(
      padding: const EdgeInsets.fromLTRB(20, 4, 20, 24),
      itemCount: modules.length,
      itemBuilder: (context, index) {
        final module = modules[index];
        final isLast = index == modules.length - 1;

        String status;
        if (module.isLocked) {
          status = 'locked';
        } else {
          switch (module.status) {
            case 2:
              status = 'completed';
              break;
            case 1:
              status = 'inprogress';
              break;
            default:
              status = 'locked';
          }
        }

        final item = TimelineItem(
          week: module.orderNo,
          title: module.name,
          subtitle: '',
          status: status,
        );

        return _buildTimelineRow(context, item, isLast);
      },
    );
  }

  // ── Fallback timeline ──────────────────────────────────────


  // ── Shared row builder ─────────────────────────────────────

  Widget _buildTimelineRow(
      BuildContext context, TimelineItem item, bool isLast) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // dot + line
          SizedBox(
            width: 44,
            child: Column(
              children: [
                const SizedBox(height: 14),
                _buildDot(item.status),
                if (!isLast)
                  Expanded(
                    child: Center(
                      child: Container(
                        width: 2,
                        color: _getLineColor(item.status),
                      ),
                    ),
                  ),
              ],
            ),
          ),
          // card
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 14),
              child: _buildCard(context, item),
            ),
          ),
        ],
      ),
    );
  }
}

// ─── AppBar (same pattern as Analytics) ─────────────────────────────────────

class _TimelineAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onMenuTap;
  final VoidCallback onProfileTap;

  const _TimelineAppBar({
    required this.onMenuTap,
    required this.onProfileTap,
  });

  @override
  Size get preferredSize => const Size.fromHeight(96);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,

      // ── Row 1: back button only ──────────────────────────
      leading: IconButton(
        icon: const Icon(Icons.arrow_back, color: Colors.black87),
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      title: const SizedBox.shrink(),
      centerTitle: false,
      titleSpacing: 0,

      // ── Row 2: sidebar icon + title + profile icon ───────
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(48),
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 10),
              child: Row(
                children: [
                  // sidebar icon
                  SidebarIcon(
                    onTap: onMenuTap,
                  ),
                  const SizedBox(width: 10),
                  // title
                  Expanded(
                    child: Text(
                      'Program Timeline',
                      style: GoogleFonts.inter(
                        color: const Color(0xFF1A1A2E),
                        fontWeight: FontWeight.w700,
                        fontSize: 18,
                      ),
                    ),
                  ),
                  // profile icon
                  GestureDetector(
                    onTap: onProfileTap,
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
                ],
              ),
            ),
            Divider(
              height: 0.5,
              thickness: 0.5,
              color: Colors.grey.shade200,
            ),
          ],
        ),
      ),
    );
  }
}