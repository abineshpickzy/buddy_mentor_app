import 'package:buddymentor/core/constants/app_colors.dart';
import 'package:buddymentor/features/mentee/program/chapter_sessions/widgets/asset_preview_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:buddymentor/features/mentee/program_purchase/controllers/program_overview_controller.dart';
import '../models/session_asset_model.dart';

class SessionDownloadables extends ConsumerWidget {
  final List<SessionAsset> downloads;
  final String nodeId;

  const SessionDownloadables({
    super.key,
    required this.downloads,
    required this.nodeId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (downloads.isEmpty) return const SizedBox.shrink();

    final programOverview = ref.watch(programOverviewProvider).value;
    final programType     = programOverview?.program.type ?? 0;

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
            // Header
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
                    child: const Icon(Icons.download_outlined,
                        size: 16, color: Color(0xFF2D4383)),
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
            Padding(
              padding: const EdgeInsets.fromLTRB(14, 10, 14, 10),
              child: Column(
                children: downloads
                    .map((a) => _buildRow(context, a, programType))
                    .toList(),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRow(BuildContext context, SessionAsset asset, int programType) {
    IconData fileIcon;
    Color    iconColor;
    switch (asset.type) {
      case 'image':
        fileIcon  = Icons.image_outlined;
        iconColor =AppColors.primary ;
        break;
      case 'pdf':
        fileIcon  = Icons.picture_as_pdf_outlined;
        iconColor = AppColors.primary;
        break;
      case 'docx':
      case 'doc':
        fileIcon  = Icons.description_outlined;
        iconColor = AppColors.primary;
        break;
      default:
        fileIcon  = Icons.insert_drive_file_outlined;
        iconColor = AppColors.primary;
    }

    return Container(
      padding: const EdgeInsets.symmetric(vertical: 10 ,horizontal: 10),
      margin: const EdgeInsets.symmetric(vertical:5),
    
        decoration: BoxDecoration(
                  color: AppColors.info.withValues(alpha: 0.25) ,
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: AppColors.border),
      ),
      child: Row(
        children: [
         
        Icon(fileIcon, color: iconColor, size: 18),
        
          const SizedBox(width: 12),

          // File name
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
          const SizedBox(width: 8),

          // 👁 Eye icon — tap to open preview popup
          GestureDetector(
            onTap: () => AssetPreviewSheet.show(
              context,
              asset: asset,
              programType: programType,
              nodeId: nodeId,
            ),
            child: Container(
              width: 20,
              height: 20,
             
              child: const Icon(Icons.remove_red_eye_outlined,
                  color: Color(0xFF2D4383), size: 18),
            ),
          ),
        ],
      ),
    );
  }
}