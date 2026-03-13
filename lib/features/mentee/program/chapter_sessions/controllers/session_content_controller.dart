import 'package:buddymentor/features/mentee/program_purchase/controllers/program_overview_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../service/video_service.dart';

class SessionContentController {
  late TabController tabController;
  late String currentSessionId;
  late String currentSessionName;
  List<dynamic> chapterSessions = [];
  bool tabControllerInitialized = false;

  void initialize({
    required String sessionId,
    required String sessionName,
    required TickerProvider vsync,
  }) {
    currentSessionId = sessionId;
    currentSessionName = sessionName;
    tabController = TabController(length: 1, vsync: vsync, initialIndex: 0);
  }

  void dispose() {
    tabController.dispose();
  }

  void initializeTabController(List<dynamic> sessions, TickerProvider vsync) {
    if (chapterSessions.length == sessions.length && tabControllerInitialized) {
      return;
    }

    chapterSessions = sessions;
    final currentIndex = findCurrentSessionIndex(sessions);

    if (tabControllerInitialized) {
      tabController.dispose();
    }

    tabController = TabController(
      length: sessions.length,
      vsync: vsync,
      initialIndex: currentIndex,
    );

    tabControllerInitialized = true;
  }

  int findCurrentSessionIndex(List<dynamic> sessions) {
    for (int i = 0; i < sessions.length; i++) {
      if (sessions[i].id == currentSessionId) return i;
    }
    return 0;
  }

  void switchToSession(dynamic session) {
    if (currentSessionId != session.id) {
      currentSessionId = session.id;
      currentSessionName = session.name;
    }
  }

  void switchToNextSession() {
    if (chapterSessions.isEmpty) return;
    final currentIndex = findCurrentSessionIndex(chapterSessions);
    if (currentIndex < chapterSessions.length - 1) {
      final nextSession = chapterSessions[currentIndex + 1];
      if (!nextSession.isLocked) {
        tabController.animateTo(currentIndex + 1);
        switchToSession(nextSession);
      }
    }
  }

  Future<bool> markSessionComplete(WidgetRef ref) async {
    try {
      final notifier = ref.read(programOverviewProvider.notifier);
      return await notifier.markSessionComplete(currentSessionId);
    } catch (e) {
      throw Exception('Failed to mark session complete: $e');
    }
  }

  String? getVideoEmbedUrl(String? cloudflareUid) {
    return VideoService.getVideoEmbedUrl(cloudflareUid);
  }

  String getSubtitleFor(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('pep talk')) {
      return 'Watch the motivational pep talk video to kickstart your week. '
          'Download the companion image after viewing.';
    }
    if (lower.contains('session title')) {
      return 'Document download for today\'s session title and topic overview.';
    }
    if (lower.contains('standards')) {
      return 'Review industry standards and best practices. '
          'Watch the reference video and download the documentation.';
    }
    if (lower.contains('lessons')) {
      return 'Key lessons and takeaways. Watch the video and download '
          'supporting documents.';
    }
    return 'Explore the content below for this session.';
  }
}