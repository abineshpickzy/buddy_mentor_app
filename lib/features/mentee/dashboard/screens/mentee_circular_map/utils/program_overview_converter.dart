import 'package:buddymentor/features/mentee/program_purchase/models/program_overview_model.dart' hide Chapter, Module;

import '../models/learning_map_models.dart';


class ProgramOverviewConverter {
  static Subject convertToSubject(ProgramOverview programOverview) {
    final modules = programOverview.hierarchy.modules.map((moduleData) {
      final chapters = moduleData.chapters.map((chapterData) {
        return Chapter(
          id: chapterData.id,
          title: chapterData.name,
          status: chapterData.status,
          isLocked: chapterData.isLocked,
        );
      }).toList();

      return Module(
        id: moduleData.id,
        moduleName: moduleData.name,
        chapters: chapters,
        status: moduleData.status,
        isLocked: moduleData.isLocked,
      );
    }).toList();

    return Subject(
      subject: programOverview.program.name,
      modules: modules,
    );
  }
}