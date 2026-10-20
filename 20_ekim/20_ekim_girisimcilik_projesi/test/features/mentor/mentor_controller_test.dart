import 'package:flutter_test/flutter_test.dart';
import 'package:yorunge/features/mentor/controller/mentor_controller.dart';
import 'package:yorunge/features/mentor/models/mentor_model.dart';

void main() {
  group('MentorController Tests', () {
    late MentorController controller;

    setUp(() {
      controller = MentorController();
    });

    tearDown(() {
      controller.dispose();
    });

    test('Başlangıçta en az 8 mentor profili mock veriden yüklenir', () {
      expect(controller.tumMentorlar.value.length, greaterThanOrEqualTo(8));
      expect(controller.gorunenMentorlar.value.length, greaterThanOrEqualTo(8));
    });

    test('Sektöre göre filtreleme doğru çalışır', () {
      final hedefSektor = controller.sektorler.first;
      controller.sektorSec(hedefSektor);

      expect(controller.seciliSektor.value, equals(hedefSektor));
      for (final mentor in controller.gorunenMentorlar.value) {
        expect(mentor.sektor, equals(hedefSektor));
      }

      controller.sektorSec(null);
      expect(
        controller.gorunenMentorlar.value.length,
        equals(controller.tumMentorlar.value.length),
      );
    });

    test('Arama filtresi ad, uzmanlık veya sektöre göre listeyi daraltır', () {
      controller.aramaYap('Havacılık');
      expect(controller.gorunenMentorlar.value.isNotEmpty, isTrue);
      for (final mentor in controller.gorunenMentorlar.value) {
        final adUygun = mentor.ad.toLowerCase().contains('havacılık');
        final unvanUygun = mentor.unvan.toLowerCase().contains('havacılık');
        final sektorUygun = mentor.sektor.toLowerCase().contains('havacılık');
        final uzmanlikUygun = mentor.uzmanliklar.any(
          (u) => u.toLowerCase().contains('havacılık'),
        );
        expect(adUygun || unvanUygun || sektorUygun || uzmanlikUygun, isTrue);
      }
    });

    test('Eşleşme isteği gönderildiğinde mentor durumu beklemede olur', () {
      final mentor = controller.tumMentorlar.value.first;
      expect(mentor.durum, equals(EslesmeDurumu.yok));

      controller.eslesmeIste(mentor.id);
      final guncelMentor = controller.tumMentorlar.value.firstWhere(
        (m) => m.id == mentor.id,
      );
      expect(guncelMentor.durum, equals(EslesmeDurumu.beklemede));
    });
  });
}
