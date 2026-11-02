import 'package:flutter/material.dart';

// StokRozeti:
// Ürünün stokta olup olmadığını yeşil veya kırmızı renkli bir etiket (badge) olarak gösteren
// tekrar kullanılabilir (reusable) özel widget'ımız.
class StokRozeti extends StatelessWidget {
  final bool stoktaVarMi; // Ürünün stokta olup olmadığı bilgisi

  const StokRozeti({
    super.key,
    required this.stoktaVarMi,
  });

  @override
  Widget build(BuildContext context) {
    // Ternary operator (? :) kullanarak stok durumuna göre rengi dinamik seçiyoruz:
    // Stokta varsa yeşil tonları, tükenmişse kırmızı tonları uyguluyoruz.
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: stoktaVarMi ? Colors.green.shade50 : Colors.red.shade50,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: stoktaVarMi ? Colors.green.shade300 : Colors.red.shade300,
          width: 1,
        ),
      ),
      child: Text(
        stoktaVarMi ? 'Stokta Var' : 'Tükendi',
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: stoktaVarMi ? Colors.green.shade800 : Colors.red.shade800,
        ),
      ),
    );
  }
}

