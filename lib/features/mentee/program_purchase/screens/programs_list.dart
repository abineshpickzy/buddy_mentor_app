import 'package:buddymentor/core/constants/app_colors.dart';
import 'package:buddymentor/features/auth/controllers/auth_controller.dart';
import 'package:buddymentor/features/mentee/dashboard/widgets/profile_sidebar.dart';
import 'package:buddymentor/features/mentee/program_purchase/widgets/program_card_skeleton.dart';
import 'package:buddymentor/features/mentee/program_purchase/widgets/stat_card_skeleton.dart';
import 'package:buddymentor/shared/widgets/icons/sidebar_icon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../controllers/program_list_controller.dart';
import '../controllers/program_overview_controller.dart';

import 'payment_page.dart';

class ProgramList extends ConsumerWidget {
  const ProgramList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final programsAsync = ref.watch(programsProvider);
    final statsAsync = ref.watch(programStatsProvider);

    
    return Scaffold(
     backgroundColor: Colors.white,
  appBar: AppBar(
    backgroundColor: Colors.white,
    elevation: 0,
    toolbarHeight: 120, // Increased height to fit both rows
    centerTitle: true,
    title: Column(
      children: [
        /// Row 1: The Logo & Brand Name
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              'assets/images/logo.png', // Replace with your Buddy Mentor asset
              height: 30,
            ),
            const SizedBox(width: 8),
            Text(
              "Buddy Mentor",
              style:Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.primaryDark,
                    fontWeight: FontWeight.w600,
                    fontSize: 18
              ),
              ),
          ],
        ),
        const SizedBox(height: 15),
        
