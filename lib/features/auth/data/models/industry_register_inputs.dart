class Mobile {
  final String? dialing_code;
  final String? number;

  Mobile({this.dialing_code, this.number});
}

class IndustryRegisterInputs {
  final String firstName;
  final String lastName;
  final String email;
  final Mobile? mobile;
  final String companyName;
  final String websiteLink;
  final String message;

  IndustryRegisterInputs({
    required this.firstName,
    required this.lastName,
    required this.email,
    this.mobile,
    required this.companyName,
    required this.websiteLink,
    required this.message,
  });
}
