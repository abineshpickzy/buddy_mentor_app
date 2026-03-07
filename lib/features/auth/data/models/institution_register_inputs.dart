class Mobile {
  final String? dialing_code;
  final String? number;

  Mobile({this.dialing_code, this.number});
}

class InstitutionRegisterInputs {
  final String firstName;
  final String lastName;
  final String email;
  final Mobile? mobile;
  final String message;

  InstitutionRegisterInputs({
    required this.firstName,
    required this.lastName,
    required this.email,
    this.mobile,
    required this.message,
  });
}
