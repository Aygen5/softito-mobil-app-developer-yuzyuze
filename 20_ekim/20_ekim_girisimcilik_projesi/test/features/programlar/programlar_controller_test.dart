import 'package:flutter_test/flutter_test.dart';
import 'package:yorunge/features/programlar/controller/programlar_controller.dart';
import 'package:yorunge/features/programlar/models/program_model.dart';

void main() {
  group('ProgramlarController Tests', () {
    late ProgramlarController controller;

    setUp(() {
      controller = ProgramlarController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Toplamda 5 kategori x 3 program (en az 15 program) mevcuttur', () {
      expect(controller.tumProgramlar.value.length, greaterThanOrEqualTo(15));
    });

    test('Kategori değişimi listeyi reaktif günceller', () {
      controller.kategoriSec(ProgramKategori.yurtdisi);
      expect(controller.seciliKategori.value, equals(ProgramKategori.yurtdisi));

      for (final p in controller.gorunenProgramlar.value) {
        expect(p.kategori, equals(ProgramKategori.yurtdisi));
      }
    });

    test('Takvime ekleme ve çıkarma doğru çalışır', () {
      final p = controller.tumProgramlar.value.first;
      expect(p.takvimeEklendi, isFalse);

      controller.takvimeEkle(p.id);
      var guncel = controller.tumProgramlar.value.firstWhere(
        (item) => item.id == p.id,
      );
      expect(guncel.takvimeEklendi, isTrue);

      controller.takvimeEkle(p.id);
      guncel = controller.tumProgramlar.value.firstWhere(
        (item) => item.id == p.id,
      );
      expect(guncel.takvimeEklendi, isFalse);
    });
  });
}
