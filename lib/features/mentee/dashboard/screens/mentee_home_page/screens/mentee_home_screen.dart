import 'package:buddymentor/core/constants/app_colors.dart';
import 'package:buddymentor/features/mentee/dashboard/widgets/profile_sidebar.dart';
import 'package:buddymentor/features/mentee/dashboard/widgets/home_skeleton.dart';
import 'package:buddymentor/features/mentee/program_purchase/controllers/program_overview_controller.dart';
import 'package:buddymentor/shared/widgets/icons/sidebar_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';

class MenteeHomeScreen extends ConsumerWidget {
  const MenteeHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final programOverviewAsync = ref.watch(programOverviewProvider);
    final scaffoldKey = GlobalKey<ScaffoldState>();

    final programName = programOverviewAsync.value?.program.name ?? 'Programs';

    return Scaffold(
      key: scaffoldKey,
      backgroundColor: AppColors.white,
      drawer: const ProfileSidebar(), //
      appBar: const _HomeTopBar(),
      body: SafeArea(
        top: false,
        child: programOverviewAsync.when(
          loading: () => const HomeSkeletonLoader(),
          error: (e, _) => _ErrorState(
            message: 'Error loading program',
            details: e.toString(),
            onRetry: () {},
          ),
          data: (programOverview) {
            if (programOverview == null) return const _EmptyState();

            final moduleList = programOverview.hierarchy.modules;
            final totalModules = moduleList.length;
            
            // Calculate progress: count only completed modules (status == 2)
            final completedModules =
                moduleList.where((m) => m.status == 2).length;
            final progress =
                totalModules > 0 ? completedModules / totalModules : 0.0;

            // Find the first module that is not completed
            // This will be the "current" or "next" week to resume/start
            int nextModuleIndex = 0;
            for (int i = 0; i < moduleList.length; i++) {
              if (moduleList[i].status != 2) {
                nextModuleIndex = i;
                break;
              }
              // If all modules are completed, nextModuleIndex stays at the last module
              if (i == moduleList.length - 1) {
                nextModuleIndex = i;
              }
            }

            final nextModule = moduleList[nextModuleIndex];
            final nextWeekNumber = nextModule.orderNo;
            final isFirstWeek = completedModules == 0;

            return SingleChildScrollView(
              physics: const BouncingScrollPhysics(),
              padding:
                  const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // ── Header row ───────────────────────────────
                  Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              // ✅ Menu icon — left of program name
                              SidebarIcon(
                                onTap: () =>
                                    scaffoldKey.currentState?.openDrawer(),
                              ),
                              const SizedBox(width: 20),
                              Text(
                                programName,
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      fontSize: 16,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.textDark,
                                    ),
                              ),
                            ],
                          ),
                          GestureDetector(
                            onTap: () => context.push('/menteeprofile'),
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
                      const SizedBox(height: 5),
                      Divider(height: 1, color: AppColors.border),
                    ],
                  ),

                  const SizedBox(height: 24),

                  // ── Progress + CTA ───────────────────────────
                  Center(
                    child: Column(
                      children: [
                        _ProgressCircle(
                          progress: progress,
                          completedModules: completedModules,
                          totalModules: totalModules,
                        ),
                        const SizedBox(height: 20),

                        SizedBox(
                          height: 46,
                          child: ElevatedButton.icon(
                            onPressed: () => context.push('/menteemap'),
                            icon: const Icon(Icons.play_arrow,
                                color: Colors.white, size: 18),
                            label: Text(
                              isFirstWeek
                                  ? 'Start Week 1'
                                  : 'Resume Week $nextWeekNumber',
                              style: const TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.w600,
                                fontSize: 15,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: AppColors.primary,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 0,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // ── Section label ────────────────────────────
                  Text(
                    'WEEKLY SKILL TITLES',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          letterSpacing: 1.0,
                          color: const Color(0xFF9091A4),
                        ),
                  ),
                  const SizedBox(height: 12),

                  // ── Week list ────────────────────────────────
                  ListView.builder(
                    itemCount: moduleList.length,
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemBuilder: (context, index) {
                      final module = moduleList[index];
                      
                      // Determine status based on module properties
                      final status = module.isLocked
                          ? 'locked'
                          : (module.status == 2
                              ? 'completed'
                              : (module.status == 1
                                  ? 'in_progress'
                                  : 'not_started'));

                      return _WeekCard(
                        weekNumber: module.orderNo,
                        title: module.name,
                        status: status,
                      );
                    },
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

// ─── Top Bar ────────────────────────────────────────────────────────────────

class _HomeTopBar extends StatelessWidget implements PreferredSizeWidget {
  const _HomeTopBar();

  @override
  Size get preferredSize => const Size.fromHeight(64);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      automaticallyImplyLeading: false, // ✅ no back/drawer icon in AppBar
      backgroundColor: Colors.white,
      surfaceTintColor: Colors.transparent,
      elevation: 0,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(0.5),
        child: Divider(
          height: 0.5,
          thickness: 0.5,
          color: Colors.grey.shade50,
        ),
      ),
      centerTitle: false,
      titleSpacing: 16,
      title: Row(
        children: [
          Image.asset(
            'assets/images/logo.png',
            height: 32,
            width: 32,
          ),
          const SizedBox(width: 8),
          Text(
            'Buddy Mentor',
            style: GoogleFonts.inter(
              color: AppColors.primary,
              fontWeight: FontWeight.w700,
              fontSize: 18,
            ),
          ),
        ],
      ),
      actions: [
        IconButton(
          onPressed: () {},
          icon: const Icon(Icons.notifications_none, color: Colors.black87),
        ),
        const SizedBox(width: 4),
      ],
    );
  }
}

// ─── Progress Circle ────────────────────────────────────────────────────────

class _ProgressCircle extends StatelessWidget {
  final double progress;
  final int completedModules;
  final int totalModules;

  const _ProgressCircle({
    required this.progress,
    required this.completedModules,
    required this.totalModules,
  });

  @override
  Widget build(BuildContext context) {
    final shown = completedModules.clamp(0, totalModules);
    const double size = 120;

    return SizedBox(
      height: size,
      width: size,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: size,
            width: size,
            child: CircularProgressIndicator(
              value: progress,
              strokeWidth: 10,
              strokeCap: StrokeCap.round,
              backgroundColor: const Color(0xFFDFDFDF),
              color: AppColors.primary,
            ),
          ),
          Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                '$shown',
                style: const TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF1A1A2E),
                ),
              ),
              const SizedBox(height: 3),
              Text(
                'of $totalModules weeks',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey.shade500,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ─── Week Card ──────────────────────────────────────────────────────────────

class _WeekCard extends StatelessWidget {
  final int weekNumber;
  final String title;
  final String status;

  const _WeekCard({
    required this.weekNumber,
    required this.title,
    required this.status,
  });

  static _StatusStyle _getStyle(String status) {
    switch (status) {
      case 'completed':
        return _StatusStyle(
          dot: const Color(0xFF22C55E),
          bg: const Color(0xFFE6F4EC),
          label: 'Complete',
          labelColor: const Color(0xFF16A34A),
          borderColor: const Color(0xFFE5E7F1),
        );
      case 'in_progress':
        return _StatusStyle(
          dot: AppColors.primary,
          bg: const Color(0xFFE8EAF6),
          label: 'In Progress',
          labelColor: AppColors.primary,
          borderColor: const Color(0xFFC5C8E8),
        );
      case 'not_started':
        return _StatusStyle(
          dot: const Color(0xFFE6A817),
          bg: const Color(0xFFFFF8E6),
          label: 'Pending',
          labelColor: const Color(0xFFB07D10),
          borderColor: const Color(0xFFE5E7F1),
        );
      case 'locked':
      default:
        return _StatusStyle(
          dot: const Color(0xFFB0B0C0),
          bg: const Color(0xFFF3F3F6),
          label: 'Locked',
          labelColor: const Color(0xFF888888),
          borderColor: const Color(0xFFE5E7F1),
        );
    }
  }

  @override
  Widget build(BuildContext context) {
    final style = _getStyle(status);

    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: style.borderColor, width: 0.5),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        leading: Container(
          width: 28,
          height: 28,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: style.bg,
          ),
          child: Center(
            child: Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                color: style.dot,
              ),
            ),
          ),
        ),
        title: Text(
          'Week $weekNumber',
          style: const TextStyle(
            fontSize: 11,
            color: Color(0xFF9091A4),
          ),
        ),
        subtitle: Text(
          title,
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: Color(0xFF1A1A2E),
          ),
        ),
        trailing: Container(
          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
          decoration: BoxDecoration(
            color: style.bg,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Text(
            style.label,
            style: TextStyle(
              fontSize: 11.5,
              color: style.labelColor,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
      ),
    );
  }
}

class _StatusStyle {
  final Color dot;
  final Color bg;
  final String label;
  final Color labelColor;
  final Color borderColor;

  const _StatusStyle({
    required this.dot,
    required this.bg,
    required this.label,
    required this.labelColor,
    required this.borderColor,
  });
}

// ─── Error State ────────────────────────────────────────────────────────────

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
            Text(
              message,
              style: Theme.of(context).textTheme.titleMedium,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 4),
            Text(
              details,
              style: Theme.of(context)
                  .textTheme
                  .bodySmall
                  ?.copyWith(color: Colors.grey[600]),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: onRetry,
              child: const Text('Retry'),
            ),
          ],
        ),
      ),
    );
  }
}

// ─── Empty State ────────────────────────────────────────────────────────────

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
          Text('No program data available'),
        ],
      ),
    );
  }
}