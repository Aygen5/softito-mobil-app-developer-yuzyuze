import 'package:flutter/material.dart';

import 'core/constants/app_strings.dart';
import 'core/theme/app_theme.dart';
import 'core/theme/theme_controller.dart';
import 'features/auth/controller/auth_controller.dart';
import 'features/splash/view/splash_screen.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final themeController = ThemeController();
  final authController = AuthController();
  // Kayıtlı kullanıcı oturumu var mı diye kontrol ediyoruz
  await authController.initSession();

  runApp(
    YorungeApp(
      themeController: themeController,
      authController: authController,
    ),
  );
}

// Yörünge Girişimcilik Uygulaması
class YorungeApp extends StatelessWidget {
  final ThemeController themeController;
  final AuthController authController;

  const YorungeApp({
    super.key,
    required this.themeController,
    required this.authController,
  });

  @override
  Widget build(BuildContext context) {
    // ValueListenableBuilder: Tema modu (açık/koyu) değiştiğinde MaterialApp'i yeniler
    return ValueListenableBuilder<ThemeMode>(
      valueListenable: themeController.themeMode,
      builder: (context, currentMode, _) {
        return MaterialApp(
          title: AppStrings.appName,
          debugShowCheckedModeBanner: false,
          theme: AppTheme.lightTheme,
          darkTheme: AppTheme.darkTheme,
          themeMode: currentMode,
          // Açılış ekranı olarak SplashScreen başlatıyoruz
          home: SplashScreen(
            themeController: themeController,
            authController: authController,
          ),
        );
      },
    );
  }
}
