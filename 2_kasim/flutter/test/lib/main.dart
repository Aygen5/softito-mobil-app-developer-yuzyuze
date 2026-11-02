import 'package:flutter/material.dart';
import 'routes/app_router.dart'; 

// Uygulamanın giriş noktası
void main() {
  runApp(const MyApp());
}

// Kök widget: go_router ile rota yönetimini başlatıyor
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MaterialApp.router: go_router paketini projeye bağlamak için standart MaterialApp yerine bunu kullanıyoruz.
    return MaterialApp.router(
      debugShowCheckedModeBanner: false, // Sağ üstteki debug bandını kaldırır
      title: 'Softito go_router Örneği',
      // routerConfig: Sayfa yönlendirmelerini, alt bar geçişlerini app_router.dart dosyasından çekiyoruz
      routerConfig: appRouter,
    );
  }
}
