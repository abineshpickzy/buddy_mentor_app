import 'package:flutter/material.dart';
import 'package:buddymentor/core/constants/app_colors.dart';

class TimelineEmptyState extends StatelessWidget {
  final String title;
  final String subtitle;
  final IconData icon;
  final VoidCallback? onRetry;
  final String? retryButtonText;

  const TimelineEmptyState({
    super.key,
    required this.title,
    required this.subtitle,
    this.icon = Icons.timeline_outlined,
    this.onRetry,
    this.retryButtonText = 'Try Again',
  });

  // Factory constructors for common states
  factory TimelineEmptyState.noProgram({VoidCallback? onRetry}) {
    return TimelineEmptyState(
      title: 'No Program Selected',
      subtitle: 'Please select a program from the program list to view your timeline.',
      icon: Icons.school_outlined,
      onRetry: onRetry,
      retryButtonText: 'Go to Programs',
    );
  }

  factory TimelineEmptyState.error({VoidCallback? onRetry}) {
    return TimelineEmptyState(
      title: 'Unable to Load Timeline',
      subtitle: 'Something went wrong while loading your program timeline. Please check your connection and try again.',
      icon: Icons.error_outline,
      onRetry: onRetry,
      retryButtonText: 'Retry',
    );
  }

  factory TimelineEmptyState.networkError({VoidCallback? onRetry}) {
    return TimelineEmptyState(
      title: 'Connection Problem',
      subtitle: 'Please check your internet connection and try again.',
      icon: Icons.wifi_off_outlined,
      onRetry: onRetry,
      retryButtonText: 'Retry',
    );
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Icon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: Colors.grey.shade100,
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 40,
                color: Colors.grey.shade400,
              ),
            ),
            
            const SizedBox(height: 24),
            
            // Title
            Text(
              title,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: Color(0xFF1A1A2E),
              ),
              textAlign: TextAlign.center,
            ),
            
            const SizedBox(height: 8),
            
            // Subtitle
            Text(
              subtitle,
              style: TextStyle(
                fontSize: 14,
                color: Colors.grey.shade600,
                height: 1.4,
              ),
              textAlign: TextAlign.center,
            ),
            
            if (onRetry != null) ...[
              const SizedBox(height: 24),
              
              // Retry Button
              ElevatedButton(
                onPressed: onRetry,
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  elevation: 0,
                ),
                child: Text(
                  retryButtonText ?? 'Try Again',
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}