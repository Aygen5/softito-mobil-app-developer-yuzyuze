import 'package:flutter/material.dart';

// Profil Ekranı: go_router içerisindeki 2. sekmeyi (StatefulShellBranch) temsil eder.
// Alt bardaki 'Profil' sekmesine tıklandığında ekrana basılır.
class Profil extends StatelessWidget {
  const Profil({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Profil İçeriği',
        style: TextStyle(fontSize: 24), 
      ),
    );
  }
}

