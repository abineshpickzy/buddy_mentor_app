class MenteeRegisterInputs {
  final String? firstName;
  final String? lastName;
  final String? email;
  final Mobile? mobile;
  final String? password;
  final String? dateOfBirth;
  final String? proStage;
  final int? proStageId;
  final String? discipline;
  final int? disciplineId;
  final String? qualificationType;
  final int? qualificationTypeId;
  final String? country;
  final int? countryId;
  final String? state;
  final int? stateId;
  final bool? coreFoundation;
  final String? certificateNumber;
  final String? program;
  final String? programId;

  MenteeRegisterInputs({
    this.firstName,
    this.lastName,
    this.email,
    this.mobile,
    this.password,
    this.dateOfBirth,
    this.proStage,
    this.proStageId,
    this.discipline,
    this.disciplineId,
    this.qualificationType,
    this.qualificationTypeId,
    this.country,
    this.countryId,
    this.state,
    this.stateId,
    this.coreFoundation,
    this.certificateNumber,
    this.program,
    this.programId,
  });

  MenteeRegisterInputs copyWith({
    String? firstName,
    String? lastName,
    String? email,
    Mobile? mobile,
    String? password,
    String? dateOfBirth,
    String? proStage,
    int? proStageId,
    String? discipline,
    int? disciplineId,
    String? qualificationType,
    int? qualificationTypeId,
    String? country,
    int? countryId,
    String? state,
    int? stateId,
    bool? coreFoundation,
    String? certificateNumber,
    String? program,
    String? programId,
  }) {
    return MenteeRegisterInputs(
      firstName: firstName ?? this.firstName,
      lastName: lastName ?? this.lastName,
      email: email ?? this.email,
      mobile: mobile ?? this.mobile,
      password: password ?? this.password,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      proStage: proStage ?? this.proStage,
      proStageId: proStageId ?? this.proStageId,
      discipline: discipline ?? this.discipline,
      disciplineId: disciplineId ?? this.disciplineId,
      qualificationType: qualificationType ?? this.qualificationType,
      qualificationTypeId: qualificationTypeId ?? this.qualificationTypeId,
      country: country ?? this.country,
      countryId: countryId ?? this.countryId,
      state: state ?? this.state,
      stateId: stateId ?? this.stateId,
      coreFoundation: coreFoundation ?? this.coreFoundation,
      certificateNumber: certificateNumber ?? this.certificateNumber,
      program: program ?? this.program,
      programId: programId ?? this.programId,
    );
  }

  factory MenteeRegisterInputs.fromMap(Map<String, dynamic> map) {
    return MenteeRegisterInputs(
      firstName: map['firstName'],
      lastName: map['lastName'],
      email: map['email'],
      mobile: map['mobile'] != null ? Mobile.fromMap(map['mobile']) : null,
      password: map['password'],
      dateOfBirth: map['dateOfBirth'],
      proStage: map['proStage'],
      proStageId: map['proStageId'],
      discipline: map['discipline'],
      disciplineId: map['disciplineId'],
      qualificationType: map['qualificationType'],
      qualificationTypeId: map['qualificationTypeId'],
      country: map['country'],
      countryId: map['countryId'],
      state: map['state'],
      stateId: map['stateId'],
      coreFoundation: map['coreFoundation'],
      certificateNumber: map['certificateNumber'],
      program: map['program'],
      programId: map['programId'],
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
      'proStage': proStageId,
      'discipline': disciplineId,
      'qualificationType': qualificationTypeId,
      'country': countryId,
      'state': stateId,
      'coreFoundation': coreFoundation,
      'certificateNumber': certificateNumber ?? '',
      'program': programId ?? '',
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
