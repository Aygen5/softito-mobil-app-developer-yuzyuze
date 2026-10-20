import 'package:flutter/material.dart';
import '../../../core/widgets/app_bottom_navigation.dart';
import 'home_screen.dart';
import '../../account/screens/account_screen.dart';

/// ---------------------------------------------------------------------------
/// 🐚 MainShell — Ana Uygulama İskeleti (Bottom Navigation Shell)
/// ---------------------------------------------------------------------------
/// Uygulamanın ana ekranlarını (Ana Sayfa, Rezervasyonlar, Hesap) barındıran
/// ve alt navigasyon çubuğuyla (AppBottomNavigation) yöneten ana kabuktur.
///
/// 👑 Kritik Flutter Mimarisi: 'IndexedStack'
/// Neden `if (_currentIndex == 0) HomeScreen() else AccountScreen()` KULLANMADIK?
/// Çünkü ternary / if-else yapısı kullanılsaydı, sekmeler arasında her geçişte
/// önceki ekran bellekten silinir (dispose olur) ve tekrar tıklandığında baştan
/// yüklenirdi. Bu durum; kullanıcının kaydırma (scroll) pozisyonunu kaybetmesine
/// ve arama filtrelerinin sıfırlanmasına sebep olurdu.
///
/// 'IndexedStack' ise çocuk widget'larının hepsini ağaçta canlı tutar; yalnızca
/// seçili indeksteki sayfayı görünür kılar. Böylece sekme değiştirdiğinizde
/// hiçbir veri ve kaydırma konumu kaybolmaz!
class MainShell extends StatefulWidget {
  final int initialIndex; // Başlangıçta hangi sekmenin açık geleceği (0: Home)

  const MainShell({super.key, this.initialIndex = 0});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _currentIndex; // Aktif sekme indeksi

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  /// Alt navigasyon çubuğundan bir sekmeye tıklandığında çalışır
  void _onNavigationTapped(int index) {
    setState(() {
      _currentIndex = index; // Seçilen sekme indeksini güncelle ve ekranı yeniden çiz
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      /// IndexedStack ile tüm ana sayfalar hafızada korunur
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          // 0. İndeks: Keşfet ve Vitrin Sayfası
          HomeScreen(),

          // 1. İndeks: Doğrudan 'Rezervasyonlarım' sekmesi açık gelen Profil/Hesap ekranı
          AccountScreen(initialTabIndex: 0),

          // 2. İndeks: Doğrudan 'Profil & Ayarlar' sekmesi açık gelen Hesap ekranı
          AccountScreen(initialTabIndex: 1),
        ],
      ),

      /// Alt Navigasyon Çubuğumuz
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: _currentIndex,
        onTap: _onNavigationTapped,
      ),
    );
  }
}

