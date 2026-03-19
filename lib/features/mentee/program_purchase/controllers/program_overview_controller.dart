import 'package:buddymentor/features/mentee/program_purchase/controllers/program_selection_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/program_overview_model.dart';
import '../services/program_overview_service.dart';
import '../../../../core/network/dio_client.dart';

// Export the models for easier access
export '../models/program_overview_model.dart';

// Service provider
final programOverviewServiceProvider = Provider<ProgramOverviewService>((ref) {
  return ProgramOverviewService(DioClient.dio);
});

// Program Overview AsyncNotifier
class ProgramOverviewNotifier extends AsyncNotifier<ProgramOverview?> {
  @override
  Future<ProgramOverview?> build() async {
    final selected = ref.watch(selectedProgramProvider);

    if (selected == null) return null;

    final service = ref.read(programOverviewServiceProvider);
    print(selected.isFreeTrial);

    if (selected.isFreeTrial) {
      return service.fetchtrialProgram(selected.productId);
    }

    return service.fetchProgram(
      selected.programId,
      selected.productType,
    );
  }

  Future<void> fetchtrialProgram(String productId) async {
    state = const AsyncValue.loading();
    state = await AsyncValue.guard(() async {
      final service = ref.read(programOverviewServiceProvider);
      return service.fetchtrialProgram(productId);
    });
  }

  Future<bool> markSessionComplete(String sessionId) async {
    final selected = ref.watch(selectedProgramProvider);
    print("product id :" + selected!.productId);
    print(" program id : " + selected!.programId);
    print("session id :" + sessionId);

    try {
      final service = ref.read(programOverviewServiceProvider);
      final success = await service.markSessionComplete(
          selected.productId, selected.programId, sessionId);

      if (success) {
        // Update local state with session completion
        final currentState = state.value;
        if (currentState != null) {
          var updatedOverview = _updateSessionStatus(currentState, sessionId);

          // Check if chapter is fully completed and advance to next chapter
          updatedOverview = _checkAndAdvanceChapter(updatedOverview, sessionId);

          // Check if module is fully completed
          updatedOverview = _checkAndUpdateModuleStatus(updatedOverview);

          state = AsyncValue.data(updatedOverview);
        }
      }

      return success;
    } catch (e) {
      throw Exception('Failed to mark session complete: $e');
    }
  }

  // Helper method to update session status locally
  ProgramOverview _updateSessionStatus(ProgramOverview overview, String sessionId) {
    // Create a deep copy and update the specific session
    final updatedModules = overview.hierarchy.modules.map((module) {
      final updatedChapters = module.chapters.map((chapter) {
        final updatedSessions = chapter.sessions.map((session) {
          if (session.id == sessionId) {
            // Mark current session as completed (status = 2)
            return Session(
              id: session.id,
              name: session.name,
              parentId: session.parentId,
              orderNo: session.orderNo,
              menteeEngagement: session.menteeEngagement,
              isLocked: false,
              clickable: session.clickable,
              status: 2, // Mark as completed
            );
          }
          // Unlock next session if current one is completed
          if (session.orderNo == _getSessionOrderNo(overview, sessionId) + 1 &&
              session.parentId == _getSessionParentId(overview, sessionId)) {
            return Session(
              id: session.id,
              name: session.name,
              parentId: session.parentId,
              orderNo: session.orderNo,
              menteeEngagement: session.menteeEngagement,
              isLocked: false, // Unlock next session
              clickable: true,
              status: session.status,
            );
          }
          return session;
        }).toList();

        return Chapter(
          id: chapter.id,
          name: chapter.name,
          parentId: chapter.parentId,
          orderNo: chapter.orderNo,
          menteeEngagement: chapter.menteeEngagement,
          isLocked: chapter.isLocked,
          clickable: chapter.clickable,
          status: chapter.status,
          sessions: updatedSessions,
        );
      }).toList();

      return Module(
        id: module.id,
        name: module.name,
        parentId: module.parentId,
        orderNo: module.orderNo,
        menteeEngagement: module.menteeEngagement,
        isLocked: module.isLocked,
        clickable: module.clickable,
        status: module.status,
        chapters: updatedChapters,
      );
    }).toList();

    final updatedHierarchy = Hierarchy(
      id: overview.hierarchy.id,
      name: overview.hierarchy.name,
      parentId: overview.hierarchy.parentId,
      orderNo: overview.hierarchy.orderNo,
      menteeEngagement: overview.hierarchy.menteeEngagement,
      isLocked: overview.hierarchy.isLocked,
      clickable: overview.hierarchy.clickable,
      status: overview.hierarchy.status,
      modules: updatedModules,
    );

    return ProgramOverview(
      success: overview.success,
      message: overview.message,
      product: overview.product,
      program: overview.program,
      hierarchy: updatedHierarchy,
    );
  }

