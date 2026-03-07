import 'package:buddymentor/features/auth/data/models/mentee_register_inputs.dart';
import 'package:buddymentor/features/auth/data/models/mentor_register_inputs.dart';
import 'package:buddymentor/features/auth/data/models/industry_register_inputs.dart';
import 'package:buddymentor/features/auth/data/models/institution_register_inputs.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class RegisterState{
    MenteeRegisterInputs menteeRegisterInputs;
    MentorRegisterInputs mentorRegisterInputs;
    IndustryRegisterInputs industryRegisterInputs;
    InstitutionRegisterInputs institutionRegisterInputs;

  RegisterState({
    required this.menteeRegisterInputs,
    required this.mentorRegisterInputs,
    required this.industryRegisterInputs,
    required this.institutionRegisterInputs,
});
}

class RegisterInputNotifier extends Notifier<RegisterState> {
  @override
  RegisterState build() {
    return RegisterState(
      menteeRegisterInputs: MenteeRegisterInputs(),
      mentorRegisterInputs: MentorRegisterInputs(),
      industryRegisterInputs: IndustryRegisterInputs(
        firstName: '',
        lastName: '',
        email: '',
        companyName: '',
        websiteLink: '',
        message: '',
      ),
      institutionRegisterInputs: InstitutionRegisterInputs(
        firstName: '',
        lastName: '',
        email: '',
        message: '',
      ),
    );
  }

  setMenteeRegisterInputs(MenteeRegisterInputs inputs) {
    state = RegisterState(
      menteeRegisterInputs: inputs,
      mentorRegisterInputs: state.mentorRegisterInputs,
      industryRegisterInputs: state.industryRegisterInputs,
      institutionRegisterInputs: state.institutionRegisterInputs,
    );
    print("Updated mentee inputs: ${state.menteeRegisterInputs.toMap()}");
  }

  setMentorRegisterInputs(MentorRegisterInputs inputs) {
    state = RegisterState(
      menteeRegisterInputs: state.menteeRegisterInputs,
      mentorRegisterInputs: inputs,
      industryRegisterInputs: state.industryRegisterInputs,
      institutionRegisterInputs: state.institutionRegisterInputs,
    );
  }

  setIndustryRegisterInputs(IndustryRegisterInputs inputs) {
    state = RegisterState(
      menteeRegisterInputs: state.menteeRegisterInputs,
      mentorRegisterInputs: state.mentorRegisterInputs,
      industryRegisterInputs: inputs,
      institutionRegisterInputs: state.institutionRegisterInputs,
    );
  }

  setInstitutionRegisterInputs(InstitutionRegisterInputs inputs) {
    state = RegisterState(
      menteeRegisterInputs: state.menteeRegisterInputs,
      mentorRegisterInputs: state.mentorRegisterInputs,
      industryRegisterInputs: state.industryRegisterInputs,
      institutionRegisterInputs: inputs,
    );
  }

}

final registerInputProvider = NotifierProvider<RegisterInputNotifier, RegisterState>(
  RegisterInputNotifier.new,
);
