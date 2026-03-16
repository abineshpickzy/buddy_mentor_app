import 'package:flutter/material.dart';
import 'package:buddymentor/core/widgets/shimmer_widgets.dart';

class ProgramCardSkeleton extends StatelessWidget {
  const ProgramCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerWrapper(
      child: Container(
        margin: const EdgeInsets.only(bottom: 20),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.06),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header image area skeleton
            ShimmerBox(
              width: double.infinity,
              height: 140,
              borderRadius: 0,
            ),
            Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title
                  ShimmerBox(width: double.infinity, height: 16),
                  const SizedBox(height: 8),
                  // Subtitle line 1
                  ShimmerBox(width: double.infinity, height: 12),
                  const SizedBox(height: 6),
                  // Subtitle line 2 (shorter)
                  ShimmerBox(width: MediaQuery.of(context).size.width * 0.55, height: 12),
                  const SizedBox(height: 16),
                  // Icon row
                  Row(
                    children: [
                      ShimmerBox(width: 70, height: 12),
                      const SizedBox(width: 12),
                      ShimmerBox(width: 60, height: 12),
                      const SizedBox(width: 12),
                      ShimmerBox(width: 50, height: 12),
                    ],
                  ),
                  const SizedBox(height: 20),
                  // Bottom row: price + button
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ShimmerBox(width: 100, height: 16),
                      ShimmerBox(width: 100, height: 40, borderRadius: 8),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}