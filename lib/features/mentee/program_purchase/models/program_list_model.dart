class Program {
  final String id;
  final String title;
  final String description;
  final int weeks;
  final int learners;
  final double rating;
  final String? price;
  final String tag;
  final bool isEnrolled;
  final String? imageUrl;

  Program({
    required this.id,
    required this.title,
    required this.description,
    required this.weeks,
    required this.learners,
    required this.rating,
    this.price,
    this.tag = '',
    this.isEnrolled = false,
    this.imageUrl,
  });

  factory Program.fromJson(Map<String, dynamic> json) {
    return Program(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      weeks: json['weeks'] ?? 0,
      learners: json['learners'] ?? 0,
      rating: (json['rating'] ?? 0.0).toDouble(),
      price: json['price'],
      tag: json['tag'] ?? '',
      isEnrolled: json['isEnrolled'] ?? false,
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'weeks': weeks,
      'learners': learners,
      'rating': rating,
      'price': price,
      'tag': tag,
      'isEnrolled': isEnrolled,
      'imageUrl': imageUrl,
    };
  }
}

class ProgramStats {
  final int totalPrograms;
  final String activeLearners;
  final double avgRating;

  ProgramStats({
    required this.totalPrograms,
    required this.activeLearners,
    required this.avgRating,
  });

  factory ProgramStats.fromJson(Map<String, dynamic> json) {
    return ProgramStats(
      totalPrograms: json['totalPrograms'] ?? 0,
      activeLearners: json['activeLearners'] ?? '0',
      avgRating: (json['avgRating'] ?? 0.0).toDouble(),
    );
  }
}