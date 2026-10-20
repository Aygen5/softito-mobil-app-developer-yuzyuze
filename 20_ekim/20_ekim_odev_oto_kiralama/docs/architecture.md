# RotaRent — Yazılım Mimarisi

## 1. Mimari Yaklaşım

RotaRent, Flutter ile geliştirilen, yalnızca istemci tarafında çalışan küçük ölçekli bir mobil uygulamadır.

Mimari, projenin öğrenme amacına uygun olarak sade tutulacaktır. Gereksiz katmanlar, karmaşık tasarım desenleri ve büyük ölçekli uygulamalara özgü mimari yapılar kullanılmayacaktır.

Temel yaklaşım:

- Ekranlar, veri modelleri ve ortak bileşenler birbirinden ayrılır.
- Araç verileri yerel JSON dosyasından yüklenir.
- Filtreleme ve sıralama yerel listeler üzerinde yapılır.
- Rezervasyon ve müsaitlik işlemleri uygulama içerisinde gerçekleştirilir.
- Ortak tema, navigasyon ve yardımcı bileşenler merkezi olarak yönetilir.
- Aynı işlevi yapan kodlar mümkün olduğunca tekrar kullanılabilir bileşenlere ayrılır.

## 2. Önerilen Klasör Yapısı

```text
rotarent/
├── assets/
│   ├── data/
│   │   └── vehicles.json
│   └── images/
│       └── vehicles/
│
├── docs/
│   ├── project.md
│   ├── architecture.md
│   ├── design-system.md
│   └── skills.md
│
├── lib/
│   ├── main.dart
│   │
│   ├── core/
│   │   ├── theme/
│   │   │   ├── app_theme.dart
│   │   │   └── theme_controller.dart
│   │   │
│   │   ├── navigation/
│   │   │   └── app_navigation.dart
│   │   │
│   │   ├── constants/
│   │   │   └── app_constants.dart
│   │   │
│   │   ├── utils/
│   │   │   ├── date_utils.dart
│   │   │   └── price_utils.dart
│   │   │
│   │   └── widgets/
│   │       ├── app_button.dart
│   │       ├── app_bottom_navigation.dart
│   │       ├── app_empty_state.dart
│   │       └── app_section_title.dart
│   │
│   ├── models/
│   │   ├── vehicle.dart
│   │   ├── unavailable_range.dart
│   │   └── reservation.dart
│   │
│   ├── data/
│   │   ├── vehicle_data_source.dart
│   │   └── reservation_store.dart
│   │
│   ├── features/
│   │   ├── home/
│   │   │   ├── screens/
│   │   │   │   └── home_screen.dart
│   │   │   └── widgets/
│   │   │       ├── category_list.dart
│   │   │       ├── featured_vehicle_card.dart
│   │   │       └── branch_map_preview.dart
│   │   │
│   │   ├── vehicles/
│   │   │   ├── screens/
│   │   │   │   └── vehicle_list_screen.dart
│   │   │   └── widgets/
│   │   │       ├── vehicle_card.dart
│   │   │       ├── vehicle_grid.dart
│   │   │       ├── vehicle_filter_sheet.dart
│   │   │       └── vehicle_sort_sheet.dart
│   │   │
│   │   ├── reservation/
│   │   │   ├── screens/
│   │   │   │   └── vehicle_detail_screen.dart
│   │   │   ├── widgets/
│   │   │   │   ├── availability_calendar.dart
│   │   │   │   ├── rental_date_form.dart
│   │   │   │   ├── rental_price_summary.dart
│   │   │   │   └── fuel_gauge.dart
│   │   │   └── dialogs/
│   │   │       ├── reservation_result_dialog.dart
│   │   │       └── fuel_prices_dialog.dart
│   │   │
│   │   └── account/
│   │       ├── screens/
│   │       │   └── account_screen.dart
│   │       ├── widgets/
│   │       │   └── reservation_card.dart
│   │       └── dialogs/
│   │           ├── logout_dialog.dart
│   │           └── rental_agreement_dialog.dart
│   │
│   └── app.dart
│
├── test/
│   ├── models/
│   └── logic/
│
├── pubspec.yaml
└── README.md
```

