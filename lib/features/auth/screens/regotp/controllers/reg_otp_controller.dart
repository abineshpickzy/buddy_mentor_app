import 'package:buddymentor/features/auth/controllers/register_controller.dart';
import 'package:buddymentor/features/auth/providers/reg_userInput_provider.dart';
import 'package:buddymentor/features/auth/providers/role_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';


class RegOtpController extends AsyncNotifier<void> {
  @override
  Future<void> build() async {}

  Future<String?> resendOtp() async {
    state = const AsyncLoading();
    try {
      final role = ref.read(roleProvider.notifier).state;
      if (role.toLowerCase() == "mentee") {
        final menteeInputs = ref.read(registerInputProvider.notifier).state.menteeRegisterInputs;
        
        final data = {
          "email": menteeInputs.email,
          "mobile": {
            "dialing_code": int.parse(menteeInputs.mobile?.dialing_code.replaceAll('+', '') ?? '91'),
            "number": int.parse(menteeInputs.mobile?.number ?? '0')
          }
        };
        
        final errorMessage = await ref.read(RegisterControllerProvider.notifier).verifySignup(data);
        state = const AsyncData(null);
        return errorMessage;
      } else if (role.toLowerCase() == "mentor") {
        final mentorInputs = ref.read(registerInputProvider.notifier).state.mentorRegisterInputs;
        
        final data = {
          "email": mentorInputs.email,
          "mobile": {
            "dialing_code": int.parse(mentorInputs.mobile?.dialing_code.replaceAll('+', '') ?? '91'),
            "number": int.parse(mentorInputs.mobile?.number ?? '0')
          }
        };
        
        final errorMessage = await ref.read(RegisterControllerProvider.notifier).verifySignup(data);
        state = const AsyncData(null);
        return errorMessage;
      } else if (role.toLowerCase() == "industry") {
        final industryInputs = ref.read(registerInputProvider.notifier).state.industryRegisterInputs;
        
        final data = {
          "email": industryInputs.email,
          "mobile": {
            "dialing_code": int.parse((industryInputs.mobile?.dialing_code ?? '91').replaceAll('+', '')),
            "number": int.parse(industryInputs.mobile?.number ?? '0')
          }
        };
        
        final errorMessage = await ref.read(RegisterControllerProvider.notifier).verifySignup(data);
        state = const AsyncData(null);
        return errorMessage;
      } else if (role.toLowerCase() == "institution") {
        final institutionInputs = ref.read(registerInputProvider.notifier).state.institutionRegisterInputs;
        
        final data = {
          "email": institutionInputs.email,
          "mobile": {
            "dialing_code": int.parse((institutionInputs.mobile?.dialing_code ?? '91').replaceAll('+', '')),
            "number": int.parse(institutionInputs.mobile?.number ?? '0')
          }
        };
        
        final errorMessage = await ref.read(RegisterControllerProvider.notifier).verifySignup(data);
        state = const AsyncData(null);
        return errorMessage;
      }
      state = const AsyncData(null);
      return null;
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
      return 'Failed to resend OTP. Please try again.';
    }
  }

  Future<String?> verifyOtp(String otpCode) async {
    state = const AsyncLoading();
    try {
      final role = ref.read(roleProvider.notifier).state;
      if (role.toLowerCase() == "mentee") {
        final menteeInputs = ref.read(registerInputProvider.notifier).state.menteeRegisterInputs;
        
        final data = {
          "email": {
            "id": menteeInputs.email
          },
          "mobile": {
            "dialing_code": int.parse(menteeInputs.mobile?.dialing_code.replaceAll('+', '') ?? '91'),
            "number": int.parse(menteeInputs.mobile?.number ?? '0')
          },
          "first_name": menteeInputs.firstName,
          "last_name": menteeInputs.lastName,
          "password": menteeInputs.password,
          "otp": int.parse(otpCode),
          "user_type": 1,
          "discipline": menteeInputs.disciplineId,
          "country": menteeInputs.countryId,
          "state": menteeInputs.stateId,
          "dob": menteeInputs.dateOfBirth,
          "pro_stage": menteeInputs.proStageId,
          "stream": menteeInputs.qualificationTypeId,
          "has_certificate": menteeInputs.coreFoundation,
          if (menteeInputs.coreFoundation == true) "certificate_number": menteeInputs.certificateNumber,
          if (menteeInputs.coreFoundation == true) "program_id": menteeInputs.programId,
        };
        
        final errorMessage = await ref.read(RegisterControllerProvider.notifier).signup(data);
        state = const AsyncData(null);
        return errorMessage;
      } else if (role.toLowerCase() == "mentor") {
        final mentorInputs = ref.read(registerInputProvider.notifier).state.mentorRegisterInputs;
        
        final data = {
          "email": {
            "id": mentorInputs.email
          },
          "mobile": {
            "dialing_code": int.parse(mentorInputs.mobile?.dialing_code.replaceAll('+', '') ?? '91'),
            "number": int.parse(mentorInputs.mobile?.number ?? '0')
          },
          "first_name": mentorInputs.firstName,
          "last_name": mentorInputs.lastName,
          "password": mentorInputs.password,
          "otp": int.parse(otpCode),
          "user_type": 2,
          "discipline": mentorInputs.disciplineId,
          "country": mentorInputs.countryId,
          "state": mentorInputs.stateId,
          "dob": mentorInputs.dateOfBirth,
          "exp_years": int.tryParse(mentorInputs.expYears ?? '0') ?? 0,
          "experience": mentorInputs.experience,
          // "program_id": mentorInputs.programId,
        };
        
        final errorMessage = await ref.read(RegisterControllerProvider.notifier).signup(data);
        state = const AsyncData(null);
        return errorMessage;
      } else if (role.toLowerCase() == "industry") {
        final industryInputs = ref.read(registerInputProvider.notifier).state.industryRegisterInputs;
        
        final data = {
          "email": {
            "id": industryInputs.email
          },
          "mobile": {
            "dialing_code": int.parse((industryInputs.mobile?.dialing_code ?? '91').replaceAll('+', '')),
            "number": int.parse(industryInputs.mobile?.number ?? '0')
          },
          "first_name": industryInputs.firstName,
          "last_name": industryInputs.lastName,
          "otp": int.parse(otpCode),
          "user_type": 4,
          "company_name": industryInputs.companyName,
          // "website_link": industryInputs.websiteLink,
          "message": industryInputs.message,
        };
        
        final errorMessage = await ref.read(RegisterControllerProvider.notifier).signup(data);
        state = const AsyncData(null);
        return errorMessage;
      } else if (role.toLowerCase() == "institution") {
        final institutionInputs = ref.read(registerInputProvider.notifier).state.institutionRegisterInputs;
        
        final data = {
          "email": {
            "id": institutionInputs.email
          },
          "mobile": {
            "dialing_code": int.parse((institutionInputs.mobile?.dialing_code ?? '91').replaceAll('+', '')),
            "number": int.parse(institutionInputs.mobile?.number ?? '0')
          },
          "first_name": institutionInputs.firstName,
          "last_name": institutionInputs.lastName,
          "otp": int.parse(otpCode),
          "user_type": 3,
          "message": institutionInputs.message,
        };
        
        final errorMessage = await ref.read(RegisterControllerProvider.notifier).signup(data);
        state = const AsyncData(null);
        return errorMessage;
      }
      
      state = const AsyncData(null);
      return null;
    } catch (error) {
      state = AsyncError(error, StackTrace.current);
      return 'OTP verification failed. Please try again.';
    }
  }
}

final regOtpControllerProvider = AsyncNotifierProvider<RegOtpController, void>(
  RegOtpController.new,
);