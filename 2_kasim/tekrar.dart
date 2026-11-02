// Mülakat İçin önemli: 
// Sealed sınıflar, dışarıdan extend edilmez. 
// Switch içinde tüm alt sınıflar tüketilmek (exhaustiveness) zorundadır.
sealed class OdemeDurumu {}

class OdemeBasarili extends OdemeDurumu {
  final ({String referansKodu, double tutar}) veri; // Record kullanımı
  OdemeBasarili(this.veri);
}

class OdemeBasarisiz extends OdemeDurumu {
  final String hataNedeni;
  OdemeBasarisiz(this.hataNedeni);
}

// abstract class
abstract class IBankaServisi {
  Future<OdemeDurumu> odemeYap({required double miktar});
}

// mixin
mixin GuvenlikDenetimiMixin {
  bool tokenGecerliMi(String token) {
    return token.isNotEmpty && token.length >= 32;
  }
}

mixin AuditLogMixin {
  void islemKaydet(String mesaj) {
    final zaman = DateTime.now().toIso8601String();
    print('Log - $zaman: $mesaj');
  }
}

class GarantiBankasiServisi with GuvenlikDenetimiMixin, AuditLogMixin implements IBankaServisi {
  final String apiAnahtari;
  
  GarantiBankasiServisi({required this.apiAnahtari});

  @override
  Future<OdemeDurumu> odemeYap({required double miktar}) async {
    if (!tokenGecerliMi(apiAnahtari)) {
      islemKaydet('Ödeme Reddedildi. Geçersiz Api Anahtarı.');
      return OdemeBasarisiz('Yetkilendirme hatası: Geçersiz token.');
    }

    await Future.delayed(const Duration(milliseconds: 1000));
    islemKaydet('$miktar tutarındaki ödeme Garanti Bankası tarafından ONAYLANDI.');
    return OdemeBasarili((referansKodu: 'GRNT-${DateTime.now().millisecondsSinceEpoch}', tutar: miktar));
  }
}

void odemeSonucunuEkranaBas(OdemeDurumu durum) {
  // Sealed class sayesinde default (else) durumuna gerek kalmaz.
  final mesaj = switch (durum) {
    OdemeBasarili b => 'Ödeme Başarılı! Ref: ${b.veri.referansKodu}, Tutar: ${b.veri.tutar}₺',
    OdemeBasarisiz h => 'Ödeme Başarısız! Gerekçe: ${h.hataNedeni}',
  };
  print(mesaj);
}

void main() async {
  print('--- 1. Senaryo: Geçersiz API Anahtarı (Hatalı Durum) ---');
  final hataliServis = GarantiBankasiServisi(apiAnahtari: 'kisa-token');
  final sonuc1 = await hataliServis.odemeYap(miktar: 150.0);
  odemeSonucunuEkranaBas(sonuc1);

  print('\n--- 2. Senaryo: Başarılı Ödeme Durumu ---');
  final basariliServis = GarantiBankasiServisi(apiAnahtari: 'abcdefghij1234567890abcdefghij12');
  final sonuc2 = await basariliServis.odemeYap(miktar: 2450.50);
  odemeSonucunuEkranaBas(sonuc2);
}
