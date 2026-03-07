import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../core/constants/app_colors.dart';

class PasswordResetedScreen extends StatelessWidget {
  const PasswordResetedScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [

              /// Center Content
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [

                    /// Lock Icon
                    Container(
                      height: 90,
                      width: 90,
                      decoration: BoxDecoration(
                        color: AppColors.lightblue,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.lock_outline_rounded,
                        size: 45,
                        color: AppColors.primary,
                      ),
                    ),

                    const SizedBox(height: 24),

                    /// Title
                    const Text(
                      "Password Reset",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: AppColors.textDark,
                      ),
                    ),

                    const SizedBox(height: 8),

                    /// Subtitle
                    const Text(
                      "Sign in to continue your mentoring journey",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: AppColors.textDark,
                      ),
                    ),

                  SizedBox(height: 32),
                    /// Bottom Button
              Padding(
                padding: const EdgeInsets.only(bottom: 24),
                child: AppButton(
                  text: "Back to Login",
                  onPressed: () {
                    context.push('/login'); // change if needed
                  },
                ),
              ),
                  ],
                ),
              ),

              
            ],
          ),
        ),
      ),
    );
  }
}