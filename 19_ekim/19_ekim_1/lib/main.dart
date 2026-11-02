import 'package:flutter/material.dart';
import 'core/theme/app_theme.dart';
import 'features/beverage_tracker/controller/beverage_tracker_controller.dart';
import 'features/splash/splash_screen.dart';
import 'features/workout/controller/workout_controller.dart';

void main() {
  // Flutter motorunu başlatıyoruz
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SusadimApp());
}

// Susadım Uygulaması: Su, içecek ve antrenman takibi yapan ana uygulama
class SusadimApp extends StatefulWidget {
  const SusadimApp({super.key});

  @override
  State<SusadimApp> createState() => _SusadimAppState();
}

class _SusadimAppState extends State<SusadimApp> {
  // Durum yönetimini sağlayan controller nesneleri
  late final BeverageTrackerController _beverageController;
  late final WorkoutController _workoutController;

  @override
  void initState() {
    super.initState();
    // Ekran açılırken controller'ları başlatıyoruz
    _beverageController = BeverageTrackerController();
    _workoutController = WorkoutController();
  }

  @override
  void dispose() {
    // Bellek sızıntısını önlemek için controller'ları kapatıyoruz
    _beverageController.dispose();
    _workoutController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Susadım',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme, // Koyu tema ile başlatıyoruz
      // İlk açılışta splash ekranını gösterip controller'ları parametre geçiyoruz
      home: SplashScreen(
        beverageController: _beverageController,
        workoutController: _workoutController,
      ),
    );
  }
}
