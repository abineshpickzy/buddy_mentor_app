class Discipline {
  final int value;
  final String name;

  Discipline({
    required this.value,
    required this.name,
  });

  factory Discipline.fromJson(Map<String, dynamic> json) {
    return Discipline(
      value: json['value'],
      name: json['name'],
    );
  }
}

class DisciplineResponse {
  final bool success;
  final String message;
  final List<Discipline> disciplines;

  DisciplineResponse({
    required this.success,
    required this.message,
    required this.disciplines,
  });

  factory DisciplineResponse.fromJson(Map<String, dynamic> json) {
    return DisciplineResponse(
      success: json['success'],
      message: json['message'],
      disciplines: (json['discplines'] as List)
          .map((item) => Discipline.fromJson(item))
          .toList(),
    );
  }
}