Bu yapı bir başlangıç önerisidir. Proje henüz oluşturulmamışsa veya mevcut yapı farklıysa, Antigravity gerçek dosyaları inceleyerek gerekli uyarlamaları yapmalıdır. Her dosyayı sırf bu listede bulunduğu için oluşturmak zorunlu değildir.

## 3. Uygulamanın Başlangıç Noktası

### `main.dart`

Uygulamanın giriş noktasıdır.

Sorumlulukları:

- Flutter uygulamasını başlatmak.
- Gerekli başlangıç verilerini yüklemek için `app.dart` yapısına geçmek.
- Uygulamanın temel yaşam döngüsünü başlatmak.

İş mantığı ve ekran tasarımları bu dosyada tutulmamalıdır.

### `app.dart`

Uygulamanın ana yapılandırmasını içerir.

Sorumlulukları:

- `MaterialApp` yapılandırması.
- Uygulama adı.
- Açık ve koyu tema tanımları.
- Başlangıç ekranı.
- Yerel ayarların ve Türkçe metinlerin yapılandırılması.
- Gerekli uygulama seviyesindeki durumun ekranlara aktarılması.

Material Design 3 etkin olmalıdır.

## 4. Dört Ana Ekranın Sorumlulukları

### 4.1. Ana Sayfa

Dosya: `features/home/screens/home_screen.dart`

Sorumlulukları:

- Ana sayfa düzenini göstermek.
- Araç kategorilerini göstermek.
- Öne çıkan araçları görüntülemek.
- Araç arama akışını başlatmak.
- Kategori seçimini araç listesine aktarmak.
- Basit şube haritası önizlemesini göstermek.

Araç verileri bu ekranın içinde sabit listeler hâlinde tekrar tanımlanmamalıdır. Ortak veri kaynağı kullanılmalıdır.

### 4.2. Araç Listesi

Dosya: `features/vehicles/screens/vehicle_list_screen.dart`

Sorumlulukları:

- Araç listesini görüntülemek.
- Seçilen kategori ve arama kriterlerini uygulamak.
- Filtreleme ve sıralamayı yönetmek.
- Bir, iki veya üç sütunlu görünümü seçmek.
- Seçilen aracı detay ekranına aktarmak.
- Boş sonuç durumunu göstermek.

Filtreleme ve sıralama orijinal araç listesini bozmadan uygulanmalıdır. Kullanıcı filtreleri temizlediğinde bütün araçlara geri dönebilmelidir.

### 4.3. Araç Detayı ve Rezervasyon

Dosya: `features/reservation/screens/vehicle_detail_screen.dart`

Sorumlulukları:

- Seçilen aracın bütün bilgilerini göstermek.
- Araç görsellerini görüntülemek.
- Kiralama süresi ve ücretini göstermek.
- Alış ve dönüş tarihlerini yönetmek.
- Müsaitlik takvimini göstermek.
- Form doğrulaması yapmak.
- Rezervasyon işlemini başlatmak.
- Başarılı veya başarısız işlem sonucunu göstermek.

Takvim, fiyat hesaplama ve form bileşenleri ayrı widget'lar olarak tutulabilir. Bütün iş mantığı tek bir büyük ekran dosyasında biriktirilmemelidir.

### 4.4. Hesabım ve Rezervasyonlarım

Dosya: `features/account/screens/account_screen.dart`

Sorumlulukları:

- Demo kullanıcı profilini göstermek.
- Bellekte tutulan rezervasyonları listelemek.
- Aktif ve geçmiş rezervasyonları ayırmak.
- Rezervasyon durumunu göstermek.
- Sözleşme ve çıkış diyaloğunu açmak.
- Tema seçeneğine erişim sağlamak.

