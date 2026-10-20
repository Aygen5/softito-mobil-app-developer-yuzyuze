import 'package:flutter/foundation.dart';

import '../../auth/controller/permission_service.dart';
import '../../auth/models/user_role.dart';
import '../data/mock_mentor_data.dart';
import '../models/mentor_model.dart';

class MentorController {
  final ValueNotifier<List<MentorModel>> tumMentorlar =
      ValueNotifier<List<MentorModel>>(mockMentorlar);
  final ValueNotifier<List<MentorModel>> gorunenMentorlar =
      ValueNotifier<List<MentorModel>>(mockMentorlar);
  final ValueNotifier<String?> seciliSektor = ValueNotifier<String?>(null);
  final ValueNotifier<String> aramaMetni = ValueNotifier<String>('');

  List<String> get sektorler =>
      tumMentorlar.value.map((m) => m.sektor).toSet().toList();

  List<MentorModel> get onerilenMentorlar =>
      tumMentorlar.value.where((m) => m.puan >= 4.9).take(3).toList();

  bool get isFilterActive =>
      seciliSektor.value != null || aramaMetni.value.trim().isNotEmpty;

  void sektorSec(String? sektor) {
    if (seciliSektor.value == sektor) {
      seciliSektor.value = null;
    } else {
      seciliSektor.value = sektor;
    }
    _filtrele();
  }

  void aramaYap(String metin) {
    aramaMetni.value = metin;
    _filtrele();
  }

  void filtreleriTemizle() {
    seciliSektor.value = null;
    aramaMetni.value = '';
    _filtrele();
  }

  /// Mentorluk talebi gönderir.
  /// Rol parametresi verilmişse [PermissionService] üzerinden merkezi yetki kontrolü yapar.
  bool eslesmeIste(String mentorId, {UserRole? currentRole}) {
    if (currentRole != null &&
        !PermissionService.canSendMentorshipRequest(currentRole)) {
      return false;
    }

    tumMentorlar.value = [
      for (final m in tumMentorlar.value)
        if (m.id == mentorId && m.durum == EslesmeDurumu.yok)
          m.copyWith(durum: EslesmeDurumu.beklemede)
        else
          m,
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
    final sektor = seciliSektor.value;
    final aramaRaw = aramaMetni.value.trim();
    final arama = normalize(aramaRaw);

    gorunenMentorlar.value = tumMentorlar.value.where((m) {
      final sektorUygun = sektor == null || m.sektor == sektor;
      if (!sektorUygun) return false;

      if (arama.isEmpty) return true;

      final adNorm = normalize(m.ad);
      final unvanNorm = normalize(m.unvan);
      final sektorNorm = normalize(m.sektor);
      final sirketNorm = normalize(m.sirket);
      final uzmanlikUygun = m.uzmanliklar.any(
        (u) => normalize(u).contains(arama),
      );

      return adNorm.contains(arama) ||
          unvanNorm.contains(arama) ||
          sektorNorm.contains(arama) ||
          sirketNorm.contains(arama) ||
          uzmanlikUygun;
    }).toList();
  }

  void dispose() {
    tumMentorlar.dispose();
    gorunenMentorlar.dispose();
    seciliSektor.dispose();
    aramaMetni.dispose();
  }
}
