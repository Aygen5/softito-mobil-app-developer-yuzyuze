# StajTakip — Tasarım Sistemi ve Stitch'ten Flutter'a Dönüşüm Rehberi

## 1. Amaç

Bu dosya, Stitch kullanılarak oluşturulan tasarımların Flutter ve Dart ile gerçek, çalışan, sürdürülebilir arayüzlere dönüştürülmesini yönetir.

Stitch tasarımları görsel referans ve etkileşim kaynağıdır. Tasarım çıktısı doğrudan çalışan Flutter kodu olarak kabul edilmez.

Amaç yalnızca ekrana benzeyen bir görüntü oluşturmak değildir. Gerçek uygulamada aynı görsel dili koruyan, farklı ekran boyutlarında çalışan, erişilebilir, tekrar kullanılabilir ve Cubit ile entegre edilebilen widget'lar geliştirmektir.

## 2. Tasarım Öncelikleri

Öncelik sırası:
1. Stitch tasarımına görsel sadakat.
2. Kullanılabilirlik ve anlaşılır etkileşim.
3. Tüm ekranlarda tutarlı tasarım sistemi.
4. Responsive ve erişilebilir Flutter arayüzü.
5. Yeniden kullanılabilir widget'lar.
6. Mimari kurallara uygun entegrasyon.

Görsel sadakat sağlamak için mimariyi bozma. Mimariyi korumak için de tasarımı gereksiz yere basitleştirme. Bir sorun olduğunda tasarım ve kod arasında kontrollü bir çözüm üret.

## 3. Tasarım Referanslarını İnceleme

Kodlamaya başlamadan önce mevcut Stitch çıktısını incele.

Şunları belirle:
- Hangi ekranların tasarlandığı.
- Ekranların birbirleriyle ilişkisi.
- Renk paleti.
- Tipografi ve yazı boyutları.
- Boşluklar.
- Kenar yuvarlaklıkları.
- Kart ve buton ölçüleri.
- İkonlar.
- Alt menü ve navigasyon davranışı.
- Form alanları.
- Yükleniyor, boş, hata ve başarılı durumlar.
- Scroll davranışı.
- Mobil cihazın güvenli alanları.
- Ekranlar arasındaki geçişler.

Mevcut tasarım dosyalarını, kodları ve varlıkları kontrol etmeden sıfırdan tasarım oluşturma.

Eksik bir ekran varsa önce mevcut tasarım sistemini incele ve aynı tasarım dilini kullanarak eksik ekranı tamamla. Tasarım referansı olmayan alanlarda rastgele stil üretme.

## 4. Tasarım Token'ları

Aşağıdaki değerler başlangıç tasarım token'larıdır. Stitch tasarımında farklı, açıkça tanımlanmış değerler varsa gerçek referansla tutarlı şekilde güncelle.

### Renkler

```dart
abstract final class AppColors {
  static const primaryNavy = Color(0xFF142D4E);
  static const primaryBlue = Color(0xFF246BFD);
  static const accentTeal = Color(0xFF20A486);

  static const background = Color(0xFFF4F7FB);
  static const surface = Color(0xFFFFFFFF);
  static const textPrimary = Color(0xFF182538);
  static const textSecondary = Color(0xFF69778B);
  static const border = Color(0xFFE3EAF2);

  static const success = Color(0xFF16845B);
  static const warning = Color(0xFFC78116);
  static const error = Color(0xFFC64747);
}
```

Bu sınıf yalnızca renklerin nasıl merkezi yönetileceğini gösteren örnektir. Gerçek dosya mevcut mimariye göre oluşturulmalıdır.

Kurallar:
- Ekran dosyalarına gelişigüzel renk kodları yazma.
- Aynı anlamdaki renkler tüm uygulamada aynı token'ı kullansın.
- Durum renkleri yalnızca renkle ifade edilmesin; etiket ve gerekirse ikon da bulunsun.
- Metin ve arka plan arasında yeterli kontrast olsun.
- Tema değişikliği gerekiyorsa Material 3 tema sistemi kullanılsın.