## 5. Navigasyon Yapısı

İlk sürümde Flutter'ın yerleşik `Navigator` yapısı yeterlidir.

Ana navigasyon:

- Ana Sayfa
- Rezervasyonlarım
- Hesabım

Bu üç hedef alt navigasyonda yer alır. Rezervasyonlarım ve Hesabım aynı ana ekran içinde farklı sekmeler olarak uygulanabilir.

Araç listesi ve araç detayı, gerektiğinde `Navigator.push` ile açılan ikincil ekranlardır. Geri dönüş için `Navigator.pop` kullanılır.

Her işlem için yeni bir ekran oluşturulması gerekmez.

Aşağıdaki işlemler diyalog veya alt pencere ile yapılmalıdır:

- Filtreleme.
- Sıralama.
- Yakıt fiyatları.
- Rezervasyon sonucu.
- Çıkış onayı.
- Kiralama sözleşmesi.

## 6. Veri Modelleri

### 6.1. Vehicle

Dosya: `models/vehicle.dart`

Araç bilgilerini temsil eder.

Önerilen alanlar:

- `id`: benzersiz araç kimliği.
- `brand`: marka.
- `model`: model.
- `year`: model yılı.
- `category`: araç kategorisi.
- `transmission`: vites türü.
- `fuelType`: yakıt türü.
- `mileage`: kilometre.
- `hourlyPrice`: saatlik ücret.
- `dailyPrice`: günlük ücret.
- `description`: araç açıklaması.
- `image`: ana görsel yolu.
- `images`: diğer görsel yolları.
- `fuelLevel`: yakıt seviyesi.
- `estimatedRange`: tahmini kalan menzil.
- `unavailableRanges`: dolu tarih aralıkları.

JSON verisini modele dönüştürmek için `fromJson` kullanılmalıdır.

### 6.2. UnavailableRange

Bir aracın kiralanamayacağı tarih aralığını temsil eder.

Alanlar:

- `startDate`: başlangıç tarihi.
- `endDate`: bitiş tarihi.

Tarih aralığı kuralları açıkça tanımlanmalı ve takvim ile rezervasyon doğrulamasında aynı kurallar kullanılmalıdır.

### 6.3. Reservation

Bir rezervasyon kaydını temsil eder.

Alanlar:

- `id`: rezervasyon kimliği.
- `vehicleId`: araç kimliği.
- `vehicleName`: görüntüleme için araç adı.
- `startDateTime`: alış tarihi ve saati.
- `endDateTime`: dönüş tarihi ve saati.
- `pickupLocation`: alış noktası.
- `returnLocation`: dönüş noktası.
- `destinationCity`: isteğe bağlı gidilecek şehir.
- `totalPrice`: toplam ücret.
- `status`: rezervasyon durumu.

Rezervasyon modeli, verinin gösterilmesini ve yönetilmesini kolaylaştırmalıdır.

## 7. Veri Akışı

### Araç verileri

1. `vehicles.json` dosyası Flutter varlığı olarak tanımlanır.
2. `vehicle_data_source.dart` dosyası JSON verisini okur.
3. JSON verileri `Vehicle` nesnelerine dönüştürülür.
4. Ekranlar bu ortak veri listesini kullanır.
5. Filtreleme ve sıralama sonuçları kullanıcı arayüzüne yansıtılır.

Araç bilgileri farklı ekranlarda birbirinden bağımsız şekilde sabit kodlanmamalıdır.

### Rezervasyon verileri

1. Kullanıcı bir araç seçer.
2. Araç detay ekranında tarih ve saatleri belirler.
3. Form doğrulanır.
4. Araç müsaitliği kontrol edilir.
5. Ücret hesaplanır.
6. Geçerli işlem `reservation_store.dart` üzerinden bellekte saklanır.
7. Rezervasyon özeti gösterilir.
8. Hesabım ve Rezervasyonlarım ekranı güncel listeyi görüntüler.

