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

  Module({
    required this.id,
    required this.moduleName,
    required this.chapters,
  });
}

class Chapter {
  final String id;
  final String title;

  Chapter({
    required this.id,
    required this.title,
  });
}