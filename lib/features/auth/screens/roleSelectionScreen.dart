import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import '../../../shared/utils/app_toast.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/role_provider.dart';

class RoleSelectionScreen extends ConsumerStatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  ConsumerState<RoleSelectionScreen> createState() =>
      _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends ConsumerState<RoleSelectionScreen> {
  final List<Map<String, dynamic>> roles = [
    {
      "title": "Mentee",
      "subtitle": "Learn with structured weekly guidance",
      "icon": Icons.school_outlined,
    },
    {
      "title": "Mentor",
      "subtitle": "Guide learners through programs",
      "icon": Icons.person_outline,
    },
    {
      "title": "Industry",
      "subtitle": "Collaborate on program insights",
      "icon": Icons.apartment_outlined,
    },
    {
      "title": "Institution",
      "subtitle": "Monitor & manage mentee progress",
      "icon": Icons.home_work_outlined,
    },
  ];

  @override
  Widget build(BuildContext context) {
    final selectedRole = ref.watch(roleProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Padding(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 60),

            Text(
              "BDM Master",
              style: Theme.of(
                context,
              ).textTheme.headlineMedium?.copyWith(fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 10),

            Text(
              "Choose how you'll use the platform",
              style: Theme.of(context).textTheme.bodyMedium,
            ),

            const SizedBox(height: 30),

            /// Grid
            Expanded(
              child: GridView.builder(
                itemCount: roles.length,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 16,
                  childAspectRatio: 0.9,
                ),
                itemBuilder: (context, index) {
                  final role = roles[index];

                  final isSelected = selectedRole == role["title"];

                  return GestureDetector(
                    onTap: () {
                      ref.read(roleProvider.notifier).setRole(role["title"]);
                    },
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(
                          color: isSelected
                              ? AppColors.primary
                              : Colors.transparent,
                          width: 2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: const Offset(0, 5),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: const Color(0xFFE8EDFF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Icon(role["icon"], color: AppColors.primary),
                          ),
                          const SizedBox(height: 20),
                          Text(
                            role["title"],
                            style: Theme.of(context).textTheme.headlineSmall,
                          ),
                          const SizedBox(height: 6),
                          Text(
                            role["subtitle"],
                            style: Theme.of(
                              context,
                            ).textTheme.bodyMedium?.copyWith(fontSize: 12),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),

            /// Continue Button
            AppButton(
              text: "Continue",
              onPressed: selectedRole == ""
                  ? () {
                      AppToast.show(
                        context,
                        message: "Please select a role!",
                        type: ToastType.warning,
                      );
                    }
                  : () {
                      print("Selected Role: $selectedRole");
                      context.push('/login', extra: selectedRole);
                    },
              isLoading: false,
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
