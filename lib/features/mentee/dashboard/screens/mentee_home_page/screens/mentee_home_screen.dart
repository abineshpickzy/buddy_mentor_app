import 'package:buddymentor/core/constants/app_colors.dart';
import 'package:buddymentor/features/auth/controllers/auth_controller.dart';
import 'package:buddymentor/features/mentee/program_purchase/controllers/program_overview_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MenteeHomeScreen extends ConsumerWidget {

  
  const MenteeHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final programOverviewAsync = ref.watch(programOverviewProvider);

    final firstName = authState.fullUserData?["first_name"] ?? "there";
    
    // Get program name from the fetched program overview data
    final programName = programOverviewAsync.value?.program.name ?? 'My Program';

    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu_rounded, color: Colors.black87),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title: Text(
          programName,
          style: const TextStyle(
            color: Colors.black87,
            fontWeight: FontWeight.bold,
            fontSize: 17,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 14),
            child: GestureDetector(
              onTap: () => context.push('/menteeprofile'),
              child: CircleAvatar(
                radius: 18,
                backgroundColor: AppColors.primary.withOpacity(0.12),
                child: Icon(Icons.person_rounded, size: 20, color: AppColors.primary),
              ),
            ),
          ),
        ],
      ),
      drawer: _buildDrawer(context, ref, authState),
      body: programOverviewAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.error_outline, size: 48, color: Colors.red),
              const SizedBox(height: 16),
              Text('Error loading program: $e'),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: () {
                 
                
                  
                },
                child: const Text('Retry'),
              ),
            ],
          ),
        ),
        data: (programOverview) {
          if (programOverview == null) {
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
          
          final moduleList = programOverview.hierarchy.modules;
          final totalWeeks = moduleList.length;
          final completedWeeks = moduleList.where((module) => module.status == 2).length;
             
          final progress = totalWeeks > 0 ? completedWeeks / totalWeeks : 0.0;

          return CustomScrollView(
            physics: const BouncingScrollPhysics(),
            slivers: [
              // ── Progress circle + button ────────────────────────────
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    const SizedBox(height: 20),
                    SizedBox(
                      height: 160,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          SizedBox(
                            height: 130,
                            width: 130,
                            child: CircularProgressIndicator(
                              value: progress,
                              strokeWidth: 10,
                              backgroundColor: Colors.grey.shade300,
                              color: AppColors.primary,
                            ),
                          ),
                          Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                '1',
                                style: const TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text(
                                'of $totalWeeks weeks',
                                style: const TextStyle(color: Colors.grey),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    SizedBox(
                      width: 220,
                      height: 48,
                      child: ElevatedButton.icon(
                        onPressed: () => context.push('/menteemap'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primary,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                          elevation: 0,
                        ),
                        icon: const Icon(Icons.play_arrow_outlined,
                            color: Colors.white),
                        label: Text(
                          completedWeeks == 0
                              ? 'Start Week 1'
                              : 'Resume Week ${completedWeeks + 1}',
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w600,
                            fontSize: 15,
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 10),
                  ],
                ),
              ),

              const SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.fromLTRB(16, 24, 16, 10),
                  child: Text(
                    'WEEKLY SKILL TITLES',
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: FontWeight.bold,
                      color: AppColors.textDark,
                      letterSpacing: 1,
                    ),
                  ),
                ),
              ),

              // ── Modules list ────────────────────────────────────────
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 0, 16, 24),
                sliver: SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final module = moduleList[index];
                      final status = module.isLocked 
                          ? 'locked' 
                          : (module.status == 2 
                              ? 'completed' 
                              : (module.status == 1 
                                  ? 'in_progress' 
                                  : 'not_started'));
                      final statusColor = _getStatusColor(status);

                      return Container(
                        margin: const EdgeInsets.only(bottom: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade200),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.04),
                              blurRadius: 4,
                              offset: const Offset(0, 2),
                            ),
                          ],
                        ),
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 14, vertical: 14),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              // Small status dot
                              Container(
                                width: 10,
                                height: 10,
                                decoration: BoxDecoration(
                                  color: statusColor,
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 12),
                              // Week label + name
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      'Week ${module.orderNo}',
                                      style: TextStyle(
                                        fontSize: 12,
                                        color: Colors.grey.shade500,
                                      ),
                                    ),
                                    const SizedBox(height: 3),
                                    Text(
                                      module.name,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14,
                                        color: status == 'locked'
                                            ? Colors.grey
                                            : Colors.black87,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              const SizedBox(width: 8),
                              // Plain status text
                              SizedBox(
                                width: 80,
                                child: Text(
                                  _getStatusText(status),
                                  textAlign: TextAlign.right,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: 12,
                                    color: statusColor,
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                    childCount: moduleList.length,
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  // ── Drawer ──────────────────────────────────────────────────────────
  Widget _buildDrawer(
      BuildContext context, WidgetRef ref, dynamic authState) {
    final fullName =
        "${authState.fullUserData?["first_name"] ?? ""} ${authState.fullUserData?["last_name"] ?? ""}"
            .trim();

    return Drawer(
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      child: SafeArea(
        child: Column(
          children: [
            const SizedBox(height: 32),
            CircleAvatar(
              radius: 38,
              backgroundColor: AppColors.primary.withOpacity(0.1),
              backgroundImage: const AssetImage('assets/images/logo.png'),
            ),
            const SizedBox(height: 12),
            Text(
              fullName.isEmpty ? 'Alex Thompson' : fullName,
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 17,
                  color: Colors.black87),
            ),
            const SizedBox(height: 4),
            Text(
              authState.fullUserData?["email"]?["id"] ??
                  "alexthompson@bu.edu",
              style:
                  TextStyle(color: Colors.grey.shade500, fontSize: 13),
            ),
            const SizedBox(height: 24),
            Divider(color: Colors.grey.shade100, height: 1),
            const SizedBox(height: 8),
            _drawerItem(Icons.home_rounded, "Home", true, null),
            _drawerItem(Icons.mail_outline_rounded, "Contact Us", false,
                () {
                  Navigator.of(context).pop(); // Close drawer first
                  context.push('/contactus');
                }),
            const Spacer(),
            Divider(color: Colors.grey.shade100, height: 1),
            _drawerItem(Icons.logout_rounded, "Sign Out", false, () async {
              Navigator.of(context).pop(); // Close drawer first
              await ref.read(authControllerProvider.notifier).logout();
              if (context.mounted) context.go('/role');
            }),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }

  static Widget _drawerItem(
      IconData icon, String title, bool selected, VoidCallback? onTap) {
    return ListTile(
      leading: Icon(icon,
          color: selected ? AppColors.primary : Colors.grey.shade600,
          size: 22),
      title: Text(
        title,
        style: TextStyle(
          color: selected ? AppColors.primary : Colors.black87,
          fontWeight: selected ? FontWeight.w600 : FontWeight.normal,
          fontSize: 15,
        ),
      ),
      onTap: onTap,
      shape:
          RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      horizontalTitleGap: 8,
    );
  }

  static Color _getStatusColor(String status) {
    switch (status) {
      case "completed":
        return Colors.green;
      case "in_progress":
        return AppColors.primary;
      case "not_started":
        return Colors.orange;
      case "locked":
        return Colors.grey;
      default:
        return Colors.orange;
    }
  }

  static IconData _getStatusIcon(String status) {
    switch (status) {
      case "completed":
        return Icons.check_circle_rounded;
      case "in_progress":
        return Icons.play_circle_rounded;
      case "not_started":
        return Icons.radio_button_unchecked_rounded;
      case "locked":
        return Icons.lock_rounded;
      default:
        return Icons.radio_button_unchecked_rounded;
    }
  }

  static String _getStatusText(String status) {
    switch (status) {
      case "completed":
        return "Done";
      case "in_progress":
        return "In Progress";
      case "not_started":
        return "Start";
      case "locked":
        return "Locked";
      default:
        return "Pending";
    }
  }
}