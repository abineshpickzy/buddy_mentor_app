import 'dart:io';
import 'dart:typed_data';
import 'package:buddymentor/shared/utils/app_toast.dart';
import 'package:flutter/material.dart';
import 'package:flutter_pdfview/flutter_pdfview.dart';
import 'package:path_provider/path_provider.dart';
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

class _AssetPreviewSheetState extends State<AssetPreviewSheet>
    with WidgetsBindingObserver {
  Uint8List? _bytes;
  String?    _pdfPath;
  bool       _loading     = true;
  bool       _downloading = false;
  bool       _downloaded  = false;
  String?    _error;

  int  _totalPages  = 0;
  int  _currentPage = 0;
  bool _pdfReady    = false;
  bool _showPdf     = true;

  PDFViewController? _pdfController;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadPreview();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (widget.asset.type != 'pdf') return;
    if (state == AppLifecycleState.paused ||
        state == AppLifecycleState.inactive) {
      if (mounted) setState(() => _showPdf = false);
    } else if (state == AppLifecycleState.resumed) {
      Future.delayed(const Duration(milliseconds: 300), () {
        if (mounted) setState(() => _showPdf = true);
      });
    }
  }

  Future<void> _loadPreview() async {
    try {
      final bytes = await SessionDownloadService.fetchBytes(
        programType: widget.programType,
        nodeId: widget.nodeId,
        assetId: widget.asset.id,
      );

      if (widget.asset.type == 'pdf') {
        final tmp  = await getTemporaryDirectory();
        final file = File('${tmp.path}/preview_${widget.asset.id}.pdf');
        await file.writeAsBytes(bytes, flush: true);
        if (mounted) {
          setState(() {
            _pdfPath = file.path;
            _bytes   = bytes;
            _loading = false;
          });
        }
      } else {
        if (mounted) setState(() { _bytes = bytes; _loading = false; });
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
          Divider(height: 1, color: Colors.white12),
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
                    width: 36, height: 4,
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
                    'Page ${_currentPage + 1} of $_totalPages',
                    style: const TextStyle(color: Colors.white38, fontSize: 11),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          // Previous page button for PDF
          if (widget.asset.type == 'pdf' && _pdfReady && _currentPage > 0)
            IconButton(
              icon: const Icon(Icons.arrow_upward, color: Colors.white54, size: 20),
              onPressed: () => _pdfController?.setPage(_currentPage - 1),
            ),
          // Next page button for PDF
          if (widget.asset.type == 'pdf' && _pdfReady && _currentPage < _totalPages - 1)
            IconButton(
              icon: const Icon(Icons.arrow_downward, color: Colors.white54, size: 20),
              onPressed: () => _pdfController?.setPage(_currentPage + 1),
            ),
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
          width: 20, height: 20,
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
    if (_loading) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            CircularProgressIndicator(color: Colors.white54),
            SizedBox(height: 14),
            Text('Loading preview…',
                style: TextStyle(color: Colors.white54, fontSize: 13)),
          ],
        ),
      );
    }

    if (_error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Icon(Icons.error_outline, color: Colors.redAccent, size: 48),
              const SizedBox(height: 12),
              const Text('Failed to load preview',
                  style: TextStyle(color: Colors.white70, fontSize: 14)),
              const SizedBox(height: 4),
              Text(_error!,
                  style: const TextStyle(color: Colors.white38, fontSize: 11),
                  textAlign: TextAlign.center),
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

    // ── PDF preview ────────────────────────────────────────────
    if (widget.asset.type == 'pdf' && _pdfPath != null) {
      if (!_showPdf) {
        return const Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              CircularProgressIndicator(color: Colors.white54),
              SizedBox(height: 12),
              Text('Resuming…',
                  style: TextStyle(color: Colors.white54, fontSize: 13)),
            ],
          ),
        );
      }

      return PDFView(
        key: ValueKey('pdf_$_showPdf'),
        filePath: _pdfPath!,
        enableSwipe: true,         // ✅ vertical swipe to scroll pages
        swipeHorizontal: false,    // ✅ vertical scroll like a document
        autoSpacing: true,         // ✅ space between pages
        pageFling: false,          // ✅ false = continuous scroll, not snap
        pageSnap: false,           // ✅ false = continuous scroll
        fitEachPage: false,        // ✅ false = shows full page width, scrollable
        fitPolicy: FitPolicy.WIDTH, // ✅ fit to width so full content is visible
        backgroundColor: const Color(0xFF1A1A2E),
        onViewCreated: (controller) {
          _pdfController = controller;
        },
        onRender: (pages) {
          if (mounted) {
            setState(() {
              _totalPages = pages ?? 0;
              _pdfReady   = true;
            });
          }
        },
        onPageChanged: (page, total) {
          if (mounted) setState(() => _currentPage = page ?? 0);
        },
        onError: (error) {
          debugPrint('❌ PDFView error: $error');
          if (mounted) setState(() => _error = error.toString());
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