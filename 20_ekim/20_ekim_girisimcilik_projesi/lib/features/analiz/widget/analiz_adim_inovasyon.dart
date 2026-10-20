import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../controller/analiz_controller.dart';
import '../models/analiz_model.dart';

class AnalizAdimInovasyon extends StatelessWidget {
  final AnalizController controller;
  final AnalizFormModel form;

  const AnalizAdimInovasyon({
    super.key,
    required this.controller,
    required this.form,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final textTheme = context.textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TextField(
            controller: TextEditingController(text: form.argeNiteligi)
              ..selection = TextSelection.collapsed(
                offset: form.argeNiteligi.length,
              ),
            onChanged: (v) =>
                controller.guncelle((c) => c.copyWith(argeNiteligi: v)),
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Ar-Ge ve Teknolojik Yenilik Niteliği',
              hintText:
                  'Hangi teknik yöntem, patent veya algoritma geliştirildi?',
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Teknolojik Hazırlık / Yeterlilik Seviyesi (TRL): %${(form.yeterlilikOrani * 100).toInt()}',
            style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          Slider(
            value: form.yeterlilikOrani,
            activeColor: colors.ascensionLime,
            onChanged: (v) =>
                controller.guncelle((c) => c.copyWith(yeterlilikOrani: v)),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: TextEditingController(text: form.farklilik)
              ..selection = TextSelection.collapsed(
                offset: form.farklilik.length,
              ),
            onChanged: (v) =>
                controller.guncelle((c) => c.copyWith(farklilik: v)),
            maxLines: 3,
            decoration: const InputDecoration(
              labelText: 'Mevcut Alternatiflerden ve Rakiplerden Farkı',
              hintText:
                  'Sizi 10 kat daha hızlı, ucuz veya verimli kılan faktör nedir?',
            ),
          ),
        ],
      ),
    );
  }
}
