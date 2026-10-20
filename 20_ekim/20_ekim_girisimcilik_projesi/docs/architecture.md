# Yörünge — Software Architecture

## 1. Mimari Amaç

Yörünge, Flutter ve Dart kullanılarak geliştirilen, feature-first ve katmanlı bir mimariye sahip mobil demo uygulamasıdır.

Mimari şu hedefleri karşılamalıdır:

- Her özelliğin sorumluluğunu açıkça ayırmak.
- UI ile iş mantığını birbirinden bağımsız tutmak.
- Mock veriyi ekran kodundan ayırmak.
- Controller'ları widget'lardan bağımsız test edebilmek.
- Tasarım sistemini merkezi olarak yönetmek.
- Yeni özellikleri mevcut modüllere zarar vermeden eklemek.
- Demo sürümünden gerçek backend kullanan bir sürüme geçişi kolaylaştırmak.

Mimari, gereksiz katmanlar oluşturmadan bu ayrımı sağlamalıdır. Her sınıf veya dosya yalnızca gerçekten ihtiyaç duyulan bir sorumluluğu üstlenmelidir.

## 2. Mimari Kararlar

| Karar | Seçim |
|---|---|
| Framework | Flutter |
| Dil | Dart |
| UI | Material 3 |
| Genel yapı | Feature-first |
| İş mantığı | Controller |
| State management | `ValueNotifier<T>` |
| UI dinleme | `ValueListenableBuilder<T>` |
| Yerel tercihler | `shared_preferences` |
| Demo verileri | Yerel mock veri dosyaları |
| Ana navigasyon | `IndexedStack` |
| Tema yönetimi | `ThemeController` |
| Test yaklaşımı | Dart/Flutter birim testleri |
| Backend | Bu sürümde yok |
| Harici state paketi | Yasak |

Provider, Riverpod, Bloc/Cubit, GetX ve MobX kullanılmaz.

## 3. Bağımlılık Yönü

Temel veri akışı şu şekilde olmalıdır:

```text
                    VIEW
                     |
                     v
                   WIDGET
                     |
                     v
                 CONTROLLER
                     |
                     v
              MODEL / DATA SOURCE
```

Bu diyagram mantıksal bir sorumluluk ayrımıdır. Küçük bir özellikte view doğrudan kendi alt widget'larını oluşturabilir; bütün bileşenler için gereksiz ara katman eklenmesi gerekmez.

Kurallar:

- View, controller üzerinden kullanıcı işlemlerini başlatır.
- Widget, controller state'ini gösterir ve kullanıcı etkileşimlerini iletir.
- Controller, iş kurallarını uygular ve state'i günceller.
- Model, verinin yapısını temsil eder.
- Data katmanı, örnek içerikleri sağlar.
- Controller, `BuildContext` veya UI widget'larına bağımlı olmaz.
- Model katmanı Flutter UI paketlerini gereksiz yere import etmez.
- Core, feature'lara özgü iş mantığını barındırmaz.

Tema sistemi gibi gerçekten uygulama geneline ait altyapılar `core/` altında yer alabilir.

## 4. Kök Klasör Yapısı

```text
yorunge/
├── android/
├── ios/
├── web/
├── test/
├── assets/
│   ├── images/
│   ├── icons/
│   └── fonts/
├── lib/
│   ├── main.dart
│   ├── core/
│   │   ├── constants/
│   │   │   ├── app_colors.dart
│   │   │   ├── app_spacing.dart
│   │   │   └── app_strings.dart
│   │   ├── extensions/
│   │   │   └── context_extensions.dart
│   │   ├── theme/
│   │   │   ├── app_theme.dart
│   │   │   └── theme_controller.dart
│   │   └── widgets/
│   │       ├── glow_card.dart
│   │       ├── starfield_background.dart
│   │       └── section_header.dart
│   └── features/
│       ├── splash/
│       ├── auth/
│       ├── shell/
│       ├── mentor/
│       ├── yatirimci/
│       ├── programlar/
│       ├── topluluk/
│       ├── analiz/
│       └── fikir_durumu/
├── .agents/
│   ├── SKILL.md
│   ├── script/
│   ├── references/
│   ├── examples/
│   └── skills/
├── project.md
├── skills.md
├── design-system.md
├── architecture.md
├── DONE.md
├── pubspec.yaml
└── analysis_options.yaml
```

