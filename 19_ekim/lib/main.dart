import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
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

  @override
  void initState() {
    super.initState();
    _beverageController = BeverageTrackerController();
    _workoutController = WorkoutController();
  }

  @override
  void dispose() {
    _beverageController.dispose();
    _workoutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Susadım',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      home: SplashScreen(
        beverageController: _beverageController,
        workoutController: _workoutController,
      ),
    );
  }
}
