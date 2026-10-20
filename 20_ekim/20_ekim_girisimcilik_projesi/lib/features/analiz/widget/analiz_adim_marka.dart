import 'package:flutter/material.dart';

import '../controller/analiz_controller.dart';
import '../models/analiz_model.dart';

class AnalizAdimMarka extends StatelessWidget {
  final AnalizController controller;
  final AnalizFormModel form;

  const AnalizAdimMarka({
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
            controller: TextEditingController(text: form.markaIsmi)
              ..selection = TextSelection.collapsed(
                offset: form.markaIsmi.length,
              ),
            onChanged: (v) =>
                controller.guncelle((c) => c.copyWith(markaIsmi: v)),
            decoration: const InputDecoration(
              labelText: 'Tescil Edilecek Marka İsmi',
              hintText: 'Örn: Yörünge, AeroScale',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: TextEditingController(text: form.konumlandirma)
              ..selection = TextSelection.collapsed(
                offset: form.konumlandirma.length,
              ),
            onChanged: (v) =>
                controller.guncelle((c) => c.copyWith(konumlandirma: v)),
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Marka Konumlandırması ve Slogan',
              hintText:
                  'Tüketicinin zihninde hangi kelimeyle hatırlanmak istiyorsunuz?',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: TextEditingController(text: form.pazarlamaKanallari)
              ..selection = TextSelection.collapsed(
                offset: form.pazarlamaKanallari.length,
              ),
            onChanged: (v) =>
                controller.guncelle((c) => c.copyWith(pazarlamaKanallari: v)),
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Müşteri Kazanım ve Pazarlama Kanalları',
              hintText:
                  'LinkedIn outreach, sektör fuarları, arama motoru optimizasyonu, partnerlikler',
            ),
          ),
        ],
      ),
    );
  }
}
