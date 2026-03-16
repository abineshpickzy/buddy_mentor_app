import 'package:buddymentor/core/constants/app_colors.dart';
import 'package:buddymentor/features/mentee/program/chapter_sessions/widgets/shimmers/session_content_skeleton.dart';
import 'package:buddymentor/features/mentee/program_purchase/controllers/program_overview_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import '../controllers/session_asset_controller.dart';
import '../controllers/session_content_controller.dart';
import '../widgets/session_progress_bar.dart';
import '../widgets/session_tab_bar.dart';
import '../widgets/session_video_player.dart';
import '../widgets/session_downloadables.dart';
import '../widgets/mark_complete_button.dart';
import '../widgets/menteeEngagement/mentee_engagement_section.dart';

class SessionContentPage extends ConsumerStatefulWidget {
  final String chapterId;
  final String chapterName;
  final String sessionId;
  final String sessionName;
  final int initialTabIndex;

  const SessionContentPage({
    super.key,
    required this.chapterName,
    required this.chapterId,
    required this.sessionId,
    required this.sessionName,
    this.initialTabIndex = 0,
  });

  @override
  ConsumerState<SessionContentPage> createState() => _SessionContentPageState();
}

class _SessionContentPageState extends ConsumerState<SessionContentPage>
    with TickerProviderStateMixin {
  late final SessionContentController _controller;

  @override
  void initState() {
    super.initState();
    _controller = SessionContentController();
    _controller.initialize(
      sessionId: widget.sessionId,
      sessionName: widget.sessionName,
      vsync: this,
    );
  }

  @override
  void dispose() {
    _controller.tabController.removeListener(_onTabChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (mounted && !_controller.tabController.indexIsChanging) {
      final sessions = _controller.chapterSessions;
      if (sessions.isNotEmpty) {
        final newSession = sessions[_controller.tabController.index];
        _controller.switchToSession(newSession);
      }
      setState(() {});
    }
  }

  void _onTabTap(int index) {
    final selectedSession = _controller.chapterSessions[index];
    _controller.switchToSession(selectedSession);
    setState(() {});
  }

  void _onMarkCompleteSuccess() {
    final updatedOverview = ref.read(programOverviewProvider).value;
    if (updatedOverview == null) return;

    List<dynamic> freshSessions = [];
    for (final module in updatedOverview.hierarchy.modules) {
      for (final chapter in module.chapters) {
        if (chapter.id == widget.chapterId) {
          freshSessions = chapter.sessions;
          break;
        }
      }
      if (freshSessions.isNotEmpty) break;
    }

    if (freshSessions.isEmpty) return;

    final currentIndex = freshSessions
        .indexWhere((s) => s.id == _controller.currentSessionId);
    if (currentIndex == -1) return;

    final nextIndex = currentIndex + 1;
    if (nextIndex < freshSessions.length) {
      final nextSession = freshSessions[nextIndex];
      _controller.switchToSession(nextSession);
      _controller.tabController.animateTo(nextIndex);
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: MarkCompleteButton(
        onMarkComplete: () => _controller.markSessionComplete(ref),
        onSuccess: _onMarkCompleteSuccess,
      ),
    );
  }

  PreferredSizeWidget _buildAppBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.transparent,
      leading: IconButton(
        icon: const Icon(Icons.chevron_left, color: Colors.black87, size: 28),
        onPressed: () => Navigator.of(context).maybePop(),
      ),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            _controller.currentSessionName,
            style: GoogleFonts.inter(
              fontSize: 12,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            widget.chapterName,
            style: GoogleFonts.inter(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: const Color(0xFF1A1A2E),
            ),
          ),
        ],
      ),
      centerTitle: false,
    );
  }

  Widget _buildBody() {
    return Consumer(
      builder: (context, ref, child) {
        final programOverviewAsync = ref.watch(programOverviewProvider);

        return programOverviewAsync.when(
          loading: () => const SessionPageSkeleton(),
          error: (err, _) => _buildErrorState(err.toString()),
          data: (programOverview) {
            if (programOverview == null) {
              return const Center(child: Text('No program data available'));
            }

            final chapterSessions = _getChapterSessions(programOverview);
            if (chapterSessions.isEmpty) {
              return const Center(child: Text('No sessions found'));
            }

            _controller.initializeTabController(
              chapterSessions,
              this,
              onTabChanged: _onTabChanged,
            );

            return Column(
              children: [
                _buildTopSection(chapterSessions),
                Divider(height: 1, color: Colors.grey.shade200),
                Expanded(child: _buildContent()),
              ],
            );
          },
        );
      },
    );
  }

  Widget _buildTopSection(List<dynamic> chapterSessions) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 10),
          SessionProgressBar(sessions: chapterSessions),
          const SizedBox(height: 10),
          SessionTabBar(
            tabController: _controller.tabController,
            sessions: chapterSessions,
            onTap: _onTabTap,
            findCurrentSessionIndex: _controller.findCurrentSessionIndex,
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _buildContent() {
    return Consumer(
      builder: (context, ref, child) {
        final asyncData =
            ref.watch(sessionContentProvider(_controller.currentSessionId));

        return asyncData.when(
          loading: () => const SessionPageSkeleton(),
          error: (err, _) => _buildErrorState(err.toString()),
          data: (data) => _buildSessionContent(data),
        );
      },
    );
  }

  Widget _buildSessionContent(data) {
    final video = data.videoAsset;
    final downloads = data.downloadableAssets;
    final hasVideo =
        video?.cloudflareUid != null && video!.cloudflareUid!.isNotEmpty;
    final hasDownloads = downloads.isNotEmpty;
    final currentSession = _getCurrentSession();
    final showEngagementUI = currentSession?.menteeEngagement == true;

    return ListView(
      padding: EdgeInsets.zero,
      children: [
        const SizedBox(height: 20),
        _buildSessionHeader(),
        if (hasVideo) ...[
          const SizedBox(height: 18),
          SessionVideoPlayer(video: video),
          const SizedBox(height: 22),
        ] else ...[
          const SizedBox(height: 18),
        ],
        if (hasDownloads) ...[
          SessionDownloadables(
            downloads: downloads,
            nodeId: _controller.currentSessionId,
          ),
          const SizedBox(height: 20),
        ],
        _buildDescription(),
        if (showEngagementUI) ...[
          const SizedBox(height: 24),
          // ← Clean single line, all logic lives in its own file
          MenteeEngagementSection(
            sessionId: _controller.currentSessionId,
          ),
        ],
        const SizedBox(height: 100),
      ],
    );
  }

  Widget _buildSessionHeader() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _controller.currentSessionName,
            style: GoogleFonts.inter(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.textDark,
              letterSpacing: 0,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            _controller.getSubtitleFor(_controller.currentSessionName),
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade600,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDescription() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16,vertical: 10),
      margin: const EdgeInsets.symmetric(horizontal: 16),
      decoration: BoxDecoration(
        border : Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
      ),  
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
           Text(
            'Description',
            textAlign: TextAlign.justify,
            style: GoogleFonts.inter(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: AppColors.textDark,
                  letterSpacing: 0.1,
              
                ),
          ),
          const SizedBox(height: 10),
          Text(
            'A business plan in engineering typically outlines the purpose, '
            'goals, and scope of the engineering business venture. It serves '
            'as an executive summary that introduces the business concept, '
            'the engineering services or products offered, and the target market.',
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey.shade700,
              height: 1.6,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildErrorState(String error) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(Icons.error_outline, size: 48, color: Colors.red),
          const SizedBox(height: 12),
          Text('Error: $error', textAlign: TextAlign.center),
          const SizedBox(height: 16),
          ElevatedButton(
            onPressed: () => ref.invalidate(programOverviewProvider),
            child: const Text('Retry'),
          ),
        ],
      ),
    );
  }

  List<dynamic> _getChapterSessions(programOverview) {
    for (final module in programOverview.hierarchy.modules) {
      for (final chapter in module.chapters) {
        if (chapter.id == widget.chapterId) {
          return chapter.sessions;
        }
      }
    }
    return [];
  }

  Session? _getCurrentSession() {
    return _controller.chapterSessions
        .cast<Session>()
        .where((session) => session.id == _controller.currentSessionId)
        .firstOrNull;
  }
}