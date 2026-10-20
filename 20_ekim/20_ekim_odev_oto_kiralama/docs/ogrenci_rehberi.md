# 🎓 RotaRent — Kapsamlı Flutter & Dart Öğrenci Başvuru Rehberi

 **RotaRent**, kurumsal bir mobil araç kiralama uygulamasında karşılaşabileceğin tüm senaryoları (dinamik müsaitlik, tarih çakışma algoritmaları, çoklu sütun ızgaraları, özel takvim motoru, reaktif durum yönetimi ve açık/koyu tema) **harici ağır kütüphanelere bağımlı kalmadan**, saf Flutter yetenekleriyle çözmektedir.

---

## 📑 İçindekiler
1. [Büyük Resim: Mimari ve Klasör Hiyerarşisi](#1-büyük-resim-mimari-ve-klasör-hiyerarşisi)
2. [Dart & Flutter Temel Kavramları — Projedeki Canlı Örnekleriyle](#2-dart--flutter-temel-kavramları)
3. [Kritik İş Kuralları ve Algoritmik Çözümler (Business Logic)](#3-kritik-iş-kuralları-ve-algoritmik-çözümler)
4. [Arayüz ve Görsel Çizim Ustalığı (UI & Custom Paint)](#4-arayüz-ve-görsel-çizim-ustalığı)
5. [Ekran ve Kullanıcı Akışları Yol Haritası](#5-ekran-ve-kullanıcı-akışları-yol-haritası)
6. [Sık Yapılan Hatalar ve Altın Kurallar (FAQ & Gotchas)](#6-sık-yapılan-hatalar-ve-altın-kurallar)
7. [Projeyi Çalıştırma ve Test Rehberi](#7-projeyi-çalıştırma-ve-test-rehberi)

---

## 🏛️ 1. Büyük Resim: Mimari ve Klasör Hiyerarşisi

Bir Flutter projesine başlarken yapılan en büyük hata, tüm dosyaları tek bir klasöre yığmaktır. RotaRent'te **Feature-First (Özellik Tabanlı) / Katmanlı Mimari** kullanılmıştır.

### 📁 Klasör Ağacı ve Katman Sorumlulukları

```text
lib/
├── core/                           # 🧠 KATMAN 1: ÇEKİRDEK (Ortak Altyapı)
│   ├── constants/                  # Sabit metinler, marka adı, lokasyonlar, kategoriler
│   │   └── app_constants.dart
│   ├── navigation/                 # Sayfa geçişleri, rota yöneticisi
│   │   └── app_navigation.dart
│   ├── theme/                      # Material 3 tema sistemi, renk paletleri, ThemeController
│   │   ├── app_colors.dart
│   │   ├── app_theme.dart
│   │   └── theme_controller.dart
│   ├── utils/                      # Yardımcı matematik ve tarih fonksiyonları
│   │   ├── date_utils.dart
│   │   └── price_utils.dart
│   └── widgets/                    # Tüm projede ortak kullanılan genel widget'lar
│       ├── app_button.dart
│       ├── app_bottom_navigation.dart
│       ├── app_empty_state.dart
│       └── app_section_title.dart
│
├── models/                         # 📦 KATMAN 2: VERİ MODELLERİ (Varlıklar / Entities)
│   ├── unavailable_range.dart      # Dolu tarih aralığı modeli
│   ├── vehicle.dart                # Araç veri modeli
│   └── reservation.dart            # Rezervasyon kayıt modeli
│
├── data/                           # 💾 KATMAN 3: VERİ KAYNAKLARI VE DEPOLAR
│   ├── vehicle_data_source.dart    # JSON dosyasını okuyan ve önbelleğe alan Singleton servis
│   └── reservation_store.dart      # Bellek içi reaktif rezervasyon deposu ve çakışma motoru
│
├── features/                       # 📱 KATMAN 4: UYGULAMA ÖZELLİKLERİ VE EKRANLAR
│   ├── splash/                     # Açılış ve karşılama animasyonu
│   │   └── screens/splash_screen.dart
│   ├── home/                       # Keşfet, arama, kategoriler, harita
│   │   ├── screens/home_screen.dart
│   │   ├── screens/main_shell.dart
│   │   └── widgets/...
│   ├── vehicles/                   # Araç listesi, filtreleme, sıralama, 1/2/3 sütun görünümü
│   │   ├── screens/vehicle_list_screen.dart
│   │   └── widgets/...
│   ├── reservation/                # Araç detayı, özel takvim, yakıt göstergesi, rezervasyon formu
│   │   ├── screens/vehicle_detail_screen.dart
│   │   ├── dialogs/...
│   │   └── widgets/...
│   └── account/                    # Kullanıcı profili, aktif/geçmiş kiralama takibi, tema anahtarı
│       ├── screens/account_screen.dart
│       ├── dialogs/...
│       └── widgets/...
│
├── app.dart                        # 🚀 MaterialApp kökü ve tema dinleyicisi
└── main.dart                       # 🎬 Uygulamanın giriş noktası (runApp)
```

### 💡 Neden Bu Mimarî Tercih Edildi?
- **Tek Sorumluluk İlkesi (Single Responsibility Principle):** Örneğin, 7 günlük kiralama indirimini %15'ten %20'ye çıkarmak istediğinde hiçbir ekran koduna dokunmazsın; sadece `core/constants/app_constants.dart` içindeki `discountRate` sabitini değiştirmen yeterlidir.
- **Yeniden Kullanılabilirlik (Reusability):** `AppButton` butonunu bir kez yazdık; hem araç detayında, hem filtre sayfasında, hem de rezervasyon onay pencerelerinde tek bir satırla çağırdık.
- **Bağımsız Test Edilebilirlik:** İş mantığı (`price_utils.dart`, `date_utils.dart`, `reservation_store.dart`) UI'dan bağımsız saf Dart sınıfları olduğu için ekranları açmadan saniyeler içinde birim testleri (`flutter test`) çalıştırılabilir.

---

## 🧩 2. Dart & Flutter Temel Kavramları — Projedeki Canlı Örnekleriyle

### 2.1. `StatelessWidget` vs `StatefulWidget`
Flutter'da iki ana widget türü vardır:
- **`StatelessWidget` (Durumsuz):** Ekranda çizildikten sonra kendi kendine değişmeyen widget'lardır.
  - *Projedeki Örnek:* `AppButton`, `AppEmptyState`, `RentalPriceSummary`. Parametrelerini dışarıdan alır ve sadece çizer.
- **`StatefulWidget` (Durumlu):** Kullanıcı etkileşimiyle veya zamanla içeriği değişen widget'lardır.
  - *Projedeki Örnek:* `AvailabilityCalendar` (seçilen tarihler değişir), `VehicleListScreen` (1/2/3 sütun düzeni ve filtreler değişir).

### 2.2. Widget Yaşam Döngüsü (Lifecycle Metotları)
`StatefulWidget` kullanırken şu 4 metot hayati önem taşır:
1. **`initState()`:** Widget ilk kez belleğe yüklendiğinde **yalnızca bir kez** çalışır. Animasyon başlatma, başlangıç tarihi atama işlemleri burada yapılır.
2. **`didUpdateWidget()`:** Üst (ebeveyn) widget yeniden çizildiğinde ve bu widget'a yeni parametreler geçtiğinde çalışır. Örneğin kullanıcı formdan saati değiştirdiğinde takvimin kendini güncellemesi `AvailabilityCalendar` içinde bu metotla sağlanır.
3. **`build()`:** Ekrana çizim yapılan yerdir. `setState()` çağrıldığında bu metot baştan çalışır. **Burada ağır hesaplamalar veya API çağrıları asla yapılmamalıdır.**
4. **`dispose()`:** Widget ekrandan kaldırıldığında çalışır. Açık kalan sayaçlar (`AnimationController`), metin denetleyicileri (`TextEditingController`) burada kapatılır. Kapatılmazsa **Memory Leak (Bellek Sızıntısı)** oluşur!

### 2.3. Singleton Tasarım Deseni (`VehicleDataSource`)
Uygulamanın farklı ekranlarından araç listesine erişmek isteriz. Her ekranda `vehicles.json` dosyasını diskten tekrar tekrar okumak performansı öldürür.
```dart
class VehicleDataSource {
  // 1. Statik ve tekil örnek (Tek kopya)
  static final VehicleDataSource _instance = VehicleDataSource._internal();

  // 2. Factory constructor: Her 'VehicleDataSource()' çağrıldığında aynı örneği döndürür
  factory VehicleDataSource() => _instance;

  // 3. Private constructor: Dışarıdan 'new' ile kopyalanmasını engeller
  VehicleDataSource._internal();
}
```
*Sonuç:* JSON diski sadece ilk açılışta 1 kere okunur, araçlar RAM bellekte önbelleğe alınır (`_cachedVehicles`).

### 2.4. Harici Paketsiz Reaktif Durum Yönetimi: `ValueNotifier` & `ValueListenableBuilder`
Uygulamada Bloc veya Provider gibi üçüncü parti paketler kullanmadan anlık reaktif güncellemeleri nasıl yaptık?
1. **`ValueNotifier<T>`:** Değiştiğinde haber veren bir kutudur.
   - Projede `ThemeController` (`ValueNotifier<ThemeMode>`) ve `ReservationStore` (`ValueNotifier<List<Reservation>>`) ile kullanıldı.
2. **`ValueListenableBuilder<T>`:** Bu kutuyu dinleyen özel widget'tır. Kutu içindeki değer değiştiğinde **sadece bu widget'ın altındaki ağaç** yeniden çizilir, tüm sayfa gereksiz yere baştan çizilmez.
3. **Kritik Kural (Referans Eşitliği):**
   ```dart
   // YANLIŞ: Liste içeriği değişti ama listenin bellek adresi aynı kaldığı için dinleyiciler UYANMAZ!
   value.add(yeniRezervasyon);

   // DOĞRU: Spread operatörü (...) ile yepyeni bir liste referansı oluşturulur!
   value = [yeniRezervasyon, ...value];
   ```

### 2.5. Dart 3 Yenilikleri: Records (Çoklu Değer Döndürme)
`lib/core/utils/price_utils.dart` içinde fiyat hesabı yaparken Dart 3'ün `Records` özelliğinden yararlandık:
```dart
// Tek bir fonksiyon ile hem gün, hem saat, hem indirim hem toplam tutar döndürme:
({
  int days,
  int hours,
  double rawPrice,
  double discountAmount,
  double totalPrice,
  bool isDiscountApplied,
}) calculateRentalPrice(...) { ... }
```
Ayrı bir `CalculationResult` sınıfı yazma hamallığından kurtulup kodumuzu hafif ve güçlü kıldık.

### 2.6. `IndexedStack` ile Sekme Durumunu Koruma (`MainShell`)
Alt gezinme çubuğundaki (Home, Araçlar, Hesabım) sekmeler arasında gezinirken kullanıcının araç listesindeki scroll pozisyonu veya seçtiği filtreler kaybolmasın diye `IndexedStack` kullanıldı. Bu widget, tüm sayfaları bellekte tutar ve sadece seçili olanı görünür kılar.

---

## 🧠 3. Kritik İş Kuralları ve Algoritmik Çözümler

Bir yazılımı değerli kılan şey arayüzün arkasında yatan kusursuz iş mantığıdır (Business Rules). Projemizdeki 3 kritik algoritma:

### 3.1. Akıllı Rezervasyon Çakışma Motoru (`ReservationStore.canBook`)
Bir araç kiralanmak istendiğinde şu 4 filtre art arda çalışır:

1. **Geçmiş Tarih Kontrolü:** `start.isBefore(now)` kontrolü ile dün veya daha önceki tarihler reddedilir.
2. **Kronolojik Mantık:** `start.isBefore(end)` kontrolü ile dönüş saati mutlaka alıştan sonra olmalıdır.
3. **Statik JSON Dolu Günleri Kontrolü:** Araç için `vehicles.json` dosyasında kayıtlı önceden rezerve edilmiş aralıklar taranır.
4. **Bellekteki Aktif Kullanıcı Rezervasyonları:** Uygulama açıkken yapılmış önceki rezervasyonlar taranır.

#### ⚡ Bitişik Rezervasyon Kuralı (Adjacent Booking Rule):
Ahmet aracı **24 Ekim saat 10:00**'da teslim edecekse, Mehmet aynı aracı **24 Ekim saat 10:00**'da kiralayabilir mi?
- **Evet!** Gerçek hayatta teslim ve alış aynı anda gerçekleşebilir.
- Bu yüzden çakışma formülü `<=` ve `>=` yerine kesin büyüktür/küçüktür kullanılarak yazılmıştır:
```dart
// Çakışma Koşulu:
final hasOverlap = !start1.isBefore(end2) && end1.isAfter(start2);
// Eğer Bitiş1 == Başlangıç2 ise çakışma sayılmaz!
```

### 3.2. Dinamik Fiyatlandırma ve %15 Uzun Dönem İndirimi
- **Kural 1:** 24 saatin katları günlük ücret üzerinden çarpılır.
- **Kural 2:** Kalan artık saatler (örneğin 2 gün 5 saat), aracın saatlik ücreti ile çarpılarak eklenir.
- **Kural 3 (%15 İndirim):** Eğer toplam süre 7 gün (168 saat) veya daha fazlaysa ham tutara otomatik **%15 indirim** uygulanır.
```dart
if (totalHours >= 7 * 24) {
  isDiscountApplied = true;
  discountAmount = rawPrice * 0.15;
  totalPrice = rawPrice - discountAmount;
}
```

### 3.3. 250 KM Günlük Kullanım Sınırı ve Yakıt Politikası
- `AppConstants.dailyKmAllowance = 250;`
- Kullanıcıya kiralama öncesinde günlük limit ve yakıt deposunu aldığı seviyede getirmesi gerektiği sözleşme ve bilgi kartlarıyla iletilir.

---

## 🎨 4. Arayüz ve Görsel Çizim Ustalığı (UI & Custom Paint)

### 4.1. Sıfırdan Takvim Motoru (`AvailabilityCalendar`)
Dışarıdan hazır paket almadan, 42 hücreli (6 hafta x 7 gün) `GridView` kullanarak nasıl takvim yaptık?
1. **Ayın Gün Sayısını Bulma:**
   ```dart
   // Gelecek ayın 0. günü = bu ayın son günüdür!
   final daysInMonth = DateTime(year, month + 1, 0).day; // Örn: Ekim -> 31
   ```
2. **Ayın İlk Gününün Haftanın Günü:**
   ```dart
   final firstWeekday = _currentMonth.weekday; // 1 = Pazartesi, 7 = Pazar
   ```
3. **Hücre Öteleme (Offset):** Ayın 1'i Çarşamba (3) ise, ilk 2 hücreyi `SizedBox.shrink()` ile boş bırakıp günleri 3. hücreden başlatırız.
4. **Aralık İçi Dolu Gün Kontrolü:** Başlangıç ile bitiş arasına dolu bir gün düşüyorsa seçim engellenir ve kırmızı uyarı banner'ı açılır.

### 4.2. Düşük Seviyeli Çizim: `CustomPaint` ve `Canvas` (`BranchMapPreview`)
Flutter'da sadece hazır widget'ları dizmekle kalmaz; doğrudan piksel düzeyinde çizim yapabilirsin:
- `CustomPainter` sınıfından türetilen `_BranchMapPainter`, `paint(Canvas canvas, Size size)` metoduna sahiptir.
- `canvas.drawCircle(...)` ile şube noktaları ve parıltı dalgaları çizilmiştir.
- `shouldRepaint(...)` false döndürülerek gereksiz işlemci tüketimi önlenmiştir.

### 4.3. Responsive Çoklu Görünüm Desteği (`VehicleListScreen`)
Kullanıcı araçları 3 farklı modda listeleyebilir:
1. **1 Sütun (Detaylı Liste Kartı):** Büyük resim, geniş teknik özellikler, fiyat dökümü.
2. **2 Sütun (Kare Izgara Kartı):** E-ticaret siteleri tarzı iki sütunlu kartlar.
3. **3 Sütun (Kompakt Mini Kart):** Hızlıca çok aracı yan yana taramak isteyenler için.
- Geçiş mantığı modülo aritmetiği ile tek bir değişkende çözüldü: `_viewMode = (_viewMode + 1) % 3;`.

---

## 🗺️ 5. Ekran ve Kullanıcı Akışları Yol Haritası

```text
[Açılış]
   └─ SplashScreen (Scale & Fade Animasyonu)
         │
         ▼
[Ana Kabuk - MainShell]
   ├── TAB 0: HomeScreen (Arama, Araç Sınıfı Çipleri, Şube Haritası)
   │     └── Bir kategoriye basınca -> VehicleListScreen'e parametreyle geçer
   │
   ├── TAB 1: VehicleListScreen (1/2/3 Sütun Görünümü, Filtreler, Sıralama)
   │     └── Bir araca basınca -> VehicleDetailScreen açılır
   │           ├── Galeri ve Araç Özellikleri
   │           ├── FuelGauge (Basınca -> FuelPricesDialog)
   │           ├── AvailabilityCalendar (Tarih Aralığı Seçimi)
   │           ├── RentalDateForm (Saatler ve Alış/Dönüş Şubeleri)
   │           ├── RentalPriceSummary (Dinamik Fiyat ve İndirim Dökümü)
   │           └── "Hemen Kirala" Butonu
   │                 └── Başarılıysa -> ReservationResultDialog (Dekont)
   │                       └── "Rezervasyonlarıma Git" -> TAB 2'ye yönlendirir!
   │
   └── TAB 2: AccountScreen (Profil, VIP Rozeti, Koyu/Açık Tema Switcher)
         ├── Aktif Rezervasyonlar Sekmesi (İptal Et Butonu & Onay Penceresi)
         ├── Geçmiş Kiralama Sekmesi
         └── Kiralama Sözleşmesi Modal Penceresi
```

---

## ⚠️ 6. Sık Yapılan Hatalar ve Altın Kurallar (FAQ & Gotchas)

### Soru 1: "Yeni rezervasyon ekledim ama Hesabım ekranındaki liste güncellenmedi?"
- **Cevap:** Listenin içine `value.add(yeni)` derseniz `ValueNotifier` liste referansının değiştiğini fark edemez. Mutlaka yeni bir liste oluşturmalısınız:
  ```dart
  value = [yeniRezervasyon, ...value]; // Spread operatörü yeni referans üretir!
  ```

### Soru 2: "RenderFlex overflowed by XXX pixels hatası aldım, ne yapmalıyım?"
- **Cevap:** Bir `Row` veya `Column` içine sığmayan widget koyduğunuzda bu hatayı alırsınız.
  - Metin taşıyorsa: `Expanded` içine alın ve `overflow: TextOverflow.ellipsis` verin.
  - Sayfa klavye açılınca taşıyorsa: `SingleChildScrollView` veya `ListView` kullanın.

### Soru 3: "`const` anahtar kelimesi neden her yerde karşımıza çıkıyor?"
- **Cevap:** `const` ile tanımlanan widget'lar derleme anında bir kez üretilir. Ekran `setState` ile tekrar çizilse bile Flutter bu widget'ları hafızadan aynen kullanır, işlemciyi yormaz.

### Soru 4: "`BuildContext context` tam olarak nedir?"
- **Cevap:** `context`, bir widget'ın Flutter widget ağacındaki yerini (adresini) belirten kimlik kartıdır. Temayı okurken (`Theme.of(context)`), ekran boyutunu alırken (`MediaQuery.of(context)`) veya sayfa değiştirirken (`Navigator.of(context)`) Flutter bu adresi kullanır.

---

## 🚀 7. Projeyi Çalıştırma ve Test Rehberi

Projeyi kendi bilgisayarında açtığında terminalden şu adımları izleyebilirsin:

```bash
# 1. Proje klasörüne geç:
cd 20_ekim/20_ekim_odev_oto_kiralama

# 2. Paket bağımlılıklarını güncelle:
flutter pub get

# 3. Kod kalitesini analiz et (Hata/Linter uyarısı olmamalı):
flutter analyze

# 4. Otomatik birim ve duman testlerini çalıştır:
flutter test

# 5. Uygulamayı çalıştır:
# Windows masaüstü için:
flutter run -d windows

# Chrome tarayıcısında çalıştırmak için:
flutter run -d chrome
```

