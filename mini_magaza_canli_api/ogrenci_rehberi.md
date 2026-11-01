# 📱 Mini Mağaza Canlı API Projesi - Öğrenci Rehberi

Bu rehber, **`mini_magaza_canli_api`** projesinin mimarisini, dosya yapısını ve kodlama kararlarını sıfırdan ileri seviyeye kadar adım adım anlatmak için hazırlanmıştır.

## 🧭 1. Büyük Resim: Bu Proje Nedir ve Neler Yapıldı?

`mini_magaza_canli_api` projesi, internet ortamındaki gerçek bir REST API'den (**FakeStore API**) canlı ürün verisi çeken, bu verileri tip güvenli (type-safe) Dart modellerine dönüştüren, kullanıcıya arama ve filtreleme olanakları sunan ve modern bir mobil e-ticaret kullanıcı arayüzü (UI) sağlayan **örnek bir Flutter uygulamasıdır**.

### Projede Neler Başarıldı?
1. **Canlı İnternet İletişimi (HTTP REST API):** Statik/sahte liste yerine `https://fakestoreapi.com/products` ucuna asenkron GET isteği atıldı.
2. **Sağlam Hata & Durum Yönetimi (4 UI Durumu):** 
   - ⏳ **Yükleniyor (Loading):** Veri gelirken `CircularProgressIndicator`.
   - ❌ **Hata (Error):** Ağ koptuğunda veya sunucu çöktüğünde `cloud_off` ikonu ve **"Tekrar Dene"** butonu.
   - 🔍 **Boş Durum (Empty State):** Arama veya filtreleme sonucu ürün bulunamadığında kullanıcı dostu uyarı.
   - ✅ **Başarılı Liste (Success):** Verilerin akıcı kartlar halinde listelenmesi.
3. **Pull-to-Refresh (Aşağı Çek Yenile):** `RefreshIndicator` ile canlı veriyi ekrandan çekerek tazeleme.
4. **Anlık Filtreleme & Arama:** Hem kategori çipleri (`ChoiceChip`) hem de arama kutusu (`TextField`) anlık ve birlikte çalışır.
5. **Hero Animasyonu:** Ürün listesinden detay ekranına geçerken görselin yumuşakça büyüyerek geçiş yapması.
6. **Katmanlı Mimari (Layered Architecture) & Soyutlama (Interface/Polymorphism):** Kodun test edilebilir, bakımı kolay ve profesyonel standartlarda yazılması.


## 🏗️ 2. Mimari Plan: `lib` İçindeki Klasörler Neden Böyle Planlandı?

Flutter'da yeni başlayanların yaptığı en büyük hata, tüm kodları tek bir `main.dart` dosyasına veya birkaç karışık widget içine yazmaktır. Bu projede **Sorumlulukların Ayrılması (Separation of Concerns)** ilkesi uygulanmıştır.

```
lib/
 ┣ 📜 main.dart                     -> [Giriş Noktası] Uygulamanın başlatıcısı ve tema ayarları
 ┣ 📁 models/                       -> [Veri Katmanı] Ham veriyi temsil eden tip güvenli Dart sınıfları
 ┃ ┣ 📄 urun.dart                   -> Ana ürün nesnesi (id, baslik, fiyat...)
 ┃ ┣ 📄 kategori.dart               -> Kategoriler (enum + Türkçe extension)
 ┃ ┗ 📄 degerlendirme.dart          -> Puan ve oy sayısı (iç içe model)
 ┣ 📁 services/                     -> [Servis / Ağ Katmanı] Dış dünyadan veri alma ve işleme
 ┃ ┣ 📄 i_urun_servisi.dart         -> Soyut sözleşme (Interface / Abstract class)
 ┃ ┗ 📄 api_urun_servisi.dart       -> Gerçek FakeStore API entegrasyonu (http istekleri)
 ┣ 📁 widgets/                      -> [Tekrar Kullanılabilir Görsel Parçalar]
 ┃ ┣ 📄 stok_rozeti.dart            -> Stok durumunu gösteren yeşil/kırmızı rozet
 ┃ ┗ 📄 urun_karti.dart             -> Liste elemanı için şık kart tasarımı (Hero destekli)
 ┗ 📁 screens/                      -> [Sayfa / Ekran Katmanı] Tam ekran görünümleri ve durum yönetimi
   ┣ 📄 urun_listesi_ekrani.dart    -> Ana ekran (Stateful, filtreleme, 4 durum)
   ┗ 📄 urun_detay_ekrani.dart      -> Detay ekranı (Stateless, büyük resim, satın alma barı)
```

