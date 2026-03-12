class Subject {
  final String subject;
  final List<Module> modules;

  Subject({
    required this.subject,
    required this.modules,
  });
}

class Module {
  final String id;
  final String moduleName;
  final List<Chapter> chapters;
  final int status; // 0=locked, 1=in_progress, 2=completed
  final bool isLocked;

  Module({
    required this.id,
    required this.moduleName,
    required this.chapters,
    this.status = 0,
    this.isLocked = false,
  });
}

class Chapter {
  final String id;
  final String title;
  final int status; // 0=locked, 1=in_progress, 2=completed
  final bool isLocked;

  Chapter({
    required this.id,
    required this.title,
    this.status = 0,
    this.isLocked = false,
  });
}