import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../controllers/forgot_password_controller.dart';
import '../../../../../../shared/utils/app_toast.dart';

import '../../../../../../shared/widgets/app_button.dart';
import '../../../../../../shared/widgets/custom_textfield.dart';
import '../../../../../../shared/utils/validators.dart';
import '../../../../../../core/constants/app_sizes.dart';
import '../../../../../../core/constants/app_colors.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  final String? email;
  const ResetPasswordScreen({super.key, this.email});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState
    extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final passwordController = TextEditingController();
  final confirmController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    passwordController.dispose();
    confirmController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSizes.padding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ---------------- BACK ----------------
              GestureDetector(
                onTap: () => context.pop(),
                child: Row(
                  children: const [
                    Icon(Icons.arrow_back, size: 18),
                    SizedBox(width: 6),
                    Text(
                      "Back",
                      style: TextStyle(fontSize: 14),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // ---------------- TITLE ----------------
              const Text(
                "Reset Password",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Enter your new password",
                style: TextStyle(
                  fontSize: 14,
                  color: AppColors.textLight,
                ),
              ),

              const SizedBox(height: 32),

              // ---------------- FORM ----------------
              Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      "New Password",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),

                    CustomTextField(
                      controller: passwordController,
                      hint: "Your password must be 6-20 characters",
                      isPassword: true,
                      validator: Validators.password,
                    ),

                    const SizedBox(height: 20),

                    const Text(
                      "Confirm Password",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),

                    CustomTextField(
                      controller: confirmController,
                      hint: "Confirm new password",
                      isPassword: true,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please confirm password";
                        }
                        if (value != passwordController.text) {
                          return "Passwords do not match";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // ---------------- BUTTON ----------------
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: "Reset Password",
                  isLoading: isLoading,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() => isLoading = true);

                      final errorMessage = await ref.read(forgotPasswordControllerProvider.notifier).resetPassword(widget.email!, passwordController.text);
                      
                      if (errorMessage != null) {
                        if (mounted) {
                          AppToast.show(context, message: errorMessage, type: ToastType.error);
                          setState(() => isLoading = false);
                        }
                        return;
                      }

                      if (mounted) {
                        AppToast.show(context, message: "Password reset successfully!", type: ToastType.success);
                        context.go('/login');
                        setState(() => isLoading = false);
                      }
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}