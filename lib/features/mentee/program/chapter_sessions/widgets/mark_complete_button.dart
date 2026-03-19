import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';

class MarkCompleteButton extends ConsumerWidget {
  /// Whether the session is already marked as complete (status == 2)
  final bool isSessionComplete;
  
  /// Callback to mark session complete
  final Future<bool> Function() onMarkComplete;
  
  /// Callback when session is marked complete (to navigate to next)
  final VoidCallback? onSuccess;

  const MarkCompleteButton({
    super.key,
    required this.isSessionComplete,
    required this.onMarkComplete,
    this.onSuccess,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // If already completed, show completed state with continue button
    if (isSessionComplete) {
      return _buildCompletedState(context);
    }

    // If not completed, show mark complete button
    return _buildMarkCompleteButton(context);
  }

  /// Completed state - shows green badge with continue to next button
  Widget _buildCompletedState(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Completed badge
              Container(
                height: 52,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFFD4EDDA),
                      Color(0xFFC3E6CB),
                    ],
                  ),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: const Color(0xFF28A745),
                    width: 1.5,
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Container(
                      width: 24,
                      height: 24,
                      decoration: const BoxDecoration(
                        color: Color(0xFF28A745),
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.check,
                        color: Colors.white,
                        size: 16,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Session Completed',
                      style: GoogleFonts.inter(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF155724),
                        letterSpacing: 0.1,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 12),
              // Continue to next button
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: onSuccess,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2D4383),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 2,
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Continue to Next',
                        style: GoogleFonts.inter(
                          fontSize: 15,
                          fontWeight: FontWeight.w600,
                          letterSpacing: 0.1,
                        ),
                      ),
                      const SizedBox(width: 6),
                      const Icon(Icons.arrow_forward, size: 18),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Mark complete button - blue button for uncompleted sessions
  Widget _buildMarkCompleteButton(BuildContext context) {
    return Container(
      color: Colors.white,
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: SizedBox(
            width: double.infinity,
            height: 52,
            child: ElevatedButton(
              onPressed: () async {
                try {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Marking session as complete...'),
                      behavior: SnackBarBehavior.floating,
                      duration: Duration(seconds: 10),
                      backgroundColor: Colors.blue,
                    ),
                  );

                  final success = await onMarkComplete();

                  if (success && context.mounted) {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Session marked as complete ✓'),
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 2),
                        backgroundColor: Color(0xFF28A745),
                      ),
                    );

                    // Call success callback after brief delay
                    Future.delayed(const Duration(milliseconds: 500), () {
                      onSuccess?.call();
                    });
                  } else if (context.mounted) {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Failed to mark session as complete'),
                        behavior: SnackBarBehavior.floating,
                        duration: Duration(seconds: 3),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                } catch (e) {
                  if (context.mounted) {
                    ScaffoldMessenger.of(context).clearSnackBars();
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text('Error: $e'),
                        behavior: SnackBarBehavior.floating,
                        duration: const Duration(seconds: 3),
                        backgroundColor: Colors.red,
                      ),
                    );
                  }
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF2D4383),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(14),
                ),
                elevation: 2,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Mark as Complete',
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      letterSpacing: 0.1,
                    ),
                  ),
                  const SizedBox(width: 6),
                  const Icon(Icons.check, size: 18),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}