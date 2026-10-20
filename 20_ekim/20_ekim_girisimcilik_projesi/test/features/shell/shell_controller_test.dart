import 'package:flutter_test/flutter_test.dart';
import 'package:yorunge/features/shell/controller/shell_controller.dart';

void main() {
  group('ShellController Tests', () {
    late ShellController controller;

    setUp(() {
      controller = ShellController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Başlangıçta ilk sekme (0 - Mentor) seçilidir', () {
      expect(controller.seciliSekmeIndex.value, equals(0));
    });

    test('Geçerli sekme değişimi reaktif olarak çalışır', () {
      controller.sekmeDegistir(2);
      expect(controller.seciliSekmeIndex.value, equals(2));

      controller.sekmeDegistir(3);
      expect(controller.seciliSekmeIndex.value, equals(3));
    });

    test('Geçersiz sekme indeksleri dikkate alınmaz', () {
      controller.sekmeDegistir(1);
      controller.sekmeDegistir(9); // Geçersiz
      expect(controller.seciliSekmeIndex.value, equals(1));

      controller.sekmeDegistir(-1); // Geçersiz
      expect(controller.seciliSekmeIndex.value, equals(1));
    });
  });
}
