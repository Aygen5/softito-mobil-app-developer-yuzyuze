import 'package:flutter/material.dart';
import '../../../core/widgets/app_bottom_navigation.dart';
import 'home_screen.dart';
import '../../account/screens/account_screen.dart';

class MainShell extends StatefulWidget {
  final int initialIndex;

  const MainShell({super.key, this.initialIndex = 0});

  @override
  State<MainShell> createState() => _MainShellState();
}

class _MainShellState extends State<MainShell> {
  late int _currentIndex;

  @override
  void initState() {
    super.initState();
    _currentIndex = widget.initialIndex;
  }

  void _onNavigationTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _currentIndex,
        children: const [
          // 0: Ana Sayfa
          HomeScreen(),
          // 1: Rezervasyonlarım Sekmesi
          AccountScreen(initialTabIndex: 0),
          // 2: Hesabım Sekmesi
          AccountScreen(initialTabIndex: 1),
        ],
      ),
      bottomNavigationBar: AppBottomNavigation(
        currentIndex: _currentIndex,
        onTap: _onNavigationTapped,
      ),
    );
  }
}