### Neden Bu Klasörleme Tercih Edildi?
- **Modülerlik:** Bir ekran değiştiğinde veri modeli etkilenmez; API adresi değiştiğinde UI widget'ları bozulmaz.
- **Değiştirilebilirlik (Loose Coupling):** Yarın FakeStore API yerine Firebase ya da yerel Mock veri kaynağına geçmek istendiğinde yalnızca `services/` katmanına yeni bir sınıf eklemek yeterlidir. Ekranların kodunu değiştirmeye gerek kalmaz.
- **Tekrar Kullanılabilirlik (Reusability):** `StokRozeti` hem ana listedeki kartta hem de detay sayfasında birebir aynı widget olarak kullanılmıştır.

---

## 🔍 3. Adım Adım Klasörler ve Kod Detayları

Büyük mimariden küçük bileşenlere doğru her dosyanın amacını inceleyelim:

### 1) 📁 `models/` (Veri Modelleri Katmanı)
JSON olarak gelen ham metinler doğrudan ekranda kullanılmaz. Tip güvenliği (String, int, double, enum) sağlamak ve yazım hatalarından kaynaklı çökmeleri (`Null Safety`) engellemek için model sınıfları kullanılır.

* **[kategori.dart]:**
  - FakeStore API'den `electronics`, `jewelery`, `men's clothing`, `women's clothing` stringleri gelir.
  - Bunları rastgele String olarak karşılaştırmak hata riskidir. Bu yüzden `enum Kategori { hepsi, elektronik, taki, erkekGiyim, kadinGiyim }` tanımlanmıştır.
  - `KategoriExtension` ile:
    - `gorunenAd`: UI'da butonlarda çıkacak Türkçe adı verir (`Takı & Mücevher` vb.).
    - `apiMetnindenUret`: API'den gelen İngilizce metni eşleştirip ilgili enum değerine çevirir.

