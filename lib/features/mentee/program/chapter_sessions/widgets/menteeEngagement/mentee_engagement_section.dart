import 'dart:typed_data';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'comment_box_widget.dart';
import 'file_upload_widget.dart';

class MenteeEngagementSection extends StatefulWidget {
  final String sessionId;

  const MenteeEngagementSection({super.key, required this.sessionId});

  @override
  State<MenteeEngagementSection> createState() =>
      _MenteeEngagementSectionState();
}

class _MenteeEngagementSectionState extends State<MenteeEngagementSection> {
  // Start with 1 answer box by default
  final List<TextEditingController> _answerControllers = [
    TextEditingController(),
  ];

  String? _uploadedFileName;
  Uint8List? _uploadedFileBytes;

  @override
  void dispose() {
    for (final c in _answerControllers) {
      c.dispose();
    }
    super.dispose();
  }

void _addAnswer() {
  if (_answerControllers.length >= 10) return;

  // Check if the last answer box is empty before adding a new one
  final int lastIndex = _answerControllers.length - 1;
  if (_answerControllers[lastIndex].text.trim().isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          'Please write Answer ${lastIndex + 1} before adding a new one',
        ),
        backgroundColor: Colors.orange.shade700,
        duration: const Duration(seconds: 2),
      ),
    );
    return;
  }

  setState(() {
    _answerControllers.add(TextEditingController());
  });
}

  void _removeAnswer(int index) {
    if (_answerControllers.length <= 1) return;
    setState(() {
      _answerControllers[index].dispose();
      _answerControllers.removeAt(index);
    });
  }

  Future<void> _pickFile() async {
    try {
      final result = await FilePicker.platform.pickFiles(
        type: FileType.custom,
        allowedExtensions: ['pdf', 'doc', 'docx'],
        withData: true,
      );
      if (result != null && result.files.isNotEmpty) {
        final file = result.files.first;
        if (file.size > 10 * 1024 * 1024) {
          if (mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('File exceeds 10MB limit')),
            );
          }
          return;
        }
        setState(() {
          _uploadedFileName = file.name;
          _uploadedFileBytes = file.bytes;
          // Clear all answer text when file is uploaded
          for (final c in _answerControllers) {
            c.clear();
          }
        });
      }
    } catch (e) {
      debugPrint('File picker error: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open file picker: $e')),
        );
      }
    }
  }

  void _removeFile() {
    setState(() {
      _uploadedFileName = null;
      _uploadedFileBytes = null;
    });
  }

void _handleSubmit() {
  final bool hasFile = _uploadedFileName != null;

  // If file uploaded — skip all text validation
  if (hasFile) {
    _submitData(hasFile: true, answers: []);
    return;
  }

  // No file — validate all answer boxes are filled
  final List<int> emptyIndexes = [];
  for (int i = 0; i < _answerControllers.length; i++) {
    if (_answerControllers[i].text.trim().isEmpty) {
      emptyIndexes.add(i + 1);
    }
  }

  if (emptyIndexes.isEmpty && _answerControllers.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Please write at least one answer or upload a file'),
      ),
    );
    return;
  }

  if (emptyIndexes.isNotEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          emptyIndexes.length == 1
              ? 'Please fill Answer ${emptyIndexes[0]} before posting'
              : 'Please fill Answer ${emptyIndexes.join(', ')} before posting',
        ),
        backgroundColor: Colors.orange.shade700,
        duration: const Duration(seconds: 2),
      ),
    );
    return;
  }

  // All filled
  final List<String> answers =
      _answerControllers.map((c) => c.text.trim()).toList();
  _submitData(hasFile: false, answers: answers);
}

void _submitData({required bool hasFile, required List<String> answers}) {
  debugPrint('=== Mentee Engagement Submission ===');
  debugPrint('Session ID   : ${widget.sessionId}');
  if (hasFile) {
    debugPrint('File Name    : $_uploadedFileName');
    debugPrint('File Bytes   : ${_uploadedFileBytes?.length ?? 0} bytes');
  } else {
    for (int i = 0; i < answers.length; i++) {
      debugPrint('Answer ${i + 1}    : ${answers[i]}');
    }
  }
  debugPrint('====================================');

  ScaffoldMessenger.of(context).showSnackBar(
    const SnackBar(
      content: Text('Entry submitted successfully!'),
      backgroundColor: Color(0xFF2A2AAA),
    ),
  );

  // Reset
  for (final c in _answerControllers) {
    c.clear();
  }
  while (_answerControllers.length > 1) {
    _answerControllers.last.dispose();
    _answerControllers.removeLast();
  }
  setState(() {
    _uploadedFileName = null;
    _uploadedFileBytes = null;
  });
}

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Section title
          Row(
            children: [
              Icon(Icons.people_alt_outlined,
                  size: 20, color: Colors.green.shade600),
              const SizedBox(width: 8),
              Text(
                'Mentee Engagement',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: Colors.green.shade600,
                ),
              ),
            ],
          ),
const SizedBox(height: 6),
// ── Instruction text ──
Text(
  'Read the question document attached above and submit your answers below.',
  style: TextStyle(
    fontSize: 13,
    color: Colors.grey.shade600,
    height: 1.5,
  ),
),
          const SizedBox(height: 16),

          // Upload box
          FileUploadWidget(
            uploadedFileName: _uploadedFileName,
            onPickFile: _pickFile,
            onRemoveFile: _removeFile,
          ),
          const SizedBox(height: 16),

          // Comment box with dynamic answers
          CommentBoxWidget(
            answerControllers: _answerControllers,
            onPickFile: _pickFile,
            onSubmit: _handleSubmit,
            onAddAnswer: _addAnswer,
            onRemoveAnswer: _removeAnswer,
            uploadedFileName: _uploadedFileName,
          ),
        ],
      ),
    );
  }
}