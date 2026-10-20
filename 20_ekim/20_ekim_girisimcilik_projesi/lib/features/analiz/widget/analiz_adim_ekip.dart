import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../controller/analiz_controller.dart';
import '../models/analiz_model.dart';

class AnalizAdimEkip extends StatelessWidget {
  final AnalizController controller;
  final AnalizFormModel form;

  const AnalizAdimEkip({
    super.key,
    required this.controller,
    required this.form,
  });

  void _showAddMemberDialog(BuildContext context) {
    String ad = '';
    String egitim = '';
    String uzmanlik = '';
    String rol = '';
    String iletisim = '';

    showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Ekip Üyesi Ekle'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  decoration: const InputDecoration(labelText: 'Ad Soyad'),
                  onChanged: (v) => ad = v,
                ),
                const SizedBox(height: 8),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Eğitim (Bölüm/Üniversite)',
                  ),
                  onChanged: (v) => egitim = v,
                ),
                const SizedBox(height: 8),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Uzmanlık Alanı',
                  ),
                  onChanged: (v) => uzmanlik = v,
                ),
                const SizedBox(height: 8),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'Girişimdeki Rolü / Sorumluluk',
                  ),
                  onChanged: (v) => rol = v,
                ),
                const SizedBox(height: 8),
                TextField(
                  decoration: const InputDecoration(
                    labelText: 'İletişim (E-posta / Telefon)',
                  ),
                  onChanged: (v) => iletisim = v,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (ad.trim().isNotEmpty) {
                  controller.ekipUyesiEkle(
                    EkipUyesiModel(
                      id: 'ekip_${DateTime.now().millisecondsSinceEpoch}',
                      adSoyad: ad,
                      egitim: egitim,
                      uzmanlik: uzmanlik,
                      sorumluluk: rol,
                      iletisim: iletisim,
                    ),
                  );
                }
                Navigator.of(ctx).pop();
              },
              child: const Text('Ekle'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final textTheme = context.textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Çekirdek Kadro (${form.ekipUyeleri.length} Üye)',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddMemberDialog(context),
                icon: const Icon(Icons.person_add_rounded, size: 16),
                label: const Text('Üye Ekle'),
              ),
            ],
          ),
          const SizedBox(height: 16),
          if (form.ekipUyeleri.isEmpty)
            Container(
              padding: const EdgeInsets.all(24),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colors.surfaceSubtle,
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                'Henüz ekip üyesi eklenmedi. "Üye Ekle" butonuna basarak kurucu ve teknik kadroyu ekleyin.',
                style: TextStyle(color: colors.textMuted, fontSize: 13),
                textAlign: TextAlign.center,
              ),
            )
          else
            ...form.ekipUyeleri.map((uye) {
              return Card(
                margin: const EdgeInsets.only(bottom: 10),
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundColor: colors.nebulaCyan.withValues(alpha: 0.2),
                    child: Text(
                      uye.adSoyad.isNotEmpty ? uye.adSoyad[0] : 'U',
                      style: TextStyle(
                        color: colors.nebulaCyan,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  title: Text(
                    uye.adSoyad,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(
                    '${uye.sorumluluk} • ${uye.uzmanlik}\n${uye.egitim}',
                  ),
                  isThreeLine: true,
                  trailing: IconButton(
                    icon: Icon(
                      Icons.delete_outline_rounded,
                      color: colors.rocketFlame,
                    ),
                    onPressed: () => controller.ekipUyesiSil(uye.id),
                  ),
                ),
              );
            }),
        ],
      ),
    );
  }
}
