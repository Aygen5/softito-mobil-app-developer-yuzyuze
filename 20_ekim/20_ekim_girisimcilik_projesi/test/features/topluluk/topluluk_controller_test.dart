import 'package:flutter_test/flutter_test.dart';
import 'package:yorunge/features/topluluk/controller/topluluk_controller.dart';
import 'package:yorunge/features/topluluk/models/topluluk_model.dart';

void main() {
  group('ToplulukController Tests', () {
    test('Başlangıçta en az 12 topluluk gönderisi mevcuttur', () {
      final controller = ToplulukController();
      expect(controller.gonderiler.value.length, greaterThanOrEqualTo(12));
      controller.dispose();
    });

    test('Onaysız kullanıcı paylaşım yapamaz, beğenemez, yanıtlayamaz', () {
      final controller = ToplulukController(
        baslangicDurumu: ToplulukKullaniciDurumu.onaysiz,
      );

      expect(controller.paylasabilir, isFalse);

      final paylasimSonucu = controller.gonderiEkle(metin: 'Deneme gönderisi');
      expect(paylasimSonucu, isFalse);

      final begeniSonucu = controller.begeniDegistir('post_1');
      expect(begeniSonucu, isFalse);

      final yanitSonucu = controller.yanitEkle(
        gonderiId: 'post_1',
        metin: 'Onaysız yanıt',
      );
      expect(yanitSonucu, isFalse);

      controller.dispose();
    });

    test(
        'Onaylı kullanıcı kurallara uygun paylaşım yapabilir, beğenebilir ve yanıtlayabilir',
        () {
      final controller = ToplulukController(
        baslangicDurumu: ToplulukKullaniciDurumu.onayli,
      );

      expect(controller.paylasabilir, isTrue);

      final oncekiSayi = controller.gonderiler.value.length;
      final basarili = controller.gonderiEkle(
        metin: 'Yeni nesil roket itki testimiz başarıyla sonuçlandı!',
        yazar: 'Test Girişimcisi',
        girisimAdi: 'Test Girişimi',
      );
      expect(basarili, isTrue);
      expect(controller.gonderiler.value.length, equals(oncekiSayi + 1));

      // 280 karakterden uzun gönderi reddedilir
      final uzunMetin = 'A' * 281;
      final uzunSonuc = controller.gonderiEkle(metin: uzunMetin);
      expect(uzunSonuc, isFalse);

      // Beğeni değişimi
      final ilkGonderi = controller.gonderiler.value.first;
      final oncekiBegeni = ilkGonderi.begeniSayisi;
      controller.begeniDegistir(ilkGonderi.id);
      final guncelGonderi = controller.gonderiler.value.first;
      expect(guncelGonderi.begenildi, isTrue);
      expect(guncelGonderi.begeniSayisi, equals(oncekiBegeni + 1));

      // Yanıt ekleme
      final oncekiYanitSayisi = guncelGonderi.yanitlar.length;
      final yanitBasarili = controller.yanitEkle(
        gonderiId: guncelGonderi.id,
        metin: 'Tebrikler, harika başarı!',
      );
      expect(yanitBasarili, isTrue);
      expect(
        controller.gonderiler.value.first.yanitlar.length,
        equals(oncekiYanitSayisi + 1),
      );

      controller.dispose();
    });
  });
}
