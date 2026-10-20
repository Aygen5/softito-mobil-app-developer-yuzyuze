import 'package:flutter/foundation.dart';

import '../../auth/controller/permission_service.dart';
import '../../auth/models/user_role.dart';
import '../data/mock_yatirimci_data.dart';
import '../models/yatirimci_model.dart';

class YatirimciController {
  final ValueNotifier<List<YatirimciModel>> tumYatirimcilar =
      ValueNotifier<List<YatirimciModel>>(mockYatirimcilar);
  final ValueNotifier<YatirimciKategori> seciliKategori =
      ValueNotifier<YatirimciKategori>(YatirimciKategori.sirketler);
  final ValueNotifier<String?> seciliAsama = ValueNotifier<String?>(null);
  final ValueNotifier<String> aramaMetni = ValueNotifier<String>('');
  final ValueNotifier<List<YatirimciModel>> gorunenYatirimcilar =
      ValueNotifier<List<YatirimciModel>>([]);

  YatirimciController() {
    _filtrele();
  }

  List<String> get asamalar => [
        'Tohum Öncesi (Pre-Seed)',
        'Tohum',
        'Tohum & Seri A',
        'Seri A',
        'Seri A & B',
      ];

  void kategoriSec(YatirimciKategori kat) {
    seciliKategori.value = kat;
    _filtrele();
  }

  void asamaSec(String? asama) {
    if (seciliAsama.value == asama) {
      seciliAsama.value = null;
    } else {
      seciliAsama.value = asama;
    }
    _filtrele();
  }

  void aramaYap(String metin) {
    aramaMetni.value = metin;
    _filtrele();
  }

  void filtreleriTemizle() {
    seciliAsama.value = null;
    aramaMetni.value = '';
    _filtrele();
  }

  /// Yatırımcı iletişim talebi gönderir.
  /// Rol parametresi verilmişse [PermissionService] üzerinden merkezi yetki kontrolü yapar.
  bool iletisimTalebiGonder(String id, {UserRole? currentRole}) {
    if (currentRole != null &&
        !PermissionService.canSendInvestmentRequest(currentRole)) {
      return false;
    }

    tumYatirimcilar.value = [
      for (final y in tumYatirimcilar.value)
        if (y.id == id) y.copyWith(iletisimTalebiGonderildi: true) else y,
    ];
    _filtrele();
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
    final asama = seciliAsama.value;
    final aramaRaw = aramaMetni.value.trim();
    final arama = normalize(aramaRaw);

    gorunenYatirimcilar.value = tumYatirimcilar.value.where((y) {
      final katUygun = y.kategori == kat;
      final asamaUygun = asama == null || y.asama.contains(asama);

      if (!katUygun || !asamaUygun) return false;
      if (arama.isEmpty) return true;

      final adNorm = normalize(y.ad);
      final sektorUygun = y.sektorler.any((s) => normalize(s).contains(arama));
      final portfoyUygun = y.portfoy.any((p) => normalize(p).contains(arama));

      return adNorm.contains(arama) || sektorUygun || portfoyUygun;
    }).toList();
  }

  void dispose() {
    tumYatirimcilar.dispose();
    seciliKategori.dispose();
    seciliAsama.dispose();
    aramaMetni.dispose();
    gorunenYatirimcilar.dispose();
  }
}
