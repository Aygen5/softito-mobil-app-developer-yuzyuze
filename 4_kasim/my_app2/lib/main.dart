import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'firebase_options.dart';
import 'screens/storage_ve_fcm_ekrani.dart';

/// ============================================================================
/// UYGULAMA GİRİŞ NOKTASI (ENTRY POINT)
/// ============================================================================
void main() async {
  // Flutter widget ağacının ve platform kanallarının hazır olduğundan emin oluyoruz
  WidgetsFlutterBinding.ensureInitialized();

  // Firebase servislerini (FCM, Storage vb.) başlatıyoruz
  try {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );
  } catch (e) {
    debugPrint('Firebase başlatma hatası: $e');
  }

  // Kök widget'ı çalıştırıyoruz
  runApp(const SoftitoFcmDemoApplication());
}

/// ============================================================================
/// KÖK UYGULAMA WIDGET'I (ROOT WIDGET)
/// ============================================================================
class SoftitoFcmDemoApplication extends StatelessWidget {
  const SoftitoFcmDemoApplication({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false, // Sağ üstteki debug şeridini gizler
      title: 'Softito FCM Demo Application',
      theme: ThemeData(
        // Uygulamanın genel tema rengi ve açık tema ayarı
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF006C4A),
          brightness: Brightness.light,
        ),
        useMaterial3: true, // Modern Material 3 tasarım standardı
      ),
      // Başlangıç ekranı olarak Storage ve FCM yönetim ekranı açılır
      home: const StorageVeFcmEkrani(),
    );
  }
}
