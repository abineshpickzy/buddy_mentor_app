import 'package:buddymentor/shared/utils/validators.dart';
import 'package:buddymentor/shared/utils/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../shared/widgets/app_outline_button.dart';
import '../../../../shared/widgets/custom_textfield.dart';
import '../../../../shared/widgets/app_dropdown.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';

class RegisterScreen extends ConsumerStatefulWidget {
  const RegisterScreen({super.key});

  @override
  ConsumerState<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends ConsumerState<RegisterScreen> {
  final PageController _pageController = PageController();

  final _step1Key = GlobalKey<FormState>();
  final _step2Key = GlobalKey<FormState>();

  // Controllers
  final nameController = TextEditingController();
  final emailController = TextEditingController();
  final experienceController = TextEditingController();

  String? discipline;
  String? country;
  String? state;
  String? qualification;

  bool mentorOnly = false;

  @override
  void dispose() {
    _pageController.dispose();
    nameController.dispose();
    emailController.dispose();
    experienceController.dispose();
    super.dispose();
  }

  void nextPage() {
    if (_step1Key.currentState!.validate()) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 400),
        curve: Curves.easeInOut,
      );
    }
  }

  void previousPage() {
    _pageController.previousPage(
      duration: const Duration(milliseconds: 400),
      curve: Curves.easeInOut,
    );
  }

  void submit() {
    if (_step2Key.currentState!.validate()) {
      print("=== Registration Data ===");
      print("Name: ${nameController.text}");
      print("Email: ${emailController.text}");
      print("Discipline: $discipline");
      print("Country: $country");
      print("State: $state");
      print("Qualification: $qualification");
      print("Experience: ${experienceController.text}");
      print("Mentor Only: $mentorOnly");

      AppToast.show(
        context,
        message: "Registration completed successfully!",
        type: ToastType.success,
      );

      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Container(
            width: 380,
            padding: const EdgeInsets.all(AppSizes.padding),
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(16)),
            child: PageView(
              controller: _pageController,
              physics: const NeverScrollableScrollPhysics(),
              children: [_buildStep1(), _buildStep2()],
            ),
          ),
        ),
      ),
    );
  }

  // ================= STEP 1 =================

  Widget _buildStep1() {
    return SingleChildScrollView(
      child: Form(
        key: _step1Key,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
              "Step 1 of 2",
              style: TextStyle(color: AppColors.textLight),
            ),
            const SizedBox(height: 8),
            const Text(
              "Create Account",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Enter your basic details to get started",
              style: TextStyle(color: AppColors.textLight),
            ),
            const SizedBox(height: 24),

            Text("Full Name", style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 6),
            CustomTextField(
              controller: nameController,
              hint: "Enter your full name",
              validator: (v) => v!.isEmpty ? "Required" : null,
            ),

            const SizedBox(height: 16),

            Text(
              "Email or Mobile",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 6),
            CustomTextField(
              controller: emailController,
              hint: "Enter email or mobile number",
              validator: (v) => v!.isEmpty ? "Required" : null,
            ),

            const SizedBox(height: 16),

            AppDropdownField(
              label: "Discipline",
              hint: "Select discipline",
              value: discipline,
              items: const ["Engineering", "Medical", "Business"],
              onChanged: (val) => setState(() => discipline = val),
              validator: (v) => v == null ? "Required" : null,
            ),

            const SizedBox(height: 16),

            Row(
              children: [
                Expanded(
                  child: AppDropdownField(
                    label: "Country",
                    hint: "Country",
                    value: country,
                    items: const ["India", "USA", "UK"],
                    onChanged: (val) => setState(() => country = val),
                    validator: (v) => v == null ? "Required" : null,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: AppDropdownField(
                    label: "State",
                    hint: "State",
                    value: state,
                    items: const ["Tamil Nadu", "Kerala", "Karnataka"],
                    onChanged: (val) => setState(() => state = val),
                    validator: (v) => v == null ? "Required" : null,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 20),

            AppButton(text: "Continue", onPressed: nextPage),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  // ================= STEP 2 =================

  Widget _buildStep2() {
    return SingleChildScrollView(
      child: Form(
        key: _step2Key,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 10),
            const Text(
              "Step 2 of 2",
              style: TextStyle(color: AppColors.textLight),
            ),
            const SizedBox(height: 8),
            const Text(
              "Complete Profile",
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold,
                color: AppColors.textDark,
              ),
            ),
            const SizedBox(height: 4),
            const Text(
              "Additional details for your profile",
              style: TextStyle(color: AppColors.textLight),
            ),
            const SizedBox(height: 24),

            AppDropdownField(
              label: "Qualification",
              hint: "Select Qualification",
              value: qualification,
              items: const ["B.Tech", "MBA", "MBBS"],
              onChanged: (val) => setState(() => qualification = val),
              validator: (v) => v == null ? "Required" : null,
            ),

            const SizedBox(height: 16),

            Text(
              "Experience (Years)",
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 6),
            CustomTextField(
              controller: experienceController,
              hint: "eg. 3",
              validator: (v) => v!.isEmpty ? "Required" : null,
            ),

            const SizedBox(height: 12),

            Row(
              children: [
                Checkbox(
                  value: mentorOnly,
                  onChanged: (val) => setState(() => mentorOnly = val ?? false),
                ),
                const Text("Required for Mentors only"),
              ],
            ),

            const SizedBox(height: 8),

            const Text.rich(
              TextSpan(
                text: "I agree to the ",
                style: TextStyle(color: AppColors.textLight),
                children: [
                  TextSpan(
                    text: "Terms & Conditions",
                    style: TextStyle(color: Colors.blue),
                  ),
                  TextSpan(text: " and "),
                  TextSpan(
                    text: "Privacy Policy",
                    style: TextStyle(color: Colors.blue),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            AppButton(text: "Submit", onPressed: submit),

            const SizedBox(height: 12),

            AppOutlineButton(text: "Back", onPressed: previousPage),
            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }
}
