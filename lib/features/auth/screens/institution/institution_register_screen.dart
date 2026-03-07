import 'package:buddymentor/features/auth/providers/reg_userInput_provider.dart';
import '../../controllers/register_controller.dart';
import 'package:buddymentor/shared/utils/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../../../core/constants/app_colors.dart';
import '../../../../../../core/constants/app_sizes.dart';
import '../../../../../../shared/widgets/app_button.dart';
import '../../../../../../shared/widgets/custom_appbar.dart';
import '../../../../../../shared/widgets/custom_textfield.dart';
import '../../../../../../shared/utils/validators.dart';
import '../../models/institution_register_inputs.dart';

class InstitutionRegisterScreen extends ConsumerStatefulWidget {
  const InstitutionRegisterScreen({super.key});

  @override
  ConsumerState<InstitutionRegisterScreen> createState() =>
      _InstitutionRegisterScreenState();
}

class _InstitutionRegisterScreenState extends ConsumerState<InstitutionRegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final messageController = TextEditingController();

  String? countryCode = "+91";
  bool agreeTerms = false;

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    messageController.dispose();
    super.dispose();
  }

  void submit() async {
    if (_formKey.currentState!.validate()) {
      if (!agreeTerms) {
        AppToast.show(context, message: "Please agree to Terms & Conditions", type: ToastType.error);
        return;
      }
      
      final inputs = InstitutionRegisterInputs(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        email: emailController.text,
        mobile: Mobile(
          dialing_code: countryCode ?? "+91",
          number: mobileController.text,
        ),
        message: messageController.text,
      );

      ref.read(registerInputProvider.notifier).setInstitutionRegisterInputs(inputs);

      // Call verify signup API first
      final data = {
        "email": inputs.email,
        "mobile": {
          "dialing_code": int.parse(inputs.mobile?.dialing_code?.replaceAll('+', '') ?? '91'),
          "number": int.parse(inputs.mobile?.number ?? '0')
        }
      };
      
      final errorMessage = await ref.read(RegisterControllerProvider.notifier).verifySignup(data);
      
      if (errorMessage != null) {
        AppToast.show(context, message: errorMessage, type: ToastType.error);
        return;
      }
      
      // Only navigate to OTP if verify signup is successful
      if (mounted) {
        context.push('/otp/${emailController.text}', extra: {
          "type": "register"
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const CustomAppBar(
        title: "Institution Registration",
        subtitle: "Enter your details to get started",
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSizes.padding),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// First Name
              const Text(
                "First Name",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 6),
              CustomTextField(
                controller: firstNameController,
                hint: "Enter your first name",
                validator: Validators.name,
              ),

              const SizedBox(height: 16),

              /// Last Name
              const Text(
                "Last Name",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 6),
              CustomTextField(
                controller: lastNameController,
                hint: "Enter your last name",
                validator: Validators.name,
              ),

              const SizedBox(height: 16),

              /// Email
              const Text(
                "Email Address",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 6),
              CustomTextField(
                controller: emailController,
                hint: "Enter your email address",
                validator: Validators.email,
              ),

              const SizedBox(height: 16),

              /// Mobile Number
              const Text(
                "Mobile Number",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    width: 80,
                    child: DropdownButtonFormField<String>(
                      value: countryCode,
                      onChanged: (val) => setState(() => countryCode = val),
                      isExpanded: true,
                      hint: const Text("+91", style: TextStyle(color: AppColors.textLight, fontSize: 14)),
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: AppColors.white,
                        contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.border, width: 1),
                        ),
                        focusedBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(12),
                          borderSide: const BorderSide(color: AppColors.primary, width: 1.5),
                        ),
                      ),
                      items: ["+91"].map((String code) {
                        return DropdownMenuItem<String>(
                          value: code,
                          child: Text(code, style: const TextStyle(fontSize: 14, color: AppColors.textDark)),
                        );
                      }).toList(),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: CustomTextField(
                      controller: mobileController,
                      hint: "1234567890",
                      validator: Validators.mobile,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// Message
              const Text(
                "Write a message here",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 6),
              CustomTextField(
                controller: messageController,
                hint: "Write your message...",
                maxLines: 4,
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),

              const SizedBox(height: 16),

              /// Terms Checkbox
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Checkbox(
                    value: agreeTerms,
                    onChanged: (val) => setState(() => agreeTerms = val ?? false),
                  ),
                  const Expanded(
                    child: Text.rich(
                      TextSpan(
                        text: "I agree to the ",
                        children: [
                          TextSpan(
                            text: "Terms & Conditions",
                            style: TextStyle(color: AppColors.primary),
                          ),
                          TextSpan(text: " and "),
                          TextSpan(
                            text: "Privacy Policy",
                            style: TextStyle(color: AppColors.primary),
                          ),
                        ],
                      ),
                      style: TextStyle(fontSize: 13),
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 30),

              /// Button
              AppButton(
                text: "SignUp & Verify",
                onPressed: () => submit(),
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}