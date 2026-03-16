import 'package:flutter/material.dart';
import 'package:buddymentor/core/widgets/shimmer_widgets.dart';

class StatCardSkeleton extends StatelessWidget {
  const StatCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerWrapper(
      child: Container(
        width: MediaQuery.of(context).size.width * 0.28,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: Colors.grey.shade100),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            ShimmerBox(width: 20, height: 20, borderRadius: 4),
            const SizedBox(height: 8),
            ShimmerBox(width: 40, height: 16),
            const SizedBox(height: 4),
            ShimmerBox(width: 70, height: 10),
          ],
        ),
      ),
    );
  }
}