### Tipografi

Tipografi merkezi tanımlanmalıdır.

Önerilen hiyerarşi:
- Ekran başlığı: 26–30 px.
- Bölüm başlığı: 18–21 px.
- Gövde metni: 14–16 px.
- Yardımcı metin: 12–14 px.
- Buton metni: yaklaşık 14–16 px.

Bu değerler başlangıç referansıdır. Stitch tasarımındaki ölçüler ve okunabilirlik esas alınmalıdır.

Türkçe karakterleri destekleyen font kullanılmalıdır. Font projeye ekleniyorsa lisansı ve dosyaları kontrol edilmeli; var olmayan font dosyaları için referans verilmemelidir.

### Boşluklar

8 noktalı boşluk sistemi temel alınmalıdır.

Örnek token'lar:
- 4 px: çok küçük iç boşluk.
- 8 px: yakın öğeler.
- 12 px: küçük aralık.
- 16 px: standart bileşen boşluğu.
- 24 px: kart veya bölüm aralığı.
- 32 px: büyük bölüm aralığı.

Bu değerler tasarım referansıyla gerektiğinde uyarlanabilir. Ekran içinde aynı tür boşluklar tutarlı kullanılmalıdır.

### Kenar yuvarlaklıkları

Önerilen başlangıç değerleri:
- Küçük etiket ve alanlar: 8 px.
- Buton ve standart kartlar: 12–16 px.
- Büyük vurgu kartları: 16–20 px.

Her bileşene farklı ve rastgele radius verme.

### Kenarlık ve gölgeler

- İnce ve düşük kontrastlı kenarlıklar tercih et.
- Gölgeleri yalnızca görsel hiyerarşiye katkı sağladığında kullan.
- Kartları birbirinden ayırmak için aynı anda kalın kenarlık, güçlü gölge ve yoğun arka plan kullanma.
- Stitch referansında olmayan dekoratif efektler ekleme.

## 5. Ortak Widget Kuralları

Aşağıdaki bileşenler tekrar kullanılabilir olacak şekilde tasarlanmalıdır:
- `AppButton`
- `AppTextField`
- `AppCard`
- `StatusBadge`
- `ProgressCard`
- `LoadingView`
- `ErrorView`
- `EmptyView`
- `AttachmentTile`
- `SectionHeader`

Her bileşen için yalnızca gerçekten gerekli parametreleri tanımla. Her widget'ı aşırı genel ve karmaşık bir tasarım sistemine dönüştürme.

Örneğin `AppButton`:
- Metin.
- Tıklama callback'i.
- Loading durumu.
- Devre dışı durumu.
- Gerekiyorsa buton çeşidi.

Loading durumunda işlem sürerken tekrar gönderim engellenmelidir. Disabled ve loading durumları görsel olarak anlaşılmalıdır.

## 6. Ekran Tasarım Kuralları

### Giriş ekranı

- Markalama ve form hiyerarşisi korunmalı.
- Alan etiketleri yalnızca placeholder olarak kullanılmamalı.
- Şifre görünürlüğü kontrolü çalışmalı.
- Doğrulama ve Firebase hata durumları tasarlanmalı.

### Dashboard

- Staj ilerleme kartı ana görsel odak olmalı.
- Tamamlanan ve zorunlu gün sayısı açıkça gösterilmeli.
- Özet kartları aynı boyut ve görsel dile sahip olmalı.
- Son raporlar okunabilir ve taranabilir olmalı.
- Gereksiz grafik ve dekorasyon eklenmemeli.

### Günlük rapor formu

- Form alanları uzun Türkçe metinleri desteklemeli.
- Gerekli alanlar açıkça belirtilmeli.
- Klavye açıldığında form kullanılabilir kalmalı.
- Kaydetme ve gönderme butonları çakışmamalı.
- Dosya seçme, yükleniyor ve hata durumları bulunmalı.
- Düzeltme talebi, formun üst kısmında belirgin biçimde gösterilmeli.

