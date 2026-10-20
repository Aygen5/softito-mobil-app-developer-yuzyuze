import 'package:flutter/material.dart';

/// ---------------------------------------------------------------------------
/// 🧭 AppBottomNavigation — Alt Navigasyon Çubuğu (Material 3 NavigationBar)
/// ---------------------------------------------------------------------------
/// Uygulamanın 3 ana sekmesi (Ana Sayfa, Rezervasyonlarım, Hesabım) arasında
/// hızlı geçiş sağlar.
///
/// Material 3 Farkı:
/// Eski Flutter sürümlerindeki 'BottomNavigationBar' yerine Material 3 standardı olan
/// 'NavigationBar' ve 'NavigationDestination' kullanıldı.
/// Bu yeni bileşen; seçili sekmede arkaya hap şeklinde renkli kapsül (indicatorColor)
/// koyar ve akıcı animasyonlar sunar.
class AppBottomNavigation extends StatelessWidget {
  /// Şu an aktif olan sekmenin sıfır tabanlı indeksi (0: Ana Sayfa, 1: Rezervasyonlar, 2: Hesap)
  final int currentIndex;

  /// Kullanıcı başka bir sekmeye dokunduğunda tetiklenen geri çağırım fonksiyonu
  final ValueChanged<int> onTap;

  const AppBottomNavigation({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Container(
      // Alt çubuğun üstüne ince modern bir sınır çizgisi (border) ekler
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        border: Border(
          top: BorderSide(
            color: theme.colorScheme.outline.withOpacity(isDark ? 0.3 : 0.6),
            width: 1,
          ),
        ),
      ),
      child: NavigationBar(
        selectedIndex: currentIndex,
        onDestinationSelected: onTap,
        backgroundColor: Colors.transparent,
        elevation: 0,
        // Aktif ikonun arkasındaki vurgulu oval kapsül rengi
        indicatorColor: theme.colorScheme.primaryContainer,
        // Yazı etiketlerini her zaman göster
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        height: 68,
        destinations: const [
          NavigationDestination(
            icon: Icon(Icons.home_outlined),
            selectedIcon: Icon(Icons.home_rounded),
            label: 'Ana Sayfa',
          ),
          NavigationDestination(
            icon: Icon(Icons.calendar_month_outlined),
            selectedIcon: Icon(Icons.calendar_month_rounded),
            label: 'Rezervasyonlarım',
          ),
          NavigationDestination(
            icon: Icon(Icons.person_outline_rounded),
            selectedIcon: Icon(Icons.person_rounded),
            label: 'Hesabım',
          ),
        ],
      ),
    );
  }
}

