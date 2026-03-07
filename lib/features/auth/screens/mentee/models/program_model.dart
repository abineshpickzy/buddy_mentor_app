class Program {
  final String id;
  final String name;

  Program({
    required this.id,
    required this.name,
  });

  factory Program.fromJson(Map<String, dynamic> json) {
    return Program(
      id: json['_id'],
      name: json['name'],
    );
  }
}