Yeni bir rezervasyon, ilgili aracın sonraki müsaitlik kontrollerine dahil edilmelidir.

## 8. Durum Yönetimi

Proje kapsamında başlangıçta `setState` ve gerektiğinde `ValueNotifier` kullanılması yeterlidir.

- Ekrana özel filtreleme ve görünüm seçimleri yerel durumla yönetilebilir.
- Seçilen tarih ve saatler rezervasyon formunun durumunda tutulabilir.
- Rezervasyon listesi ortak bir yerel durum yöneticisi üzerinden paylaşılabilir.
- Tema tercihi uygulama seviyesinde yönetilmelidir.

Provider, Riverpod, Bloc veya başka bir durum yönetimi paketi yalnızca somut bir gereksinim ortaya çıkarsa değerlendirilmelidir. İlk sürüm için zorunlu değildir.

Aynı verinin birden fazla yerde gereksiz kopyası tutulmamalıdır.

## 9. Dinamik Takvim Mantığı

Takvim hem kullanıcıya tarih seçtiren bir arayüz hem de rezervasyon doğrulamasının görsel parçasıdır.

Temel işlem sırası:

1. Kullanıcı bir araç seçer.
2. İlgili aracın dolu tarih aralıkları okunur.
3. Takvimde dolu günler işaretlenir.
4. Kullanıcı alış ve dönüş tarihlerini seçer.
5. Seçilen aralıkta çakışma kontrolü yapılır.
6. Çakışma varsa işlem engellenir ve hata mesajı gösterilir.
7. Çakışma yoksa ücret hesaplanır ve rezervasyon oluşturulabilir.

Kontrol mantığı tek bir ortak yardımcı fonksiyon veya servis üzerinden yürütülmelidir. Takvim görünümü ve rezervasyon butonu birbirinden farklı müsaitlik kuralları uygulamamalıdır.

Alış zamanı ile dönüş zamanı aynı olan veya sınır tarihlerinde bitişik iki rezervasyonun nasıl değerlendirileceği açıkça belirlenmelidir. Önerilen kural, bir rezervasyonun dönüş anının yeni rezervasyonun alış anına eşit olmasına izin vermektir.

## 10. Hata Yönetimi

Kullanıcıya teknik hata ayrıntıları gösterilmemelidir.

Örnek mesajlar:

- "Araç verileri yüklenemedi."
- "Lütfen geçerli bir tarih aralığı seçin."
- "Seçtiğiniz tarih aralığında araç müsait değil."
- "Dönüş tarihi alış tarihinden önce olamaz."
- "Lütfen gerekli alanları doldurun."

JSON okuma hataları ve beklenmeyen durumlar geliştirici tarafından takip edilebilecek şekilde ele alınmalıdır.

## 11. Test Yaklaşımı

Öncelikli test alanları:

- JSON verisinin doğru modele dönüştürülmesi.
- Fiyat hesaplama.
- Tarih aralığı çakışma kontrolü.
- Dolu tarihlerde rezervasyonun engellenmesi.
- Yeni rezervasyonun sonraki müsaitlik kontrolünü etkilemesi.
- Filtreleme ve sıralama.
- Form doğrulaması.
- Açık ve koyu tema.
- Temel navigasyon akışı.

Basit iş kuralları için birim testleri yazılması tercih edilir.

## 12. Mimari Sınırlar

- Backend veya veritabanı eklenmeyecektir.
- Araç ve rezervasyon verileri için harici servis kullanılmayacaktır.
- Ekran dosyaları gereksiz yere büyütülmeyecektir.
- Ortak bileşenler tekrar kullanılacaktır.
- Kullanılmayan paketler eklenmeyecektir.
- Mevcut projede çalışan kodlar incelenmeden silinmeyecektir.
- Tasarım, proje kapsamı ve mevcut kod birlikte değerlendirilerek uygulanacaktır.

