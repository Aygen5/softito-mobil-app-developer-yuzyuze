import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'features/beverage_tracker/controller/beverage_tracker_controller.dart';
import 'features/splash/splash_screen.dart';
import 'features/workout/controller/workout_controller.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SusadimApp());
}

class SusadimApp extends StatefulWidget {
  const SusadimApp({super.key});

  @override
  State<SusadimApp> createState() => _SusadimAppState();
}

class _SusadimAppState extends State<SusadimApp> {
  late final BeverageTrackerController _beverageController;
  late final WorkoutController _workoutController;
  late final ThemeController _themeController;

  @override
  void initState() {
    super.initState();
    _beverageController = BeverageTrackerController();
    _workoutController = WorkoutController();
    _themeController = ThemeController();
  }

  @override
  void dispose() {
    _beverageController.dispose();
    _workoutController.dispose();
    _themeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: _themeController,
      builder: (context, _) {
        return MaterialApp(
          title: 'Susadım v1',
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: _themeController.themeMode,
          home: SplashScreen(
            beverageController: _beverageController,
            workoutController: _workoutController,
            themeController: _themeController,
          ),
        );
      },
    );
  }
}
