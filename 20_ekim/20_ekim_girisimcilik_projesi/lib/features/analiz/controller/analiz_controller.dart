import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../auth/controller/permission_service.dart';
import '../../auth/models/user_role.dart';
import '../models/analiz_model.dart';

class AnalizController {
  static const String _draftKey = 'yorunge_analiz_draft_v1';

  final ValueNotifier<int> aktifAdim = ValueNotifier<int>(0);
  final ValueNotifier<AnalizFormModel> formState =
      ValueNotifier<AnalizFormModel>(const AnalizFormModel());
  final ValueNotifier<bool> gonderildi = ValueNotifier<bool>(false);
  final ValueNotifier<bool> taslakKaydedildiBildirimi = ValueNotifier<bool>(
    false,
  );

  final List<String> adimBasliklari = const [
    'Fikir Özeti',
    'Ekip Bilgisi',
    'Mevcut Durum & Traction',
    'Ar-Ge ve İnovasyon',
    'Plan Tabloları & Gantt',
    'Pazar ve Rekabet',
    'Marka Konumlandırma',
    'Özet ve Gönderim',
  ];

  AnalizController() {
    taslakYukle();
  }

  void adimSec(int index) {
    if (index >= 0 && index < adimBasliklari.length) {
      aktifAdim.value = index;
    }
  }

  void sonrakiAdim() {
    if (aktifAdim.value < adimBasliklari.length - 1) {
      aktifAdim.value++;
      taslakKaydet();
    }
  }

  void oncekiAdim() {
    if (aktifAdim.value > 0) {
      aktifAdim.value--;
    }
  }

  void guncelle(AnalizFormModel Function(AnalizFormModel current) updateFn) {
    formState.value = updateFn(formState.value);
  }

  void ekipUyesiEkle(EkipUyesiModel uye) {
    formState.value = formState.value.copyWith(
      ekipUyeleri: [...formState.value.ekipUyeleri, uye],
    );
  }

  void ekipUyesiSil(String id) {
    formState.value = formState.value.copyWith(
      ekipUyeleri:
          formState.value.ekipUyeleri.where((u) => u.id != id).toList(),
    );
  }

  void gorevEkle(GanttGorevModel gorev) {
    formState.value = formState.value.copyWith(
      gorevler: [...formState.value.gorevler, gorev],
    );
  }

  void gorevSil(String id) {
    formState.value = formState.value.copyWith(
      gorevler: formState.value.gorevler.where((g) => g.id != id).toList(),
    );
  }

  Future<void> taslakKaydet() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = jsonEncode(formState.value.toJson());
      await prefs.setString(_draftKey, jsonStr);
      taslakKaydedildiBildirimi.value = true;
      Future.delayed(const Duration(seconds: 2), () {
        taslakKaydedildiBildirimi.value = false;
      });
    } catch (_) {}
  }

  Future<void> taslakYukle() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final jsonStr = prefs.getString(_draftKey);
      if (jsonStr != null && jsonStr.isNotEmpty) {
        final map = jsonDecode(jsonStr) as Map<String, dynamic>;
        formState.value = AnalizFormModel.fromJson(map);
      }
    } catch (_) {}
  }

  Future<bool> basvuruGonder({UserRole? currentRole}) async {
    if (currentRole != null &&
        !PermissionService.canCreateBusinessPlan(currentRole)) {
      return false;
    }
    // İş planı inceleme havuzuna iletildi simülasyonu
    gonderildi.value = true;
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.remove(_draftKey);
    } catch (_) {}
    return true;
  }

  void dispose() {
    aktifAdim.dispose();
    formState.dispose();
    gonderildi.dispose();
    taslakKaydedildiBildirimi.dispose();
  }
}
