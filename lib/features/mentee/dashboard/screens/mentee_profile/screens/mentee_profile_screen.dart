import 'package:buddymentor/features/auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MenteeProfileScreen extends ConsumerWidget {
  const MenteeProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final userData = authState.fullUserData;
    
    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE), // Light greyish background
      body: SingleChildScrollView(
        child: Column(
          children: [
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                // 1. Blue Header Background
                Container(
                  height: 180,
                  width: double.infinity,
                  decoration: const BoxDecoration(
                    color: Color(0xFF2D4383), // Dark blue from image
                  ),
                  child: SafeArea(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.arrow_back, color: Colors.white),
                            onPressed: () => context.pop(),
                          ),
                          const Padding(
                            padding: EdgeInsets.only(top: 12),
                            child: Text(
                              "Profile",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.notifications_none, color: Colors.white),
                            onPressed: () {},
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // 2. Profile Image (Overlapping)
                Positioned(
                  top: 120,
                  child: Column(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(4),
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                        child: const CircleAvatar(
                          radius: 40,
                          backgroundImage: AssetImage('assets/images/logo.png'), // Use any image as a placeholder
                        ),
                      ),
                      const SizedBox(height: 10),
                      Text(
                        "${userData?["first_name"] ?? ""} ${userData?["last_name"] ?? "User"}".trim(),
                        style: const TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "Mentee • ID: ${userData?["mentee_id"] ?? "Loading..."}",
                        style: const TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),

            // Spacing for the overlapping header
            const SizedBox(height: 100),

            // 3. Info Card
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.withValues(alpha: 0.1)),
                ),
                child: Column(
                  children: [
                    _buildInfoRow(Icons.email_outlined, "EMAIL", userData?["email"]?["id"] ?? "test@gmail.com"),
                    const Divider(height: 1),
                    _buildInfoRow(Icons.phone_outlined, "PHONE", "+${userData?["mobile"]?["dialing_code"] ?? "91"} ${userData?["mobile"]?["number"] ?? "2314569780"}"),
                    const Divider(height: 1),
                    _buildInfoRow(Icons.book_outlined, "DISCIPLINE", "${userData?["discipline"] ?? "Computer Engineering"}"),
                    const Divider(height: 1),
                    _buildInfoRow(Icons.location_on_outlined, "STATE", userData?["state"] ?? "Tamil Nadu"),
                    const Divider(height: 1),
                    _buildInfoRow(Icons.badge_outlined, "MENTEE ID", userData?["mentee_id"] ?? "91TNCH00002"),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // 4. Menu List
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Column(
                  children: [
                    _buildMenuTile(Icons.person_outline, "Edit Profile", () => context.push('/menteeprofile/edit')),
                    _buildMenuTile(Icons.settings_outlined, "Settings", () {}),
                    _buildMenuTile(Icons.headset_mic_outlined, "Contact Us", () {}),
                    _buildMenuTile(Icons.help_outline, "Help & FAQ", () {}),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 30),

            // 5. Sign Out Button
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 55),
                  side: const BorderSide(color: Color(0xFFFFEBEE)),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                ),
                onPressed: () async {
                  await ref.read(authControllerProvider.notifier).logout();
                  if (context.mounted) context.go('/role');
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, color: Colors.redAccent, size: 20),
                    SizedBox(width: 8),
                    Text("Sign Out", style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 40),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFEEF2FF),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: const Color(0xFF2D4383), size: 22),
          ),
          const SizedBox(width: 15),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: const TextStyle(fontSize: 10, color: Colors.grey, fontWeight: FontWeight.bold)),
              Text(value, style: const TextStyle(fontSize: 14, fontWeight: FontWeight.w600, color: Color(0xFF333333))),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMenuTile(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: const Color(0xFFF0F2F8),
          borderRadius: BorderRadius.circular(10),
        ),
        child: Icon(icon, color: const Color(0xFF2D4383), size: 20),
      ),
      title: Text(title, style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500)),
      trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      onTap: onTap,
    );
  }
}