Bu yapı hedeflenen organizasyondur. Antigravity öncelikle mevcut dosya sistemini incelemeli, var olan kaynakları korumalı ve yalnızca gerekli eksikleri tamamlamalıdır.

`assets/` altında belirtilen alt klasörler yalnızca ilgili varlıklar mevcutsa veya gerektiğinde oluşturulmalıdır.

## 5. Feature-First Modül Standardı

Her feature aşağıdaki temel yapıyı izler:

```text
features/<feature_name>/
├── models/
├── data/
├── controller/
├── widget/
└── view/
```

### 5.1 `models/`

Sorumluluklar:

- Verinin türünü tanımlamak.
- Immutable veri yapıları oluşturmak.
- Gerektiğinde `copyWith`, `fromJson` ve `toJson` sağlamak.
- Veriyi widget veya controller'a özgü ayrıntılardan bağımsız tutmak.

Örnek:

```text
features/mentor/models/mentor.dart
features/yatirimci/models/investor.dart
features/programlar/models/support_program.dart
features/topluluk/models/community_post.dart
features/analiz/models/business_plan.dart
features/fikir_durumu/models/idea_status.dart
```

Model alanları `final` olmalıdır. `const` constructor, alanların türleri ve constructor gereksinimleri elverdiğinde kullanılmalıdır.

JSON serileştirme yalnızca veri gerçekten serileştirilecekse veya mevcut mimari standardı gerektiriyorsa eklenmelidir.

### 5.2 `data/`

Sorumluluklar:

- Feature'a ait mock veriyi sağlamak.
- Verileri ekranlardan ayrı tutmak.
- Tekrarlanabilir ve deterministik demo içeriği sunmak.
- Gerekiyorsa yerel veri erişim işlemlerini düzenlemek.

Örnek:

```text
features/mentor/data/mock_mentor_data.dart
features/yatirimci/data/mock_investor_data.dart
features/programlar/data/mock_program_data.dart
features/topluluk/data/mock_community_data.dart
features/fikir_durumu/data/mock_idea_data.dart
```

Veri dosyaları rastgele içerik üretmemelidir. Testlerde sonuçların öngörülebilir olması gerekir.

### 5.3 `controller/`

Sorumluluklar:

- State'i yönetmek.
- İş kurallarını uygulamak.
- Arama ve filtreleme işlemlerini yürütmek.
- Kullanıcı eylemlerini doğrulamak.
- Gerekli durum değişikliklerini `ValueNotifier` ile bildirmek.
- Yerel veri katmanıyla çalışmak.
- Kaynakları doğru zamanda dispose etmek.

Örnek:

```text
features/mentor/controller/mentor_controller.dart
features/yatirimci/controller/investor_controller.dart
features/programlar/controller/program_controller.dart
features/topluluk/controller/community_controller.dart
features/analiz/controller/analysis_controller.dart
features/fikir_durumu/controller/idea_status_controller.dart
```

Controller içinde `BuildContext`, `ScaffoldMessenger`, `Navigator` veya doğrudan widget üretimi bulunmamalıdır.

### 5.4 `widget/`

Sorumluluklar:

- Feature'a özel tekrar kullanılabilir UI parçalarını sunmak.
- Tasarım sistemine uymak.
- Controller state'ini gerektiği yerde dinlemek.
- Büyük ekranların okunabilirliğini artırmak.

Örnek:

```text
features/mentor/widget/mentor_card.dart
features/yatirimci/widget/investor_card.dart
features/programlar/widget/program_card.dart
features/topluluk/widget/post_card.dart
features/analiz/widget/step_progress_header.dart
features/fikir_durumu/widget/company_timeline.dart
```

Bir widget yalnızca ilgili feature'da kullanılıyorsa otomatik olarak `core/` altına taşınmamalıdır.

### 5.5 `view/`

