import 'package:flutter_test/flutter_test.dart';
import 'package:yorunge/features/yatirimci/controller/yatirimci_controller.dart';
import 'package:yorunge/features/yatirimci/models/yatirimci_model.dart';

void main() {
  group('YatirimciController Tests', () {
    late YatirimciController controller;

    setUp(() {
      controller = YatirimciController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Toplamda 4 kategori x 4 yatırımcı (en az 16 profil) mevcuttur', () {
      expect(controller.tumYatirimcilar.value.length, greaterThanOrEqualTo(16));
    });

    test('Kategori değişimi listeyi doğru filtreler', () {
      controller.kategoriSec(YatirimciKategori.melekYatirimcilar);
      expect(
        controller.seciliKategori.value,
        equals(YatirimciKategori.melekYatirimcilar),
      );

      for (final y in controller.gorunenYatirimcilar.value) {
        expect(y.kategori, equals(YatirimciKategori.melekYatirimcilar));
      }
    });

    test('İletişim talebi gönderildiğinde durum güncellenir', () {
      final y = controller.tumYatirimcilar.value.first;
      expect(y.iletisimTalebiGonderildi, isFalse);

      controller.iletisimTalebiGonder(y.id);
      final guncel = controller.tumYatirimcilar.value.firstWhere(
        (item) => item.id == y.id,
      );
      expect(guncel.iletisimTalebiGonderildi, isTrue);
    });
  });
}