### Onay ekranı

- Öğrenci bilgisi, rapor tarihi ve içerik sıralaması açık olmalı.
- Onaylama ve düzeltme işlemleri birbirinden ayırt edilmeli.
- Düzeltme açıklaması alınmadan düzeltme isteği gönderilmemeli.
- Puanlama alanı yalnızca yetkili role gösterilmeli.
- Uzun rapor içeriği rahat okunabilmeli.

### İlerleme ve geçmiş

- Gün sayısı ve yüzde birbiriyle tutarlı olmalı.
- Durum etiketleri bütün ekranlarda aynı anlama gelmeli.
- Tarihler Türkçe ve tutarlı formatta gösterilmeli.
- Boş geçmiş ekranında kullanıcıya sonraki adım anlatılmalı.

### PDF ekranı

- Resmî belge görünümü sade olmalı.
- Önizleme ile gerçek oluşturulan PDF aynı veri ve şablonu kullanmalı.
- Türkçe karakterler doğru gösterilmeli.
- Uzun içeriklerde sayfa taşmaları engellenmeli.
- Eksik onay ve rapor durumları kullanıcıya açıklanmalı.

## 7. Stitch Çıktısını Flutter'a Dönüştürme Süreci

Her ekranı aşağıdaki sırayla ele al:

### Adım 1 — Referansı incele

Stitch'ten gelen tasarım kodunu, görseli veya proje çıktısını incele. Ekranın yapısını ve ortak bileşenleri belirle.

### Adım 2 — Mevcut projeyi kontrol et

- `pubspec.yaml`
- `lib/` klasör yapısı.
- Tema dosyaları.
- Router.
- Ortak widget'lar.
- Cubit ve Repository yapıları.
- Mevcut asset dosyaları.
- İlgili testler.

Mevcut dosyaları görmeden ikinci bir tema, router veya uygulama giriş dosyası oluşturma.

### Adım 3 — Görsel yapıyı ayır

Ekranı:
- Ana layout.
- Bölüm bileşenleri.
- Tekrarlanan kartlar.
- Form alanları.
- Butonlar.
- Navigasyon.

olarak değerlendir.

Tekrarlanan bileşenleri ortak widget olarak çıkar. Tek kullanımlık basit bir widget'ı sırf dosya sayısını artırmak için ayrı dosyaya taşıma.

### Adım 4 — Flutter widget'larına dönüştür

Uygun Flutter widget'larını kullan:
- `Scaffold`
- `SafeArea`
- `CustomScrollView`
- `ListView`
- `Column`
- `Row`
- `Expanded`
- `Flexible`
- `Padding`
- `Card`
- `Container`
- `TextFormField`
- `Form`
- `Stack`
- `Positioned`

Bunlar örneklerdir; her ekranın gerçek ihtiyacına göre seçim yapılmalıdır.

Web'e özgü CSS özelliklerini Flutter'da doğrudan varmış gibi kullanma. HTML/CSS tasarımını Flutter widget ağacına bilinçli olarak dönüştür.

### Adım 5 — Gerçek veriye bağla

Görsel tasarımın tamamlanması, ekranın yalnızca sabit metinlerden oluşması anlamına gelmez.

- Dashboard, Repository üzerinden gerçek veriyi almalı.
- Rapor listesi Firestore verisini göstermeli.
- Form kaydetme ve gönderme işlemleri çalışmalı.
- Dosya yükleme Storage ile entegre edilmeli.
- Onaylar Repository üzerinden kaydedilmeli.
- İlerleme tanımlanmış iş kurallarına göre hesaplanmalı.
- PDF gerçek rapor verilerini kullanmalı.

Görsel prototipte kullanılan örnek içerikler, üretim uygulamasında kalıcı veri kaynağı olarak bırakılmamalıdır.

### Adım 6 — Durumları tamamla

Her veri odaklı ekranda uygun durumları tasarla:
- İlk açılış.
- Yükleniyor.
- Veri var.
- Veri yok.
- Hata.
- İşlem başarılı.
- İşlem başarısız.
- Yetkisiz erişim.
- Form doğrulama hatası.