Sorumluluklar:

- Sayfa iskeletini oluşturmak.
- `Scaffold`, `AppBar`, `CustomScrollView` veya uygun liste düzenlerini kullanmak.
- Alt widget'ları bir araya getirmek.
- Controller ile UI arasındaki etkileşimi koordine etmek.
- Navigasyon ve kullanıcı bildirimlerini yönetmek.

Örnek:

```text
features/mentor/view/mentor_screen.dart
features/yatirimci/view/investor_screen.dart
features/programlar/view/program_screen.dart
features/topluluk/view/community_screen.dart
features/analiz/view/analysis_screen.dart
features/fikir_durumu/view/idea_status_screen.dart
```

View dosyaları iş kurallarının merkezi hâline getirilmemelidir.

## 6. Shell ve Navigasyon

Ana iskelet `features/shell/` altında bulunur.

Önerilen yapı:

```text
features/shell/
├── controller/
├── widget/
│   └── app_bottom_navigation.dart
└── view/
    └── app_shell.dart
```

İhtiyaç varsa shell için ek model veya dosyalar oluşturulabilir; ancak gereksiz klasörler oluşturulmamalıdır.

### Navigasyon gereksinimleri

Ana shell dört sekmeyi yönetir:

- Mentorlar.
- Yatırımcılar.
- Programlar.
- Topluluk.

Sekmeler `IndexedStack` içinde tutulur. Aktif indeks ayrı bir state üzerinden yönetilir.

Beklenen davranış:

1. Kullanıcı sekme değiştirir.
2. Aktif indeks güncellenir.
3. İlgili sekme görünür olur.
4. Önceki sekmelerin widget state'i korunur.
5. Tema değişikliği tüm sekmelere yansır.

### 6.5 Kimlik Doğrulama, Çok Rollü Sistem ve Yetkilendirme (Auth & Authorization)

Mimarideki yeri: `lib/features/auth/`

Bu katman, uygulamanın açılışından itibaren kullanıcının oturum durumunu, beş farklı kullanıcı rolünü (`UserRole`) ve bu rollere bağlı işlem izinlerini (`PermissionService`) merkezi bir yaklaşımla yöneten reaktif modüldür.

```text
features/auth/
├── models/
│   ├── user_role.dart           <-- 5 rolü temsil eden enum (entrepreneur, investor, mentor, programProvider, admin)
│   └── user_model.dart          <-- Değişmez (immutable) kullanıcı modeli (rol ve isApproved alanları)
├── data/
│   └── auth_mock_data.dart      <-- 5 role ait 6 demo hesabı ve arama yardımcıları
├── controller/
│   ├── permission_service.dart  <-- Statik merkezi yetki ve ret gerekçesi otoritesi
│   └── auth_controller.dart     <-- ValueNotifier tabanlı oturum ve demo hesap yöneticisi
├── widget/
│   ├── auth_text_field.dart     <-- Özelleştirilmiş form giriş alanı
│   └── auth_banner.dart         <-- Demo rolleri hızlı seçim chip'leri ve ortam uyarısı
└── view/
    ├── login_view.dart          <-- Giriş ve demo hesap seçimi ekranı
    └── register_view.dart       <-- Kayıt ve doğrulama ekranı
```

Mimarideki Sorumluluklar ve Akış:

1. **Rol Modeli (`UserRole` enum) ve Kullanıcı Modeli (`UserModel`):**
   - Roller: `entrepreneur`, `investor`, `mentor`, `programProvider`, `admin`.
   - Her rol; Türkçe görüntüleme adı (`displayName`), açıklama (`description`) ve `IconData` ikonu taşır.
   - `UserModel`, kullanıcının `UserRole rol` ve `bool isApproved` durumunu saklar.

2. **Merkezi Yetki Otoritesi (`PermissionService`):**
   - Her ekranda dağınık `if` kontrolleri yazmak yerine tüm kural seti `PermissionService` sınıfında toplanmıştır.
   - Örn: `canCreateBusinessPlan(role)`, `canSendMentorshipRequest(role)`, `canPostInCommunity(role, isApproved: isApproved)`.
   - Yetkisiz işlemlerde kullanıcıya sunulacak pedagojik ve Türkçe açıklamalar `getDenialReason(actionKey)` metodu ile tek merkezden üretilir.

