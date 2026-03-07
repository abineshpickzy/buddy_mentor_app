import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/constants/app_colors.dart';

class MenteeDashboardShell extends StatelessWidget {
  final Widget child;
  const MenteeDashboardShell({super.key, required this.child});

  int _getIndex(String location) {
    if (location.startsWith('/menteetimeline')) return 1;
    if (location.startsWith('/menteemap')) return 2;
    if (location.startsWith('/menteetree')) return 3;
    if (location.startsWith('/menteeprofile')) return 4;
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    final location = GoRouterState.of(context).uri.toString();

    return Scaffold(
      body: child,
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _getIndex(location),
        onTap: (index) {
          switch (index) {
            case 0:
              context.push('/menteedashboard');
              break;
            case 1:
              context.push('/menteetimeline');
              break;
            case 2:
              context.push('/menteemap');
              break;
            case 3:
              context.push('/menteetree');
              break;
            case 4:
              context.push('/menteeprofile');
              break;
          }
        },
        type: BottomNavigationBarType.fixed,
        selectedItemColor: AppColors.primary,
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
          BottomNavigationBarItem(
            icon: Icon(Icons.timeline),
            label: "Timeline",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.map), label: "Map"),
          BottomNavigationBarItem(
            icon: Icon(Icons.account_tree),
            label: "Tree",
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: "Profile"),
        ],
      ),
    );
  }
}
