import 'dart:typed_data';
import 'package:buddymentor/shared/utils/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:syncfusion_flutter_pdfviewer/pdfviewer.dart';
import '../models/session_asset_model.dart';
import '../service/session_download_service.dart';

class AssetPreviewSheet extends StatefulWidget {
  final SessionAsset asset;
  final int programType;
  final String nodeId;

  const AssetPreviewSheet({
    super.key,
    required this.asset,
    required this.programType,
    required this.nodeId,
  });

  static Future<void> show(
    BuildContext context, {
    required SessionAsset asset,
    required int programType,
    required String nodeId,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      useRootNavigator: true,
      builder: (_) => AssetPreviewSheet(
        asset: asset,
        programType: programType,
        nodeId: nodeId,
      ),
    );
  }

  @override
  State<AssetPreviewSheet> createState() => _AssetPreviewSheetState();
}

class _AssetPreviewSheetState extends State<AssetPreviewSheet> {
  Uint8List? _bytes;
  bool       _loading     = true;
  bool       _downloading = false;
  bool       _downloaded  = false;
  String?    _error;

  int  _totalPages  = 0;
  int  _currentPage = 1; // Syncfusion is 1-based
  bool _pdfReady    = false;

  final PdfViewerController _pdfController = PdfViewerController();

  @override
  void initState() {
    super.initState();
    _loadPreview();
  }

  @override
  void dispose() {
    _pdfController.dispose();
    super.dispose();
  }

  Future<void> _loadPreview() async {
    try {
      final bytes = await SessionDownloadService.fetchBytes(
        programType: widget.programType,
        nodeId: widget.nodeId,
        assetId: widget.asset.id,
      );

      // ✅ No temp file needed — SfPdfViewer.memory() handles bytes directly
      if (mounted) {
        setState(() {
          _bytes   = bytes;
          _loading = false;
        });
      }
    } catch (e) {
      debugPrint('❌ Preview error: $e');
      if (mounted) setState(() { _error = e.toString(); _loading = false; });
    }
  }

  Future<void> _download() async {
    setState(() => _downloading = true);
    try {
      await SessionDownloadService.saveToDownloads(
        bytes: _bytes!,
        fileName: widget.asset.originalName,
      );
      if (mounted) {
        setState(() { _downloading = false; _downloaded = true; });
        AppToast.show(
          context,
          message: "File Saved Successfully!",
          type: ToastType.success,
          highPriority: true,
        );
      }
    } catch (e) {
      debugPrint('❌ Download error: $e');
      if (mounted) {
        setState(() => _downloading = false);
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text('Download failed: $e'),
          behavior: SnackBarBehavior.floating,
        ));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenH = MediaQuery.of(context).size.height;

    return Container(
      height: screenH * 0.88,
      decoration: const BoxDecoration(
        color: Color(0xFF1A1A2E),
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      child: Column(
        children: [
          _buildHeader(),
          const Divider(height: 1, color: Colors.white12),
          Expanded(child: _buildPreview()),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(16, 12, 8, 8),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Container(
                    width: 36,
                    height: 4,
                    decoration: BoxDecoration(
                      color: Colors.white24,
                      borderRadius: BorderRadius.circular(2),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  widget.asset.originalName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                if (widget.asset.type == 'pdf' && _pdfReady)
                  Text(
                    'Page $_currentPage of $_totalPages',
                    style: const TextStyle(color: Colors.white38, fontSize: 11),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          _buildDownloadButton(),
          IconButton(
            icon: const Icon(Icons.close, color: Colors.white70),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadButton() {
    if (_downloading) {
      return const Padding(
        padding: EdgeInsets.all(12),
        child: SizedBox(
          width: 20,
          height: 20,
          child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white70),
        ),
      );
    }
    if (_downloaded) {
      return const Padding(
        padding: EdgeInsets.all(12),
        child: Icon(Icons.check_circle_outline, color: Colors.greenAccent, size: 24),
      );
    }
    return IconButton(
      icon: const Icon(Icons.download_outlined, color: Colors.white70),
      tooltip: 'Save to Downloads',
      onPressed: (_loading || _error != null || _bytes == null) ? null : _download,
    );
  }

  Widget _buildPreview() {
    // ── Loading ────────────────────────────────────────────────
    if (_loading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Colors.white54),
            SizedBox(height: 14),
            Text(
              'Loading preview…',
              style: TextStyle(color: Colors.white54, fontSize: 13),
            ),
          ],
        ),
      );
    }

    // ── Error ──────────────────────────────────────────────────
    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
              const SizedBox(height: 12),
              const Text(
                'Failed to load preview',
                style: TextStyle(color: Colors.white70, fontSize: 14),
              ),
              const SizedBox(height: 4),
              Text(
                _error!,
                style: const TextStyle(color: Colors.white38, fontSize: 11),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 20),
              ElevatedButton.icon(
                onPressed: () {
                  setState(() { _loading = true; _error = null; });
                  _loadPreview();
                },
                icon: const Icon(Icons.refresh),
                label: const Text('Retry'),
              ),
            ],
          ),
        ),
      );
    }

    // ── Image preview ──────────────────────────────────────────
    if (widget.asset.isImage && _bytes != null) {
      return InteractiveViewer(
        child: Center(
          child: Image.memory(_bytes!, fit: BoxFit.contain),
        ),
      );
    }

    // ── PDF preview (continuous scroll) ───────────────────────
    if (widget.asset.type == 'pdf' && _bytes != null) {
      return SfPdfViewer.memory(
        _bytes!,
        controller: _pdfController,

        // ✅ True continuous vertical scroll like a PDF reader
        scrollDirection: PdfScrollDirection.vertical,
        pageLayoutMode: PdfPageLayoutMode.continuous,

        canShowScrollHead: true,
        canShowScrollStatus: true,
        canShowPaginationDialog: false,
        pageSpacing: 8,

        onDocumentLoaded: (details) {
          if (mounted) {
            setState(() {
              _totalPages = details.document.pages.count;
              _pdfReady   = true;
            });
          }
        },
        onPageChanged: (details) {
          if (mounted) {
            setState(() => _currentPage = details.newPageNumber);
          }
        },
        onDocumentLoadFailed: (details) {
          debugPrint('❌ PDF load failed: ${details.description}');
          if (mounted) setState(() => _error = details.description);
        },
      );
    }

    // ── Word doc ───────────────────────────────────────────────
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(Icons.description_outlined, size: 64, color: Colors.white24),
            const SizedBox(height: 16),
            const Text(
              'Word documents cannot be previewed.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white70, fontSize: 14),
            ),
            const SizedBox(height: 8),
            const Text(
              'Tap the download icon above to save\nand open in Word or Google Docs.',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.white38, fontSize: 13, height: 1.5),
            ),
            const SizedBox(height: 24),
            ElevatedButton.icon(
              onPressed: (_bytes == null || _downloading) ? null : _download,
              icon: const Icon(Icons.download_outlined),
              label: const Text('Download to view'),
            ),
          ],
        ),
      ),
    );
  }
}