3. **Çift Katmanlı Koruma Mimarisi (UI + Controller):**
   - **UI Seviyesi:** Butona tıklandığında veya ekran açıldığında rol kontrol edilir; yetki yoksa açıklayıcı Türkçe SnackBar veya Dialog gösterilir, işlem tetiklenmez. Gözlemci modundaki ekranlarda (Örn: Yatırımcının İş Planı veya Fikir Durumu ekranını incelemesi) bilgilendirici uyarı banner'ı yer alır.
   - **Controller Seviyesi:** Controller metotları opsiyonel `{UserRole? currentRole}` parametresi kabul eder. Eğer yetkisiz bir rol metoda erişirse controller işlemi durdurur, state değişikliğini engeller ve `false` döndürür. Böylece UI'da bir kısıt atlanmış olsa dahi iş kuralları delinemez.

4. **Oturum Yönetimi ve Rol Değişimi (`AuthController`):**
   - `currentRole`: Aktif kullanıcının `UserRole` değeri (`currentUser.value?.rol`).
   - `isApproved`: Aktif kullanıcının onaylı girişimci olup olmadığı (`currentUser.value?.isApproved`).
   - `switchDemoAccount(UserModel user)`: Geliştirme sürecinde 6 demo hesabı arasında anında geçiş sağlar. Önceki kullanıcının yetki veya rol kalıntılarını temizler, yeni oturumu `SharedPreferences`'a yazar.
   - `ShellView` profil modalı üzerinden anında rol değiştirilebilir. Değişim `ValueNotifier` ile tüm açık sekmelerde reaktif olarak anında güncellenir.

5. **Tek Uygulama ve Ortak Arayüz İlkesi:**
   - Farklı roller için ayrı uygulamalar veya ayrı shell'ler tasarlanmaz.
   - Tüm roller aynı `ShellView`, aynı alt menü ve Derin Uzay tasarımını kullanır.
   - Görünürlük ile işlem yetkisi ayrılmıştır (Örn: Yatırımcı destek programlarını görebilir, fakat iş planı oluşturamaz).

## 7. Core Katmanı

### 7.1 Constants

`app_colors.dart`

Tema uzantılarının kullandığı merkezi renk değerlerini veya renk paletlerini tanımlar.

`app_spacing.dart`

Spacing, radius ve gerekli ortak ölçü token'larını tanımlar.

`app_strings.dart`

Gerçekten birden fazla yerde kullanılan ortak metinleri tutar. Her ekrandaki bütün metinleri gereksiz biçimde tek bir dev dosyaya taşımak zorunlu değildir.

### 7.2 Context extensions

`context_extensions.dart`

Önerilen kullanımlar:

```dart
context.spaceColors
context.textTheme
```

Uzantılar `BuildContext` üzerinden mevcut tema bilgisine erişimi kolaylaştırır.

Renk uzantısı `ThemeExtension` veya projede mevcut eşdeğer bir yapı üzerinden tasarlanabilir. `ThemeExtension` kullanılıyorsa açık ve koyu tema için doğru değerler sağlanmalıdır.

### 7.3 ThemeController

Sorumluluklar:

- `ValueNotifier<ThemeMode>` ile tema tercihini yönetmek.
- Varsayılan olarak koyu temayı kullanmak.
- Tercihi `shared_preferences` ile saklamak.
- Kayıtlı tercihi uygulama açılışında yüklemek.
- Kaydetme ve yükleme hatalarını uygun biçimde ele almak.
- Dispose sırasında notifier kaynaklarını temizlemek.

Tema yüklemesi asenkrondur. `main.dart` başlangıç akışı, kayıtlı tema okunana kadar tutarlı bir başlangıç stratejisi uygulamalıdır.

### 7.4 AppTheme

`app_theme.dart` şunları sağlar:

- `ThemeData` for dark mode.
- `ThemeData` for light mode.
- Material 3 bileşen temaları.
- Tipografi.
- Tema uzantıları.
- Buton, input, chip ve kart varsayılanları.

