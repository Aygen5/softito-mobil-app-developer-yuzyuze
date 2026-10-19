import 'package:flutter/material.dart';
import '../../core/constants/app_colors.dart';
import '../../core/theme/theme_controller.dart';
import '../beverage_tracker/controller/beverage_tracker_controller.dart';
import '../beverage_tracker/view/beverage_tracker_view.dart';
import '../workout/controller/workout_controller.dart';
import '../workout/view/workout_view.dart';

class DashboardShell extends StatefulWidget {
  final BeverageTrackerController beverageController;
  final WorkoutController workoutController;
  final ThemeController themeController;

  const DashboardShell({
    super.key,
    required this.beverageController,
    required this.workoutController,
    required this.themeController,
  });

  @override
  State<DashboardShell> createState() => _DashboardShellState();
}

class _DashboardShellState extends State<DashboardShell> {
  int _currentIndex = 0;

  @override
  Widget build(BuildContext context) {
    final pages = [
      BeverageTrackerView(
        controller: widget.beverageController,
        themeController: widget.themeController,
      ),
      WorkoutView(
        controller: widget.workoutController,
        themeController: widget.themeController,
      ),
    ];

    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: pages,
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) => setState(() => _currentIndex = index),
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.local_drink_outlined),
            selectedIcon: Icon(Icons.local_drink, color: AppColors.neonCyan),
            label: 'İçecek & Su',
          ),
          NavigationDestination(
            icon: Icon(Icons.fitness_center_outlined),
            selectedIcon: Icon(Icons.fitness_center, color: AppColors.neonLime),
            label: 'Antrenman',
          ),
        ],
      ),
    );
  }
}
