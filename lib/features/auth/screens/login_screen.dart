import 'dart:async';

import 'package:buddymentor/core/providers/global_loading_provider.dart';
import 'package:buddymentor/features/auth/providers/role_provider.dart';
import 'package:buddymentor/shared/utils/app_toast.dart';
import '../controllers/auth_controller.dart';
import 'package:buddymentor/features/auth/data/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:buddymentor/shared/widgets/buttons/app_button.dart';
import 'package:buddymentor/shared/widgets/app_bar/custom_appbar.dart';
import 'package:buddymentor/shared/widgets/inputs/custom_textfield.dart';
import '../../../../../shared/utils/validators.dart';
import '../../../../../core/constants/app_colors.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';


class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final otpController = TextEditingController();

  int secondsRemaining = 0;
  Timer? timer;
 

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  void _startTimer() {
    secondsRemaining = 60;
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsRemaining == 0) {
        t.cancel();
      } else {
        setState(() {
          secondsRemaining--;
        });
      }
    });
  }

  String get formattedTime {
    final minutes = (secondsRemaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (secondsRemaining % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  @override
  Widget build(BuildContext context) {
    final selectedRole = ref.watch(roleProvider);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: "Welcome Back",
        subtitle: "Sign into continue your mentoring journey",
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              /// EMAIL LABEL
              const Text(
                "Email ID/ Registration ID",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),

              const SizedBox(height: 8),

              CustomTextField(
                controller: emailController,
                hint: "Email ID/ Registration ID",
                validator: Validators.email,
              ),

              const SizedBox(height: 20),

              /// PASSWORD LABEL
              const Text(
                "Password",
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                ),
              ),

              const SizedBox(height: 8),

              CustomTextField(
                controller: passwordController,
                hint: "Password",
                isPassword: true,
                validator: Validators.password,
              ),

              const SizedBox(height: 6),

              /// FORGOT PASSWORD
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () => context.push('/forgot'),
                  style: TextButton.styleFrom(
                    padding: EdgeInsets.zero,
                    minimumSize: const Size(0, 0),
                    tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                  ),
                  child: const Text(
                    "Forget Password?",
                    style: TextStyle(fontSize: 13, color: AppColors.secondary),
                  ),
                ),
              ),

              const SizedBox(height: 18),
              
              /// LOGIN BUTTON
              AppButton(
                text: "Login",
                onPressed: () async {
                  if (_formKey.currentState!.validate()) {
                    ref.read(globalLoadingProvider.notifier).show();
                    try {
                      final hashedPassword = md5.convert(utf8.encode(passwordController.text)).toString();
                      final response = await AuthService.passwordLogin({
                        'email': emailController.text,
                        'password': hashedPassword, 
                      });
                      
                      if (response.statusCode == 200 && response.data['success'] == true) {
                        await ref.read(authControllerProvider.notifier).setAuthData(response.data);
                        AppToast.show(context, message: "Login successful!", type: ToastType.success);
                        
                        if (mounted) {
                          final userType = response.data['data']['user_profile']['user_type'] ?? 1;
                          String dashboardRoute;
                          switch (userType) {
                            case 1:
                              dashboardRoute = '/programlist';
                              break;
                            case 2:
                              dashboardRoute = '/mentordashboard';
                              break;
                            case 3:
                              dashboardRoute = '/institutiondashboard';
                              break;
                            case 4:
                              dashboardRoute = '/industrydashboard';
                              break;
                            default:
                              dashboardRoute = '/programlist';
                          }
                          context.go(dashboardRoute);
                        }
                      } else {
                        AppToast.show(context, message: response.data['message'] ?? 'Login failed', type: ToastType.error);
                      }
                    } catch (e) {
                      AppToast.show(context, message: 'Login failed. Please try again.', type: ToastType.error);
                    } finally {
                      ref.read(globalLoadingProvider.notifier).hide();
                    }
                  }
                },
              ),

              const SizedBox(height: 22),
              /// REGISTER
              Center(
                child: GestureDetector(
                  onTap: () =>
                      context.push('/register/${selectedRole.toLowerCase()}'),
                  child: RichText(
                    text: const TextSpan(
                      text: "New to BDM Master? ",
                      style: TextStyle(
                        color: AppColors.textLight,
                        fontSize: 13,
                      ),
                      children: [
                        TextSpan(
                          text: "Register here",
                          style: TextStyle(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),

              const SizedBox(height: 40),

              /// BOTTOM TEXT
              Center(
                child: Text(
                  "Your data is protected with end-to-end encryption",
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    fontSize: 12,
                    color: AppColors.textLight,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