Bileşenlerin her birinde bağımsız renk ve tipografi değerleri tanımlanmaz.

### 7.5 Ortak widget'lar

`GlowCard`, `StarfieldBackground` ve `SectionHeader` gibi bileşenler tüm feature'lar tarafından tekrar kullanılabilir.

- `GlowCard`: Tema uyumlu kart yüzeyi.
- `StarfieldBackground`: Performanslı dekoratif arka plan.
- `SectionHeader`: Tutarlı bölüm başlığı.

Ortak widget'lar feature'a özel iş kuralları içermemelidir.

## 8. ValueNotifier State Yönetimi

Yörünge'de uygulama ve feature state'i Flutter'ın yerel reaktif araçlarıyla yönetilir.

Örnek:

```dart
class ExampleController {
  final ValueNotifier<int> count = ValueNotifier<int>(0);

  void increment() {
    count.value++;
  }

  void dispose() {
    count.dispose();
  }
}
```

UI tarafında:

```dart
ValueListenableBuilder<int>(
  valueListenable: controller.count,
  builder: (context, value, child) {
    return Text('$value');
  },
)
```

Bu örnek temel yaklaşımı gösterir. Gerçek uygulamada controller'ın oluşturulması, sahipliği ve dispose sorumluluğu açıkça tanımlanmalıdır.

### State yönetimi kuralları

- Bir state'in tek bir sahibi olmalıdır.
- Aynı değeri hem controller hem widget içinde bağımsız biçimde saklama.
- Bir `ValueNotifier` değerini değiştirmek için gereksiz yeni controller oluşturma.
- Birbiriyle ilişkili veriler için tutarlı state modeli kullan.
- İlgisiz alanların gereksiz yere yeniden çizilmesini önle.
- Widget'a özgü geçici state için `StatefulWidget` kullanmak hâlâ uygundur.
- Controller oluşturulan widget, controller'ın yaşam döngüsünü yönetmelidir.

## 9. Controller Yaşam Döngüsü

Controller'lar mümkün olduğunca uzun süreli sahiplik ve açık temizleme kurallarıyla yönetilir.

Örnek:

```dart
late final ExampleController controller;

@override
void initState() {
  super.initState();
  controller = ExampleController();
}

@override
void dispose() {
  controller.dispose();
  super.dispose();
}
```

Bu yaklaşım yalnızca ilgili widget controller'ın sahibiyse uygulanmalıdır.

Shell altında korunan sekmelerde controller'ın her sekme değişiminde yeniden oluşturulması istenmez. Controller yaşam döngüsü, ilgili ekranın veya uygulama kapsamının yaşam döngüsüyle uyumlu olmalıdır.

### Listener temizliği

- `addListener` ile eklenen listener'lar gerektiğinde kaldırılır.
- Stream abonelikleri iptal edilir.
- Timer veya animasyon controller'ları varsa dispose edilir.
- `ValueNotifier` sahipliği açık olmalıdır.
- Dispose edilmiş controller üzerinde işlem yapılmamalıdır.

## 10. Özelliklere Özel Mimari

### 10.1 Mentor

Veri akışı:

```text
MockMentorData
      |
      v
MentorController
      |
      ├── Search
      ├── Sector Filter
      ├── Expertise Filter
      └── Match State
      |
      v
MentorScreen
      |
      v
MentorCard
```

Controller'ın sorumlulukları:

- Mentor listesini sağlamak.
- Arama ve filtreleri uygulamak.
- Öne çıkan mentorları seçmek.
- Eşleşme durumlarını yönetmek.
- Filtreleri temizlemek.

Arama sonucu UI içerisinde ikinci bir filtreleme işlemiyle tekrar hesaplanmamalıdır. Tek bir tutarlı filtreleme mantığı kullanılmalıdır.

### 10.2 Yatırımcılar

Controller şu işlemleri yönetir:

- Kategori seçimi.
- Yatırım aşaması filtresi.
- Sektör filtresi.
- Yatırım aralığı filtresi.
- Sonuç listesinin oluşturulması.

