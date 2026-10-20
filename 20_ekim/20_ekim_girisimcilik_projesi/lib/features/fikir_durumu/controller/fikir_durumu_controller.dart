import 'package:flutter/foundation.dart';

import '../../auth/controller/permission_service.dart';
import '../../auth/models/user_role.dart';
import '../data/mock_fikir_durumu_data.dart';
import '../models/fikir_durumu_model.dart';

class FikirDurumuController {
  final ValueNotifier<List<FikirDurumuModel>> fikirler =
      ValueNotifier<List<FikirDurumuModel>>(mockOrnekFikirler);
  final ValueNotifier<int> seciliFikirIndex = ValueNotifier<int>(0);

  FikirDurumuModel get seciliFikir => fikirler.value[seciliFikirIndex.value];

  void fikirSec(int index) {
    if (index >= 0 && index < fikirler.value.length) {
      seciliFikirIndex.value = index;
    }
  }

  /// Şirketleşme hukuki adımını tamamlandı durumuna getirir.
  /// Rol parametresi verilmişse [PermissionService] üzerinden kontrol edilir.
  bool hukukiAdimIlerle(String fikirId, int adimSira, {UserRole? currentRole}) {
    if (currentRole != null &&
        !PermissionService.canViewIdeaStatus(currentRole)) {
      return false;
    }

    fikirler.value = [
      for (final f in fikirler.value)
        if (f.id == fikirId)
          f.copyWith(
            hukukiAdimlar: [
              for (final a in f.hukukiAdimlar)
                if (a.sira == adimSira)
                  a.copyWith(durum: HukukiAdimDurumu.tamamlandi)
                else
                  a,
            ],
          )
        else
          f,
    ];
    return true;
  }

  void dispose() {
    fikirler.dispose();
    seciliFikirIndex.dispose();
  }
}