  /// Check if all sessions in the completed session's chapter are done
  /// If yes:
  /// 1. Mark current chapter as completed (status = 2)
  /// 2. Find next chapter in the SAME MODULE
  /// 3. Mark next chapter as in progress (status = 1)
  /// 4. Mark first session of next chapter as in progress (status = 1)
  ProgramOverview _checkAndAdvanceChapter(
      ProgramOverview overview, String completedSessionId) {
    // Find the chapter and module of the completed session
    Chapter? completedSessionChapter;
    Module? completedSessionModule;

    for (final module in overview.hierarchy.modules) {
      for (final chapter in module.chapters) {
        if (chapter.sessions
            .any((session) => session.id == completedSessionId)) {
          completedSessionChapter = chapter;
          completedSessionModule = module;
          break;
        }
      }
      if (completedSessionChapter != null) break;
    }

    if (completedSessionChapter == null || completedSessionModule == null) {
      return overview;
    }

    // Check if all sessions in the current chapter are completed (status == 2)
    final allSessionsCompleted = completedSessionChapter.sessions
        .every((session) => session.status == 2);

    if (!allSessionsCompleted) {
      return overview;
    }

    print("✓ All sessions in chapter '${completedSessionChapter.name}' are completed!");

    // Find the next chapter in the SAME module only
    Chapter? nextChapter;
    final currentChapterIndex = completedSessionModule.chapters
        .indexWhere((ch) => ch.id == completedSessionChapter!.id);

    // Check if there's a next chapter in the same module
    if (currentChapterIndex >= 0 &&
        currentChapterIndex < completedSessionModule.chapters.length - 1) {
      nextChapter = completedSessionModule.chapters[currentChapterIndex + 1];
    }

    // Update: Mark current chapter as completed (status = 2)
    // and if next chapter exists, unlock it
    final updatedModules = overview.hierarchy.modules.map((module) {
      final updatedChapters = module.chapters.map((chapter) {
        
        // Mark completed chapter as status = 2
        if (chapter.id == completedSessionChapter!.id) {
          return Chapter(
            id: chapter.id,
            name: chapter.name,
            parentId: chapter.parentId,
            orderNo: chapter.orderNo,
            menteeEngagement: chapter.menteeEngagement,
            isLocked: chapter.isLocked,
            clickable: chapter.clickable,
            status: 2, // Mark chapter as completed
            sessions: chapter.sessions,
          );
        }

        // Mark next chapter as in progress (if it exists)
        if (nextChapter != null && chapter.id == nextChapter!.id) {
          final updatedSessions = chapter.sessions.map((session) {
            // Mark first session as in progress
            if (session.orderNo == 1) {
              return Session(
                id: session.id,
                name: session.name,
                parentId: session.parentId,
                orderNo: session.orderNo,
                menteeEngagement: session.menteeEngagement,
                isLocked: false,
                clickable: true,
                status: 1, // In progress
              );
            }
            return session;
          }).toList();

          return Chapter(
            id: chapter.id,
            name: chapter.name,
            parentId: chapter.parentId,
            orderNo: chapter.orderNo,
            menteeEngagement: chapter.menteeEngagement,
            isLocked: false,
            clickable: true,
            status: 1, // Chapter in progress
            sessions: updatedSessions,
          );
        }

        return chapter;
      }).toList();

      return Module(
        id: module.id,
        name: module.name,
        parentId: module.parentId,
        orderNo: module.orderNo,
        menteeEngagement: module.menteeEngagement,
        isLocked: module.isLocked,
        clickable: module.clickable,
        status: module.status,
        chapters: updatedChapters,
      );
    }).toList();

    // If no next chapter in same module
    if (nextChapter == null) {
      print("✓ All chapters in module '${completedSessionModule.name}' are completed!");
    } else {
      print("→ Moving to next chapter: '${nextChapter.name}'");
    }

    final updatedHierarchy = Hierarchy(
      id: overview.hierarchy.id,
      name: overview.hierarchy.name,
      parentId: overview.hierarchy.parentId,
      orderNo: overview.hierarchy.orderNo,
      menteeEngagement: overview.hierarchy.menteeEngagement,
      isLocked: overview.hierarchy.isLocked,
      clickable: overview.hierarchy.clickable,
      status: overview.hierarchy.status,
      modules: updatedModules,
    );

    return ProgramOverview(
      success: overview.success,
      message: overview.message,
      product: overview.product,
      program: overview.program,
      hierarchy: updatedHierarchy,
    );
  }

