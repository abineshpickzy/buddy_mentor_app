import 'package:flutter/material.dart';
import '../../../../../../core/widgets/shimmer_widgets.dart';

class TimelineItemSkeleton extends StatelessWidget {
  final bool isLast;

  const TimelineItemSkeleton({
    super.key,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Left: dot + line
          SizedBox(
            width: 40,
            child: Column(
              children: [
                const SizedBox(height: 14),
                const ShimmerBox(width: 26, height: 26, borderRadius: 13),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: Colors.grey.shade200,
                    ),
                  ),
              ],
            ),
          ),
          // Right: card
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(bottom: 16),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: Colors.grey.shade200),
                ),
                child: const Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ShimmerBox(width: 60, height: 12),
                    SizedBox(height: 4),
                    ShimmerBox(width: double.infinity, height: 14),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class TimelineSkeletonLoader extends StatelessWidget {
  const TimelineSkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerWrapper(
      child: ListView.builder(
        padding: const EdgeInsets.symmetric(horizontal: 20),
        itemCount: 6,
        itemBuilder: (context, index) {
          return TimelineItemSkeleton(
            isLast: index == 5,
          );
        },
      ),
    );
  }
}