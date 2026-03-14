import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:buddymentor/features/auth/controllers/auth_controller.dart';
import 'package:buddymentor/core/constants/app_colors.dart';

class ProfileSidebar extends ConsumerWidget {
  const ProfileSidebar({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final user = authState.fullUserData;

    final name =
        "${user?["first_name"] ?? ""} ${user?["last_name"] ?? ""}".trim();
    final email = user?["email"]?["id"] ?? "user@email.com";

    return Drawer(
      child: Column(
        children: [

          /// Profile Header
          Container(
            width: double.infinity,
            padding: const EdgeInsets.symmetric(vertical: 40),
            decoration: BoxDecoration(
              color: AppColors.primary,
            ),
            child: Column(
              children: [

                const CircleAvatar(
                  radius: 40,
                  backgroundImage:
                      AssetImage("assets/images/logo.png"),
                ),

                const SizedBox(height: 12),

                Text(
                  name.isEmpty ? "User" : name,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  email,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 13,
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          /// Menu Items
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              children: [

                _menuTile(
                  icon: Icons.person_outline,
                  title: "Profile",
                  onTap: () {},
                ),

                _menuTile(
                  icon: Icons.settings_outlined,
                  title: "Settings",
                  onTap: () {},
                ),

                _menuTile(
                  icon: Icons.help_outline,
                  title: "Help & Support",
                  onTap: () {},
                ),

                const Divider(height: 40),

                /// Logout Button
                _menuTile(
                  icon: Icons.logout,
                  title: "Logout",
                  color: Colors.red,
                  onTap: () async {
                    Navigator.pop(context);

                    await ref
                        .read(authControllerProvider.notifier)
                        .logout();

                    if (context.mounted) {
                      context.go('/role');
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _menuTile({
    required IconData icon,
    required String title,
    required VoidCallback onTap,
    Color color = Colors.black87,
  }) {
    return ListTile(
      leading: Icon(icon, color: color),
      title: Text(
        title,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.w500,
        ),
      ),
      onTap: onTap,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      hoverColor: Colors.grey.shade100,
    );
  }
}