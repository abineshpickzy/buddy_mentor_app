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
import '../../models/mentee_register_inputs.dart';
import 'controllers/mentee_register_controller.dart';
import 'models/country_model.dart';

class MenteeRegisterScreen extends ConsumerStatefulWidget {
  const MenteeRegisterScreen({super.key});

  @override
  ConsumerState<MenteeRegisterScreen> createState() =>
      _MenteeRegisterScreenState();
}

class _MenteeRegisterScreenState extends ConsumerState<MenteeRegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();
  final emailController = TextEditingController();
  final mobileController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final dobController = TextEditingController();
  final certificateController = TextEditingController();

  String? proStage;
  int? proStageId;
  String? country;
  String? countryCode = "+91";
  String? state;
  Country? selectedCountry;
  int? countryId;
  int? stateId;
  String? program;
  String? programId;
  String? discipline;
  int? disciplineId;
  String? qualificationType;
  int? qualificationTypeId;

  bool coreFoundation = false;

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    mobileController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    dobController.dispose();
    certificateController.dispose();
    super.dispose();
  }

  void submit() async {
    if (_formKey.currentState!.validate()) {
      final inputs = MenteeRegisterInputs(
        firstName: firstNameController.text,
        lastName: lastNameController.text,
        email: emailController.text,
        mobile: Mobile(
          dialing_code: countryCode ?? "+91",
          number: mobileController.text,
        ),
        password: passwordController.text,
        dateOfBirth: dobController.text,
        proStage: proStage,
        proStageId: proStageId,
        discipline: discipline,
        disciplineId: disciplineId,
        qualificationType: qualificationType,
        qualificationTypeId: qualificationTypeId,
        country: country,
        countryId: countryId,
        state: state,
        stateId: stateId,
        coreFoundation: coreFoundation,
        certificateNumber: certificateController.text,
        program: program,
        programId: programId,
      );

      ref.read(registerInputProvider.notifier).setMenteeRegisterInputs(inputs);

      // Call verify signup API first
      final data = {
        "email": inputs.email,
        "mobile": {
          "dialing_code": int.parse((inputs.mobile?.dialing_code ?? '+91').replaceAll('+', '')),
          "number": int.parse(inputs.mobile?.number ?? '0')
        }
      };
      
      final errorMessage = await ref.read(RegisterControllerProvider.notifier).verifySignup(data);
      
      if (errorMessage != null) {
        // ignore: use_build_context_synchronously
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
        title: "Mentee Registration",
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

              /// DOB + Pro Stage
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
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
                      ],
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: AppDropdownField(
                      label: "Pro Stage",
                      hint: "Fresher",
                      value: proStage,
                      items: const ["Fresher", "Final Year", "Industry Pro"],
                      onChanged: (val) {
                        int stageId = 1;
                        if (val == "Fresher") stageId = 1;
                        else if (val == "Final Year") stageId = 2;
                        else if (val == "Industry Pro") stageId = 3;
                        
                        setState(() {
                          proStage = val;
                          proStageId = stageId;
                        });
                      },
                      validator: Validators.dropdown,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// Discipline Dropdown
              Consumer(
                builder: (context, ref, child) {
                  final dataAsync = ref.watch(menteeRegisterControllerProvider);
                  
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

              /// Qualification Type Selection
              const Text(
                "Qualification Type",
                style: TextStyle(
                  fontWeight: FontWeight.w600,
                  fontSize: 13,
                  color: AppColors.textDark,
                ),
              ),
              const SizedBox(height: 8),
              
              /// Radio buttons for qualification type
              Row(
                children: [
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text("Degree", style: TextStyle(fontSize: 14)),
                      value: "degree",
                      groupValue: qualificationType,
                      onChanged: (value) {
                        setState(() {
                          qualificationType = value;
                          qualificationTypeId = 1; // Degree = 1
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                  Expanded(
                    child: RadioListTile<String>(
                      title: const Text("Diploma", style: TextStyle(fontSize: 14)),
                      value: "diploma",
                      groupValue: qualificationType,
                      onChanged: (value) {
                        setState(() {
                          qualificationType = value;
                          qualificationTypeId = 2; // Diploma = 2
                        });
                      },
                      contentPadding: EdgeInsets.zero,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 16),

              /// Country + State
              Consumer(
                builder: (context, ref, child) {
                  final dataAsync = ref.watch(menteeRegisterControllerProvider);
                  
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

              /// Core Foundation Toggle
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 10,
                ),
                decoration: BoxDecoration(
                  color: AppColors.lightblue,
                  border: Border.all(color: AppColors.border),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Core Foundation",
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            color: AppColors.textDark,
                          ),
                        ),
                        SizedBox(height: 4),
                        Text(
                          "Have you completed the course?",
                          style: TextStyle(fontSize: 13, color: Colors.grey),
                        ),
                      ],
                    ),
                    Switch(
                      value: coreFoundation,
                      onChanged: (val) => setState(() => coreFoundation = val),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              /// Certificate Number
              if (coreFoundation) ...[
                const Text(
                  "Certificate Number",
                  style: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontSize: 13,
                    color: AppColors.textDark,
                  ),
                ),
                const SizedBox(height: 6),
                CustomTextField(
                  controller: certificateController,
                  hint: "CF-283-X",
                  validator: coreFoundation ? (v) => v!.isEmpty ? "Certificate number is required" : null : null,
                ),
                const SizedBox(height: 16),
              ],

              /// Choose Program
              if (coreFoundation) ...[
                Consumer(
                  builder: (context, ref, child) {
                    final dataAsync = ref.watch(menteeRegisterControllerProvider);
                    
                    return dataAsync.when(
                      data: (data) => AppDropdownField(
                        label: "Choose program",
                        hint: "Search mentoring program",
                        value: program,
                        items: data.programs.map((p) => p.name).toList(),
                        onChanged: (val) {
                          final selectedProgram = data.programs.firstWhere((p) => p.name == val);
                          setState(() {
                            program = val;
                            programId = selectedProgram.id;
                          });
                        },
                        validator: coreFoundation ? Validators.dropdown : null,
                      ),
                      loading: () => AppDropdownField(
                        label: "Choose program",
                        hint: "Loading...",
                        value: null,
                        items: const [],
                        onChanged: (_) {},
                      ),
                      error: (error, stack) => AppDropdownField(
                        label: "Choose program",
                        hint: "Error loading programs",
                        value: null,
                        items: const [],
                        onChanged: (_) {},
                      ),
                    );
                  },
                ),
                const SizedBox(height: 16),
              ],

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
