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

class ForgotPasswordScreen extends ConsumerStatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  ConsumerState<ForgotPasswordScreen> createState() =>
      _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState
    extends ConsumerState<ForgotPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  bool isLoading = false;

  @override
  void dispose() {
    emailController.dispose();
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
                "Forgot your password ?",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),

              const SizedBox(height: 8),

              const Text(
                "Enter your registered email or mobile to reset your password",
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
                      "Email or Mobile Number",
                      style: TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),

                    CustomTextField(
                      controller: emailController,
                      hint: "Enter registered email or mobile",
                      validator: Validators.email,
                    ),
                  ],
                ),
              ),

              const Spacer(),

              // ---------------- BUTTON ----------------
              SizedBox(
                width: double.infinity,
                child: AppButton(
                  text: "Send reset Link",
                  isLoading: isLoading,
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      setState(() => isLoading = true);

                      final errorMessage = await ref.read(forgotPasswordControllerProvider.notifier).requestOtp(emailController.text);
                      
                      if (errorMessage != null) {
                        if (mounted) {
                          AppToast.show(context, message: errorMessage, type: ToastType.error);
                          setState(() => isLoading = false);
                        }
                        return;
                      }

                      if (mounted) {
                        context.push('/resetotp/${emailController.text}');
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