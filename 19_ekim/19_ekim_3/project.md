# Fitness Su ve İçecek Takip Uygulaması
Bu döküman Flutter projesinde geliştirme yapacak olan Ajan (antigravity) yapay zeka ve yazılım geliştiriciler için bağlayıcı bir kılavuzdur. Projede üretilen her kod satırı buradaki kurallara UYMAK ZORUNDADIR.

## 1. Proje Özeti ve Teknolojiler

- **Uygulama adı:** Susadım (akıllı su, çoklu içecek [çay, kahve, maden suyu], egzersiz ve kalori takibi uygulaması)
- **Hedef Platformlar:** iOS ve Android öncelikli ardından web ve masaüstü platformları.
- **Flutter SDK:** 3.29.0
- **Dart SDK:** 3.0.0
- **Tasarım dili:** Material 3, Dinamik Tema (Koyu Mod: Dark Obsidian & Neon gece spor salonu paleti; Açık Mod: Temiz Beyaz/Slate & Kontrastlı Canlı Neon paleti). Kullanıcı tek dokunuşla tema değiştirebilmelidir.

----

## 2. Mimari Yapı : Özellik Bazlı MVC (Feature-Based MVC)
Kodlar kesinlikle tek bir yerde toplanmayacaktır. Projede **Feature-First / Özellik Bazlı MVC (Model-View-Controller)** mimari deseni uygulanır. Her bir işlev modülü kendi feature klasöründe bağımsız bir MVC yapısına sahip olacaktır.

```text
lib/
core/
    constants/app_colors.dart
    theme/app_theme.dart
    theme/theme_controller.dart
    extensions/context_extensions.dart

features/
    beverage_tracker/ (Genişletilmiş Su, Çay, Kahve, Maden Suyu Takibi)
        controller/     -> Controller: İş mantığı, reaktif durum (ChangeNotifier / ValueNotifier)
        models/         -> Model: Immutable veri yapıları (copyWith, fromJson, toJson)
        view/           -> View: Ana sayfa iskeleti, pasif arayüz (StatelessWidget)
        widget/         -> Sub-Views: Modüler, tekrar kullanılabilir bileşenler (Max 40 satır)
    workout/ (Egzersiz ve Kalori Takibi)
        controller/
        models/
        view/
        widget/
    dashboard/
        dashboard_shell.dart

main.dart
```

### MVC Katman Sorumlulukları ve Kuralları

1. **Model (M - `models/`):**
   - Özelliğe ait iş varlıklarını (Domain Entity) ve veri transfer nesnelerini (DTO) temsil eder.
   - **Zorunlu Kurallar:**
     - Sınıflar kesinlikle `immutable` olmalı ve tüm alanlar `final` tanımlanmalıdır.
     - `const` yapıcı metot (constructor) içermelidir.
     - `copyWith`, `fromJson` ve `toJson` metotları eksiksiz uygulanmalıdır.
     - Saf hesaplama mantıkları model üzerinde getter olarak bulunabilir (örn: `effectiveHydrationMl`).

2. **View ve Sub-Widgets (V - `view/` ve `widget/`):**
   - Kullanıcıya sunulan görsel katmandır. Kesinlikle doğrudan iş mantığı barındırmaz (Passive View).
   - **`view/` (Ana Ekran):** `StatelessWidget` olarak tanımlanır. Controller'ı constructor üzerinden enjeksiyonla alır. `ListenableBuilder` veya `ValueListenableBuilder` ile controller'ı dinler. Sayfa düzeyinde ağır `setState` KULLANILAMAZ.
   - **`widget/` (Modüler Alt Bileşenler):** Büyük build metodlarını önlemek için 40 satırı geçmeyen, `const` constructor destekli, tekrar kullanılabilir kart, buton ve liste bileşenleridir.

3. **Controller (C - `controller/`):**
   - Model ile View arasındaki köprüdür; iş mantığını, hesaplamaları ve uygulama durumunu (state) yönetir.
   - **Zorunlu Kurallar:**
     - Harici ağır paketler yerine `ChangeNotifier` veya `ValueNotifier` çekirdek API'lerini kullanır.
     - UI'dan gelen kullanıcı aksiyonlarını (ekleme, silme, güncelleme) metotlarla karşılar, model listelerini günceller ve dinleyicileri uyarır (`notifyListeners()`).
     - Bellek sızıntılarını önlemek için `dispose()` metodunda tüm notifier kaynakları temizlenmelidir.

