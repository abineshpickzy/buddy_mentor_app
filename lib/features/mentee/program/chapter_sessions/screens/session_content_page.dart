import 'package:buddymentor/features/mentee/program_purchase/controllers/program_overview_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../controllers/session_asset_controller.dart';
import '../controllers/session_content_controller.dart';
import '../widgets/session_progress_bar.dart';
import '../widgets/session_tab_bar.dart';
import '../widgets/session_video_player.dart';
import '../widgets/session_downloadables.dart';
import '../widgets/mark_complete_button.dart';

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
    _controller.tabController.addListener(_onTabChanged);
  }

  @override
  void dispose() {
    _controller.tabController.removeListener(_onTabChanged);
    _controller.dispose();
    super.dispose();
  }

  void _onTabChanged() {
    if (mounted && !_controller.tabController.indexIsChanging) {
      setState(() {});
    }
  }

  void _onTabTap(int index) {
    final selectedSession = _controller.chapterSessions[index];
    _controller.switchToSession(selectedSession);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF6F7FA),
      appBar: _buildAppBar(),
      body: _buildBody(),
      bottomNavigationBar: MarkCompleteButton(
        onMarkComplete: () => _controller.markSessionComplete(ref),
        onSuccess: () {
          _controller.switchToNextSession();
          setState(() {});
        },
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
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w400,
            ),
          ),
          Text(
            widget.chapterName,
            style: const TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A2E),
            ),
          ),
        ],
      ),
      centerTitle: false,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Divider(height: 1, color: Colors.grey.shade200),
      ),
    );
  }

  Widget _buildBody() {
    return Consumer(
      builder: (context, ref, child) {
        final programOverviewAsync = ref.watch(programOverviewProvider);

        return programOverviewAsync.when(
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => _buildErrorState(err.toString()),
          data: (programOverview) {
            if (programOverview == null) {
              return const Center(child: Text('No program data available'));
            }

            final chapterSessions = _getChapterSessions(programOverview);
            if (chapterSessions.isEmpty) {
              return const Center(child: Text('No sessions found'));
            }

            _controller.initializeTabController(chapterSessions, this);

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
          loading: () => const Center(child: CircularProgressIndicator()),
          error: (err, _) => _buildErrorState(err.toString()),
          data: (data) {
            // Show friendly empty state if no content found (404 case)
            if (data.videoAsset == null && data.downloadableAssets.isEmpty) {
              return _buildEmptyState();
            }
            return _buildSessionContent(data);
          },
        );
      },
    );
  }

  // ✅ New empty state widget shown when API returns 404 / no content
  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.folder_open_outlined,
                size: 56, color: Colors.grey.shade300),
            const SizedBox(height: 16),
            Text(
              'No content available',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade600,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Content for this session hasn\'t been added yet.\nCheck back later.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade400,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSessionContent(data) {
    final video = data.videoAsset;
    final downloads = data.downloadableAssets;
    final hasVideo = video?.cloudflareUid != null && video!.cloudflareUid!.isNotEmpty;

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
        SessionDownloadables(
          downloads: downloads,
          nodeId: _controller.currentSessionId, 
        ),
        const SizedBox(height: 20),
        _buildDescription(),
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
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A2E),
              letterSpacing: -0.2,
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
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Description',
            style: TextStyle(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A2E),
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
}