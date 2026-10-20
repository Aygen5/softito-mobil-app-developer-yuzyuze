import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:yorunge/features/analiz/controller/analiz_controller.dart';
import 'package:yorunge/features/analiz/models/analiz_model.dart';

void main() {
  group('AnalizController Tests', () {
    late AnalizController controller;

    setUp(() {
      SharedPreferences.setMockInitialValues({});
      controller = AnalizController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('8 adımlı analiz testi 0. adımdan başlar', () {
      expect(controller.adimBasliklari.length, equals(8));
      expect(controller.aktifAdim.value, equals(0));
    });

    test('Adım ilerleme ve gerileme doğru çalışır', () {
      controller.sonrakiAdim();
      expect(controller.aktifAdim.value, equals(1));

      controller.oncekiAdim();
      expect(controller.aktifAdim.value, equals(0));
    });

    test('Ekip üyesi ekleme ve silme reaktiftir', () {
      final uye = EkipUyesiModel(
        id: 'u1',
        adSoyad: 'Ali Veli',
        egitim: 'İTÜ Uçak Müh.',
        uzmanlik: 'Aerodinamik',
        sorumluluk: 'CTO',
        iletisim: 'ali@example.com',
      );

      controller.ekipUyesiEkle(uye);
      expect(controller.formState.value.ekipUyeleri.length, equals(1));

      controller.ekipUyesiSil('u1');
      expect(controller.formState.value.ekipUyeleri.isEmpty, isTrue);
    });

    test('Gantt görevi ekleme ve silme reaktiftir', () {
      final gorev = GanttGorevModel(
        id: 'g1',
        gorevAdi: 'Prototip Tasarımı',
        baslangicAy: '1. Ay',
        bitisAy: '3. Ay',
      );

      controller.gorevEkle(gorev);
      expect(controller.formState.value.gorevler.length, equals(1));

      controller.gorevSil('g1');
      expect(controller.formState.value.gorevler.isEmpty, isTrue);
    });

    test('Başvuru gönderme işlemi durumu günceller', () async {
      expect(controller.gonderildi.value, isFalse);
      final sonuc = await controller.basvuruGonder();
      expect(sonuc, isTrue);
      expect(controller.gonderildi.value, isTrue);
    });
  });
}
