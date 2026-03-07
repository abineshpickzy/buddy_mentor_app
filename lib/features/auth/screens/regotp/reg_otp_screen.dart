import 'dart:async';
import 'package:buddymentor/shared/utils/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import 'package:buddymentor/shared/widgets/buttons/app_button.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_sizes.dart';
import '../../providers/role_provider.dart';
import 'controllers/reg_otp_controller.dart';

class OtpScreen extends ConsumerStatefulWidget {
  final String? email;
  const OtpScreen({super.key, this.email});

  @override
  ConsumerState<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends ConsumerState<OtpScreen> {
  final TextEditingController _otpController = TextEditingController();
  

  String otpCode = "";
  bool isLoading = false;

  int secondsRemaining = 60;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  // ---------------- TIMER ----------------
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

  // ---------------- RESEND OTP ----------------
  Future<void> _resendOtp() async {
    final errorMessage = await ref.read(regOtpControllerProvider.notifier).resendOtp();
    
    if (errorMessage != null && mounted) {
      AppToast.show(context, message: errorMessage, type: ToastType.error);
    } else if (mounted) {
      AppToast.show(context, message: "OTP sent successfully!", type: ToastType.success);
    }
  }

  // ---------------- VERIFY OTP ----------------
  void _verifyOtp() async {
    if (otpCode.length != 6) {
      AppToast.show(context, message: "Please enter a valid 6-digit OTP", type: ToastType.error);
      return;
    }
    
    setState(() => isLoading = true);
    
    final errorMessage = await ref.read(regOtpControllerProvider.notifier).verifyOtp(otpCode);
    
    if (errorMessage != null) {
      if (mounted) {
        AppToast.show(context, message: errorMessage, type: ToastType.error);
        setState(() => isLoading = false);
      }
      return;
    }
    
    // Success case - signup completed successfully
    if (mounted) {
      AppToast.show(context, message: "Registration successful!", type: ToastType.success);
      
      final role = ref.read(roleProvider);
      String dashboardRoute;
      switch (role.toLowerCase()) {
        case "mentee":
          dashboardRoute = '/menteedashboard';
          break;
        case "mentor":
          dashboardRoute = '/mentordashboard';
          break;
        case "institution":
          dashboardRoute = '/institutiondashboard';
          break;
        case "industry":
          dashboardRoute = '/industrydashboard';
          break;
        default:
          dashboardRoute = '/menteedashboard';
      }
      context.go(dashboardRoute);
      
      setState(() => isLoading = false);
    }
  }
   
     


  @override
  void dispose() {
    timer?.cancel();
    _otpController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final bool isButtonEnabled = otpCode.length == 6 && !isLoading;

    final defaultPinTheme = PinTheme(
      width: 50,
      height: 55,
      textStyle: const TextStyle(
        fontSize: 18,
        fontWeight: FontWeight.w600,
        color: AppColors.textDark,
      ),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.border),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyWith(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: AppColors.primary),
      ),
    );

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
                child: const Row(
                  children: [
                    Icon(Icons.arrow_back, size: 18),
                    SizedBox(width: 6),
                    Text("Back", style: TextStyle(fontSize: 14)),
                  ],
                ),
              ),

              const SizedBox(height: 40),

              // ---------------- TITLE ----------------
              const Text(
                "Verify OTP",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textDark,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "Enter the 6-digit code sent to ${widget.email ?? "your email or mobile"}",
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textLight,
                ),
              ),

              const SizedBox(height: 32),

              // ---------------- OTP FIELD ----------------
              Pinput(
                length: 6,
                controller: _otpController,
                autofocus: true,
                keyboardType: TextInputType.number,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                onChanged: (value) {
                  setState(() => otpCode = value);
                },
                onCompleted: (value) {
                  otpCode = value;
                  _verifyOtp();
                },
              ),

              const SizedBox(height: 12),

              // ---------------- TIMER / RESEND ----------------
              secondsRemaining > 0
                  ? Text(
                      "Resend code in $formattedTime",
                      style: const TextStyle(color: AppColors.textLight),
                    )
                  : TextButton(
                      onPressed: () {
                        _otpController.clear();
                        setState(() => otpCode = "");
                        _startTimer();
                        _resendOtp();
                      },
                      child: const Text(
                        "Don't receive code? Resend",
                        style: TextStyle(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),

              const Spacer(),

              // ---------------- CONTINUE BUTTON ----------------
              SizedBox(
                width: double.infinity,
                child: Opacity(
                  opacity: isButtonEnabled ? 1 : 0.5,
                  child: IgnorePointer(
                    ignoring: !isButtonEnabled,
                    child: AppButton(
                      text: "Continue",
                      isLoading: isLoading,
                      onPressed: _verifyOtp,
                    ),
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
