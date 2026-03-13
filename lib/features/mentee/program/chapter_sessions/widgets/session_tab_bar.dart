import 'package:flutter/material.dart';

class SessionTabBar extends StatelessWidget {
  final TabController tabController;
  final List<dynamic> sessions;
  final Function(int) onTap;
  final Function(List<dynamic>) findCurrentSessionIndex;

  const SessionTabBar({
    super.key,
    required this.tabController,
    required this.sessions,
    required this.onTap,
    required this.findCurrentSessionIndex,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 44,
      child: TabBar(
        controller: tabController,
        isScrollable: true,
        tabAlignment: TabAlignment.start,
        indicatorColor: Colors.transparent,
        dividerColor: Colors.transparent,
        labelPadding: const EdgeInsets.only(left: 4, right: 4),
        padding: const EdgeInsets.symmetric(horizontal: 12),
        onTap: (index) {
          final selectedSession = sessions[index];
          if (selectedSession.isLocked) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text('${selectedSession.name} is locked'),
                behavior: SnackBarBehavior.floating,
                duration: const Duration(seconds: 2),
              ),
            );
            final currentIndex = findCurrentSessionIndex(sessions);
            tabController.animateTo(currentIndex);
            return;
          }
          onTap(index);
        },
        tabs: List.generate(sessions.length, (i) {
          final session = sessions[i];
          final isSelected = tabController.index == i;
          final isLocked = session.isLocked;

          Color dotColor;
          if (isSelected) {
            dotColor = Colors.white;
          } else {
            final colors = [
              Colors.amber.shade400,
              Colors.blue.shade400,
              Colors.green.shade400,
              Colors.pink.shade400,
              Colors.purple.shade400,
            ];
            dotColor = colors[i % colors.length];
          }

          return Tab(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
              decoration: BoxDecoration(
                color: isSelected
                    ? const Color(0xFF2D4383)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF2D4383)
                      : Colors.grey.shade300,
                  width: 1,
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isLocked) ...[
                    Icon(
                      Icons.lock_outline,
                      size: 12,
                      color: isSelected ? Colors.white : Colors.grey.shade600,
                    ),
                    const SizedBox(width: 4),
                  ] else ...[
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: dotColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                  ],
                  Text(
                    session.name,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: isSelected ? Colors.white : Colors.grey.shade700,
                    ),
                  ),
                ],
              ),
            ),
          );
        }),
      ),
    );
  }
}