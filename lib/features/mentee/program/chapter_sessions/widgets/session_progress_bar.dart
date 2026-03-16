import 'package:flutter/material.dart';

class SessionProgressBar extends StatelessWidget {
  final List<dynamic> sessions;

  const SessionProgressBar({
    super.key,
    required this.sessions,
  });

  @override
  Widget build(BuildContext context) {
    final completedCount = sessions.where((s) => s.status == 2).length;
    final progress = sessions.isNotEmpty ? completedCount / sessions.length : 0.0;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: ClipRRect(
              borderRadius: BorderRadius.circular(4),
              child: LinearProgressIndicator(
                value: progress,
                minHeight: 6,
                backgroundColor: Colors.grey.shade200,
                valueColor: const AlwaysStoppedAnimation<Color>(
                  Color(0xFF2564d7),
                ),
              ),
            ),
          ),
          const SizedBox(width: 10),
          Text(
            '$completedCount/${sessions.length} completed',
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey.shade500,
              fontWeight: FontWeight.w400,
            ),
          ),
        ],
      ),
    );
  }
}