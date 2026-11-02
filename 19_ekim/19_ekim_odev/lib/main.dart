import 'package:flutter/material.dart';
import 'screens/calendar_screen.dart';
import 'theme/app_colors.dart';

// Uygulamanın giriş noktası
void main() {
  // Widget ağacı çizilmeden önce Flutter motorunu hazır hale getiriyoruz
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const GunlugumApp());
}

/// Günlüğüm uygulamasının kök widget'ı.
/// Tema ve başlangıç rotasını yapılandırır.
class GunlugumApp extends StatelessWidget {
  const GunlugumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Günlüğüm',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        scaffoldBackgroundColor: AppColors.background,
        // Projenin renk paletini AppColors'dan alıyoruz
        colorScheme: ColorScheme.fromSeed(
          seedColor: AppColors.primary,
          primary: AppColors.primary,
          secondary: AppColors.secondary,
          surface: AppColors.surface,
          brightness: Brightness.light,
        ),
        appBarTheme: const AppBarTheme(
          backgroundColor: AppColors.background,
          foregroundColor: AppColors.onSurface,
          elevation: 0,
          scrolledUnderElevation: 0,
        ),
      ),
      // İlk açılış sayfası takvim ekranı
      home: const CalendarScreen(),
    );
  }
}
