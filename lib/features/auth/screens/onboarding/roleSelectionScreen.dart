import 'package:buddymentor/shared/utils/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../core/constants/app_colors.dart';
import '../../../../../core/constants/app_sizes.dart';
import 'package:buddymentor/shared/widgets/buttons/app_button.dart';
import 'package:buddymentor/shared/widgets/app_bar/custom_appbar.dart';
import '../../providers/role_provider.dart';

class RoleSelectionScreen extends ConsumerStatefulWidget {
  const RoleSelectionScreen({super.key});

  @override
  ConsumerState<RoleSelectionScreen> createState() => _RoleSelectionScreenState();
}

class _RoleSelectionScreenState extends ConsumerState<RoleSelectionScreen> {
  String? selectedRole;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: "Select Your Role",
        subtitle: "Select the role that best describes\nyou to continue",
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.padding,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),

            /// ROLE GRID
            Expanded(
              child: GridView.count(
                crossAxisCount: 2,
                mainAxisSpacing: 16,
                crossAxisSpacing: 16,
                childAspectRatio: 0.95,
                children: [
                  _roleCard(
                    role: "Mentee",
                    description: "Learn with structured\nweekly guidance",
                    icon: Icons.school_outlined,
                  ),
                  _roleCard(
                    role: "Mentor",
                    description: "Guide learners\nthrough programs",
                    icon: Icons.person_outline,
                  ),
                  _roleCard(
                    role: "Industry",
                    description: "Collaborate on\nprogram insights",
                    icon: Icons.apartment_outlined,
                  ),
                  _roleCard(
                    role: "Institution",
                    description: "Monitor & manage\nmentee progress",
                    icon: Icons.home_outlined,
                  ),
                ],
              ),
            ),

            /// CONTINUE BUTTON
            AppButton(
              text: "Continue",
              onPressed: selectedRole == null
                  ? (){
                    AppToast.show(context,message:"Please select a role to continue", type: ToastType.warning);
                  }
                  : () async {
                      ref.read(roleProvider.notifier).setRole(selectedRole!);
                      await Future.microtask(() => context.push('/login'));
                    },
            ),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _roleCard({
    required String role,
    required String description,
    required IconData icon,
  }) {
    final bool isSelected = selectedRole == role;

    return GestureDetector(
      onTap: () {
        setState(() {
          selectedRole = role;
        });
      },
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: AppColors.white,
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.border,
            width: isSelected ? 1.5 : 1,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.04),
              blurRadius: 12,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ICON BOX
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFFE8EDFF),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Icon(
                icon,
                color: AppColors.primary,
                size: 22,
              ),
            ),

            const SizedBox(height: 16),

            /// ROLE TITLE
            Text(
              role,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(fontWeight: FontWeight.w500),
            ),

            const SizedBox(height: 6),

            /// DESCRIPTION
            Text(
              description,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium
                  ?.copyWith(fontSize: 13),
            ),
          ],
        ),
      ),
    );
  }
}