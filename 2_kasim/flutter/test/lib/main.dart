import 'package:flutter/material.dart';
import 'routes/app_router.dart'; 

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      debugShowCheckedModeBanner: false,
      title: 'Softito go_router Örneği',
      routerConfig: appRouter, // Tüm alt menü ve sayfa düzeni buradan yönetiliyor
    );
  }
}