Yatırım aralıkları için `double` veya uygun sayısal türler kullanılmalı; gösterim biçimi modelin iç veri biçiminden ayrılmalıdır.

Para birimi, birim ve örnek yatırım tutarları tutarlı biçimde gösterilmelidir.

### 10.3 Programlar

Controller:

- Kategori filtreleme.
- Başvuru durumu filtreleme.
- Tarihe göre durum gösterimi.
- Program detay verisinin seçilmesi.
- Takvim aksiyonuna uygun veri hazırlanması.

Açık/yakında/kapandı durumları birden fazla yerde çelişkili biçimde hesaplanmamalıdır.

Program tarihleri örnek içerikse gerçek güncel başvuru tarihi olduğu iddia edilmemelidir.

### 10.4 Topluluk

Controller:

- Gönderi listesini yönetir.
- Yeni gönderi ekler.
- Beğeni durumunu değiştirir.
- Tek seviyeli yanıt ekler.
- 280 karakter sınırını uygular.
- Onaylı kullanıcı durumunu kontrol eder.
- Yetkisiz işlemleri reddeder.

Örnek durum modeli:

```text
CommunityState
├── posts
├── currentUserStatus
└── relevant UI status
```

Controller metotları sonuçlarını açıkça ifade etmelidir. Projede mevcut bir `bool` veya sonuç modeli standardı varsa korunmalıdır.

Beğeni ve yanıt sayıları, ilgili veri modeliyle tutarlı olmalıdır. Yalnızca ikon rengini değiştirip veriyi değiştirmemek yeterli değildir.

### 10.5 Analiz

Önerilen yapı:

```text
features/analiz/
├── models/
│   ├── business_plan.dart
│   └── plan_step.dart
├── data/
├── controller/
│   └── analysis_controller.dart
├── widget/
│   ├── step_progress_header.dart
│   └── analysis_step_container.dart
└── view/
    └── analysis_screen.dart
```

Gerekli olduğunda her form adımının alanları için ayrı modeller veya widget dosyaları eklenebilir.

Controller:

- Form değerlerini tutar.
- Adım indeksini yönetir.
- Adım doğrulaması yapar.
- İleri/geri geçişi kontrol eder.
- Taslağı kaydeder.
- Taslağı geri yükler.
- Özet verisini hazırlar.
- Demo gönderimini yönetir.

Form state'i doğrudan birden fazla widget'a dağıtılmamalıdır.

### 10.6 Fikir Durumu

Controller:

- Örnek girişim durumunu sağlar.
- Altı aşamalı yol haritasını sunar.
- Avukat kartı verisini sağlar.
- Demo destek hedefi ve ilerleme değerini sunar.
- Örnek girişim listesini yönetir.

İlerleme değerleri tutarlı ve geçerli aralıklarda olmalıdır. Örneğin yüzde değeri 0–100 arasında sınırlandırılmalıdır.

Hukuki süreç verisi, genel bir örnek yol haritası olarak ele alınır; bütün şirketler için değişmez yasal süreç olarak modellenmez.

## 11. İş Planı Taslağının Kalıcılığı

Taslak, `shared_preferences` üzerinden yerel olarak saklanabilir.

Önerilen veri akışı:

```text
User Input
    |
    v
AnalysisController
    |
    v
BusinessPlan Model
    |
    v
Serialization
    |
    v
SharedPreferences
```

Geri yükleme:

```text
SharedPreferences
    |
    v
Deserialize
    |
    v
Validate Draft
    |
    v
AnalysisController
    |
    v
Analysis UI
```

Kurallar:

- Serileştirme ve geri yükleme aynı veri şemasını kullanmalıdır.
- Eksik veya bozuk kayıt uygulamanın çökmesine neden olmamalıdır.
- Geçersiz kayıt uygun biçimde ele alınmalıdır.
- Taslak, form tamamlanmadan kaydedilebilir.
- Form doğrulaması ile taslağın geri yüklenmesi birbirinden ayrılmalıdır.
- Taslak silme işlemi gerekiyorsa açık bir kullanıcı aksiyonu bulunmalıdır.

