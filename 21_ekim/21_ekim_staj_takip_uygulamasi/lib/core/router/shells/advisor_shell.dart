import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

import '../../theme/app_colors.dart';

/// Akademik Danışman paneli için alt menülü StatefulShellRoute kabuğu.
class AdvisorShell extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AdvisorShell({super.key, required this.navigationShell});

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
            icon: Icon(Icons.fact_check_outlined),
            selectedIcon: Icon(Icons.fact_check_rounded),
            label: 'Onay Bekleyenler',
          ),
          NavigationDestination(
            icon: Icon(Icons.people_outline),
            selectedIcon: Icon(Icons.people_rounded),
            label: 'Öğrencilerim',
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
