# 🎓 RotaRent — Flutter Öğrenci Rehberi

Merhaba! Flutter ve Dart dünyasına hoş geldin. Bu rehber, **RotaRent Araç Kiralama & Rezervasyon Mobil Uygulaması**'nın mimarisini, kod organizasyonunu ve Flutter'ın temel özelliklerinin gerçek bir projede nasıl uygulandığını adım adım kavramanı sağlamak için hazırlandı.

---

## 🏛️ 1. Büyük Resim: Proje Mimarisi ve Klasör Yapısı

Flutter projelerinde kodların rastgele dosyalara yazılması, proje büyüdükçe yönetimi imkansız hale getirir. Bu nedenle projemizi **Özellik Tabanlı (Feature-First) / Katmanlı Mimari** prensiplerine göre organize ettik.

### 📁 Klasör Ağacı ve Görevleri

```text
lib/
├── core/                           # 🧠 Tüm uygulamada ortak kullanılan çekirdek yapılar
│   ├── constants/                  # Sabitler (marka adı, kategoriler, şehirler)
│   ├── navigation/                 # Sayfa geçişleri ve yönlendirme rotaları
│   ├── theme/                      # Renkler, Material 3 Açık/Koyu tema ve ThemeController
│   ├── utils/                      # Tarih biçimlendirme ve fiyat/indirim hesaplayıcılar
│   └── widgets/                    # Ortak butonlar, başlıklar, boş durumlar, alt menü
│
├── models/                         # 📦 Veri Modelleri (Verilerin Dart sınıfları)
│   ├── unavailable_range.dart      # Dolu tarih aralığı modeli
│   ├── vehicle.dart                # Araç veri modeli
│   └── reservation.dart            # Rezervasyon modeli
│
├── data/                           # 💾 Veri Katmanı
│   ├── vehicle_data_source.dart    # JSON dosyasından araçları okuyan ve önbelleğe alan servis
│   └── reservation_store.dart      # Bellek içi (In-Memory) rezervasyon deposu ve çakışma kontrolü
│
├── features/                       # 📱 Ekranlar ve Kullanıcı Deneyimi Özellikleri
│   ├── splash/                     # Açılış Ekranı (Logo animasyonu ve karşılama)
│   ├── home/                       # Ana Sayfa (Arama, kategoriler, öne çıkanlar, şube haritası)
│   ├── vehicles/                   # Araç Listeleme, 1/2/3 sütun görünümü, filtreleme ve sıralama
│   ├── reservation/                # Araç Detayı, dinamik takvim, yakıt göstergesi ve rezervasyon formu
│   └── account/                    # Kullanıcı profili, aktif/geçmiş rezervasyonlar, sözleşme, tema değişimi
│
├── app.dart                        # 🚀 MaterialApp kökü ve ThemeMode dinleyicisi
└── main.dart                       # 🎬 Uygulamanın giriş kapısı (runApp)
```

