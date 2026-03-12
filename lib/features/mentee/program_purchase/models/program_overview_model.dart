class ProgramOverview {
  final bool success;
  final String message;
  final Product product;
  final Program program;
  final Hierarchy hierarchy;

  ProgramOverview({
    required this.success,
    required this.message,
    required this.product,
    required this.program,
    required this.hierarchy,
  });

  factory ProgramOverview.fromJson(Map<String, dynamic> json) {
    return ProgramOverview(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
      product: Product.fromJson(json['product'] ?? {}),
      program: Program.fromJson(json['program'] ?? {}),
      hierarchy: Hierarchy.fromJson(json['hierarchy'] ?? {}),
    );
  }
}

class Product {
  final String id;
  final String name;

  Product({
    required this.id,
    required this.name,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
    );
  }
}

class Program {
  final String id;
  final String name;
  final int orderNo;
  final int type;
  final bool isFreeTrial;
  final bool isEnrolled;
  final String paymentStatus;
  final String accessType;

  Program({
    required this.id,
    required this.name,
    required this.orderNo,
    required this.type,
    required this.isFreeTrial,
    required this.isEnrolled,
    required this.paymentStatus,
    required this.accessType,
  });

  factory Program.fromJson(Map<String, dynamic> json) {
    return Program(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      orderNo: json['order_no'] ?? 0,
      type: json['type'] ?? 0,
      isFreeTrial: json['is_free_trial'] ?? false,
      isEnrolled: json['is_enrolled'] ?? false,
      paymentStatus: json['payment_status'] ?? '',
      accessType: json['access_type'] ?? '',
    );
  }
}

class Hierarchy {
  final String id;
  final String name;
  final String parentId;
  final int orderNo;
  final bool menteeEngagement;
  final bool isLocked;
  final bool clickable;
  final int status;
  final List<Module> modules;

  Hierarchy({
    required this.id,
    required this.name,
    required this.parentId,
    required this.orderNo,
    required this.menteeEngagement,
    required this.isLocked,
    required this.clickable,
    required this.status,
    required this.modules,
  });

  factory Hierarchy.fromJson(Map<String, dynamic> json) {
    final List<dynamic> childrenData = json['children'] ?? [];
    final List<Module> modules = childrenData
        .map((moduleJson) => Module.fromJson(moduleJson))
        .toList();

    return Hierarchy(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      parentId: json['parent_id'] ?? '',
      orderNo: json['order_no'] ?? 0,
      menteeEngagement: json['mentee_engagement'] ?? false,
      isLocked: json['is_locked'] ?? false,
      clickable: json['clickable'] ?? false,
      status: json['status'] ?? 0,
      modules: modules,
    );
  }
}

class Module {
  final String id;
  final String name;
  final String parentId;
  final int orderNo;
  final bool menteeEngagement;
  final bool isLocked;
  final bool clickable;
  final int status;
  final List<Chapter> chapters;

  Module({
    required this.id,
    required this.name,
    required this.parentId,
    required this.orderNo,
    required this.menteeEngagement,
    required this.isLocked,
    required this.clickable,
    required this.status,
    required this.chapters,
  });

  factory Module.fromJson(Map<String, dynamic> json) {
    final List<dynamic> childrenData = json['children'] ?? [];
    final List<Chapter> chapters = childrenData
        .map((chapterJson) => Chapter.fromJson(chapterJson))
        .toList();

    return Module(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      parentId: json['parent_id'] ?? '',
      orderNo: json['order_no'] ?? 0,
      menteeEngagement: json['mentee_engagement'] ?? false,
      isLocked: json['is_locked'] ?? false,
      clickable: json['clickable'] ?? false,
      status: json['status'] ?? 0,
      chapters: chapters,
    );
  }
}

class Chapter {
  final String id;
  final String name;
  final String parentId;
  final int orderNo;
  final bool menteeEngagement;
  final bool isLocked;
  final bool clickable;
  final int status;
  final List<Session> sessions;

  Chapter({
    required this.id,
    required this.name,
    required this.parentId,
    required this.orderNo,
    required this.menteeEngagement,
    required this.isLocked,
    required this.clickable,
    required this.status,
    required this.sessions,
  });

  factory Chapter.fromJson(Map<String, dynamic> json) {
    final List<dynamic> childrenData = json['children'] ?? [];
    final List<Session> sessions = childrenData
        .map((sessionJson) => Session.fromJson(sessionJson))
        .toList();

    return Chapter(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      parentId: json['parent_id'] ?? '',
      orderNo: json['order_no'] ?? 0,
      menteeEngagement: json['mentee_engagement'] ?? false,
      isLocked: json['is_locked'] ?? false,
      clickable: json['clickable'] ?? false,
      status: json['status'] ?? 0,
      sessions: sessions,
    );
  }
}

class Session {
  final String id;
  final String name;
  final String parentId;
  final int orderNo;
  final bool menteeEngagement;
  final bool isLocked;
  final bool clickable;
  final int status;

  Session({
    required this.id,
    required this.name,
    required this.parentId,
    required this.orderNo,
    required this.menteeEngagement,
    required this.isLocked,
    required this.clickable,
    required this.status,
  });

  factory Session.fromJson(Map<String, dynamic> json) {
    return Session(
      id: json['_id'] ?? '',
      name: json['name'] ?? '',
      parentId: json['parent_id'] ?? '',
      orderNo: json['order_no'] ?? 0,
      menteeEngagement: json['mentee_engagement'] ?? false,
      isLocked: json['is_locked'] ?? false,
      clickable: json['clickable'] ?? false,
      status: json['status'] ?? 0,
    );
  }
}