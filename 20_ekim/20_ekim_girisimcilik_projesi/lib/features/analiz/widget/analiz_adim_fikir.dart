import 'package:flutter/material.dart';

import '../controller/analiz_controller.dart';
import '../models/analiz_model.dart';

class AnalizAdimFikir extends StatelessWidget {
  final AnalizController controller;
  final AnalizFormModel form;

  const AnalizAdimFikir({
    super.key,
    required this.controller,
    required this.form,
  });

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: TextEditingController(text: form.fikirAdi)
              ..selection = TextSelection.collapsed(
                offset: form.fikirAdi.length,
              ),
            onChanged: (v) =>
                controller.guncelle((c) => c.copyWith(fikirAdi: v)),
            decoration: const InputDecoration(
              labelText: 'Girişim / Fikir Adı',
              hintText: 'Örn: Yörünge İtki Teknolojileri',
            ),
          ),
          const SizedBox(height: 16),
          _buildSektorDropdown(),
          const SizedBox(height: 16),
          TextField(
            controller: TextEditingController(
              text: form.problem,
            )..selection = TextSelection.collapsed(offset: form.problem.length),
            onChanged: (v) =>
                controller.guncelle((c) => c.copyWith(problem: v)),
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Çözülen Problem Nedir?',
              hintText:
                  'Hedef kitlenin yaşadığı en büyük darboğazı açıklayın...',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: TextEditingController(text: form.cozum)
              ..selection = TextSelection.collapsed(offset: form.cozum.length),
            onChanged: (v) => controller.guncelle((c) => c.copyWith(cozum: v)),
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Sunduğunuz Çözüm Nedir?',
              hintText: 'Yenilikçi teknolojiniz bu problemi nasıl çözüyor?',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: TextEditingController(text: form.hedefKitle)
              ..selection = TextSelection.collapsed(
                offset: form.hedefKitle.length,
              ),
            onChanged: (v) =>
                controller.guncelle((c) => c.copyWith(hedefKitle: v)),
            decoration: const InputDecoration(
              labelText: 'Hedef Kitle',
              hintText: 'Örn: Savunma sanayii KOBİ’leri, B2B SaaS şirketleri',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSektorDropdown() {
    final sektorler = [
      'Yapay Zekâ',
      'Havacılık ve Uzay',
      'Finansal Teknolojiler',
      'Sağlık Teknolojileri',
      'SaaS & Bulut',
      'Temiz Enerji',
      'Oyun & Simülasyon',
      'Tarım Teknolojileri',
    ];

    return DropdownButtonFormField<String>(
      initialValue:
          sektorler.contains(form.sektor) ? form.sektor : sektorler.first,
      decoration: const InputDecoration(labelText: 'Faaliyet Sektörü'),
      items: sektorler
          .map((s) => DropdownMenuItem(value: s, child: Text(s)))
          .toList(),
      onChanged: (v) {
        if (v != null) {
          controller.guncelle((c) => c.copyWith(sektor: v));
        }
      },
    );
  }
}
