class MentorRegisterInputs {
  final String? firstName;
  final String? lastName;
  final String? email;
  final Mobile? mobile;
  final String? password;
  final String? dateOfBirth;
  final String? discipline;
  final int? disciplineId;
  final String? country;
  final int? countryId;
  final String? state;
  final int? stateId;
  final String? expYears;
  final String? experience;
  final String? program;

  MentorRegisterInputs({
    this.firstName,
    this.lastName,
    this.email,
    this.mobile,
    this.password,
    this.dateOfBirth,
    this.discipline,
    this.disciplineId,
    this.country,
    this.countryId,
    this.state,
    this.stateId,
    this.expYears,
    this.experience,
    this.program,
  });

  MentorRegisterInputs copyWith({
    String? firstName,
    String? lastName,
    String? email,
    Mobile? mobile,
    String? password,
    String? dateOfBirth,
    String? discipline,
    int? disciplineId,
    String? country,
    int? countryId,
    String? state,
    int? stateId,
    String? expYears,
    String? experience,
    String? program,
  }) {
    return MentorRegisterInputs(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      password: password ?? this.password,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      discipline: discipline ?? this.discipline,
      disciplineId: disciplineId ?? this.disciplineId,
      country: country ?? this.country,
      countryId: countryId ?? this.countryId,
      state: state ?? this.state,
      stateId: stateId ?? this.stateId,
      expYears: expYears ?? this.expYears,
      experience: experience ?? this.experience,
      program: program ?? this.program,
    );
  }

  factory MentorRegisterInputs.fromMap(Map<String, dynamic> map) {
    return MentorRegisterInputs(
      firstName: map['firstName'],
      lastName: map['lastName'],
      email: map['email'],
      mobile: map['mobile'] != null ? Mobile.fromMap(map['mobile']) : null,
      password: map['password'],
      dateOfBirth: map['dateOfBirth'],
      discipline: map['discipline'],
      disciplineId: map['disciplineId'],
      country: map['country'],
      countryId: map['countryId'],
      state: map['state'],
      stateId: map['stateId'],
      expYears: map['expYears'],
      experience: map['experience'],
      program: map['program'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'mobile': mobile?.toMap(),
      'password': password,
      'dateOfBirth': dateOfBirth,
      'discipline': disciplineId,
      'country': countryId,
      'state': stateId,
      'expYears': expYears,
      'experience': experience,
      'program': program,
    };
  }
}

class Mobile {
  final String dialing_code;
  final String number;

  Mobile({required this.dialing_code, required this.number});

  factory Mobile.fromMap(Map<String, dynamic> map) {
    return Mobile(
      dialing_code: map['dialing_code'],
      number: map['number'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'dialing_code': dialing_code,
      'number': number,
    };
  }
}