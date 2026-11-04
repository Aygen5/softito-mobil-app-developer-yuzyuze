import 'package:flutter/material.dart';

/// ============================================================================
/// UYGULAMA GİRİŞ NOKTASI (ENTRY POINT) - MY_APP2
/// ============================================================================
/// Bu proje, Firebase Cloud Messaging (FCM) ve Firebase Storage servislerinin
/// katmanlı mimaride (models, services, widgets) nasıl kurgulanacağını gösterir.
/// 
/// 💡 Canlı Entegrasyon Senaryosu:
/// Bu uygulamayı tam teşekküllü çalıştırmak için `main()` fonksiyonunda
/// Firebase çekirdeği ve FCM servisi başlatılır:
/// 
/// ```dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   await Firebase.initializeApp(); // Firebase Core
///   
///   final fcmServisi = FcmBildirimServisi();
///   await fcmServisi.baslat(); // FCM izinleri ve yerel bildirim kurulumu
///   
///   runApp(const MyApp());
/// }
/// ```
void main() {
  runApp(const MyApp());
}

/// Uygulamanın Kök Widget'ı
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FCM & Storage Yönetimi (my_app2)',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFF006C4A)),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'FCM & Storage Yönetimi'),
    );
  }
}

/// Ana Sayfa Widget'ı
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  void _incrementCounter() {
    setState(() {
      _counter++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Butona basılma sayısı:',
              style: TextStyle(fontSize: 16),
            ),
            Text(
              '$_counter',
              style: Theme.of(context).textTheme.headlineMedium,
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _incrementCounter,
        tooltip: 'Sayaç Artır',
        child: const Icon(Icons.add),
      ),
    );
  }
}
