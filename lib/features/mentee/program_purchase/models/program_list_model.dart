class Program {
  final String id;
  final String name;
  final String productId;
  final String productName;
  final int duration;
  final bool showFreeTrial;
  final int orderNo;
  final int type;
  final bool isEnrolled;
  final String paymentStatus;
  final String accessType;
  
  // UI fallback properties
  final String description;
  final int learners;
  final double rating;
  final String? price;
  final String tag;
  final String? imageUrl;

  Program({
    required this.id,
    required this.name,
    required this.productId,
    required this.productName,
    required this.duration,
    required this.showFreeTrial,
    required this.orderNo,
    required this.type,
    required this.isEnrolled,
    required this.paymentStatus,
    required this.accessType,
    this.description = 'Comprehensive program designed to enhance your skills and knowledge.',
    this.learners = 1000,
    this.rating = 4.5,
    this.price,
    this.tag = '',
    this.imageUrl,
  });

  factory Program.fromJson(Map<String, dynamic> json) {
    return Program(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      productId: json['product_id'] ?? '',
      productName: json['product_name'] ?? '',
      duration: json['duration'] ?? 0,
      showFreeTrial: json['show_free_trial'] ?? false,
      orderNo: json['order_no'] ?? 0,
      type: json['type'] ?? 0,
      isEnrolled: json['is_enrolled'] ?? false,
      paymentStatus: json['payment_status'] ?? 'not_started',
      accessType: json['access_type'] ?? 'none',
      description: json['description'] ?? 'Comprehensive program designed to enhance your skills and knowledge.',
      learners: json['learners'] ?? 1000,
      rating: (json['rating'] ?? 4.5).toDouble(),
      price: json['price'],
      tag: json['tag'] ?? (json['is_enrolled'] == true ? 'Enrolled' : ''),
      imageUrl: json['imageUrl'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      '_id': id,
      'name': name,
      'product_id': productId,
      'product_name': productName,
      'duration': duration,
      'show_free_trial': showFreeTrial,
      'order_no': orderNo,
      'type': type,
      'is_enrolled': isEnrolled,
      'payment_status': paymentStatus,
      'access_type': accessType,
      'description': description,
      'learners': learners,
      'rating': rating,
      'price': price,
      'tag': tag,
      'imageUrl': imageUrl,
    };
  }
  
  // Getters for UI compatibility
  String get title => name;
  int get weeks => duration;
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