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

          // Dot color: white when selected, colored when not
          Color dotColor;
         if(isLocked) {
            dotColor = Colors.grey;
          }
          else if(session.status==2){
            dotColor=Colors.green;
          }
          else{
            dotColor=Colors.yellow;
          }

          return Tab(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 200),
              padding: EdgeInsets.symmetric(
                // Selected pill gets slightly more horizontal padding
                horizontal: isSelected ? 16 : 12,
                vertical: 7,
              ),
              decoration: BoxDecoration(
                // Selected: filled navy pill. Unselected: no bg, no border
                color: isSelected
                    ? const Color(0xFF2564d7)
                    : Colors.transparent,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(10),topRight: Radius.circular(10)),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (isLocked) ...[
                    Icon(
                      Icons.lock_outline,
                      size: 12,
                      color: isSelected ? Colors.white : Colors.grey.shade500,
                    ),
                    const SizedBox(width: 5),
                  ] else ...[
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: dotColor,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 6),
                  ],
                  Text(
                    session.name,
                    style: TextStyle(
                      fontSize: 13,
                      fontWeight: isSelected
                          ? FontWeight.w600
                          : FontWeight.w500,
                      color: isSelected
                          ? Colors.white
                          : Colors.black87,
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