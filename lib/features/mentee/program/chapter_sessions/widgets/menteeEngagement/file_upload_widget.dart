import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class FileUploadWidget extends StatelessWidget {
  final String? uploadedFileName;
  final VoidCallback onPickFile;
  final VoidCallback onRemoveFile;

  const FileUploadWidget({
    super.key,
    required this.uploadedFileName,
    required this.onPickFile,
    required this.onRemoveFile,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(Icons.upload_rounded, size: 28, color: Colors.grey.shade700),
          const SizedBox(height: 10),
           Text(
            'Upload Your Assignment',
            style: GoogleFonts.inter(
              fontSize: 15,
              fontWeight: FontWeight.w700,
              color: Color(0xFF1A1A2E),
            ),
          ),
          const SizedBox(height: 4),
          Text(
            'PDF or Word document • Max 10MB',
            style: TextStyle(fontSize: 12, color: Colors.grey.shade500),
          ),
          const SizedBox(height: 14),
          OutlinedButton(
            onPressed: onPickFile,
            style: OutlinedButton.styleFrom(
              side: BorderSide(color: Colors.grey.shade400),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
              padding:
                  const EdgeInsets.symmetric(horizontal: 24, vertical: 10),
              foregroundColor: const Color(0xFF1A1A2E),
            ),
            child: Text(
              uploadedFileName != null ? 'Change File' : 'Choose File',
              style: const TextStyle(
                  fontSize: 13, fontWeight: FontWeight.w500),
            ),
          ),
          if (uploadedFileName != null) ...[
            const SizedBox(height: 10),
            Container(
              padding:
                  const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.green.shade50,
                borderRadius: BorderRadius.circular(8),
                border:
                    Border.all(color: Colors.green.shade200, width: 0.5),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(Icons.insert_drive_file_outlined,
                      size: 16, color: Colors.green.shade600),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      uploadedFileName!,
                      style: TextStyle(
                          fontSize: 12, color: Colors.green.shade700),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const SizedBox(width: 6),
                  GestureDetector(
                    onTap: onRemoveFile,
                    child: Icon(Icons.close,
                        size: 14, color: Colors.green.shade600),
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}