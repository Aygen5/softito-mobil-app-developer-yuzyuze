import 'package:flutter/material.dart';
import 'package:_3_kasim_veri/models/ogrenci_model.dart';
import 'package:_3_kasim_veri/services/firestore_ogrenci_servisi.dart';

/// Öğrencinin notunu güncellemek için açılan modal iletişim kutusu
class NotGuncelleDialog {
  static Future<void> goster({
    required BuildContext context,
    required OgrenciModel ogrenci,
    required IOgrenciServisi ogrenciServisi,
  }) async {
    final TextEditingController notKontrolcusu =
        TextEditingController(text: ogrenci.notu.toString());

    try {
      final String? girilenNot = await showDialog<String>(
        context: context,
        builder: (BuildContext dialogContext) => AlertDialog(
          title: Text('${ogrenci.adSoyad} için Not Güncelle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Proje: ${ogrenci.projeAdi}',
                  style: const TextStyle(color: Colors.grey)),
              const SizedBox(height: 12),
              TextField(
                controller: notKontrolcusu,
                autofocus: true,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Yeni Not (0-100)',
                  prefixIcon: Icon(Icons.grade),
                  border: OutlineInputBorder(),
                ),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text('İptal'),
            ),
            FilledButton(
              onPressed: () =>
                  Navigator.pop(dialogContext, notKontrolcusu.text.trim()),
              child: const Text('Kaydet'),
            ),
          ],
        ),
      );

      if (girilenNot == null) return;

      final int? yeniNot = int.tryParse(girilenNot);
      if (yeniNot == null || yeniNot < 0 || yeniNot > 100) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Lütfen 0 ile 100 arasında geçerli bir not girin.'),
          ),
        );
        return;
      }

      await ogrenciServisi.ogrenciNotuGuncelle(ogrenci.id, yeniNot);

      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('${ogrenci.adSoyad} öğrencisinin notu güncellendi: $yeniNot'),
        ),
      );
    } catch (error) {
      if (!context.mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Not güncellenemedi: $error')),
      );
    } finally {
      notKontrolcusu.dispose();
    }
  }
}
