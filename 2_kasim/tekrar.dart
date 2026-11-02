// Mülakat İçin önemli: 
// Sealed sınıf demek: Sadece bu dosya içinde alt sınıfları türetilebilir, dışarıdan extend edilemez.
// Amacı: Switch yapısında tüm alt sınıfları tek tek kontrol etmeyi (exhaustiveness) zorunlu kılar.
// Böylece yeni bir durum eklendiğinde switch'te unutma şansımız kalmaz, default/else yazmaya da gerek olmaz.
sealed class OdemeDurumu {}

// Ödeme başarılı olduğunda dönecek durum sınıfı
class OdemeBasarili extends OdemeDurumu {
  // Record kullanımı: Ayrı bir model/class yazmadan birden fazla veriyi (referansKodu ve tutar)
  // tek seferde taşımak için Dart 3'ün bu özelliğini kullandık.
  final ({String referansKodu, double tutar}) veri;
  OdemeBasarili(this.veri);
}

// Ödeme başarısız olursa çalışacak durum sınıfı, hata mesajını tutuyor
class OdemeBasarisiz extends OdemeDurumu {
  final String hataNedeni;
  OdemeBasarisiz(this.hataNedeni);
}

// abstract class (Soyut Arayüz / Interface):
// Buradaki amaç bir standart/sözleşme belirlemek. Yarın Garanti yerine Akbank gelse de
// odemeYap metodunu aynı parametrelerle ezmek (override etmek) zorunda kalacak.
abstract class IBankaServisi {
  Future<OdemeDurumu> odemeYap({required double miktar});
}

// mixin: Dart'ta çoklu kalıtım (multiple inheritance) olmadığı için kullanılır.
// Tek bir sınıfa birden fazla yetenek eklemek amacıyla yazdık. 'with' ile sınıfa dahil edilir.
mixin GuvenlikDenetimiMixin {
  // Token kontrolü: Boş mu ve en az 32 karakter mi diye bakıyoruz
  bool tokenGecerliMi(String token) {
    return token.isNotEmpty && token.length >= 32;
  }
}

// İşlem geçmişini konsola basan loglama mixin'i
mixin AuditLogMixin {
  void islemKaydet(String mesaj) {
    final zaman = DateTime.now().toIso8601String();
    print('Log - $zaman: $mesaj');
  }
}

// Servis sınıfımız:
// with -> Mixin'leri ekleyip güvenlik kontrolü ve loglama yeteneklerini aldık.
// implements -> IBankaServisi sözleşmesine uyacağımızı taahhüt ettik.
class GarantiBankasiServisi with GuvenlikDenetimiMixin, AuditLogMixin implements IBankaServisi {
  final String apiAnahtari;
  
  GarantiBankasiServisi({required this.apiAnahtari});

  @override
  Future<OdemeDurumu> odemeYap({required double miktar}) async {
    // 1. Adım: Mixin'den gelen güvenliği çalıştır, token geçerli değilse işlemi kes
    if (!tokenGecerliMi(apiAnahtari)) {
      islemKaydet('Ödeme Reddedildi. Geçersiz Api Anahtarı.');
      return OdemeBasarisiz('Yetkilendirme hatası: Geçersiz token.');
    }

    // 2. Adım: Gerçek banka sunucusu yanıt veriyormuş gibi 1 saniye bekletiyoruz (Simülasyon)
    await Future.delayed(const Duration(milliseconds: 1000));
    islemKaydet('$miktar tutarındaki ödeme Garanti Bankası tarafından ONAYLANDI.');
    
    // Başarılı sonucu Record yapısı içinde referans kodu ve tutarla dönüyoruz
    return OdemeBasarili((referansKodu: 'GRNT-${DateTime.now().millisecondsSinceEpoch}', tutar: miktar));
  }
}

// Sonucu ekrana yazdıran fonksiyon
void odemeSonucunuEkranaBas(OdemeDurumu durum) {
  // Sealed class kullandığımız için switch expression burada tip kontrolü yapar.
  // OdemeBasarili ve OdemeBasarisiz durumlarının ikisini de yazdığımız için compiler default sormaz.
  final mesaj = switch (durum) {
    OdemeBasarili b => 'Ödeme Başarılı! Ref: ${b.veri.referansKodu}, Tutar: ${b.veri.tutar}₺',
    OdemeBasarisiz h => 'Ödeme Başarısız! Gerekçe: ${h.hataNedeni}',
  };
  print(mesaj);
}

void main() async {
  print('--- 1. Senaryo: Geçersiz API Anahtarı (Hatalı Durum) ---');
  // Kısa token verip başarısız durumu test ediyoruz
  final hataliServis = GarantiBankasiServisi(apiAnahtari: 'kisa-token');
  final sonuc1 = await hataliServis.odemeYap(miktar: 150.0);
  odemeSonucunuEkranaBas(sonuc1);

  print('\n--- 2. Senaryo: Başarılı Ödeme Durumu ---');
  // 32 karakterlik geçerli token verip başarılı durumu test ediyoruz
  final basariliServis = GarantiBankasiServisi(apiAnahtari: 'abcdefghij1234567890abcdefghij12');
  final sonuc2 = await basariliServis.odemeYap(miktar: 2450.50);
  odemeSonucunuEkranaBas(sonuc2);
}