Basit bir demo taslağı için `shared_preferences` yeterlidir. Büyük ve karmaşık yerel veri gereksinimleri ortaya çıkarsa yeni bir depolama çözümü ancak gerekçeli biçimde değerlendirilmelidir.

## 12. Hata Yönetimi

Hatalar üç seviyede ele alınır:

### Controller

- Geçersiz kullanıcı işlemlerini kontrol eder.
- Veri dönüşüm hatalarını yakalar.
- Anlamlı işlem sonuçları üretir.
- Beklenmeyen hataları sessizce yok saymaz.

### View

- Controller sonucunu kullanıcıya anlaşılır biçimde sunar.
- Hata ve başarı mesajlarını gösterir.
- Navigasyon ve modal davranışlarını yönetir.
- Asenkron işlem sonrası `BuildContext` kullanılacaksa `context.mounted` kontrolü yapar.

### Data

- Mock veri tutarlılığını korur.
- Yerel veri okuma/yazma hatalarını uygun katmana iletir.
- Serileştirme hatalarının yönetilmesine imkân verir.

Stack trace veya teknik ayrıntılar son kullanıcıya gösterilmez.

## 13. Test Mimarisi

Testler `test/` altında düzenlenir.

Önerilen yapı:

```text
test/
├── core/
│   └── theme/
│       └── theme_controller_test.dart
└── features/
    ├── mentor/
    │   └── mentor_controller_test.dart
    ├── yatirimci/
    │   └── investor_controller_test.dart
    ├── programlar/
    │   └── program_controller_test.dart
    ├── topluluk/
    │   └── community_controller_test.dart
    ├── analiz/
    │   └── analysis_controller_test.dart
    └── fikir_durumu/
        └── idea_status_controller_test.dart
```

### Test kapsamı

- Mentor arama ve filtreleme.
- Eşleşme durumları.
- Yatırımcı filtreleri.
- Program kategori ve durum filtreleri.
- Topluluk yetkilendirme kuralları.
- 280 karakter sınırı.
- Analiz adımı doğrulaması.
- Taslak kaydetme ve geri yükleme.
- Tema tercihinin yüklenmesi ve kaydedilmesi.
- Hatalı yerel veriyle karşılaşıldığında güvenli davranış.

Testler gerçek ağ bağlantısına ihtiyaç duymamalıdır. Yerel depolama gerekiyorsa kontrol edilebilir bir test ortamı kullanılmalıdır.

## 14. .agents Ekosistemi ile Çalışma

Projede mevcutsa `.agents/` klasörü mimari geliştirme sürecinin bir parçasıdır.

Beklenen içerik:

```text
.agents/
├── SKILL.md
├── script/
│   └── generate_feature.sh
├── references/
│   ├── architecture_and_rules.md
│   └── state_flow.md
├── examples/
│   └── sample_screen.dart
└── skills/
```

### Yeni feature oluşturma

Yeni bir modül gerektiğinde:

1. `.agents/SKILL.md` dosyasını oku.
2. `references/architecture_and_rules.md` dosyasını incele.
3. `references/state_flow.md` dosyasındaki state akışını kontrol et.
4. `examples/sample_screen.dart` içindeki ilgili kalıpları değerlendir.
5. Gerekliyse `generate_feature.sh` otomasyonunu kullan.
6. Oluşturulan dosyaların içeriğini kontrol et.
7. Yeni feature'ı shell veya uygun navigasyon noktasına bağla.
8. Birim testlerini oluştur.
9. Analiz ve testleri çalıştır.

Otomasyonun mevcut dosyaları ezmediğini ve üretilen kodun güncel kurallarla uyumlu olduğunu kontrol et.

Kök dizindeki `skills.md`, `.agents/SKILL.md` dosyasının yerine geçmez. İki belge farklı kapsamları tamamlar.

Mevcut `.agents/` dosyaları varsa, kullanıcı açıkça istemedikçe bunları yeniden yazma veya silme.

## 15. Uygulama Başlangıcı

`main.dart` uygulamanın başlangıç noktasıdır.

