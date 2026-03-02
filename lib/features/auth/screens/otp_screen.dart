import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../shared/widgets/app_button.dart';
import '../../../../core/constants/app_colors.dart';
import '../../../../core/constants/app_sizes.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

class OtpScreen extends StatefulWidget {
  final String? email;
  const OtpScreen({super.key, this.email});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
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

  // ---------------- VERIFY ----------------
  Future<void> _verifyOtp() async {
    if (otpCode.length != 6) return;

    setState(() => isLoading = true);

    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      context.push('/verified');
    }

    if (mounted) {
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

    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Center(
          child: Container(
            width: 380,
            padding: const EdgeInsets.all(AppSizes.padding),
            decoration: BoxDecoration(
              color: AppColors.white,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                const SizedBox(height: 20),

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
                  textAlign: TextAlign.center,
                  style: const TextStyle(
                    color: AppColors.textLight,
                  ),
                ),

                const SizedBox(height: 30),

                // ---------------- OTP FIELD ----------------
                PinCodeTextField(
                  appContext: context,
                  controller: _otpController,
                  length: 6,
                  keyboardType: TextInputType.number,
                  autoFocus: true,
                enableActiveFill: true,
                  enablePinAutofill: true, // SMS AutoFill
                  animationType: AnimationType.fade,
                  animationDuration:
                      const Duration(milliseconds: 200),
                  cursorColor: AppColors.primary,
                  textStyle: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.w600,
                  ),
                  pinTheme: PinTheme(
                    shape: PinCodeFieldShape.box,
                    borderRadius: BorderRadius.circular(10),
                    fieldHeight: 55,
                    fieldWidth: 45,
                    inactiveColor: AppColors.border,
                    selectedColor: AppColors.primary,
                    activeColor: AppColors.primary,
                    activeFillColor: AppColors.white,
                    selectedFillColor:
                        AppColors.primary.withOpacity(0.05),
                    inactiveFillColor: AppColors.white,
                  ),
                  onChanged: (value) {
                    setState(() => otpCode = value);
                  },
                  onCompleted: (value) {
                    otpCode = value;
                    _verifyOtp(); // Auto submit
                  },
                ),

                const SizedBox(height: 12),

                // ---------------- TIMER / RESEND ----------------
                secondsRemaining > 0
                    ? Text(
                        "Resend code in $formattedTime",
                        style: const TextStyle(
                          color: AppColors.textLight,
                        ),
                      )
                    : TextButton(
                        onPressed: () {
                          _otpController.clear();
                          setState(() => otpCode = "");
                          _startTimer();
                          // Call resend API here
                        },
                        child: const Text(
                          "Resend Code",
                          style: TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),

                const SizedBox(height: 30),

                // ---------------- CONTINUE BUTTON ----------------
                Opacity(
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
              ],
            ),
          ),
        ),
      ),
    );
  }
}
