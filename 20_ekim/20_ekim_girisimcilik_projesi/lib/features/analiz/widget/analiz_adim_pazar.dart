import 'package:flutter/material.dart';

import '../controller/analiz_controller.dart';
import '../models/analiz_model.dart';

class AnalizAdimPazar extends StatelessWidget {
  final AnalizController controller;
  final AnalizFormModel form;

  const AnalizAdimPazar({
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
            controller: TextEditingController(text: form.ticarilesmePlani)
              ..selection = TextSelection.collapsed(
                offset: form.ticarilesmePlani.length,
              ),
            onChanged: (v) =>
                controller.guncelle((c) => c.copyWith(ticarilesmePlani: v)),
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Ticarileşme ve Gelir Modeli Planı',
              hintText:
                  'Abonelik, komisyon, lisanslama veya doğrudan satış stratejisi',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: TextEditingController(text: form.pazarBuyuklugu)
              ..selection = TextSelection.collapsed(
                offset: form.pazarBuyuklugu.length,
              ),
            onChanged: (v) =>
                controller.guncelle((c) => c.copyWith(pazarBuyuklugu: v)),
            maxLines: 2,
            decoration: const InputDecoration(
              labelText: 'Pazar Hacmi (TAM / SAM / SOM)',
              hintText:
                  'Toplam Pazar (TAM), Ulaşılabilir Pazar (SAM), Hedeflenen Pazar (SOM)',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: TextEditingController(text: form.rakipler)
              ..selection = TextSelection.collapsed(
                offset: form.rakipler.length,
              ),
            onChanged: (v) =>
                controller.guncelle((c) => c.copyWith(rakipler: v)),
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Doğrudan ve Dolaylı Rakipler',
              hintText: 'Türkiye’deki ve dünyadaki rakipler; pazar payları',
            ),
          ),
        ],
      ),
    );
  }
}
