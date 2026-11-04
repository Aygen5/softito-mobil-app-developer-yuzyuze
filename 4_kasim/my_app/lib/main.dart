import 'package:flutter/material.dart';

/// ============================================================================
/// UYGULAMA GİRİŞ NOKTASI (ENTRY POINT) - MY_APP
/// ============================================================================
/// Bu dosya Flutter uygulamasının ana başlangıç noktasıdır.
/// 
/// 💡 Firebase ve Bildirim Entegrasyonu İçin Not:
/// Projede yazılan `BildirimServisi`, `YerelBildirimYoneticisi` ve `StorageServisi`
/// bileşenlerini canlıya alırken `main()` fonksiyonu genellikle aşağıdaki gibi
/// asenkron hale getirilir ve başlatılır:
/// 
/// ```dart
/// void main() async {
///   WidgetsFlutterBinding.ensureInitialized();
///   await Firebase.initializeApp(); // Firebase Core başlatma
///   await YerelBildirimYoneticisi.kurulum(); // Yerel bildirim kanalları
///   await BildirimServisi().baslat(); // FCM izinleri ve Token alma
///   runApp(const MyApp());
/// }
/// ```
void main() {
  runApp(const MyApp());
}

/// Uygulamanın kök widget'ı (Root Widget)
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        // Modern Material 3 renk şeması
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Firebase & Bildirim Çalışması (my_app)'),
    );
  }
}

/// Durumlu Ana Sayfa Widget'ı (StatefulWidget)
class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  int _counter = 0;

  // Butona tıklandığında sayacı 1 artıran ve arayüzü yeniden çizen metot
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
