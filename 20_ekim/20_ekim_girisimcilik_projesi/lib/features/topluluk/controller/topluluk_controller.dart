import 'package:flutter/foundation.dart';

import '../../auth/controller/permission_service.dart';
import '../../auth/models/user_role.dart';
import '../data/mock_topluluk_data.dart';
import '../models/topluluk_model.dart';

class ToplulukController {
  final ValueNotifier<ToplulukKullaniciDurumu> kullaniciDurumu;
  final ValueNotifier<UserRole?> aktifRol;
  final ValueNotifier<List<ToplulukGonderiModel>> gonderiler;

  ToplulukController({
    ToplulukKullaniciDurumu baslangicDurumu = ToplulukKullaniciDurumu.onayli,
    UserRole? baslangicRol,
  })  : kullaniciDurumu = ValueNotifier<ToplulukKullaniciDurumu>(
          baslangicDurumu,
        ),
        aktifRol = ValueNotifier<UserRole?>(baslangicRol),
        gonderiler = ValueNotifier<List<ToplulukGonderiModel>>(
          mockToplulukGonderileri,
        );

  /// Topluluk yetki kontrolü (Kural gereği controller katmanında uygulanır)
  /// Rol tanımlıysa [PermissionService] üzerinden değerlendirilir.
  bool get paylasabilir {
    final role = aktifRol.value;
    final isApproved = kullaniciDurumu.value == ToplulukKullaniciDurumu.onayli;
    if (role != null) {
      return PermissionService.canPostInCommunity(role, isApproved: isApproved);
    }
    return isApproved;
  }

  bool gonderiEkle({
    required String metin,
    String yazar = 'Girişimci',
    String girisimAdi = 'Girişim Projem',
  }) {
    if (!paylasabilir) return false;
    final temizMetin = metin.trim();
    if (temizMetin.isEmpty || temizMetin.length > 280) return false;

    final yeniGonderi = ToplulukGonderiModel(
      id: 'post_${DateTime.now().millisecondsSinceEpoch}',
      yazar: yazar,
      girisimAdi: girisimAdi,
      metin: temizMetin,
      tarih: DateTime.now(),
      begeniSayisi: 0,
      begenildi: false,
      yanitlar: const [],
    );

    gonderiler.value = [yeniGonderi, ...gonderiler.value];
    return true;
  }

  bool yanitEkle({
    required String gonderiId,
    required String metin,
    String yazar = 'Girişimci',
    String unvan = 'Kurucu',
  }) {
    if (!paylasabilir) return false;
    final temizMetin = metin.trim();
    if (temizMetin.isEmpty || temizMetin.length > 280) return false;

    final yeniYanit = ToplulukYanitModel(
      id: 'rep_${DateTime.now().millisecondsSinceEpoch}',
      yazar: yazar,
      unvan: unvan,
      metin: temizMetin,
      tarih: DateTime.now(),
    );

    gonderiler.value = [
      for (final g in gonderiler.value)
        if (g.id == gonderiId)
          g.copyWith(yanitlar: [...g.yanitlar, yeniYanit])
        else
          g,
    ];
    return true;
  }

  bool begeniDegistir(String gonderiId) {
    if (!paylasabilir) return false;

    gonderiler.value = [
      for (final g in gonderiler.value)
        if (g.id == gonderiId)
          g.copyWith(
            begenildi: !g.begenildi,
            begeniSayisi: g.begenildi
                ? (g.begeniSayisi - 1).clamp(0, 999999)
                : g.begeniSayisi + 1,
          )
        else
          g,
    ];
    return true;
  }

  void kullaniciDurumuAyarla(ToplulukKullaniciDurumu yeniDurum) {
    kullaniciDurumu.value = yeniDurum;
  }

  void rolAyarla(UserRole? rol) {
    aktifRol.value = rol;
  }

  void dispose() {
    kullaniciDurumu.dispose();
    aktifRol.dispose();
    gonderiler.dispose();
  }
}
