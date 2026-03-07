import 'package:buddymentor/core/constants/app_colors.dart';
import 'package:buddymentor/features/mentee/dashboard/screens/mentee_program_timeline/models/timeline_model.dart';
import 'package:flutter/material.dart';

class MenteeTimelineScreen extends StatelessWidget {
  const MenteeTimelineScreen({super.key});

  @override
  Widget build(BuildContext context) {
    int completedCount =
        items.where((e) => e.status == "completed").length;

    double progress = completedCount / items.length;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F6FA),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),

              /// 🔹 HEADER
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    "Program Timeline",
                    style: TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold,color: AppColors.textDark),
                  ),
                  Text(
                    "${(progress *  100).toInt()}%" ,
                    style: const TextStyle(
                        fontSize: 12, color: Colors.grey),
                  ),
                ],
              ),

              const SizedBox(height: 4),

              Text(
                "${items.length}-week structured journey",
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),

              const SizedBox(height: 10),

              /// 🔹 Progress Bar
              ClipRRect(
                borderRadius: BorderRadius.circular(10),
                child: LinearProgressIndicator(
                  value: progress,
                  minHeight: 6,
                  backgroundColor: Colors.grey.shade300,
                  color: AppColors.primary,
                ),
              ),

              const SizedBox(height: 20),

              /// 🔹 Timeline List
              Expanded(
                child: ListView.builder(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];

                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        /// LEFT SIDE
                        Column(
                          children: [
                            _buildIndicator(item.status),
                            if (index != items.length - 1)
                              Container(
                                width: 2,
                                height: 80,
                                color: _getLineColor(item.status),
                              ),
                          ],
                        ),

                        const SizedBox(width: 12),

                        /// RIGHT CARD
                        Expanded(child: _buildCard(item)),
                      ],
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// 🔹 Indicator
  Widget _buildIndicator(String status) {
    if (status == "completed") {
      return Container(
        width: 22,
        height: 22,
        decoration: const BoxDecoration(
          color: AppColors.primary,
          shape: BoxShape.circle,
        ),
        child: const Icon(Icons.check, size: 14, color: Colors.white),
      );
    }

    if (status == "inprogress") {
      return Container(
        width: 22,
        height: 22,
        decoration: BoxDecoration(
          color: Colors.white,
          shape: BoxShape.circle,
          border: Border.all(color: AppColors.primary, width: 3),
        ),
      );
    }

    return Container(
      width: 22,
      height: 22,
      decoration: BoxDecoration(
        color: Colors.grey.shade300,
        shape: BoxShape.circle,
      ),
      child: const Icon(Icons.lock, size: 12, color: Colors.grey),
    );
  }

  /// 🔹 Card
  Widget _buildCard(TimelineItem item) {
    bool isLocked = item.status == "locked";
    bool isInProgress = item.status == "inprogress";

    return Container(
      margin: const EdgeInsets.only(bottom: 20),
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: isLocked ? Colors.grey.shade100 : Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: isInProgress
            ? Border.all(color: AppColors.primary)
            : Border.all(color: Colors.grey.shade200),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "Week ${item.week}",
            style: TextStyle(
              fontSize: 12,
              color: isLocked ? Colors.grey : Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            item.title,
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: isLocked ? Colors.grey : Colors.black,
            ),
          ),
          if (item.status == "completed")
            const Padding(
              padding: EdgeInsets.only(top: 6),
              child: Text(
                "Complete",
                style: TextStyle(
                    color: AppColors.primary, fontSize: 12),
              ),
            ),
          if (item.status == "inprogress")
            const Padding(
              padding: EdgeInsets.only(top: 6),
              child: Text(
                "In Progress",
                style: TextStyle(
                    color: AppColors.primary, fontSize: 12),
              ),
            ),
        ],
      ),
    );
  }

  Color _getLineColor(String status) {
    if (status == "completed" || status == "inprogress") {
      return AppColors.primary;
    }
    return Colors.grey.shade300;
  }
}