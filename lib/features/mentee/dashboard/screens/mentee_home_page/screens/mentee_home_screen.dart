import 'package:buddymentor/core/constants/app_colors.dart';
import 'package:buddymentor/features/auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../models/week_item.dart';

class MenteeHomeScreen extends ConsumerWidget {
  const MenteeHomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final List<WeekItem> weeks = sampleWeeks;
    final authState = ref.watch(
      authControllerProvider,
    ); // Use watch to listen to changes

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),

      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: Builder(
          builder: (context) => IconButton(
            icon: const Icon(Icons.menu, color: Colors.black),
            onPressed: () => Scaffold.of(context).openDrawer(),
          ),
        ),
        title:  Text(
          "Engineering Program",
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.textDark,
                fontWeight: FontWeight.bold,
                fontSize: 18,

              ),
        ),
        centerTitle: true,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16),
            child: GestureDetector(
              onTap: () {
                context.push('/menteeprofile');
              },
              child: const CircleAvatar(
                radius: 16,
                backgroundColor: Colors.grey,
                child: Icon(Icons.person, size: 18, color: Colors.white),
              ),
            ),
          ),
        ],
      ),

      drawer: Drawer(
        shape: const RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topRight: Radius.circular(0),
            bottomRight: Radius.circular(0),
          ),
        ),
        child: Column(
          children: [
            const SizedBox(height: 60),
            const CircleAvatar(
              radius: 40,
              backgroundImage: AssetImage('assets/images/logo.png'),
            ),
            const SizedBox(height: 10),
            Text(
              "${authState.fullUserData?["first_name"] ?? ""} ${authState.fullUserData?["last_name"] ?? "Alex Thompson"}"
                  .trim(),
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
            ),

            Text(
              authState.fullUserData?["email"]?["id"] ?? "alexthompson@bu.edu",

              style: TextStyle(color: Colors.grey),
            ),
            const Divider(height: 40),
            _drawerItem(Icons.home, "Home", true, null),
            _drawerItem(
              Icons.mail,
              "Contact Us",
              false,
              () => context.push('/contactus'),
            ),
            const Spacer(),
            const Divider(height: 1),
            _drawerItem(Icons.logout, "Sign Out", false, () async {
              await ref.read(authControllerProvider.notifier).logout();
              if (context.mounted) {
                context.go('/role');
              }
            }),
            const SizedBox(height: 20),
          ],
        ),
      ),

      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Column(
          children: [
            const SizedBox(height: 20),

            // Progress Circle
            SizedBox(
              height: 160,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  SizedBox(
                    height: 130,
                    width: 130,
                    child: CircularProgressIndicator(
                      value: 3 / 16,
                      strokeWidth: 10,
                      backgroundColor: Colors.grey.shade300,
                      color: AppColors.primary,
                    ),
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: const [
                      Text(
                        "3",
                        style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text("of 16 weeks", style: TextStyle(color: Colors.grey)),
                    ],
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Resume Button
            SizedBox(
              width: 200,
              height: 45,
              child: ElevatedButton.icon(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                icon: const Icon(
                  Icons.play_arrow_outlined,
                  color: Colors.white,
                ),
                label: const Text(
                  "Resume Week 4",
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
              ),
            ),

            const SizedBox(height: 30),

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "WEEKLY SKILL TITLES",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  letterSpacing: 1,
                  color: Colors.black54,
                ),
              ),
            ),

            const SizedBox(height: 15),

            Expanded(
              child: ListView.builder(
                itemCount: weeks.length,
                physics: const BouncingScrollPhysics(),
                cacheExtent: 200,
                itemBuilder: (context, index) {
                  final week = weeks[index];

                  return Container(
                    margin: const EdgeInsets.only(bottom: 14),
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: Colors.grey.shade200),
                    ),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// LEFT SIDE (80%)
                        Expanded(
                          flex: 7,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: 10,
                                height: 10,
                                margin: const EdgeInsets.only(top: 6),
                                decoration: BoxDecoration(
                                  color: _getStatusColor(week.status),
                                  shape: BoxShape.circle,
                                ),
                              ),
                              const SizedBox(width: 12),

                              /// Text section
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      "Week ${week.week}",
                                      style: const TextStyle(
                                        color: Colors.grey,
                                      ),
                                    ),
                                    Text(
                                      week.title,
                                      maxLines: 1,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),

                        /// RIGHT SIDE (30%)
                        Expanded(
                          flex: 3,
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              _getStatusText(week.status),
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: AppColors.primary,
                                fontWeight: FontWeight.w500,
                                fontSize: 12,
                              ),
                            ),
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

  static Widget _drawerItem(
    IconData icon,
    String title,
    bool selected,
    VoidCallback? onTap,
  ) {
    return ListTile(
      leading: Icon(icon, color: selected ? AppColors.primary : Colors.grey),
      title: Text(
        title,
        style: TextStyle(color: selected ? AppColors.primary : Colors.black),
      ),
      selected: selected,
      onTap: onTap,
    );
  }

  static Color _getStatusColor(String status) {
    switch (status) {
      case "complete":
        return Colors.green;
      case "in_progress":
        return Colors.blue;
      default:
        return Colors.orange;
    }
  }

  static String _getStatusText(String status) {
    switch (status) {
      case "complete":
        return "Complete";
      case "in_progress":
        return "In Progress";
      default:
        return "Pending";
    }
  }
}
