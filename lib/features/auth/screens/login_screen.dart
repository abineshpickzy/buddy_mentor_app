import 'dart:async';
import 'package:buddymentor/core/providers/global_loading_provider.dart';
import 'package:buddymentor/features/auth/providers/role_provider.dart';
import 'package:buddymentor/shared/utils/app_toast.dart';
import '../controllers/auth_controller.dart';
import 'package:buddymentor/features/auth/data/services/auth_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:buddymentor/shared/widgets/inputs/custom_textfield.dart';
import '../../../../../shared/utils/validators.dart';
import 'package:crypto/crypto.dart';
import 'dart:convert';
import 'package:google_fonts/google_fonts.dart';

class LoginScreen extends ConsumerStatefulWidget {
  const LoginScreen({super.key});

  @override
  ConsumerState<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends ConsumerState<LoginScreen> {
  final _formKey          = GlobalKey<FormState>();
  final emailController    = TextEditingController();
  final passwordController = TextEditingController();
  final otpController      = TextEditingController();

  int    secondsRemaining = 0;
  Timer? timer;

  @override
  void dispose() {
    timer?.cancel();
    super.dispose();
  }

  String get formattedTime {
    final minutes = (secondsRemaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (secondsRemaining % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  static const _primaryBlue  = Color(0xFF2D4383);
  static const _accentBlue   = Color(0xFF4F6FD4);
  static const _borderColor  = Color(0xFFE0E5F5);

  @override
  Widget build(BuildContext context) {
    final selectedRole = ref.watch(roleProvider);

    // ✅ AnnotatedRegion for white icons on blue hero header
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: const SystemUiOverlayStyle(
        statusBarColor: Colors.transparent,
        statusBarIconBrightness: Brightness.light,  // ✅ white icons
        statusBarBrightness: Brightness.dark,        // ✅ white icons iOS
      ),
      child: Scaffold(
        backgroundColor: const Color(0xFFF8F9FE),
        body: Column(
          children: [
            _buildHeader(context),
            Expanded(
              child: SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 28),

                      _buildLabel("Email ID / Registration ID"),
                      const SizedBox(height: 8),
                      _buildFieldWrapper(
                        child: CustomTextField(
                          controller: emailController,
                          hint: "Enter your email or ID",
                          validator: Validators.email,
                        ),
                      ),

                      const SizedBox(height: 20),

                      _buildLabel("Password"),
                      const SizedBox(height: 8),
                      _buildFieldWrapper(
                        child: CustomTextField(
                          controller: passwordController,
                          hint: "Enter your password",
                          isPassword: true,
                          validator: Validators.password,
                        ),
                      ),

                      const SizedBox(height: 6),

                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton(
                          onPressed: () => context.push('/forgot'),
                          style: TextButton.styleFrom(
                            padding: EdgeInsets.zero,
                            minimumSize: const Size(0, 0),
                            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
                          ),
                          child: Text(
                            "Forgot Password?",
                            style: GoogleFonts.inter(
                              fontSize: 13,
                              color: _accentBlue,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 24),

                      _buildLoginButton(selectedRole),

                      const SizedBox(height: 24),

                      Row(
                        children: [
                          Expanded(
                              child: Divider(
                                  color: _borderColor, thickness: 1)),
                          Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 12),
                            child: Text(
                              "or",
                              style: GoogleFonts.inter(
                                fontSize: 12,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ),
                          Expanded(
                              child: Divider(
                                  color: _borderColor, thickness: 1)),
                        ],
                      ),

                      const SizedBox(height: 24),

                      Center(
                        child: GestureDetector(
                          onTap: () => context.push(
                              '/register/${selectedRole.toLowerCase()}'),
                          child: RichText(
                            text: TextSpan(
                              text: "New to BDM Master?  ",
                              style: GoogleFonts.inter(
                                color: Colors.grey.shade500,
                                fontSize: 13,
                              ),
                              children: [
                                TextSpan(
                                  text: "Register here",
                                  style: GoogleFonts.inter(
                                    color: _primaryBlue,
                                    fontWeight: FontWeight.w700,
                                    fontSize: 13,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 32),

                      Center(
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Icon(Icons.lock_outline,
                                size: 12, color: Colors.grey.shade400),
                            const SizedBox(width: 6),
                            Text(
                              "End-to-end encrypted & secure",
                              style: GoogleFonts.inter(
                                fontSize: 11.5,
                                color: Colors.grey.shade400,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(height: 32),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        color: _primaryBlue,
        borderRadius: BorderRadius.vertical(
          bottom: Radius.circular(32),
        ),
      ),
      child: SafeArea(
        bottom: false,
        child: Padding(
          padding: const EdgeInsets.fromLTRB(24, 16, 24, 32),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              GestureDetector(
                onTap: () => Navigator.of(context).maybePop(),
                child: Container(
                  width: 38,
                  height: 38,
                  decoration: BoxDecoration(
                    color: Colors.white.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 20,
                  ),
                ),
              ),

              const SizedBox(height: 24),

              Row(
                children: [
                  Container(
                    width: 42,
                    height: 42,
                    child: Image.asset('assets/images/logo.png', height: 28),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    "Buddy Mentor",
                    style: GoogleFonts.inter(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      letterSpacing: 0.3,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),

              Text(
                "Welcome Back",
                style: GoogleFonts.inter(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.w800,
                  height: 1.1,
                ),
              ),
              const SizedBox(height: 6),
              Text(
                "Sign in to continue your mentoring journey",
                style: GoogleFonts.inter(
                  color: Colors.white.withOpacity(0.7),
                  fontSize: 13.5,
                  fontWeight: FontWeight.w400,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text) {
    return Text(
      text,
      style: GoogleFonts.inter(
        fontSize: 13,
        fontWeight: FontWeight.w600,
        color: const Color(0xFF1A1A2E),
      ),
    );
  }

  Widget _buildFieldWrapper({required Widget child}) {
    return Container(
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: child,
    );
  }

  Widget _buildLoginButton(String selectedRole) {
    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: () async {
          if (_formKey.currentState!.validate()) {
            ref.read(globalLoadingProvider.notifier).show();
            try {
              final hashedPassword = md5
                  .convert(utf8.encode(passwordController.text))
                  .toString();
              final response = await AuthService.passwordLogin({
                'email': emailController.text,
                'password': hashedPassword,
              });

              if (response.statusCode == 200 &&
                  response.data['success'] == true) {
                await ref
                    .read(authControllerProvider.notifier)
                    .setAuthData(response.data);
                AppToast.show(context,
                    message: "Login successful!",
                    type: ToastType.success);

                if (mounted) {
                  final userType =
                      response.data['data']['user_profile']['user_type'] ?? 1;
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
                AppToast.show(context,
                    message: response.data['message'] ?? 'Login failed',
                    type: ToastType.error);
              }
            } catch (e) {
              AppToast.show(context,
                  message: 'Login failed. Please try again.',
                  type: ToastType.error);
            } finally {
              ref.read(globalLoadingProvider.notifier).hide();
            }
          }
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: _primaryBlue,
          foregroundColor: Colors.white,
          elevation: 0,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
        ),
        child: Text(
          "Sign In",
          style: GoogleFonts.inter(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: Colors.white,
            letterSpacing: 0.3,
          ),
        ),
      ),
    );
  }
}