Her ekranın bütün durumlarını tek seferde oluşturmak zorunlu değildir; ilgili özellik geliştirilirken tamamlanmalıdır.

### Adım 7 — Görsel karşılaştırma yap

Flutter ekranını Stitch referansıyla karşılaştır.

Kontrol listesi:
- Genel yerleşim.
- Başlıkların konumu.
- Kart boyutları.
- Boşluklar.
- Renkler.
- Tipografi.
- İkonlar.
- Alt menü.
- Safe area.
- Scroll davranışı.
- Klavye açıldığındaki görünüm.
- Taşan metinler.
- Küçük ekran davranışı.

Mümkünse aynı cihaz boyutunda ekran görüntüsü alarak görsel karşılaştırma yap.

### Adım 8 — Kalite kontrolü

Dönüştürme tamamlandığında:
- `dart format` çalıştır.
- `flutter analyze` çalıştır.
- İlgili testleri çalıştır.
- Çalışan diğer ekranların bozulmadığını kontrol et.
- Eksik işlevleri ve kalan sorunları raporla.

## 8. Responsive Tasarım

Mobil öncelikli yaklaşım kullanılmalıdır.

- Sabit genişlik ve yükseklikleri gelişigüzel kullanma.
- Gerektiğinde `LayoutBuilder`, `MediaQuery` ve esnek layout widget'ları kullan.
- Dar ekranlarda taşma oluşmamalı.
- Uzun Türkçe metinler desteklenmeli.
- Büyük yazı boyutlarında temel içerik kullanılabilir kalmalı.
- Form klavyesi ekranın ana butonlarını tamamen erişilemez hale getirmemeli.
- Güvenli alanlar ve sistem çubukları dikkate alınmalı.

Stitch tasarımındaki ölçüleri doğrudan her cihaza sabit piksel değerleriyle uygulama.

## 9. Asset ve Görsel Yönetimi

- Mevcut proje asset'lerini incele.
- Kullanıcı tarafından verilen görsel bağlantılarını ve dosyalarını doğrula.
- Görsellerin yüklenememesi durumunda uygun hata veya yedek görünüm sağla.
- Projede olmayan dosya yollarını uydurma.
- Gereksiz ağ görselleri ekleme.
- Logo ve marka görsellerini tutarlı kullan.
- Görsellerin oranlarını ve kırpma biçimlerini referansa göre ayarla.

## 10. Erişilebilirlik

- Yeterli metin kontrastı.
- Anlaşılır buton etiketleri.
- Uygun touch target boyutları.
- Semantik olarak doğru kontroller.
- Renk dışında durum açıklaması.
- Ekran okuyucu için anlamlı etiketler.
- Uzun metinler için uygun satır aralığı.

## 11. Tasarımda Değişiklik Yönetimi

Bir Stitch ekranı değiştirildiğinde:
1. Değişen bölümleri belirle.
2. Ortak bileşenlere etkisini incele.
3. İlgili Flutter dosyalarını güncelle.
4. Gereksiz dosya kopyalama yapma.
5. Diğer ekranlarda görsel tutarlılığı kontrol et.
6. Etkilenen testleri çalıştır.

Tasarım değişikliklerini bütün projeyi gereksiz yere yeniden yazarak uygulama.

## 12. Kabul Kriterleri

Bir ekran tamamlandı sayılmadan önce:
- Stitch referansıyla görsel olarak tutarlı olmalı.
- Türkçe metinler doğru görünmeli.
- Mobil ölçülerde taşma olmamalı.
- Ortak tasarım token'larını kullanmalı.
- Loading, boş ve hata durumları ele alınmalı.
- Cubit ve Repository mimarisine uygun olmalı.
- Sahte veriyle çalışan bir prototip olarak bırakılmamalı.
- `flutter analyze` sonuçları kontrol edilmeli.
- İlgili temel testler geçmeli.