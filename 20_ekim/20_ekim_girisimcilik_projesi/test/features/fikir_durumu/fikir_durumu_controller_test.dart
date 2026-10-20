import 'package:flutter_test/flutter_test.dart';
import 'package:yorunge/features/fikir_durumu/controller/fikir_durumu_controller.dart';
import 'package:yorunge/features/fikir_durumu/models/fikir_durumu_model.dart';

void main() {
  group('FikirDurumuController Tests', () {
    late FikirDurumuController controller;

    setUp(() {
      controller = FikirDurumuController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Önceden kabul almış en az 6 örnek fikir mevcuttur', () {
      expect(controller.fikirler.value.length, greaterThanOrEqualTo(6));
    });

    test('Fikir seçimi reaktif olarak değişir', () {
      expect(controller.seciliFikirIndex.value, equals(0));
      controller.fikirSec(2);
      expect(controller.seciliFikirIndex.value, equals(2));
      expect(controller.seciliFikir.id, equals('f_3'));
    });

    test('Hukuki süreç adımları Türkiye mevzuatına uygun 6 adımı içerir', () {
      final fikir = controller.seciliFikir;
      expect(fikir.hukukiAdimlar.length, equals(6));
      expect(fikir.avukat.adSoyad.isNotEmpty, isTrue);
      expect(fikir.gelirDestegi.aylikHedefTl, greaterThan(0));
    });

    test('Hukuki adım durumu güncellenebilir', () {
      final fikir = controller.seciliFikir;
      controller.hukukiAdimIlerle(fikir.id, 5);
      final guncelFikir = controller.fikirler.value.firstWhere(
        (f) => f.id == fikir.id,
      );
      final adim5 = guncelFikir.hukukiAdimlar.firstWhere((a) => a.sira == 5);
      expect(adim5.durum, equals(HukukiAdimDurumu.tamamlandi));
    });
  });
}
