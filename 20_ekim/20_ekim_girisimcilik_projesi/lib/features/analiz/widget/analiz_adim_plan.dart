import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../controller/analiz_controller.dart';
import '../models/analiz_model.dart';

class AnalizAdimPlan extends StatelessWidget {
  final AnalizController controller;
  final AnalizFormModel form;

  const AnalizAdimPlan({
    super.key,
    required this.controller,
    required this.form,
  });

  void _showAddGanttDialog(BuildContext context) {
    String gorev = '';
    String baslangic = '1. Ay';
    String bitis = '3. Ay';

    showDialog<void>(
      context: context,
      builder: (ctx) {
        return AlertDialog(
          title: const Text('Gantt Görevi Ekle'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Görev / Faaliyet Adı',
                ),
                onChanged: (v) => gorev = v,
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Başlangıç (Örn: 1. Ay)',
                ),
                onChanged: (v) => baslangic = v,
              ),
              const SizedBox(height: 8),
              TextField(
                decoration: const InputDecoration(
                  labelText: 'Bitiş (Örn: 4. Ay)',
                ),
                onChanged: (v) => bitis = v,
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(ctx).pop(),
              child: const Text('İptal'),
            ),
            ElevatedButton(
              onPressed: () {
                if (gorev.trim().isNotEmpty) {
                  controller.gorevEkle(
                    GanttGorevModel(
                      id: 'gantt_${DateTime.now().millisecondsSinceEpoch}',
                      gorevAdi: gorev,
                      baslangicAy: baslangic,
                      bitisAy: bitis,
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
                'Gantt Zaman Planı',
                style: textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: colors.textPrimary,
                ),
              ),
              ElevatedButton.icon(
                onPressed: () => _showAddGanttDialog(context),
                icon: const Icon(Icons.add_task_rounded, size: 16),
                label: const Text('Görev Ekle'),
              ),
            ],
          ),
          const SizedBox(height: 12),
          if (form.gorevler.isEmpty)
            Container(
              padding: const EdgeInsets.all(16),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                color: colors.surfaceSubtle,
                borderRadius: BorderRadius.circular(10),
              ),
              child: Text(
                'Henüz iş planı görevi eklenmedi.',
                style: TextStyle(color: colors.textMuted, fontSize: 12),
              ),
            )
          else
            ...form.gorevler.map((g) {
              return Card(
                margin: const EdgeInsets.only(bottom: 8),
                child: ListTile(
                  dense: true,
                  leading: Icon(
                    Icons.timelapse_rounded,
                    color: colors.nebulaCyan,
                  ),
                  title: Text(
                    g.gorevAdi,
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text('${g.baslangicAy} — ${g.bitisAy}'),
                  trailing: IconButton(
                    icon: Icon(
                      Icons.close_rounded,
                      size: 18,
                      color: colors.rocketFlame,
                    ),
                    onPressed: () => controller.gorevSil(g.id),
                  ),
                ),
              );
            }),
          const SizedBox(height: 16),
          TextField(
            controller: TextEditingController(text: form.kilometreTaslari)
              ..selection = TextSelection.collapsed(
                offset: form.kilometreTaslari.length,
              ),
            onChanged: (v) =>
                controller.guncelle((c) => c.copyWith(kilometreTaslari: v)),
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Kritik Kilometre Taşları (Milestones)',
              hintText: 'Örn: 3. Ay: MVP Çıkışı, 6. Ay: İlk 1000 Kullanıcı',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: TextEditingController(text: form.butceTutarliligi)
              ..selection = TextSelection.collapsed(
                offset: form.butceTutarliligi.length,
              ),
            onChanged: (v) =>
                controller.guncelle((c) => c.copyWith(butceTutarliligi: v)),
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Bütçe & Harcama Kalemleri Tutarlılığı',
              hintText: 'Personel, sunucu, patent ve pazarlama bütçe dağılımı',
            ),
          ),
        ],
      ),
    );
  }
}
