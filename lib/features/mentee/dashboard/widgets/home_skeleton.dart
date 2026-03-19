import 'package:flutter/material.dart';
import 'package:buddymentor/core/constants/app_colors.dart';
import 'package:buddymentor/core/widgets/shimmer_widgets.dart';

class HomeProgressSkeleton extends StatelessWidget {
  const HomeProgressSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          // Progress Circle Skeleton
          Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: Colors.grey.shade200,
            ),
            child: Stack(
              alignment: Alignment.center,
              children: [
                Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.grey.shade100,
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ShimmerBox(width: 40, height: 24),
                    const SizedBox(height: 4),
                    ShimmerBox(width: 60, height: 12),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Button Skeleton
          ShimmerBox(width: 200, height: 46, borderRadius: 10),
        ],
      ),
    );
  }
}

class WeekCardSkeleton extends StatelessWidget {
  const WeekCardSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.grey.shade100, width: 0.5),
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        leading: ShimmerBox(
          width: 28,
          height: 28,
          borderRadius: 14,
        ),
        title: ShimmerBox(width: 60, height: 12),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 4),
          child: ShimmerBox(width: double.infinity, height: 16),
        ),
        trailing: ShimmerBox(
          width: 60,
          height: 20,
          borderRadius: 20,
        ),
      ),
    );
  }
}

class HomeSkeletonLoader extends StatelessWidget {
  const HomeSkeletonLoader({super.key});

  @override
  Widget build(BuildContext context) {
    return ShimmerWrapper(
      child: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Header row skeleton
            Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        ShimmerBox(width: 24, height: 24),
                        const SizedBox(width: 20),
                        ShimmerBox(width: 120, height: 20),
                      ],
                    ),
                    Container(
                      width: 34,
                      height: 34,
                      decoration: const BoxDecoration(
                        color: Color(0xFFE8EAF6),
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 5),
                Divider(height: 1, color: AppColors.border),
              ],
            ),

            const SizedBox(height: 24),

            // Progress + CTA skeleton
            const HomeProgressSkeleton(),

            const SizedBox(height: 32),

            // Section label skeleton
            ShimmerBox(width: 150, height: 12),
            const SizedBox(height: 12),

            // Week list skeleton
            Column(
              children: List.generate(
                5,
                (index) => const WeekCardSkeleton(),
              ),
            ),
            const SizedBox(height: 16),
          ],
        ),
      ),
    );
  }
}