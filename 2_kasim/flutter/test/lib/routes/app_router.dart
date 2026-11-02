import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/anasayfa.dart';
import '../screens/profil.dart';
import '../screens/ayarlar.dart';

// GoRouter yapılandırması:
// Uygulamanın tüm yönlendirme mantığını burada tutuyoruz.
final GoRouter appRouter = GoRouter(
  initialLocation: '/', // Uygulama ilk açıldığında gösterilecek başlangıç rotası
  routes: [
    // StatefulShellRoute.indexedStack:
    // Bu yapının en büyük avantajı; sekmeler (tabs) arası geçişte sayfaların durumunu (scroll konumu, girilen veriler)
    // kaybetmemesidir. Sayfalar arkada canlı kalır, IndexedStack mantığıyla gizlenip gösterilir.
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        // Alt çubuğu (BottomNavigationBar) barındıran ortak kabuk ekran
        return AnaGecisEkrani(navigationShell: navigationShell);
      },
      branches: [
        // 1. Dal: Anasayfa sekmesi ve rotaları
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const Anasayfa(),
            ),
          ],
        ),
        // 2. Dal: Profil sekmesi ve rotaları
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profil',
              builder: (context, state) => const Profil(), 
            ),
          ],
        ),
        // 3. Dal: Ayarlar sekmesi ve rotaları
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/ayarlar',
              builder: (context, state) => const Ayarlar(),
            ),
          ],
        ),
      ],
    ),
  ],
);

// Ana Geçiş Ekranı: Scaffold, dinamik AppBar ve BottomNavigationBar içerir
class AnaGecisEkrani extends StatelessWidget {
  // StatefulNavigationShell: GoRouter'ın aktif sekme indeksini ve dallarını yöneten nesnesi
  final StatefulNavigationShell navigationShell;

  const AnaGecisEkrani({super.key, required this.navigationShell});

  // Seçili sekmeye göre AppBar başlığını dinamik belirleyen fonksiyon
  String _getBaslik(int index) {
    switch (index) {
      case 0:
        return 'Anasayfa';
      case 1:
        return 'Profil';
      case 2:
        return 'Ayarlar';
      default:
        return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(_getBaslik(navigationShell.currentIndex)),
        centerTitle: true,
      ),
  
      // body olarak doğrudan navigationShell veriyoruz, o anki dalın widget'ını ekrana basar
      body: navigationShell, 
      bottomNavigationBar: BottomNavigationBar(
        // Aktif sekmenin indeksini navigationShell'den alıyoruz
        currentIndex: navigationShell.currentIndex,
        onTap: (int index) {
          // goBranch: İlgili dala geçiş yapar.
          // initialLocation parametresi ile aynı sekmeye tekrar tıklanırsa alt sayfalardan sekmenin ana ekranına dönülmesini sağlar.
          navigationShell.goBranch(index, initialLocation: index == navigationShell.currentIndex);
        },
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Anasayfa'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profil'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Ayarlar'),
        ],
      ),
    );
  }
}