### MVC Veri ve Etkileşim Akışı

```text
[Kullanıcı Aksiyonu] ──▶ [View / Widget] ──(Metot Çağrısı)──▶ [Controller]
                               ▲                                    │
                               │                               (Veri Değişimi)
                        (notifyListeners)                           ▼
                               │                                 [Model]
                               └──────────(İzole Yeniden Çizim)─────┘
```

### Sadece uygulama başlatma ve tema bölümleri:
`main.dart` yalnızca uygulamanın başlatılması, controller'ların sağlanması ve tema konfigürasyonunu içerecektir.

----

## 3. Kırmızı Çizgiler ve Kod Kalite Standartları
1- **State Yönetim Standartları:**
Sayfa düzeyinde ağır `setState` KULLANILMAYACAKTIR.
Sadece yerel arayüz durumunu yöneten (örneğin buton animasyonları, modal seçimleri vb.) StatefulWidget kabul edilir.

2- **UI ve Performans Kuralları:**
Static tüm widget'larda `const` zorunludur.
Renk ve metin stilleri kesinlikle tema dosyalarına yazılacaktır.
Büyük build metodları yasaktır. 40 satırı geçen build metodları özel widgetlara yazılacaktır.

3- **Yasaklı Paketler:**
Projeye onay almadan harici ağır state paketleri EKLENMEYECEKTİR.
Dart'ın ve Flutter'ın yerel çekirdek API'lerini (`ChangeNotifier`, `ValueNotifier`, `ListenableBuilder`) kullanmak esastır.

----

## 4. Geliştirme Analiz ve Test Komutları
Ajan yaptığı herhangi bir kod değişikliğinden sonra mutlaka alttaki komutların çalıştığını doğrulamalıdır.

* **Statik kod analizi (0 uyarı ve 0 hata şart):**
```bash
flutter analyze
```

* **Birim ve Widget Testleri:**
```bash
flutter test
```

* **Projeyi Çalıştırma:**
```bash
flutter run
```

----

## 5. Ajanın Çıktı ve Yanıt Verme Standartları

* **Açıklamalar:** Türkçe teknik ve terimlerin özünü bozmadan net ve doğrudan olacaktır.
* **Değişiklik Sunumları:** Örnek 500 satırlık bir dosyada 3 satır değiştiyse tüm dosyayı baştan sona basma, hedef satırları ve diff yapısını göster.
* **Dosya yolları:** Bahsedilen ve üretilen her dosya için mutlaka projeye göre tıklanabilir link ver.
* **Doğrulama:** Kod yazdıktan sonra kullanıcıya "Şimdi flutter analyze ile kontrol edebilirsin." şeklinde doğrulama yönergeleri ver.

----

## 6. Çoklu İçecek ve Hidrasyon Takibi Kuralları (Su, Çay, Kahve, Maden Suyu)

1- **Desteklenen İçecek Türleri ve Hidrasyon Faktörleri:**
- **Su:** %100 Hidrasyon katsayısı, Neon Cyan vurgusu.
- **Maden Suyu:** %100 Hidrasyon katsayısı, mineralli su desteği, Neon Teal/Buz mavisi vurgusu.
- **Çay:** %90 Hidrasyon katsayısı (hafif kafein/diüretik payı), Açık Yeşil/Kehribar neon vurgusu.
- **Kahve:** %80 Hidrasyon katsayısı (kafein su atımı payı), Sıcak Karamel/Bronz vurgusu.

2- **Geriye Dönük Uyumluluk (Backward Compatibility):**
- Eski su takibi modelleri ve API'leri (`WaterLogModel`, `WaterTrackerController`) bozulmayacak, `BeverageTrackerController` altında tam uyumlu olarak çalışmaya devam edecektir.
- Daha önce kaydedilmiş su tüketim geçmişi silinmeyecek ve hesaplamalara eksiksiz dahil edilecektir.

3- **UI ve Çoklu İçecek Deneyimi:**
- Kullanıcı kolayca içecek tipini (Su, Çay, Kahve, Maden Suyu) seçebilmeli ve seçili içeceğe uygun porsiyon seçenekleriyle (örn: Çay bardağı 100ml, Kupa 200ml, Fincan Kahve 150ml, Şişe Maden Suyu 200ml, Matara Su 500ml) hızlı ekleme yapabilmelidir.
- Günlük sıvı dağılımı (hangi içecekten kaç ml tüketildiği ve efektif hidrasyon miktarı) gösterilmelidir.
