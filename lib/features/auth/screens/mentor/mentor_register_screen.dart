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
import '../../../../../../shared/widgets/app_dropdown.dart';
import '../../../../../../shared/utils/validators.dart';
import '../../models/mentor_register_inputs.dart';
import 'controllers/mentor_register_controller.dart';
import '../mentee/models/country_model.dart';

class MentorRegisterScreen extends ConsumerStatefulWidget {
  const MentorRegisterScreen({super.key});

  @override
  ConsumerState<MentorRegisterScreen> createState() =>
      _MentorRegisterScreenState();
}

class _MentorRegisterScreenState extends ConsumerState<MentorRegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final dobController = TextEditingController();
  final expYearsController = TextEditingController();
  final experienceController = TextEditingController();
  final programController = TextEditingController();

  String? country;
  String? countryCode = "+91";
  String? state;
  Country? selectedCountry;
  int? countryId;
  int? stateId;
  String? discipline;
  int? disciplineId;
  String? expYears;
  String? program;
  bool agreeTerms = false;

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    dobController.dispose();
    expYearsController.dispose();
    experienceController.dispose();
    programController.dispose();
    super.dispose();
  }

  void submit() async {
    if (_formKey.currentState!.validate()) {
      if (!agreeTerms) {
        AppToast.show(context, message: "Please agree to Terms & Conditions", type: ToastType.error);
        return;
      }
      
      final inputs = MentorRegisterInputs(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        email: emailController.text,
        mobile: Mobile(
          dialing_code: countryCode ?? "+91",
          number: mobileController.text,
        ),
        password: passwordController.text,
        dateOfBirth: dobController.text,
        discipline: discipline,
        disciplineId: disciplineId,
        country: country,
        countryId: countryId,
        state: state,
        stateId: stateId,
        expYears: expYears,
        experience: experienceController.text,
        program: program,
      );

      ref.read(registerInputProvider.notifier).setMentorRegisterInputs(inputs);

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
        title: "Mentor Registration",
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

              /// Password
              const Text(
                "Password",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 6),
              CustomTextField(
                controller: passwordController,
                hint: "Enter your password",
                isPassword: true,
                validator: Validators.password,
              ),

              const SizedBox(height: 16),

              /// Confirm Password
              const Text(
                "Confirm Password",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 6),
              CustomTextField(
                controller: confirmPasswordController,
                hint: "Confirm your password",
                isPassword: true,
                validator: (v) => Validators.confirmPassword(v, passwordController.text),
              ),

              const SizedBox(height: 16),

              /// Date of Birth
              const Text(
                "Date of Birth",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 6),
              GestureDetector(
                onTap: () async {
                  DateTime? picked = await showDatePicker(
                    context: context,
                    firstDate: DateTime(1950),
                    lastDate: DateTime.now(),
                    initialDate: DateTime.now(),
                  );
                  if (picked != null) {
                    dobController.text = "${picked.year}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}";
                  }
                },
                child: AbsorbPointer(
                  child: CustomTextField(
                    validator: (v) => v!.isEmpty ? "Required" : null,
                    controller: dobController,
                    hint: "yyyy-mm-dd",
                  ),
                ),
              ),

              const SizedBox(height: 16),

              /// Experience Years
              AppDropdownField(
                label: "Years of Experience",
                hint: "Select experience",
                value: expYears,
                items: const ["0-1", "1-3", "3-5", "5-10", "10+"],
                onChanged: (val) => setState(() => expYears = val),
                validator: Validators.dropdown,
              ),

              const SizedBox(height: 16),

              /// Discipline Dropdown
              Consumer(
                builder: (context, ref, child) {
                  final dataAsync = ref.watch(mentorRegisterControllerProvider);
                  
                  return dataAsync.when(
                    data: (data) => AppDropdownField(
                      label: "Discipline",
                      hint: "Select discipline",
                      value: discipline,
                      items: data.disciplines.map((d) => d.name).toList(),
                      onChanged: (val) {
                        final selectedDiscipline = data.disciplines.firstWhere((d) => d.name == val);
                        setState(() {
                          discipline = val;
                          disciplineId = selectedDiscipline.value;
                        });
                      },
                      validator: Validators.dropdown,
                    ),
                    loading: () => AppDropdownField(
                      label: "Discipline",
                      hint: "Loading...",
                      value: null,
                      items: const [],
                      onChanged: (_) {},
                    ),
                    error: (error, stack) => AppDropdownField(
                      label: "Discipline",
                      hint: "Error loading disciplines",
                      value: null,
                      items: const [],
                      onChanged: (_) {},
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              /// Country + State
              Consumer(
                builder: (context, ref, child) {
                  final dataAsync = ref.watch(mentorRegisterControllerProvider);
                  
                  return dataAsync.when(
                    data: (data) => Row(
                      children: [
                        Expanded(
                          child: AppDropdownField(
                            label: "Country",
                            hint: "Select country",
                            value: country,
                            items: data.countries.map((c) => c.name).toList(),
                            onChanged: (val) {
                              final selectedCountryObj = data.countries.firstWhere((c) => c.name == val);
                              setState(() {
                                country = val;
                                countryId = selectedCountryObj.value;
                                selectedCountry = selectedCountryObj;
                                state = null;
                                stateId = null;
                              });
                            },
                            validator: Validators.dropdown,
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppDropdownField(
                            label: "State",
                            hint: "Select state",
                            value: state,
                            items: selectedCountry?.states.map((s) => s.name).toList() ?? [],
                            onChanged: (val) {
                              final selectedStateObj = selectedCountry!.states.firstWhere((s) => s.name == val);
                              setState(() {
                                state = val;
                                stateId = selectedStateObj.value;
                              });
                            },
                            validator: Validators.dropdown,
                          ),
                        ),
                      ],
                    ),
                    loading: () => Row(
                      children: [
                        Expanded(
                          child: AppDropdownField(
                            label: "Country",
                            hint: "Loading...",
                            value: null,
                            items: const [],
                            onChanged: (_) {},
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppDropdownField(
                            label: "State",
                            hint: "Select country first",
                            value: null,
                            items: const [],
                            onChanged: (_) {},
                          ),
                        ),
                      ],
                    ),
                    error: (error, stack) => Row(
                      children: [
                        Expanded(
                          child: AppDropdownField(
                            label: "Country",
                            hint: "Error loading",
                            value: null,
                            items: const [],
                            onChanged: (_) {},
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: AppDropdownField(
                            label: "State",
                            hint: "Error loading",
                            value: null,
                            items: const [],
                            onChanged: (_) {},
                          ),
                        ),
                      ],
                    ),
                  );
                },
              ),

              const SizedBox(height: 16),

              /// Experience Description
              const Text(
                "Experience Description",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 6),
              CustomTextField(
                controller: experienceController,
                hint: "Describe your experience...",
                maxLines: 4,
                validator: (v) => v!.isEmpty ? "Required" : null,
              ),

              const SizedBox(height: 16),

              /// Program
              AppDropdownField(
                label: "Program",
                hint: "Select program",
                value: program,
                items: const [
                  "EPC CORE FOUNDATION",
                  "CIVIL CORE FOUNDATION",
                  "MECH CORE FOUNDATION",
                  "ECE CORE FOUNDATION",
                  "CSE CORE FOUNDATION"
                ],
                onChanged: (val) => setState(() => program = val),
                validator: Validators.dropdown,
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
              Consumer(
                builder: (context, ref, child) {
                  return AppButton(
                    text: "SignUp & Verify",
                    onPressed: () => submit(),
                  );
                },
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }
}