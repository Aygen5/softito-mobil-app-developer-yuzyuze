import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/app_colors.dart';

/// Öğrenci paneli için alt menülü StatefulShellRoute kabuğu.
class StudentShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const StudentShell({super.key, required this.navigationShell});

  void _onDestinationSelected(int index) {
    navigationShell.goBranch(
      index,
      initialLocation: index == navigationShell.currentIndex,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: navigationShell,
      bottomNavigationBar: NavigationBar(
        selectedIndex: navigationShell.currentIndex,
        onDestinationSelected: _onDestinationSelected,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.dashboard_outlined),
            selectedIcon: Icon(Icons.dashboard_rounded),
            label: 'Ana Sayfa',
          ),
          NavigationDestination(
            icon: Icon(Icons.menu_book_outlined),
            selectedIcon: Icon(Icons.menu_book_rounded),
            label: 'Günlüğüm',
          ),
          NavigationDestination(
            icon: Icon(Icons.trending_up_outlined),
            selectedIcon: Icon(Icons.trending_up_rounded),
            label: 'İlerlemem',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Profil',
          ),
        ],
      ),
    );
  }
}