        /// Row 2: Menu, Title, and Profile
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            SidebarIcon(
              onTap: () => _showProfileSidebar(context),
            ),
            const SizedBox(width: 20),
            Text(
              "Programs",
                    style:Theme.of(context).textTheme.headlineMedium?.copyWith(
                    color: AppColors.textDark,
                    fontWeight: FontWeight.w700,
                    fontSize: 18
              ),
            ),
            const Spacer(),
            GestureDetector(
              onTap: () => _showProfilePopup(context, ref),
              child: Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFFE8EAF6),
                  shape: BoxShape.circle,
                ),
                child: const Icon(Icons.person_outline, color: Color(0xFF5C6280), size: 20),
              ),
            ),
          ],
        ),
        
        /// The Thin Divider Line
        const SizedBox(height: 8),
        Divider(color: Colors.grey.withOpacity(0.2), thickness: 1),
      ],
    ),
  ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Program Catalogue",
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 16
              ) 
            ),
            const SizedBox(height: 4),
            const Text(
              "Browse mentoring programs and enroll in your\nlearning journey",
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
            const SizedBox(height: 20),
            
            /// Stats Row
            statsAsync.when(
              data: (stats) => Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _StatCard(icon: Icons.book_outlined, value: "1" , label: "Total Programs", color: Colors.green),
                  _StatCard(icon: Icons.people_outline, value: stats.activeLearners, label: "Active Learners", color: Colors.blue),
                  _StatCard(icon: Icons.trending_up, value: stats.avgRating.toString(), label: "Avg. Rating", color: Colors.indigo),
                ],
              ),
                        loading: () => const Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                StatCardSkeleton(),
                StatCardSkeleton(),
                StatCardSkeleton(),
              ],
            ),
              error: (error, stack) => const Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _StatCard(icon: Icons.book_outlined, value: "0", label: "Total Programs", color: Colors.green),
                  _StatCard(icon: Icons.people_outline, value: "0", label: "Active Learners", color: Colors.blue),
                  _StatCard(icon: Icons.trending_up, value: "0", label: "Avg. Rating", color: Colors.indigo),
                ],
              ),
            ),
            const SizedBox(height: 24),

            /// List of Cards
            programsAsync.when(
              data: (programs) => Column(
                children: programs.map((program) => ProgramCard(
                  programId: program.id,
                  productId: program.productId,
                  productType:program.type,
                  title: program.title,
                  desc: program.description,
                  weeks: program.weeks,
                  learners: program.learners,
                  rating: program.rating,
                  tag: program.tag,
                  price: program.price ?? "₹0",
                  isEnrolled: program.isEnrolled,
                  showFreeTrial: program.showFreeTrial,
                )).toList(),
              ),
                        loading: () => Column(
              children: List.generate(
                3,
                (index) => const ProgramCardSkeleton(),
              ),
            ),
              error: (error, stack) => Center(
                child: Column(
                  children: [
                    const Icon(Icons.error_outline, size: 48, color: Colors.red),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load programs',
                      style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Please check your connection and try again',
                      style: TextStyle(color: Colors.grey[600], fontSize: 14),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => ref.read(programsProvider.notifier).refresh(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppColors.primary,
                        foregroundColor: Colors.white,
                      ),
                      child: const Text('Retry'),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showProfileSidebar(BuildContext context) {
    showGeneralDialog(
      context: context,
      barrierDismissible: true,
      barrierLabel: '',
      barrierColor: Colors.black54,
      transitionDuration: const Duration(milliseconds: 300),
      pageBuilder: (context, animation, secondaryAnimation) {
        return Align(
          alignment: Alignment.centerLeft,
          child: SlideTransition(
            position: Tween<Offset>(
              begin: const Offset(-1.0, 0.0),
              end: Offset.zero,
            ).animate(CurvedAnimation(
              parent: animation,
              curve: Curves.easeInOut,
            )),
            child: const ProfileSidebar(),
          ),
        );
      },
    );
  }

  void _showProfilePopup(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authControllerProvider);
    final userData = authState.fullUserData;
    final fullName = "${userData?["first_name"] ?? ""} ${userData?["last_name"] ?? "User"}".trim();
    final email = userData?["email"]?["id"] ?? "user@example.com";

    showMenu(
      context: context,
      position: const RelativeRect.fromLTRB(1000, 120, 16, 0),
      color: Colors.white,
      elevation: 8,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      items: [
        PopupMenuItem(
          enabled: false,
          child: Container(
            width: 200,
            padding: const EdgeInsets.symmetric(vertical: 8),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 16,
                      backgroundColor: AppColors.primary.withOpacity(0.1),
                      child: Icon(Icons.person, size: 16, color: AppColors.primary),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            fullName,
                            style: const TextStyle(
                              fontWeight: FontWeight.w600,
                              fontSize: 13,
                              color: Colors.black87,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          Text(
                            email,
                            style: const TextStyle(
                              fontSize: 11,
                              color: Colors.grey,
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                const Divider(height: 1),
              ],
            ),
          ),
        ),
        PopupMenuItem(
          child: Row(
            children: [
              Icon(Icons.logout, size: 16, color: Colors.red.shade600),
              const SizedBox(width: 8),
              Text(
                'Sign Out',
                style: TextStyle(
                  color: Colors.red.shade600,
                  fontWeight: FontWeight.w500,
                  fontSize: 13,
                ),
              ),
            ],
          ),
          onTap: () async {
            await ref.read(authControllerProvider.notifier).logout();
            if (context.mounted) context.go('/role');
          },
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  final IconData icon;
  final String value, label;
  final Color color;

  const _StatCard({required this.icon, required this.value, required this.label, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: MediaQuery.of(context).size.width * 0.28,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.grey.shade100),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 20),
          const SizedBox(height: 8),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
          Text(label, style: const TextStyle(color: Colors.grey, fontSize: 10)),
        ],
      ),
    );
  }
}

class ProgramCard extends ConsumerWidget {
  final String programId;
  final String productId;
  final int productType;
  final String title, desc, tag;
  final int weeks, learners;
  final double rating;
  final String? price;
  final bool isEnrolled;
  final bool showFreeTrial;

  const ProgramCard({
    super.key,
    required this.programId,
    required this.productId,
    required this.productType,
    required this.title,
    required this.desc, 
    required this.weeks,
    required this.learners,
    required this.rating,
    this.tag = "",
    this.price,
    this.isEnrolled = false,
    this.showFreeTrial = false,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.08),
            blurRadius: 24,
            offset: const Offset(0, 8),
            spreadRadius: 0,
          ),
          BoxShadow(
            color: Colors.black.withOpacity(0.04),
            blurRadius: 8,
            offset: const Offset(0, 2),
            spreadRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header Image Area
          Stack(
            children: [
              Container(
                height: 140,
                decoration: const BoxDecoration(
                  gradient: LinearGradient(
                    colors: [AppColors.primaryDark,AppColors.primaryDark],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
                ),
                child: const Center(
                  child: Icon(Icons.menu_book_outlined, color: Colors.white54, size: 60),
                ),
              ),
              if (tag.isNotEmpty)
                Positioned(
                  top: 12, right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
                    decoration: BoxDecoration(
                      color: tag == "Enrolled" ? Colors.green : (tag == "Popular" ? Colors.orange : Colors.blueGrey),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(tag, style: const TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold)),
                  ),
                ),
            ],
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style:Theme.of(context).textTheme.headlineMedium?.copyWith(
                   fontSize: 16,
                   fontWeight: FontWeight.bold,
                )),
                const SizedBox(height: 8),
                Text(desc, style: TextStyle(fontSize: 13, color: Colors.grey[600], height: 1.4)),
                const SizedBox(height: 16),
                
                Row(
                  children: [
                    _iconInfo(Icons.access_time, "$weeks weeks"),
                    const SizedBox(width: 12),
                    _iconInfo(Icons.people_outline, "$learners"),
                    const SizedBox(width: 12),
                    _iconInfo(Icons.star, "$rating", iconColor: Colors.orange),
                  ],
                ),
                
                const SizedBox(height: 20),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    GestureDetector(
                      onTap: () async {
                        if (showFreeTrial) {
                          await ref.read(programOverviewProvider.notifier).fetchtrialProgram(productId);
                          if (context.mounted) {
                            context.push('/menteetrialtimeline');
                          }
                        }
                      },
                      child: Text(
                        (isEnrolled || showFreeTrial) ? "Free Trial Available" : (price ?? ""),
                        style: TextStyle(
                          fontWeight: FontWeight.bold, 
                          fontSize: 15,
                          color: (isEnrolled || showFreeTrial ) ? Colors.black87 : Colors.black,
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          backgroundColor: (isEnrolled || showFreeTrial) ? AppColors.primaryDark: Colors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                            side: BorderSide(
                              color: const Color.fromARGB(255, 220, 220, 220),
                              width: 1,
                            ),
                          ),
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                        ),
                        onPressed: () async {
                          if (isEnrolled) {
                            // If enrolled, fetch program and go to dashboard
                            await ref.read(programOverviewProvider.notifier).fetchProgram(programId, productType);
                            if (context.mounted) {
                              context.push('/menteedashboard');
                            }
                          } else {
                            // If not enrolled, navigate to payment page
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => PaymentPage(
                                  programId: programId,
                                  programTitle: title,
                                  programPrice: price ?? "₹0",
                                  productId: productId,
                                  productType: productType,
                                ),
                              ),
                            );
                          }
                        },
                        child: Row(
                          children: [
                            Text((isEnrolled || showFreeTrial) ? "Continue" : "View", style: TextStyle(color: (isEnrolled || showFreeTrial)?Colors.white:Colors.black)),
                            const SizedBox(width: 8),
                             Icon(Icons.arrow_forward, size: 18, color: (isEnrolled || showFreeTrial)? Colors.white:Colors.black),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _iconInfo(IconData icon, String label, {Color iconColor = Colors.grey}) {
    return Row(
      children: [
        Icon(icon, size: 16, color: iconColor),
        const SizedBox(width: 4),
        Text(label, style: const TextStyle(fontSize: 12, color: Colors.grey)),
      ],
    );
  }
}