Sorumlulukları:

- Gerekli Flutter başlangıç işlemlerini yapmak.
- Tema controller'ını uygun yaşam döngüsünde oluşturmak.
- `MaterialApp` yapılandırmasını hazırlamak.
- Açık ve koyu tema verilerini bağlamak.
- Tema değişikliklerini reaktif biçimde uygulamak.
- Uygun başlangıç ekranını göstermek.
- Gerekli kaynakları uygulama kapanışında temizlemek.

Başlangıç sırasında tema tercihi yükleniyorsa basit ve tutarlı bir başlangıç stratejisi uygulanmalıdır. Yükleme süreci gereksiz bir açılış ekranı karmaşasına dönüşmemelidir.

## 16. Mimari Değişiklik Kuralları

Bir mimari karar değiştirilmeden önce:

- Mevcut çözümün neden yetersiz olduğu belirlenir.
- Etkilenen feature'lar tespit edilir.
- Değişikliğin test edilebilirliği değerlendirilir.
- Gereksiz paket eklenmesinden kaçınılır.
- İlgili belgeler ve testler güncellenir.

Yalnızca daha popüler olduğu için başka bir state management paketine geçilmez.

## 17. Antigravity İçin Uygulama Planı

Antigravity, bu belgeleri okuduktan sonra şu sırayla ilerlemelidir:

### Aşama 1 — Mevcut durumu doğrula

- Proje kökünü ve `pubspec.yaml` dosyasını incele.
- Var olan feature'ları belirle.
- `.agents/` belgelerini oku.
- Testleri ve analiz sonuçlarını kontrol et.
- Tamamlanmış modülleri yeniden yazma.

### Aşama 2 — Mimari tutarlılığı kontrol et

- Katman sınırlarını kontrol et.
- Controller yaşam döngülerini incele.
- Sabit renk ve stil kullanımını tespit et.
- Gereksiz state yönetimi paketlerini kontrol et.
- Mock verinin UI'dan ayrıldığını doğrula.

### Aşama 3 — Eksikleri tamamla

- Eksik dosyaları mevcut yapıya uygun oluştur.
- İş kurallarını controller katmanına taşı.
- Ortak tasarım bileşenlerini yeniden kullan.
- Eksik doğrulama ve hata durumlarını tamamla.
- Navigasyon ve kalıcılık davranışlarını kontrol et.

### Aşama 4 — Doğrula

Aşağıdaki kontrolleri çalıştır:

```bash
dart format .
flutter analyze
flutter test
```

Bir komut hata verirse ilgili sorunu düzelt ve komutu yeniden çalıştır.

Web hedefi yapılandırılmışsa:

```bash
flutter build web
```

Platforma özgü bir paket veya yapılandırma nedeniyle komut çalışmıyorsa gerçek nedeni belirt; başarılı olmuş gibi raporlama yapma.

## 18. Mimari Tamamlanma Kriterleri

- [ ] Feature-first klasör yapısı korunuyor.
- [ ] Controller'lar UI bağımlılığı taşımıyor.
- [ ] State yönetimi Flutter yerel araçlarıyla yapılıyor.
- [ ] Controller kaynakları doğru temizleniyor.
- [ ] Tema değerleri merkezi sistemden geliyor.
- [ ] Mock veriler ayrı dosyalarda tutuluyor.
- [ ] Filtreler ve iş kuralları controller içinde uygulanıyor.
- [ ] Form doğrulama ve taslak kalıcılığı çalışıyor.
- [ ] Topluluk yetkileri controller tarafından kontrol ediliyor.
- [ ] Birim testleri kritik davranışları doğruluyor.
- [ ] `.agents/` kuralları korunuyor.
- [ ] Gereksiz paket ve abstraction eklenmiyor.
- [ ] Analiz ve test sonuçları doğrulanmış durumda.

**Mimari hedef:** Yörünge'nin her özelliği kendi sorumluluğuna sahip olmalı; UI, iş mantığı ve veri birbirine karışmamalı; uygulama yeni özelliklerle büyürken mevcut yapının anlaşılabilirliği korunmalıdır.