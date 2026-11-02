import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/anasayfa.dart';
import '../screens/profil.dart';
import '../screens/ayarlar.dart';

final GoRouter appRouter = GoRouter(
  initialLocation: '/', 
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, navigationShell) {
        return AnaGecisEkrani(navigationShell: navigationShell);
      },
      branches: [
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => const Anasayfa(),
            ),
          ],
        ),
        StatefulShellBranch(
          routes: [
            GoRoute(
              path: '/profil',
              builder: (context, state) => const Profil(), 
            ),
          ],
        ),
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

class AnaGecisEkrani extends StatelessWidget {
  final StatefulNavigationShell navigationShell;

  const AnaGecisEkrani({super.key, required this.navigationShell});

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
  
      body: navigationShell, 
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: navigationShell.currentIndex,
        onTap: (int index) {
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