  /// Check if all chapters in a module are completed
  /// If yes, mark the module as completed (status = 2)
  ProgramOverview _checkAndUpdateModuleStatus(ProgramOverview overview) {
    final updatedModules = overview.hierarchy.modules.map((module) {
      // Check if all chapters in this module are completed
      final allChaptersCompleted = module.chapters.every((chapter) {
        return chapter.sessions.every((session) => session.status == 2);
      });

      if (allChaptersCompleted && module.status != 2) {
        print("✓ All chapters and sessions in module '${module.name}' are completed!");
        print("→ Marking module '${module.name}' as completed");

        // Mark module as completed
        return Module(
          id: module.id,
          name: module.name,
          parentId: module.parentId,
          orderNo: module.orderNo,
          menteeEngagement: module.menteeEngagement,
          isLocked: module.isLocked,
          clickable: module.clickable,
          status: 2, // Mark as completed
          chapters: module.chapters,
        );
      }

      return module;
    }).toList();

    final updatedHierarchy = Hierarchy(
      id: overview.hierarchy.id,
      name: overview.hierarchy.name,
      parentId: overview.hierarchy.parentId,
      orderNo: overview.hierarchy.orderNo,
      menteeEngagement: overview.hierarchy.menteeEngagement,
      isLocked: overview.hierarchy.isLocked,
      clickable: overview.hierarchy.clickable,
      status: overview.hierarchy.status,
      modules: updatedModules,
    );

    return ProgramOverview(
      success: overview.success,
      message: overview.message,
      product: overview.product,
      program: overview.program,
      hierarchy: updatedHierarchy,
    );
  }

  // Helper to get session order number
  int _getSessionOrderNo(ProgramOverview overview, String sessionId) {
    for (final module in overview.hierarchy.modules) {
      for (final chapter in module.chapters) {
        for (final session in chapter.sessions) {
          if (session.id == sessionId) {
            return session.orderNo;
          }
        }
      }
    }
    return 0;
  }

  // Helper to get session parent ID
  String _getSessionParentId(ProgramOverview overview, String sessionId) {
    for (final module in overview.hierarchy.modules) {
      for (final chapter in module.chapters) {
        for (final session in chapter.sessions) {
          if (session.id == sessionId) {
            return session.parentId;
          }
        }
      }
    }
    return '';
  }

  void clearProgram() {
    state = const AsyncValue.data(null);
  }

  Future<bool> enrollProgram(
      String programId, String productId, int productType) async {
    try {
      final service = ref.read(programOverviewServiceProvider);
      return await service.enrollProgram(programId, productId, productType);
    } catch (e) {
      throw Exception('Failed to enroll in program: $e');
    }
  }
}

// Provider
final programOverviewProvider =
    AsyncNotifierProvider<ProgramOverviewNotifier, ProgramOverview?>(() {
  return ProgramOverviewNotifier();
});