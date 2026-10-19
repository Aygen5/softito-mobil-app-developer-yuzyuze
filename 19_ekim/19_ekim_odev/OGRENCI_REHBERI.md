# 📖 Günlüğüm (Sessiz Defter) — Flutter Öğrenci Rehberi
> **Seviye:** Başlangıçtan Orta Seviyeye Geçiş  
> **Odak:** Temiz Mimari (Clean Architecture temelleri), Widget Yaşam Döngüsü, Veri Akışı ve İleri Seviye Flutter Konuları

---

## 🧭 İçindekiler
1. [Büyük Resim: Uygulamanın Amacı ve Felsefesi](#1-büyük-resim-uygulamanın-amacı-ve-felsefesi)
2. [Mimari Kararlar: Neden Bu Klasör Yapısını Seçtik?](#2-mimari-kararlar-neden-bu-klasör-yapısını-seçtik)
3. [Dosya Dosya İnceleme & Kod Blokları](#3-dosya-dosya-inceleme--kod-blokları)
   - [3.1 main.dart (Giriş Kapısı)](#31-maindart-giriş-kapısı)
   - [3.2 theme/app_colors.dart (Tasarım Sistemi)](#32-themeapp_colorsdart-tasarım-sistemi)
   - [3.3 models/diary_entry.dart (Veri Modeli)](#33-modelsdiary_entrydart-veri-modeli)
   - [3.4 screens/calendar_screen.dart (Ana Ekran & Takvim Mantığı)](#34-screenscalendar_screendart-ana-ekran--takvim-mantığı)
   - [3.5 screens/diary_screen.dart (Yazı Düzenleyici)](#35-screensdiary_screendart-yazı-düzenleyici)
   - [3.6 widgets/calendar_grid.dart (Özelleştirilmiş Takvim Izgarası)](#36-widgetscalendar_griddart-özelleştirilmiş-takvim-ızgarası)
   - [3.7 widgets/diary_editor.dart (Yazma Alanı & Mood Seçici)](#37-widgetsdiary_editordart-yazma-alanı--mood-seçici)
   - [3.8 test/widget_test.dart (Kalite ve Otomasyon)](#38-testwidget_testdart-kalite-ve-otomasyon)
4. [Uçtan Uca Kullanıcı ve Veri Akışı (Adım Adım Senaryo)](#4-uçtan-uca-kullanıcı-ve-veri-akışı-adım-adım-senaryo)
5. [Flutter'da Nelere Dikkat Ettik? (Teknik İncelikler)](#5-flutterda-nelere-dikkat-ettik-teknik-incelikler)
6. [İleri Seviye Flutter Yol Haritası (Gelecekte Ne Kullanabiliriz?)](#6-ileri-seviye-flutter-yol-haritası-gelecekte-ne-kullanabiliriz)

---

## 1. Büyük Resim: Uygulamanın Amacı ve Felsefesi

**Günlüğüm**, kullanıcıların takvim üzerinden gün seçerek o güne ait duygu, düşünce ve anılarını kaydedebildikleri kişisel bir mobil uygulamadır.

Mobil geliştirmede en sık yapılan hata:  
*Bütün kodu tek bir `main.dart` dosyasına doldurmak ve ekran, model, tasarım, iş mantığını birbirine karıştırmaktır (Spagetti Kod).*

Bizim benimsediğimiz felsefe:
* **Tek Sorumluluk İlkesi (Single Responsibility Principle):** Her dosya ve her widget yalnızca tek bir işi mükemmel şekilde yapmalıdır.
* **Okunabilirlik ve Genişletilebilirlik:** Bir öğrenci veya ekip arkadaşınız projeyi açtığında neyin nerede olduğunu saniyeler içinde bulabilmelidir.
* **Tasarım Bütünlüğü:** Renkler, yazı boyutları ve boşluklar rastgele değil, önceden belirlenen bir tasarım sistemi standardında (`AppColors`) yönetilmelidir.

---

## 2. Mimari Kararlar: Neden Bu Klasör Yapısını Seçtik?

Projeyi `lib/` altında şu 4 ana kata ayırdık:

```text
lib/
├── main.dart             -> Uygulama motorunu ateşleyen başlangıç noktası
├── theme/                -> Renk ve stil sabitleri
├── models/               -> Verinin nesne yönelimli (OOP) tanımı
├── screens/              -> Kullanıcının gördüğü bağımsız tam sayfalar (Ekranlar)
└── widgets/              -> Ekranları oluşturan tekrar kullanılabilir alt parçalar
```

### 🧱 Neden "Screens" ve "Widgets" Ayrımı Yaptık?
* **Screens (Ekranlar):** Sayfa seviyesindedir. Kendi içinde `Scaffold` barındırır, AppBar taşır, kullanıcıyı bir ekrandan diğerine yönlendirir (`Navigator`).
* **Widgets (Bileşenler):** Tam bir sayfa değildir. Ekranın içine oturan yapboz parçalarıdır (Örn: takvim ızgarası, mood seçici kartı). Bu sayede `CalendarScreen` 800 satırlık dev bir dosya olmak yerine ~200 satırlık tertemiz bir orkestra şefine dönüşür.

### 🔄 Dosyalar Arası İlişki Şeması

```text
       [ main.dart ]
             │ (Başlatır & Temayı Tanımlar)
             ▼
  [ screens/calendar_screen.dart ] ◄── Uses ──► [ theme/app_colors.dart ]
     │                      │
     │ (Kullanır)           │ (Açar: Navigator.push)
     ▼                      ▼
[ widgets/calendar_grid ]  [ screens/diary_screen.dart ]
                                │
                                │ (Kullanır)
                                ▼
                       [ widgets/diary_editor.dart ]
                                │
                                └── Modellerle çalışır ──► [ models/diary_entry.dart ]
```

---

## 3. Dosya Dosya İnceleme & Kod Blokları

### 3.1 `main.dart` (Giriş Kapısı)
`main.dart`, Flutter motoruna uygulamanın nasıl başlayacağını söyler.

```dart
void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const GunlugumApp());
}
```

* **`WidgetsFlutterBinding.ensureInitialized()`:** Flutter framework'ünün alt sistemlerinin (ekran çizimi, dokunma algılayıcıları) ayağa kalktığından emin olur.
* **`GunlugumApp`:** Bir `StatelessWidget`'tır çünkü uygulamanın kök ayarları (teması, rotası) çalışma esnasında dinamik olarak değişmez.
* **`theme: ThemeData(...)`:** Global renk paletini tek merkezden Material 3 standartlarında tanımlar.

---

### 3.2 `theme/app_colors.dart` (Tasarım Sistemi)
Tasarımda renk kodlarını doğrudan widget'ların içine hard-coded (`Color(0xFF...)`) yazmak büyük bir anti-patterndir. Yarın temanın yeşilini değiştirmek istediğinizde 50 farklı dosyayı aramak zorunda kalırsınız.

```dart
class AppColors {
  AppColors._(); // Private constructor: Bu sınıftan nesne üretilmesini engeller

  static const Color background = Color(0xFFFEF8F6);
  static const Color primary = Color(0xFF485949); // Muted Sage
  static const Color secondaryContainer = Color(0xFFD1E5CF);
  static const Color onSurface = Color(0xFF1D1B1A);
  static const Color outlineVariant = Color(0xFFE6E0D6);
}
```
* `static const` kullanmamızın sebebi: Renklerin derleme aşamasında (compile-time constant) hafızaya alınmasını ve sıfır bellek maliyetiyle her yerden `AppColors.primary` şeklinde çağrılabilmesini sağlamaktır.

---

### 3.3 `models/diary_entry.dart` (Veri Modeli)
Veriyi ham `Map` (`{'content': '...', 'date': '...'}`) olarak taşımak yerine nesneye yönelik (OOP) bir sınıfta topladık.

```dart
class DiaryEntry {
  final DateTime date;
  final String content;
  final String mood;
  final DateTime updatedAt;

  const DiaryEntry({
    required this.date,
    required this.content,
    this.mood = 'Huzurlu',
    required this.updatedAt,
  });

  DiaryEntry copyWith({
    DateTime? date,
    String? content,
    String? mood,
    DateTime? updatedAt,
  }) {
    return DiaryEntry(
      date: date ?? this.date,
      content: content ?? this.content,
      mood: mood ?? this.mood,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
```
* **İmmutability (Değişmezlik):** Bütün alanlar `final` tanımlanmıştır. Bir nesnenin durumu dışarıdan habersizce değiştirilemez.
* **`copyWith` Metodu:** Flutter'da bir nesneyi güncellerken mevcut nesneyi bozmayıp, sadece değişen alanlarıyla yeni bir kopyasını üretmek (Clean State) için endüstri standardı bir yöntemdir.

---

### 3.4 `screens/calendar_screen.dart` (Ana Ekran & Takvim Mantığı)
Burası kullanıcının karşılandığı merkezdir. `StatefulWidget` olmasının sebebi; seçili ayın, seçili günün ve kaydedilen günlük listesinin zamanla değişmesidir.

**Tarihleri Anahtar Olarak Saklama Yöntemi:**
```dart
final Map<String, DiaryEntry> _entries = {};

String _dateKey(DateTime d) =>
    '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';
```
* **Neden `List` yerine `Map`?**
  Bir tarihe ait günlük olup olmadığını listede `for` döngüsüyle aramak $O(n)$ zaman alır. Oysa `Map` (Hash Map) kullanarak `_entries['2026-10-19']` şeklinde aramak $O(1)$ yani anında gerçekleşir.

**Sayfalar Arası İletişim (Beklemeli Geçiş):**
```dart
final result = await Navigator.push<DiaryEntry>(
  context,
  MaterialPageRoute(
    builder: (context) => DiaryScreen(
      date: date,
      initialEntry: existingEntry,
    ),
  ),
);

if (result != null) {
  setState(() {
    _entries[key] = result;
  });
}
```
* `await Navigator.push<DiaryEntry>`: Günlük ekranına gider ve kullanıcının sayfayı kapatıp bir günlük kaydederek dönmesini asenkron olarak bekler. Dönen nesne varsa `setState` ile takvim anında güncellenir ve o günün altına nokta işareti eklenir.

---

### 3.5 `screens/diary_screen.dart` (Yazı Düzenleyici)
Seçilen tarihin günlüğünün yazıldığı veya düzenlendiği ekrandır.

**Controller Yaşam Döngüsü:**
```dart
@override
void initState() {
  super.initState();
  _textController = TextEditingController(text: widget.initialEntry?.content ?? '');
  _selectedMood = widget.initialEntry?.mood ?? 'Huzurlu';
}

@override
void dispose() {
  _textController.dispose(); // Bellek sızıntısını önler
  super.dispose();
}
```
* Eğer bir Controller `dispose()` edilmezse, ekran kapansa bile işletim sistemi belleğinde kalır (Memory Leak). Uygulama zamanla yavaşlar ve çöker.

**Veriyi Geri Gönderme:**
```dart
Navigator.pop(context, entry);
```
* `Navigator.pop`, sadece ekranı kapatmaz; ikinci parametresiyle önceki ekrana veri iletir.

---

### 3.6 `widgets/calendar_grid.dart` (Özelleştirilmiş Takvim Izgarası)
Takvim için hazır ağır kütüphaneler eklemek yerine Flutter'ın matematiksel gücünü kullandık.

**Dinamik Gün Hesabı:**
```dart
final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
final daysInMonth = DateTime(currentMonth.year, currentMonth.month + 1, 0).day;
final leadingEmptyCount = firstDayOfMonth.weekday - 1;
```
* `DateTime(year, month + 1, 0).day` hilesi: Bir sonraki ayın 0. günü, otomatik olarak bu ayın son gününü (28, 29, 30 veya 31) verir! Artık yılları bile kendisi çözer.
* `GridView.builder`: Ekranda görünmeyen hücreleri bellekte tutmaz, performansı maksimize eder.

---

### 3.7 `widgets/diary_editor.dart` (Yazma Alanı & Mood Seçici)

**Kelime Sayacı ve Performans İncelemesi:**
```dart
ValueListenableBuilder<TextEditingValue>(
  valueListenable: controller,
  builder: (context, value, _) {
    final wordCount = value.text.trim().isEmpty
        ? 0
        : value.text.trim().split(RegExp(r'\s+')).length;
    return Text('$wordCount kelime');
  },
)
```
* **Neden `setState` kullanmadık?**
  Kullanıcı klavyede her harfe bastığında `setState` çağırsaydık, bütün ekran baştan çizilirdi (Rebuild). `ValueListenableBuilder` kullanarak sadece kelime sayısını gösteren küçük `Text` widget'ının güncellenmesini sağladık!

---

### 3.8 `test/widget_test.dart` (Kalite ve Otomasyon)
Profesyonel yazılım geliştirmede test olmazsa olmazdır.

```dart
testWidgets('Gunluk ekranina gecis ve geri donus dogrulanir', (WidgetTester tester) async {
  await tester.pumpWidget(const GunlugumApp());
  await tester.pumpAndSettle();

  final writeButton = find.text('Bugün İçin Günlük Yaz');
  await tester.ensureVisible(writeButton);
  await tester.tap(writeButton);
  await tester.pumpAndSettle();

  expect(find.text('Yazı Düzenleyici'), findsOneWidget);
});
```
* **`tester.ensureVisible`:** Buton ekranın alt kısmındaysa test ortamında kaydırma yaparak butonu görünür alana çeker ve gerçek bir insan gibi tıklar.

---

## 4. Uçtan Uca Kullanıcı ve Veri Akışı (Adım Adım Senaryo)

1. **Açılış:** Kullanıcı uygulamayı açtığında `main.dart` çalışır, `CalendarScreen` ekrana gelir.
2. **Ay Seçimi:** Kullanıcı sağ/sol oklara basar. `_previousMonth` / `_nextMonth` tetiklenir, `_currentMonth` güncellenir ve takvim yeni ayın günleriyle tekrar çizilir.
3. **Gün Seçimi:** Kullanıcı takvimden ayın 19'una dokunur. `onDateSelected` fonksiyonu `_openDiaryScreen(19 Ekim)` metodunu çağırır.
4. **Ekran Geçişi:** `Navigator.push` ile `DiaryScreen` açılır. Eğer o gün için daha önce yazılmış bir günlük varsa `initialEntry` parametresiyle gönderilir ve metin kutusuna doldurulur.
5. **Giriş ve Mood:** Kullanıcı hissini "Neşeli" seçer, his butonunun rengi `secondaryContainer` olur. Metnini yazar, kelime sayacı anlık artar.
6. **Kaydetme:** "Kaydet ve Mühürle" butonuna basılır:
   * Butonda dönen bir `CircularProgressIndicator` belirir (`_isSaving = true`).
   * Yeni bir `DiaryEntry` nesnesi oluşturulur.
   * `Navigator.pop(context, entry)` çağrılarak takvim sayfasına geri dönülür.
7. **Senkronizasyon:** `CalendarScreen`'deki `await` satırı uyanır, dönen `entry`'yi `_entries` haritasına kaydeder. `setState()` ile takvim yenilenir ve 19 Ekim hücresinin altına sage rengi bir nokta eklenir.

---

## 5. Flutter'da Nelere Dikkat Ettik? (Teknik İncelikler)

1. **`withValues(alpha: ...)` Kullanımı:**  
   Flutter 3.47+ ile birlikte eski `Color.withOpacity(0.5)` fonksiyonu hassasiyet kaybı nedeniyle deprecated olmuştur. Modern standart olan `color.withValues(alpha: 0.5)` tercih edilmiştir.
2. **`const` Anahtar Kelimesi:**  
   Değişmeyen widget'ların başına `const` konularak Flutter'ın widget ağacını gereksiz yere tekrar derlemesi engellenmiştir.
3. **Ekran Taşmalarına Karşı Savunma:**  
   `SingleChildScrollView` ve `SafeArea` kullanılarak farklı ekran boyutlarında veya klavye açıldığında oluşabilecek sarı-siyah taşma çizgileri (RenderFlex Overflow) önlenmiştir.
4. **Saat/Dakika Sıfırlama:**  
   Tarih karşılaştırmalarında `DateTime.now()` kullanırken saat, dakika ve saniyeden kaynaklanabilecek eşleşme hatalarını önlemek için tarihler `DateTime(year, month, day)` olarak normalize edilmiştir.

---

## 6. İleri Seviye Flutter Yol Haritası (Gelecekte Ne Kullanabiliriz?)

Flutter bilginiz ilerledikçe bu projede kullandığımız yapıların yerine sektörde kullanılan şu ileri seviye çözümlere geçebilirsiniz:

| Şu Anki Basit Yapımız | İleride Kullanabileceğiniz İleri Seviye Alternatif | Neden ve Ne Zaman Kullanılır? |
| :--- | :--- | :--- |
| **`setState()`** | **`Provider`, `Riverpod` veya `Bloc`** | Ekran sayısı ve veri akışı arttığında, veriyi widget ağacında elden ele geçirmek zorlaşır. State management paketleri ile iş mantığını (Business Logic) arayüzden tamamen koparabilirsiniz. |
| **Bellekte Tutma (In-Memory Map)** | **`shared_preferences`, `Hive`, `Isar` veya `sqflite`** | Şu an uygulama kapatılınca günlükler sıfırlanır. Cihaz hafızasında kalıcı olarak saklamak için yerel NoSQL/SQL veritabanları kullanılır. |
| **`Navigator.push` (Navigator 1.0)** | **`GoRouter` (Navigator 2.0)** | Web desteği, derin bağlantılar (Deep Linking) ve URL senkronizasyonu gerektiğinde deklaratif yönlendirme kütüphaneleri kullanılır. |
| **Doğrudan Ekran İçi İş Mantığı** | **`Clean Architecture & Repository Pattern`** | Veritabanı veya uzak API (Backend) entegrasyonu geldiğinde; `Data Layer`, `Domain Layer` ve `Presentation Layer` birbirinden bağımsız katmanlara ayrılır. |

---

> 💡 **Tavsiye:** Kodları incelerken önce `models/diary_entry.dart` dosyasından başlayın, ardından `main.dart` -> `screens/calendar_screen.dart` yolunu takip edin. Bir widget'ın içine girdiğinizde `widgets/` klasöründeki karşılığına geçerek taşların nasıl yerine oturduğunu görün.
