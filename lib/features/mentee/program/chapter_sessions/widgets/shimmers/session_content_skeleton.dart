import 'package:flutter/material.dart';
import 'package:shimmer/shimmer.dart';

class _ShimmerBox extends StatelessWidget {
  final double? width;
  final double height;
  final double borderRadius;

  const _ShimmerBox({
    this.width,
    required this.height,
    this.borderRadius = 8,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width ?? double.infinity,
      height: height,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        borderRadius: BorderRadius.circular(borderRadius),
      ),
    );
  }
}

/// Full page skeleton shown while programOverviewProvider is loading
class SessionPageSkeleton extends StatelessWidget {
  const SessionPageSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade50,
      period: const Duration(milliseconds: 1200),
      child: Column(
        children: [
          // Tab bar skeleton
          _buildTabBarSkeleton(context),
          Divider(height: 1, color: Colors.grey.shade200),
          // Content skeleton
          Expanded(child: _buildContentSkeleton(context)),
        ],
      ),
    );
  }

  Widget _buildTabBarSkeleton(BuildContext context) {
    return Container(
      color: Colors.white,
      child: Column(
        children: [
          const SizedBox(height: 10),
          // Progress bar skeleton
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Row(
              children: [
                const _ShimmerBox(width: 120, height: 12),
                const Spacer(),
                const _ShimmerBox(width: 60, height: 12),
              ],
            ),
          ),
          const SizedBox(height: 10),
          // Tab pills skeleton
          SizedBox(
            height: 44,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12),
              children: List.generate(4, (i) {
                return Padding(
                  padding: const EdgeInsets.only(right: 8),
                  child: _ShimmerBox(
                    width: 90 + (i % 2 == 0 ? 10.0 : 0.0),
                    height: 36,
                    borderRadius: 20,
                  ),
                );
              }),
            ),
          ),
          const SizedBox(height: 4),
        ],
      ),
    );
  }

  Widget _buildContentSkeleton(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      children: [
        const SizedBox(height: 20),
        // Session title
        const _ShimmerBox(height: 20),
        const SizedBox(height: 10),
        // Subtitle line 1
        const _ShimmerBox(height: 13),
        const SizedBox(height: 6),
        // Subtitle line 2 shorter
        _ShimmerBox(
          width: MediaQuery.of(context).size.width * 0.6,
          height: 13,
        ),
        const SizedBox(height: 22),
        // Video player skeleton
        _ShimmerBox(
          width: double.infinity,
          height: 200,
          borderRadius: 12,
        ),
        const SizedBox(height: 22),
        // Downloads section header
        const _ShimmerBox(width: 120, height: 14),
        const SizedBox(height: 12),
        // Download item 1
        _buildDownloadItemSkeleton(),
        const SizedBox(height: 10),
        // Download item 2
        _buildDownloadItemSkeleton(),
        const SizedBox(height: 24),
        // Description header
        const _ShimmerBox(width: 100, height: 14),
        const SizedBox(height: 10),
        // Description lines
        const _ShimmerBox(height: 12),
        const SizedBox(height: 6),
        const _ShimmerBox(height: 12),
        const SizedBox(height: 6),
        _ShimmerBox(
          width: MediaQuery.of(context).size.width * 0.7,
          height: 12,
        ),
      ],
    );
  }

  Widget _buildDownloadItemSkeleton() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          const _ShimmerBox(width: 40, height: 40, borderRadius: 8),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _ShimmerBox(height: 12),
                const SizedBox(height: 6),
                _ShimmerBox(width: 80, height: 10),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const _ShimmerBox(width: 32, height: 32, borderRadius: 16),
        ],
      ),
    );
  }
}

/// Content-only skeleton shown while sessionContentProvider is loading
class SessionContentSkeleton extends StatelessWidget {
  const SessionContentSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Shimmer.fromColors(
      baseColor: Colors.grey.shade200,
      highlightColor: Colors.grey.shade50,
      period: const Duration(milliseconds: 1200),
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16),
        children: [
          const SizedBox(height: 20),
          // Session title
          const _ShimmerBox(height: 20),
          const SizedBox(height: 10),
          const _ShimmerBox(height: 13),
          const SizedBox(height: 6),
          _ShimmerBox(
            width: MediaQuery.of(context).size.width * 0.6,
            height: 13,
          ),
          const SizedBox(height: 22),
          // Video skeleton
          _ShimmerBox(
            width: double.infinity,
            height: 200,
            borderRadius: 12,
          ),
          const SizedBox(height: 22),
          // Downloads header
          const _ShimmerBox(width: 120, height: 14),
          const SizedBox(height: 12),
          _buildDownloadItemSkeleton(),
          const SizedBox(height: 10),
          _buildDownloadItemSkeleton(),
          const SizedBox(height: 24),
          // Description header
          const _ShimmerBox(width: 100, height: 14),
          const SizedBox(height: 10),
          const _ShimmerBox(height: 12),
          const SizedBox(height: 6),
          const _ShimmerBox(height: 12),
          const SizedBox(height: 6),
          _ShimmerBox(
            width: MediaQuery.of(context).size.width * 0.7,
            height: 12,
          ),
        ],
      ),
    );
  }

  Widget _buildDownloadItemSkeleton() {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: Colors.grey.shade200),
      ),
      child: Row(
        children: [
          const _ShimmerBox(width: 40, height: 40, borderRadius: 8),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const _ShimmerBox(height: 12),
                const SizedBox(height: 6),
                _ShimmerBox(width: 80, height: 10),
              ],
            ),
          ),
          const SizedBox(width: 12),
          const _ShimmerBox(width: 32, height: 32, borderRadius: 16),
        ],
      ),
    );
  }
}