class State {
  final int value;
  final String name;

  State({
    required this.value,
    required this.name,
  });

  factory State.fromJson(Map<String, dynamic> json) {
    return State(
      value: json['value'],
      name: json['name'],
    );
  }
}

class Country {
  final int value;
  final String name;
  final int dialingCode;
  final List<State> states;

  Country({
    required this.value,
    required this.name,
    required this.dialingCode,
    required this.states,
  });

  factory Country.fromJson(Map<String, dynamic> json) {
    return Country(
      value: json['value'],
      name: json['name'],
      dialingCode: json['dialing_code'],
      states: (json['states'] as List)
          .map((item) => State.fromJson(item))
          .toList(),
    );
  }
}

class CountryResponse {
  final bool success;
  final String message;
  final List<Country> countries;

  CountryResponse({
    required this.success,
    required this.message,
    required this.countries,
  });

  factory CountryResponse.fromJson(Map<String, dynamic> json) {
    return CountryResponse(
      success: json['success'],
      message: json['message'],
      countries: (json['countries'] as List)
          .map((item) => Country.fromJson(item))
          .toList(),
    );
  }
}