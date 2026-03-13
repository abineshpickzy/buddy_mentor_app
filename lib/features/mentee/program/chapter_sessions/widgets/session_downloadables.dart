import 'package:flutter/material.dart';
import '../models/session_asset_model.dart';

class SessionDownloadables extends StatelessWidget {
  final List<SessionAsset> downloads;

  const SessionDownloadables({
    super.key,
    required this.downloads,
  });

  @override
  Widget build(BuildContext context) {
    if (downloads.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Container(
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
          border: Border.all(color: Colors.grey.shade200),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 14, 14, 10),
              child: Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2D4383).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(
                      Icons.download_outlined,
                      size: 16,
                      color: Color(0xFF2D4383),
                    ),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Downloadables',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF1A1A2E),
                    ),
                  ),
                ],
              ),
            ),
            // Divider
            Divider(height: 1, color: Colors.grey.shade200),
            // Items list
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
              child: Column(
                children: downloads.map((a) => _buildDownloadRow(a)).toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDownloadRow(SessionAsset asset) {
    IconData fileIcon;
    Color iconColor;

    switch (asset.type) {
      case 'image':
        fileIcon = Icons.image_outlined;
        iconColor = Colors.blue.shade400;
        break;
      case 'pdf':
        fileIcon = Icons.picture_as_pdf_outlined;
        iconColor = Colors.red.shade400;
        break;
      case 'docx':
      case 'doc':
        fileIcon = Icons.description_outlined;
        iconColor = Colors.blue.shade700;
        break;
      default:
        fileIcon = Icons.insert_drive_file_outlined;
        iconColor = Colors.grey.shade600;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        children: [
          Container(
            width: 36,
            height: 36,
            decoration: BoxDecoration(
              color: iconColor.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(fileIcon, color: iconColor, size: 18),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              asset.originalName,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: Color(0xFF1A1A2E),
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          Icon(
            Icons.download_outlined,
            color: Colors.grey.shade500,
            size: 20,
          ),
        ],
      ),
    );
  }
}