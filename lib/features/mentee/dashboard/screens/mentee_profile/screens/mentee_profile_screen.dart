import 'package:buddymentor/features/auth/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

class MenteeProfileScreen extends ConsumerWidget {
  const MenteeProfileScreen({super.key});

  static const _primaryBlue = Color(0xFF2D4383);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final userData = authState.fullUserData;

    final name =
        "${userData?["first_name"] ?? ""} ${userData?["last_name"] ?? ""}".trim();
    final email = userData?["email"]?["id"] ?? "arjun.mehta@university.edu";
    final phone =
        "+${userData?["mobile"]?["dialing_code"] ?? "91"} ${userData?["mobile"]?["number"] ?? "98765 43210"}";
    final discipline = userData?["discipline"] ?? "Computer Engineering";
    final institution = userData?["institution"] ?? "NIT Surat";

    return Scaffold(
      backgroundColor: const Color(0xFFF8F9FE),
      appBar: AppBar(
        backgroundColor: _primaryBlue,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.white),
          onPressed: () => Navigator.of(context).maybePop(),
        ),
        title: const Text(
          'Profile',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications_none, color: Colors.white),
            onPressed: () {},
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            // ── Blue header + overlapping avatar ─────────────
            Stack(
              clipBehavior: Clip.none,
              alignment: Alignment.center,
              children: [
                Container(
                  height: 80,
                  width: double.infinity,
                  color: _primaryBlue,
                ),
                Positioned(
                  top: 30,
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: const BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.circle,
                    ),
                    child: const CircleAvatar(
                      radius: 44,
                      backgroundImage: AssetImage('assets/images/logo.png'),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 54),

            // ── Name ─────────────────────────────────────────
            Text(
              name.isEmpty ? "User" : name,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Color(0xFF1A1A2E),
              ),
            ),
            const SizedBox(height: 4),

            // ── Subtitle: Mentee • Week 5 ─────────────────────
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Text(
                  "Mentee",
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 6),
                  child: Text("•",
                      style: TextStyle(fontSize: 13, color: Colors.grey)),
                ),
                const Text(
                  "Week 5", // replace with dynamic week if available
                  style: TextStyle(fontSize: 13, color: Colors.grey),
                ),
              ],
            ),

            const SizedBox(height: 24),

            // ── Info card ─────────────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: Colors.grey.withOpacity(0.1)),
                ),
                child: Column(
                  children: [
                    _buildInfoRow(
                      Icons.email_outlined,
                      "EMAIL",
                      email,
                    ),
                    _buildDivider(),
                    _buildInfoRow(
                      Icons.phone_outlined,
                      "PHONE",
                      phone,
                    ),
                    _buildDivider(),
                    _buildInfoRow(
                      Icons.book_outlined,
                      "DISCIPLINE",
                      discipline.toString(),
                    ),
                    _buildDivider(),
                    _buildInfoRow(
                      Icons.account_balance_outlined,
                      "INSTITUTION",
                      institution,
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 20),

            // ── Menu tiles — separate cards ───────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Column(
                children: [
                  _buildMenuTile(
                    Icons.person_outline,
                    "Edit Profile",
                    () => context.push('/menteeprofile/edit'),
                  ),
                  const SizedBox(height: 10),
                  _buildMenuTile(
                    Icons.settings_outlined,
                    "Settings",
                    () {},
                  ),
                  const SizedBox(height: 10),
                  _buildMenuTile(
                    Icons.headset_mic_outlined,
                    "Contact Us",
                    () {},
                  ),
                  const SizedBox(height: 10),
                  _buildMenuTile(
                    Icons.help_outline,
                    "Help & FAQ",
                    () {},
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // ── Sign out button ───────────────────────────────
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: OutlinedButton(
                style: OutlinedButton.styleFrom(
                  minimumSize: const Size(double.infinity, 52),
                  side: BorderSide(color: Colors.grey.shade300),
                  backgroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
                onPressed: () async {
                  await ref
                      .read(authControllerProvider.notifier)
                      .logout();
                  if (context.mounted) context.go('/role');
                },
                child: const Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.logout, color: Colors.redAccent, size: 20),
                    SizedBox(width: 8),
                    Text(
                      "Sign Out",
                      style: TextStyle(
                        color: Colors.redAccent,
                        fontWeight: FontWeight.w600,
                        fontSize: 15,
                      ),
                    ),
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

  // ── Info row: icon + label/value, NO icon background box ──
  Widget _buildInfoRow(IconData icon, String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          Icon(icon, color: const Color(0xFF2D4383), size: 22),
          const SizedBox(width: 14),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                label,
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.5,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Color(0xFF1A1A2E),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildDivider() =>
      const Divider(height: 1, thickness: 0.5, color: Color(0xFFEEEEEE),
          indent: 16, endIndent: 16);

  // ── Menu tile: each in its own white rounded card ──────────
  Widget _buildMenuTile(IconData icon, String title, VoidCallback onTap) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: ListTile(
        onTap: onTap,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: const Color(0xFFF0F2F8),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Icon(icon, color: const Color(0xFF2D4383), size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Color(0xFF1A1A2E),
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: Colors.grey),
      ),
    );
  }
}