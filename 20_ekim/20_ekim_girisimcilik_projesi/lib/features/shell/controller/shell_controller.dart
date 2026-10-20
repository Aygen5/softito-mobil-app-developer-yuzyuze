import 'package:flutter/foundation.dart';

class ShellController {
  final ValueNotifier<int> seciliSekmeIndex;

  ShellController([int baslangicSekme = 0])
      : seciliSekmeIndex = ValueNotifier<int>(baslangicSekme);

  void sekmeDegistir(int yeniIndex) {
    if (yeniIndex >= 0 && yeniIndex <= 3) {
      seciliSekmeIndex.value = yeniIndex;
    }
  }

  void dispose() {
    seciliSekmeIndex.dispose();
  }
}
