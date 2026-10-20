import 'package:flutter/foundation.dart';

import '../../auth/controller/permission_service.dart';
import '../../auth/models/user_role.dart';
import '../data/mock_program_data.dart';
import '../models/program_model.dart';

class ProgramlarController {
  final ValueNotifier<List<ProgramModel>> tumProgramlar =
      ValueNotifier<List<ProgramModel>>(mockProgramlar);
  final ValueNotifier<ProgramKategori> seciliKategori =
      ValueNotifier<ProgramKategori>(ProgramKategori.hibe);
  final ValueNotifier<ProgramDurum?> seciliDurum = ValueNotifier<ProgramDurum?>(
    null,
  );
  final ValueNotifier<String> aramaMetni = ValueNotifier<String>('');
  final ValueNotifier<List<ProgramModel>> gorunenProgramlar =
      ValueNotifier<List<ProgramModel>>([]);

  ProgramlarController() {
    _filtrele();
  }

  void kategoriSec(ProgramKategori kat) {
    seciliKategori.value = kat;
    _filtrele();
  }

  void durumSec(ProgramDurum? durum) {
    if (seciliDurum.value == durum) {
      seciliDurum.value = null;
    } else {
      seciliDurum.value = durum;
    }
    _filtrele();
  }

  void aramaYap(String metin) {
    aramaMetni.value = metin;
    _filtrele();
  }

  void filtreleriTemizle() {
    seciliDurum.value = null;
    aramaMetni.value = '';
    _filtrele();
  }

  void takvimeEkle(String id) {
    tumProgramlar.value = [
      for (final p in tumProgramlar.value)
        if (p.id == id) p.copyWith(takvimeEklendi: !p.takvimeEklendi) else p,
    ];
    _filtrele();
  }

  /// Destek programı düzenleme veya oluşturma işlemi.
  /// Yalnızca Kurum Temsilcisi ve Admin rollerine izin verilir.
  bool programDuzenle(String id, {UserRole? currentRole}) {
    if (currentRole != null &&
        !PermissionService.canManagePrograms(currentRole)) {
      return false;
    }
    return true;
  }

  static String normalize(String text) {
    return text
        .toLowerCase()
        .replaceAll('â', 'a')
        .replaceAll('î', 'i')
        .replaceAll('û', 'u')
        .replaceAll('ı', 'i')
        .replaceAll('İ', 'i')
        .replaceAll('ğ', 'g')
        .replaceAll('ü', 'u')
        .replaceAll('ş', 's')
        .replaceAll('ö', 'o')
        .replaceAll('ç', 'c')
        .trim();
  }

  void _filtrele() {
    final kat = seciliKategori.value;
    final durum = seciliDurum.value;
    final aramaRaw = aramaMetni.value.trim();
    final arama = normalize(aramaRaw);

    gorunenProgramlar.value = tumProgramlar.value.where((p) {
      final katUygun = p.kategori == kat;
      final durumUygun = durum == null || p.durum == durum;
      if (!katUygun || !durumUygun) return false;

      if (arama.isEmpty) return true;

      final adNorm = normalize(p.ad);
      final kurumNorm = normalize(p.kurum);
      final aciklamaNorm = normalize(p.aciklama);

      return adNorm.contains(arama) ||
          kurumNorm.contains(arama) ||
          aciklamaNorm.contains(arama);
    }).toList();
  }

  void dispose() {
    tumProgramlar.dispose();
    seciliKategori.dispose();
    seciliDurum.dispose();
    aramaMetni.dispose();
    gorunenProgramlar.dispose();
  }
}