* **[degerlendirme.dart](:**
  - JSON içindeki `{"rate": 3.9, "count": 120}` nesnesini `puan` ve `oySayisi` değişkenlerine dönüştüren iç modeldir.
  - `num` dönüşümleri yapılarak API'den tam sayı veya ondalık gelse bile uygulamanın çökmesi engellenir.

* **[urun.dart]:**
  - Uygulamanın kalbidir. `id`, `baslik`, `fiyat`, `aciklama`, `kategori`, `resimUrl`, `degerlendirme`, `stoktaVarMi` alanlarını tutar.
  - `factory Urun.fromJson(Map<String, dynamic> json)`: Gelen JSON sözlüğünü parse eder.
  - `copyWith`: İleride bir ürünün sadece bir alanını (örneğin favori durumu veya stok) değiştirmek istediğimizde nesneyi klonlamayı sağlar (İmmutable mimari).

---

### 2) 📁 `services/` (Servis ve Ağ Katmanı)
İnternet isteklerini ekrandan (UI) soyutlayan katmandır.

* **[i_urun_servisi.dart]:**
  - Bir `abstract class` (Arayüz / Interface) tanımlar.
  - İki kural koyar: `Future<List<Urun>> urunleriGetir();` ve `Future<Urun?> urunGetirById(int id);`.
  - Bu sayede ekranlarımız "Ben veriyi nereden aldığımı bilmem, bana `IUrunServisi` kurallarına uyan bir servis verin yeter" der (Dependency Inversion prensibi).

* **[api_urun_servisi.dart]:**
  - `implements IUrunServisi` diyerek sözleşmeyi uygular.
  - `http.get(...)` ile istek atar.
  - **10 Saniyelik Zaman Aşımı Koruması (`.timeout(...)`):** İnternet çok yavaşsa uygulamanın sonsuza kadar donmasını engeller.
  - **UTF-8 Desteği (`utf8.decode(yanit.bodyBytes)`):** Türkçe ve özel karakterlerin soru işareti veya bozuk çıkmasını önler.
  - `status == 200` kontrolü ve `try-catch` mekanizması ile hataları yakalayıp ekran katmanına fırlatır (`rethrow`).

---

### 3) 📁 `widgets/` (Tekrar Kullanılabilir Parçalar)
Ekran kodlarını yüzlerce satır şişirmemek için görsel parçalar ayrı widget'lar haline getirilmiştir.

* **[stok_rozeti.dart]:**
  - Gelen `stoktaVarMi` boolean değerine göre yeşil "Stokta Var" veya kırmızı "Tükendi" rozetini yuvarlak köşeler ve şık renklerle basar.
  - Tek bir yerde tasarımı değiştirildiğinde hem liste kartında hem de detay sayfasında otomatik güncellenir.

* **[urun_karti.dart]:**
  - Liste ekranındaki her bir ürün satırıdır.
  - `InkWell` ile dokunulduğunda Material dalgalanma efekti verir.
  - `Image.network`'ün `loadingBuilder` ve `errorBuilder`'ı kullanılarak resim yüklenirken dönen çubuk, resim bozuksa kırık resim ikonu gösterilir.
  - Görsele `Hero(tag: 'urun_resim_${urun.id}')` sarmalaması yapılmıştır.

---

### 4) 📁 `screens/` (Ekran Katmanı)

* **[urun_listesi_ekrani.dart]:**
  - Uygulamanın ana ekranıdır ve durum yönetimi (`StatefulWidget`) buradadır.
  - **Değişkenler:** `_tumUrunler` (kaynak havuz), `_filtrelenmisUrunler` (ekranda görünen), `_yukleniyor`, `_hataMesaji`, `_seciliKategori`.
  - **Filtreleme Mantığı (`_filtreleriUygula`):** Kullanıcı kategori değiştirdiğinde veya arama kutusuna yazdığında, `_tumUrunler.where(...)` çalışarak hem kategoriye hem de başlığa göre filtre uygular.
  - **4 UI Durumu (`_durumaGoreGovdeyiOlustur`):**
    1. `_yukleniyor == true` ➔ Ortalanmış yükleniyor göstergesi.
    2. `_hataMesaji != null` ➔ Hata simgesi ve **Tekrar Dene** butonu.
    3. `_filtrelenmisUrunler.isEmpty` ➔ "Ürün bulunamadı" boş durumu.
    4. Başarılı ise ➔ `RefreshIndicator` + `ListView.builder`.

* **[urun_detay_ekrani.dart]:**
  - Seçilen ürünün büyük görselini, kategorisini, yıldızlı değerlendirmesini ve detaylı açıklamasını gösterir.
  - `Hero` widget'ı sayesinde liste ekranındaki küçük resim detay ekranına akıcı bir animasyonla büyüyerek geçer.
  - Ekranın altında `bottomNavigationBar` içinde sabit bir fiyat ve "Sepete Ekle" butonu yer alır.
  - Ürün stokta yoksa buton otomatik olarak pasif (`null`) hale gelir ve "Tükendi" yazar. Stokta varsa tıklandığında yeşil bir `SnackBar` ile bildirim gösterir.

---

### 5) 📜 `main.dart`
Uygulamanın giriş noktasıdır (`void main() => runApp(...)`).
- Google Material 3 tasarım standardını aktifleştirir (`useMaterial3: true`).
- Tohum renk olarak gece mavisi/indigo (`colorSchemeSeed: Colors.indigo`) belirleyerek tüm buton, çip ve AppBar tonlarını otomatik uyumlu hale getirir.
- Başlangıç sayfası olarak `UrunListesiEkrani`'nı ayarlar.

---

## 💡 Öğrenciler İçin Kritik İpuçları ve Mülakat Soruları

1. **Neden `http` isteklerinde `utf8.decode(yanit.bodyBytes)` kullandık?**
   - Doğrudan `yanit.body` kullanılırsa API'den gelen Türkçe karakterler (ş, ğ, ç, ı, ö, ü) veya tırnak işaretleri bozulabilir. `bodyBytes` UTF-8 olarak çözüldüğünde karakter sorunu yaşanmaz.
2. **Neden `mounted` kontrolü yaptık?**
   - Sayfa yüklenirken kullanıcı geri butonuna basıp sayfadan çıkarsa, asenkron işlem bittiğinde `setState()` çağrılırsa Flutter "State nesnesi ağaçta yok" hatası verir. `if (!mounted) return;` kontrollü bellek ve yaşam döngüsü güvenliği sağlar.
3. **Neden `Hero` animasyonu kullandık?**
   - Liste kartındaki görsel ile detay sayfasındaki görsel aynı etiket değerini (`urun_resim_${urun.id}`) paylaştığında Flutter iki ekran arasında geçiş yaparken resmi pürüzsüzce uçurur; profesyonel bir e-ticaret hissi yaratır.


