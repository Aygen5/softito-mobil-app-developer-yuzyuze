import 'package:flutter/material.dart';

import '../../../core/extensions/context_extensions.dart';
import '../controller/analiz_controller.dart';
import '../models/analiz_model.dart';

class AnalizAdimTraction extends StatelessWidget {
  final AnalizController controller;
  final AnalizFormModel form;

  const AnalizAdimTraction({
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
          SwitchListTile(
            title: const Text('Ücretli Müşteri / Pilot Kullanıcı Var mı?'),
            subtitle: const Text(
              'Ürünü deneyimleyen veya ön sipariş veren kullanıcılar',
            ),
            value: form.musteriVarMi,
            activeThumbColor: colors.rocketFlame,
            onChanged: (v) =>
                controller.guncelle((c) => c.copyWith(musteriVarMi: v)),
          ),
          const SizedBox(height: 12),
          if (form.musteriVarMi) ...[
            TextField(
              controller: TextEditingController(text: form.musteriDetay)
                ..selection = TextSelection.collapsed(
                  offset: form.musteriDetay.length,
                ),
              onChanged: (v) =>
                  controller.guncelle((c) => c.copyWith(musteriDetay: v)),
              decoration: const InputDecoration(
                labelText: 'Kaç Müşteri Var ve Kimler?',
                hintText: 'Örn: 3 B2B kurumsal pilot, 120 bireysel kullanıcı',
              ),
            ),
            const SizedBox(height: 16),
          ],
          Text(
            'Hedefe Yakınlık Oranı: %${(form.hedefeYakinlikYuzdesi * 100).toInt()}',
            style: textTheme.titleSmall?.copyWith(fontWeight: FontWeight.bold),
          ),
          Slider(
            value: form.hedefeYakinlikYuzdesi,
            activeColor: colors.nebulaCyan,
            onChanged: (v) => controller.guncelle(
              (c) => c.copyWith(hedefeYakinlikYuzdesi: v),
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: TextEditingController(text: form.ciro)
              ..selection = TextSelection.collapsed(offset: form.ciro.length),
            onChanged: (v) => controller.guncelle((c) => c.copyWith(ciro: v)),
            decoration: const InputDecoration(
              labelText: 'Mevcut Ciro / Aylık Düzenli Gelir (MRR)',
              hintText: 'Örn: 25.000 ₺ veya 0 ₺',
            ),
          ),
          const SizedBox(height: 16),
          TextField(
            controller: TextEditingController(text: form.karDurumu)
              ..selection = TextSelection.collapsed(
                offset: form.karDurumu.length,
              ),
            onChanged: (v) =>
                controller.guncelle((c) => c.copyWith(karDurumu: v)),
            decoration: const InputDecoration(
              labelText: 'Kâr / Nakit Akışı Durumu',
              hintText: 'Örn: Başabaş noktasına 6 ay kaldı',
            ),
          ),
        ],
      ),
    );
  }
}
