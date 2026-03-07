import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:pinput/pinput.dart';
import '../../controllers/forgot_password_controller.dart';
import '../../../../../../shared/utils/app_toast.dart';
import 'package:buddymentor/shared/widgets/buttons/app_button.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_sizes.dart';

class ResetOtpScreen extends ConsumerStatefulWidget {
  final String email;
  const ResetOtpScreen({super.key, required this.email});

  @override
  ConsumerState<ResetOtpScreen> createState() => _ResetOtpScreenState();
}

class _ResetOtpScreenState extends ConsumerState<ResetOtpScreen> {
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

  void _startTimer() {
    secondsRemaining = 60;
    timer?.cancel();
    timer = Timer.periodic(const Duration(seconds: 1), (t) {
      if (secondsRemaining == 0) {
        t.cancel();
      } else {
        setState(() => secondsRemaining--);
      }
    });
  }

  String get formattedTime {
    final minutes = (secondsRemaining ~/ 60).toString().padLeft(2, '0');
    final seconds = (secondsRemaining % 60).toString().padLeft(2, '0');
    return "$minutes:$seconds";
  }

  Future<void> _resendOtp() async {
    final errorMessage = await ref.read(forgotPasswordControllerProvider.notifier).requestOtp(widget.email);
    
    if (errorMessage != null && mounted) {
      AppToast.show(context, message: errorMessage, type: ToastType.error);
    } else if (mounted) {
      AppToast.show(context, message: "OTP sent successfully!", type: ToastType.success);
    }
  }

  void _verifyOtp() async {
    if (otpCode.length != 6) {
      AppToast.show(context, message: "Please enter a valid 6-digit OTP", type: ToastType.error);
      return;
    }
    
    setState(() => isLoading = true);
    
    final errorMessage = await ref.read(forgotPasswordControllerProvider.notifier).verifyResetOtp(widget.email, otpCode);
    
    if (errorMessage != null) {
      if (mounted) {
        AppToast.show(context, message: errorMessage, type: ToastType.error);
        setState(() => isLoading = false);
      }
      return;
    }
    
    if (mounted) {
      context.push('/reset/${widget.email}');
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
                "Enter the 6-digit code sent to ${widget.email}",
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textLight,
                ),
              ),
              const SizedBox(height: 32),
              Pinput(
                length: 6,
                controller: _otpController,
                autofocus: true,
                keyboardType: TextInputType.number,
                defaultPinTheme: defaultPinTheme,
                focusedPinTheme: focusedPinTheme,
                onChanged: (value) => setState(() => otpCode = value),
                onCompleted: (value) {
                  otpCode = value;
                  _verifyOtp();
                },
              ),
              const SizedBox(height: 12),
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