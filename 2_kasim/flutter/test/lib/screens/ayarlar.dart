import 'package:flutter/material.dart';
// Ayarlar Ekranı: go_router içerisindeki 3. sekmeyi (StatefulShellBranch) temsil eder.
// Alt bardaki 'Ayarlar' sekmesine tıklandığında ekrana basılır.
class Ayarlar extends StatelessWidget {
  const Ayarlar({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: Text(
        'Ayarlar İçeriği',
        style: TextStyle(fontSize: 24), 
      ),
    );
  }
}
