import 'package:flutter/material.dart';

class CommentBoxWidget extends StatefulWidget {
  final List<TextEditingController> answerControllers;
  final VoidCallback onPickFile;
  final VoidCallback onSubmit;
  final String? uploadedFileName;
  final VoidCallback onAddAnswer;
  final Function(int) onRemoveAnswer;

  const CommentBoxWidget({
    super.key,
    required this.answerControllers,
    required this.onPickFile,
    required this.onSubmit,
    required this.onAddAnswer,
    required this.onRemoveAnswer,
    this.uploadedFileName,
  });

  @override
  State<CommentBoxWidget> createState() => _CommentBoxWidgetState();
}

class _CommentBoxWidgetState extends State<CommentBoxWidget> {
  void _addAndScroll() {
    widget.onAddAnswer();
    // Let the page ListView handle scrolling to bottom
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final ctx = context;
      if (!ctx.mounted) return;
      // Find the nearest Scrollable (the page ListView) and scroll to end
      final scrollable = Scrollable.maybeOf(ctx);
      if (scrollable != null) {
        scrollable.position.animateTo(
          scrollable.position.maxScrollExtent,
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final bool fileUploaded = widget.uploadedFileName != null;
    final bool canAddMore =
        widget.answerControllers.length < 10 && !fileUploaded;
    final int count = widget.answerControllers.length;

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          // ── Sticky-style Header (fixed inside card, page scrolls) ──
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                top: Radius.circular(12),
              ),
              border: Border(
                bottom:
                    BorderSide(color: Colors.grey.shade200, width: 0.5),
              ),
            ),
            padding:
                const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
            child: Row(
              children: [
                const Text(
                  'Your Answers',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1A1A2E),
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 8, vertical: 2),
                  decoration: BoxDecoration(
                    color: const Color(0xFF2A2AAA).withOpacity(0.08),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(
                    '$count / 10',
                    style: const TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2A2AAA),
                    ),
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  onTap: canAddMore ? _addAndScroll : null,
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 200),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 7),
                    decoration: BoxDecoration(
                      color: canAddMore
                          ? const Color(0xFF2A2AAA)
                          : Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          Icons.add_rounded,
                          size: 15,
                          color: canAddMore
                              ? Colors.white
                              : Colors.grey.shade400,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          canAddMore
                              ? 'Add Answer'
                              : count >= 10
                                  ? 'Max Reached'
                                  : 'File Uploaded',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w600,
                            color: canAddMore
                                ? Colors.white
                                : Colors.grey.shade400,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // ── Answer boxes — expands naturally, page scrolls ──
          if (fileUploaded)
            Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.green.shade50,
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(Icons.insert_drive_file_outlined,
                        size: 18, color: Colors.green.shade600),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.uploadedFileName!,
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.green.shade700,
                            fontWeight: FontWeight.w500,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 2),
                        Text(
                          'Text answers disabled while file is attached',
                          style: TextStyle(
                              fontSize: 11, color: Colors.grey.shade500),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            )
          else
            // No internal scroll — expands fully, page ListView scrolls
            Column(
              mainAxisSize: MainAxisSize.min,
              children: List.generate(
                widget.answerControllers.length,
                (index) => Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    _buildAnswerField(index),
                    if (index < widget.answerControllers.length - 1)
                      Divider(
                          height: 0.5, color: Colors.grey.shade100),
                  ],
                ),
              ),
            ),

          // ── Bottom bar ──
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: const BorderRadius.vertical(
                bottom: Radius.circular(12),
              ),
              border: Border(
                top: BorderSide(color: Colors.grey.shade200, width: 0.5),
              ),
            ),
            padding:
                const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
            child: Row(
              children: [
                const Spacer(),
                ElevatedButton.icon(
                  onPressed: widget.onSubmit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2A2AAA),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 20, vertical: 10),
                    elevation: 0,
                  ),
                  icon: const Icon(Icons.send_rounded, size: 15),
                  label: const Text(
                    'Post',
                    style: TextStyle(
                        fontSize: 13, fontWeight: FontWeight.w600),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildAnswerField(int index) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      color: const Color(0xFF2A2AAA).withOpacity(0.1),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    alignment: Alignment.center,
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w700,
                        color: Color(0xFF2A2AAA),
                      ),
                    ),
                  ),
                  const SizedBox(width: 7),
                  Text(
                    'Answer ${index + 1}',
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: Color(0xFF2A2AAA),
                    ),
                  ),
                ],
              ),
              if (widget.answerControllers.length > 1)
                GestureDetector(
                  onTap: () => widget.onRemoveAnswer(index),
                  child: Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: Colors.red.shade50,
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Icon(Icons.close_rounded,
                        size: 14, color: Colors.red.shade400),
                  ),
                ),
            ],
          ),
          const SizedBox(height: 7),
          TextField(
            controller: widget.answerControllers[index],
            maxLines: 3,
            decoration: InputDecoration(
              hintText: 'Type your answer ${index + 1} here...',
              hintStyle:
                  TextStyle(fontSize: 13, color: Colors.grey.shade400),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    BorderSide(color: Colors.grey.shade200, width: 0.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide:
                    BorderSide(color: Colors.grey.shade200, width: 0.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: const BorderSide(
                    color: Color(0xFF2A2AAA), width: 1),
              ),
              contentPadding: const EdgeInsets.all(12),
              filled: true,
              fillColor: Colors.grey.shade50,
            ),
          ),
        ],
      ),
    );
  }
}