### 💡 Neden Bu Şekilde Ayırdık?
- **Tek Sorumluluk İlkesi (Single Responsibility):** Bir dosyada değişiklik yaparken (örneğin sadece fiyat indirim oranını güncellerken) ekran kodlarına dokunmak zorunda kalmazsınız (`price_utils.dart`'ı değiştirmek yeterlidir).
- **Yeniden Kullanılabilirlik (Reusability):** `AppButton` gibi bir widget'ı bir kez yazıp onlarca ekranda aynı kurumsal tasarımla kullanabilirsiniz.
- **Test Edilebilirlik:** İş mantığını (`utils/`, `data/`) UI'dan ayırdığımız için `flutter test` ile sayfaları açmadan saf Dart testleri yazabildik.

---

## 🧩 2. Küçük Resim: Neyi, Neden ve Nasıl Geliştirdik?

### 2.1. Veri Modelleri (`models/`)
Flutter'da harici veriler (örneğin `assets/data/vehicles.json`) `Map<String, dynamic>` şeklinde ham metin olarak gelir. Ham harita (`map['brand']`) kullanmak yerine tip güvenliği (Type Safety) sağlayan Dart sınıfları yazarız.

```dart
// factory constructor ile JSON'dan nesne üretme
factory Vehicle.fromJson(Map<String, dynamic> json) {
  return Vehicle(
    id: json['id'] as String,
    brand: json['brand'] as String,
    dailyPrice: (json['dailyPrice'] as num).toDouble(),
    ...
  );
}
```
- **Öğrenci Notu:** `fromJson` metodu bir fabrika kurucudur (`factory constructor`). Gelen ham JSON verisini Dart nesnesine dönüştürür. `toJson` ise nesneyi tekrar JSON haritasına çevirir.

---

### 2.2. Veri Kaynağı ve Bellek Yönetimi (`data/`)

#### Singleton Deseni (`VehicleDataSource`):
Uygulamanın neresinden çağrılırsa çağrılsın aynı araç listesine ulaşabilmesi için `Singleton` tasarım kalıbı kullanıldı:
```dart
class VehicleDataSource {
  static final VehicleDataSource _instance = VehicleDataSource._internal();
  factory VehicleDataSource() => _instance;
  VehicleDataSource._internal();
  ...
}
```
Böylece JSON dosyası diskten yalnızca bir kez okunur (`rootBundle.loadString`) ve hafızada (`_cachedVehicles`) saklanır.

#### Dinamik Rezervasyon Deposu (`ReservationStore`):
Kullanıcı yeni bir rezervasyon yaptığında backend olmadığı için veriler bellekte (`List<Reservation>`) tutulur. `ValueNotifier<List<Reservation>>` ile sarıldığı için yeni bir rezervasyon eklendiğinde **"Hesabım & Rezervasyonlarım"** ekranı anında otomatik güncellenir.

---

### 2.3. Dinamik Müsaitlik Takvimi Algoritması (`availability_calendar.dart`)

Uygulamanın en kritik iş kuralı dinamik araç müsaitliğidir:
1. **Geçmiş Tarih Koruması:** `day.isBefore(today)` kontrolüyle bugünden önceki tarihler pasif gri renge boyanır ve tıklanamaz.
2. **JSON + Bellek Kontrolü:** Araç için JSON'da tanımlı olan `unavailableRanges` tarih aralıkları ile az önce hafızada oluşturulmuş olan kullanıcı rezervasyonları birleştirilir.
3. **Kırmızı Doluluk Vurgusu:** Seçilmek istenen tarihler arasında dolu bir gün varsa takvimde kırmızı rozetle gösterilir ve kiralama engellenir.
4. **Bitişik Rezervasyon Kuralı:** Bir kiralama 24 Ekim saat 10:00'da bitiyorsa, başka bir kullanıcı aynı gün 24 Ekim saat 10:00'da yeni bir kiralama başlatabilir (`!start.isBefore(otherEnd)`).

---

### 2.4. Fiyat Hesaplama ve %15 Uzun Dönem İndirimi (`price_utils.dart`)
- Saatlik ve günlük ücret hesaplanır.
- **İş Kuralı:** Eğer kiralama süresi 7 gün veya üzeriyse tutara otomatik **%15 indirim** uygulanır.
- Kullanıcıya indirim tutarı ve indirimsiz fiyat üzeri çizili şekilde gösterilerek şeffaflık sağlanır.

---

### 2.5. Durum Yönetimi (State Management)
Bu projede harici ağır paketler (Bloc, Riverpod vb.) yerine Flutter'ın yerleşik ve son derece hızlı olan yapıları kullanıldı:
1. **`StatefulWidget` ve `setState()`:** Ekran içi filtreler, sıralama seçenekleri veya form alanları gibi yerel durumlarda kullanıldı.
2. **`ValueNotifier<ThemeMode>` ve `ValueListenableBuilder`:** Açık ve Koyu tema değişiminde tüm uygulamayı yeniden çizdirmek için kullanıldı.
3. **`Navigator` 1.0:** Ekranlar arasında geçiş yapmak (`MaterialPageRoute` ve `PageRouteBuilder`) için kullanıldı.

---

## 🎨 3. Dört Ana Ekranın Mimarisi ve Flutter Bileşenleri

### 1. Açılış Ekranı (`SplashScreen`)
- `AnimationController`, `FadeTransition` ve `ScaleTransition` kullanılarak açılışta logonun yumuşakça belirmesi sağlandı.
- 2 saniye sonra `Navigator.pushReplacement` ile kullanıcıyı ana kabuğa yönlendirir.

### 2. Ana Sayfa (`HomeScreen`)
- Karşılama başlığı ve arama çubuğu.
- Araç sınıfı çipleri (`Basic`, `Basic+`, `Flex`, `Flex+`, `Lux`, `Ultra Lux`). Tıklandığında araç listesini o kategoriye göre filtreler.
- `CustomPaint` ile çizilmiş temsili Türkiye harita gridi ve şube seçici butonları (`BranchMapPreview`).

### 3. Araç Listesi (`VehicleListScreen`)
- **Çoklu Görünüm Desteği:** Kullanıcı araçları 1 sütun (liste), 2 sütun (ızgara) veya 3 sütun (kompakt) olarak görüntüleyebilir.
- `showModalBottomSheet` kullanılarak alttan açılan sıralama ve filtreleme pencereleri eklendi.

### 4. Araç Detayı & Takvim (`VehicleDetailScreen`)
- Araç resimleri galerisi ve teknik özellikler.
- `CustomPaint` ile çizilmiş interaktif yakıt deposu göstergesi ([`FuelGaugeWidget`](file:///Users/d1-18/Desktop/softito-mobil-app-developer-yuzyuze/20_ekim/20_ekim_odev_oto_kiralama/lib/features/reservation/widgets/fuel_gauge.dart)). Tıklandığında Türkiye akaryakıt fiyatları modalı açılır.
- Dinamik Müsaitlik Takvimi ([`AvailabilityCalendar`](file:///Users/d1-18/Desktop/softito-mobil-app-developer-yuzyuze/20_ekim/20_ekim_odev_oto_kiralama/lib/features/reservation/widgets/availability_calendar.dart)) ve rezervasyon formu.

### 5. Hesabım & Rezervasyonlarım (`AccountScreen`)
- Kullanıcı profil kartı, aktif ve tamamlanmış rezervasyon sekmeleri.
- Kiralama sözleşmesi modalı ([`RentalAgreementDialog`](file:///Users/d1-18/Desktop/softito-mobil-app-developer-yuzyuze/20_ekim/20_ekim_odev_oto_kiralama/lib/features/account/dialogs/rental_agreement_dialog.dart)).
- Açık/Koyu tema değiştirici anahtar switch'i.

---

## 🧪 4. Testler ve Kod Kalitesi

- `flutter analyze`: Projede hiçbir linter uyarısı veya hata bulunmamaktadır (0 issue).
- `flutter test`: 12 birim ve widget testi yazılmış olup; modellerin serileştirilmesi, tarih çakışma mantığı, indirim hesaplama ve ekran duman testleri eksiksiz geçmektedir.

---

## 🚀 Projeyi Çalıştırma

```bash
cd /Users/d1-18/Desktop/softito-mobil-app-developer-yuzyuze/20_ekim/20_ekim_odev_oto_kiralama

# Masaüstü uygulaması olarak çalıştırmak için:
flutter run -d macos

# Chrome tarayıcısında çalıştırmak için:
flutter run -d chrome
```
