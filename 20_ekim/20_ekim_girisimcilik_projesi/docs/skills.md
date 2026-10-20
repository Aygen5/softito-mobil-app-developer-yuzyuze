# Yörünge — Development Skills & Coding Standards

## 1. Amaç

Bu belge, Yörünge projesinde kod üreten veya mevcut kodu değiştiren yapay zekâ ajanlarının uyması gereken geliştirme standartlarını tanımlar.

Amaç yalnızca çalışan bir arayüz üretmek değildir. Kodun okunabilir, test edilebilir, sürdürülebilir, performanslı ve mevcut mimariyle tutarlı olması gerekir.

Bu kurallar, projedeki mevcut `.agents/SKILL.md`, `references/architecture_and_rules.md`, `references/state_flow.md` ve ilgili örnek kodlarla birlikte değerlendirilmelidir.

Çelişki durumunda:
1. Kullanıcının açıkça belirttiği gereksinimler.
2. Mevcut projenin doğrulanmış çalışan davranışı ve bağlayıcı mimari kuralları.
3. Bu belge ve `architecture.md`.
4. `design-system.md` içindeki görsel kurallar.

Görsel tercihler, güvenlik veya iş kurallarını geçersiz kılamaz.

## 2. Temel Geliştirme İlkeleri

### 2.1 Önce incele, sonra değiştir

Her geliştirme görevinden önce:

- Mevcut proje yapısını incele.
- `pubspec.yaml` ve kullanılan paketleri kontrol et.
- İlgili feature dosyalarını ve testlerini oku.
- Projede hâlihazırda uygulanan kalıpları belirle.
- Aynı işlevin zaten bulunup bulunmadığını kontrol et.
- Değişikliklerin mevcut özellikleri bozmayacağından emin ol.

Mevcut çalışan kodu yalnızca daha yeni bir yaklaşım kullanmak için yeniden yazma.

### 2.2 Gereksiz karmaşıklıktan kaçın

- Gereksiz abstraction veya katman oluşturma.
- Tek seferlik, çok küçük bir işlem için genel amaçlı framework yazma.
- Birbirinin aynısı controller, model veya servisler üretme.
- Aynı iş kuralını birden fazla yerde tekrar etme.
- Yalnızca gösteriş için tasarım deseni kullanma.
- Bir özelliğin basit kalması gerekiyorsa onu gereksiz biçimde karmaşıklaştırma.

Her sınıfın açık ve tek bir sorumluluğu olmalıdır.

### 2.3 Çalışan özellik üret

Bir buton, filtre, form veya navigasyon öğesi yalnızca görünüşte çalışıyor olmamalıdır.

Örneğin:
- Filtre seçimi sonuç listesini değiştirmelidir.
- Beğeni butonu gönderi durumunu güncellemelidir.
- Tema değişimi uygulamanın tamamına yansımalıdır.
- Taslak kaydı uygulama yeniden açıldığında geri yüklenebilmelidir.
- Yetkisiz kullanıcı paylaşım yapamamalıdır.

Backend bulunmayan işlemler gerçek sunucu işlemiymiş gibi gösterilmemelidir.

### 2.4 Kimlik Doğrulama ve Demo Oturumu Standartları

Auth akışı geliştirilirken veya genişletilirken şu kurallara kesinlikle uyulur:
1. **Mimari Bütünlük:** Auth modülü `features/auth/` altında `models`, `data`, `controller`, `widget`, `view` katmanlarına uygun olarak geliştirilmeli; diğer modüllerin controller'larıyla gereksiz sorumluluk çakışması oluşturulmamalıdır.
2. **Gerçekçi Sınırlar:** Backend veya bulut sağlayıcı (Firebase/Supabase vb.) bulunmadığı için kullanıcıya hiçbir zaman gerçek bir sunucuya bağlandığı iddiasında bulunulmamalı; "Demo Ortamı" olduğu açıkça gösterilmelidir.
3. **Yetki Ayrımı:** Demo oturumu açmak, Topluluk modülündeki onaylı girişimci (`onayli`) statüsünü otomatik olarak vermemelidir. Demo verileri gerçek yetkilerle karıştırılmamalıdır.
4. **Güvenli Saklama:** `SharedPreferences` üzerinde şifreler asla saklanmamalıdır; yalnızca demo oturum kimlik bilgileri tutulmalıdır.
5. **Form Doğrulama ve Test:** Form doğrulamaları (boş alan, e-posta regex, şifre uzunluğu, şifre eşleşmesi) controller katmanında yapılmalı ve %100 birim testleriyle doğrulanmalıdır.
6. **Türkçe Standartları:** Form etiketleri, hata mesajları ve yönlendirme metinleri eksiksiz Türkçe olmalıdır.

### 2.5 Çok Rollü Sistem ve Yetkilendirme Standartları

Çok rollü yetkilendirme sistemi geliştirilirken şu kurallara riayet edilir:
1. **Merkezi Yetki Yönetimi:** Yetki kontrolleri widget'lara ve sayfalara rastgele dağıtılmış `if-else` bloklarıyla uygulanmaz. Tüm yetki kuralları ve ret açıklamaları merkezi `PermissionService` otoritesinde toplanır.
2. **Çift Katmanlı Koruma (Dual-Layer Defense):** Yalnızca UI butonunu pasifleştirmek yetersizdir. İş mantığını yürüten controller katmanında da yetki denetlenmeli (`currentRole`), yetkisiz işlem durumunda durum değişikliği engellenmelidir.
3. **Tek Uygulama / Ortak Arayüz İlkesi:** Beş rol için asla ayrı uygulamalar, ayrı sayfalar veya ayrı alt navigasyonlar tasarlanmaz. Arayüz tektir, görünürlük ile işlem yetkisi birbirinden ayrılır.
4. **Pedagojik ve Anlaşılır Bildirimler:** Yetkisiz bir eylemde kullanıcıya kuru bir "Yetkisiz işlem" mesajı verilmez; işlemin hangi role ait olduğu ve kısıtlamanın sebebi Türkçe olarak açıklanır.
5. **Demo Rol Simülasyonu Sınırları:** Geliştirme araçları dışındaki normal kullanıcı akışlarında yetkisiz rol geçişi yapılamaz; sistemin yerel bir demo simülasyonu olduğu ve gerçek sunucu güvenliği sağlamadığı dokümantasyonda ve kodda açıkça belirtilir.

## 3. Zorunlu Teknoloji ve State Management Kuralları

### 3.1 State management

Harici state management paketleri yasaktır:

- Provider
- Riverpod
- Bloc / Cubit
- GetX
- MobX

Durum yönetimi Flutter'ın yerel araçlarıyla yapılır:

- `ValueNotifier<T>`
- `ValueListenableBuilder<T>`
- Gerektiğinde widget'a özel, yerel `StatefulWidget` durumu.
- Asenkron işlemler için `Future` ve `Stream`, yalnızca ihtiyaç duyulduğunda.

`ValueNotifier` üzerinden yönetilmesi gereken uygulama veya feature durumları widget'ların içine dağıtılmamalıdır.

Bir controller, kendi sorumluluğundaki iş kurallarını ve state'i yönetir. UI yalnızca state'i gösterir ve kullanıcı eylemlerini controller'a iletir.

### 3.2 Controller kuralları

Controller sınıfları:

- `package:flutter/foundation.dart` dışında Flutter UI bağımlılığı taşımamalıdır.
- `BuildContext` kabul etmemelidir.
- `ScaffoldMessenger`, `Navigator` veya widget oluşturmamalıdır.
- State değişikliklerini açık metotlarla yönetmelidir.
- İlgili `ValueNotifier` nesnelerini `dispose()` içinde temizlemelidir.
- Mümkün olduğunca bağımsız birim testlerine uygun tasarlanmalıdır.

Controller içerisinde navigasyon, modal açma veya doğrudan görsel bildirim gösterme yapılmaz. Bu kararlar view katmanında uygulanır.

### 3.3 Asenkron işlemler

- `await` sonrasında `BuildContext` kullanılacaksa `if (!context.mounted) return;` kontrolü yapılmalıdır.
- `StatefulWidget` dispose edildikten sonra controller'a veya notifier'a erişilmemelidir.
- Dinleyiciler, stream abonelikleri ve controller nesneleri doğru yaşam döngüsünde temizlenmelidir.
- Hatalar yakalanmalı ve anlamlı biçimde ele alınmalıdır.
- Kullanıcıya gösterilen hata mesajları teknik stack trace içermemelidir.

## 4. Kod Düzeni ve Widget Standartları

### 4.1 Dosya organizasyonu

Feature-first klasör yapısı kullanılmalıdır.

Her feature, `architecture.md` içinde tanımlanan katmanlara uygun düzenlenir:

- `models/`
- `data/`
- `controller/`
- `widget/`
- `view/`

Bir dosya yalnızca bir feature'a aitse ilgisiz bir global klasöre taşınmamalıdır.

Birden fazla feature tarafından kullanılan gerçek ortak bileşenler `core/` altında yer alır.

### 4.2 Widget sorumlulukları

- View: ekranın genel düzenini ve bileşenleri bir araya getirir.
- Widget: tek bir görsel veya etkileşimli bileşeni temsil eder.
- Controller: iş kurallarını ve ilgili state'i yönetir.
- Model: veri yapısını ve gerekiyorsa serileştirme davranışını tanımlar.
- Data: demo içeriklerini ve bunlara erişim sağlayan yerel kaynakları barındırır.

### 4.3 40 satır kuralı

Bir `build()` metodu 40 satırı aşıyorsa mantıklı alt widget'lara bölünmelidir.

Bu kural, satırları anlamsız biçimde kısaltmak için uygulanmaz. Amaç okunabilirliği artırmaktır.

- Büyük kartları ayrı widget'lara ayır.
- Karmaşık liste öğelerini ayrı widget'lara ayır.
- Birden fazla sorumluluğu tek widget'a yükleme.
- Her küçük `Container` için yeni dosya oluşturma.

Projede mevcut `.agents` kuralları daha katı bir sınır tanımlıyorsa mevcut kural korunmalıdır.

### 4.4 Const kullanımı

Uygun olan yerlerde `const` constructor ve `const` widget kullan.

Gereksiz nesne oluşturumundan kaçın; ancak kodu okunamaz hâle getirecek yapay `const` düzenlemeleri yapma.

### 4.5 İsimlendirme

- Sınıflar: `UpperCamelCase`
- Değişkenler ve metotlar: `lowerCamelCase`
- Dosyalar: `snake_case.dart`
- Sabitler: projenin mevcut isimlendirme standardına uygun biçimde tanımlanır.
- Feature klasörleri: mevcut Türkçe isimlendirme korunur; örneğin `yatirimci`, `programlar`, `topluluk`.

İngilizce teknik kavramlar ve Türkçe ürün terimleri tutarlı kullanılmalıdır.

## 5. Tema ve Tasarım Sistemi Kuralları

### 5.1 Sabit stil yazımı yasaktır

Widget içinde doğrudan renk tanımlamak yasaktır:

```dart
// YASAK
Container(
  color: Color(0xFF05070F),
)
```

Bunun yerine projedeki tema uzantısı kullanılmalıdır:

```dart
// Tercih edilen yaklaşım
Container(
  color: context.spaceColors.background,
)
```

Benzer şekilde, widget içinde rastgele `TextStyle(...)` tanımlamak yerine `context.textTheme` kullanılmalıdır.

Tema uzantısında bulunmayan bir renk veya tipografi rolüne ihtiyaç duyuluyorsa önce merkezi tema sistemi uygun biçimde genişletilmelidir.

`app_colors.dart`, `app_spacing.dart`, `app_theme.dart` ve `design-system.md` tek bir tutarlı tasarım kaynağı olarak değerlendirilmelidir.

### 5.2 Bileşen tekrar kullanımı

Projede mevcutsa şu bileşenler tercih edilmelidir:

- `StarfieldBackground`
- `GlowCard`
- `SectionHeader`

Bu bileşenlerin benzerlerini farklı isimlerle tekrar oluşturma. Gerçekten farklı bir davranış gerekiyorsa mevcut bileşeni genişlet veya gerekçeli yeni bir bileşen oluştur.

### 5.3 Görsel kalite

- Her ekranın net bir görsel hiyerarşisi olmalıdır.
- Glow ve gradyan efektleri ölçülü kullanılmalıdır.
- İçerik, dekoratif efektlerden daha ön planda olmalıdır.
- Tekrarlanan kartlar aynı spacing ve tipografi kurallarını izlemelidir.
- Açık ve koyu tema ayrı ayrı test edilmelidir.
- Sabit ekran genişliği varsayılmamalıdır.

## 6. Model ve Veri Kuralları

### 6.1 Immutable modeller

Veri modelleri mümkün olduğunca immutable tasarlanmalıdır.

Uygun modellerde:

- `final` alanlar.
- Gerektiğinde `const` constructor.
- `copyWith`.
- Gerekli olduğunda `fromJson` ve `toJson`.
- Açık ve tutarlı tür tanımları.

Kullanılmayan serileştirme metotları sırf standart olsun diye eklenmemelidir.

### 6.2 Mock veri

Mock veri dosyaları ile iş mantığı ve UI birbirinden ayrılmalıdır.

Örnek:

```text
features/mentor/data/mock_mentor_data.dart
```

Kurallar:

- Mentor, yatırımcı ve program verilerini ekranların içine gömme.
- Filtreleri mock veri üzerinde gerçek biçimde çalıştır.
- Tek bir veri kaynağını aynı özellik içinde tekrar tekrar kopyalama.
- Tarih, para birimi ve durum alanlarında tutarlı türler kullan.
- Demo içeriklerini gerçek doğrulanmış kayıtlar gibi sunma.
- Eksik içerikleri sessizce uydurma; tanımlı demo verisini kullan veya eksik durumu göster.

### 6.3 Kalıcı yerel veri

`shared_preferences`, basit kullanıcı tercihleri ve taslak veriler için kullanılabilir.

Örneğin:
- Tema tercihi.
- İş planı taslağı.
- Demo sürümünde gerekli basit tercih değerleri.

Karmaşık nesneler saklanacaksa serileştirme ve geri yükleme açıkça tanımlanmalıdır.

Her widget içinde bağımsız `SharedPreferences` erişimi oluşturulmaz. Saklama sorumluluğu uygun controller veya veri katmanında toplanır.

## 7. Form Doğrulama ve Topluluk Yetkileri

### 7.1 İş planı formu

- Her adım kendi doğrulama kurallarına sahip olmalıdır.
- Zorunlu alanlar açıkça belirtilmelidir.
- Geçersiz veriyle sonraki adıma geçilmemelidir.
- Form durumu tek bir tutarlı kaynakta tutulmalıdır.
- Taslak kaydedilirken tamamlanmamış alanlar da korunmalıdır.
- Geri yüklenen taslak doğrulanmalıdır.
- Son gönderimden önce özet gösterilmelidir.

### 7.2 Topluluk yetkisi

Onaylı girişimci kontrolü `ToplulukController` içinde zorunlu olarak uygulanmalıdır.

UI'da butonları gizlemek veya devre dışı bırakmak tek başına yeterli değildir.

Controller aşağıdaki işlemlerde yetkiyi kontrol etmelidir:

- Gönderi oluşturma.
- Beğenme veya beğeniyi kaldırma.
- Yanıt oluşturma.

Yetki bulunmadığında işlem yapılmamalı ve kullanıcıya uygun sonuç dönülmelidir.

Bu kontrol yalnızca demo içi iş kuralıdır; gerçek bir backend'in güvenlik katmanının yerine geçmez.

## 8. Test Standartları

Her yeni iş kuralı mümkün olduğunca birim testleriyle doğrulanmalıdır.

Öncelikli testler:

- Mentor arama ve filtreleme.
- Eşleşme durumu geçişleri.
- Yatırımcı ve program filtreleri.
- Sekiz adımlı form doğrulaması.
- Taslak serileştirme ve geri yükleme.
- Toplulukta yetkili ve yetkisiz işlem sonuçları.
- Gönderi karakter sınırı.
- Tema tercihinin yüklenmesi ve kaydedilmesi.

Testlerde dış servis çağrısı yapılmamalıdır. Yerel demo verileri ve gerekli bağımlılıklar kontrollü biçimde sağlanmalıdır.

## 9. Hata ve Performans Yönetimi

- Liste öğelerinde gereksiz yeniden çizimleri önle.
- Uygun yerlerde `const` kullan.
- `ListView.builder` veya uygun lazy listeleri tercih et.
- Büyük dekoratif arka planları her state değişiminde yeniden çizme.
- `CustomPainter` için gerektiğinde `RepaintBoundary` kullan.
- `shouldRepaint` doğru tanımlanmalıdır.
- Listener ve controller kaynakları temizlenmelidir.
- Kullanıcıya anlaşılır hata durumları gösterilmelidir.
- Hata yakalayıp hiçbir şey yapmadan devam etme.
- Kullanılmayan paketleri ve gereksiz bağımlılıkları ekleme.

## 10. Paket Seçimi

Yeni bir paket eklemeden önce:

1. Flutter/Dart yerleşik araçları yeterli mi kontrol et.
2. Projede aynı işi yapan bir paket var mı incele.
3. Paketin platform uyumluluğunu değerlendir.
4. Bakım durumunu ve sürüm uyumluluğunu kontrol et.
5. Neden gerekli olduğunu açıkça belirle.

Mevcut gereksinimler için kullanılabilecek paketler:

- `shared_preferences`: basit yerel tercihler ve taslaklar.
- `url_launcher`: harici bağlantı açma.
- `table_calendar` veya benzeri bir paket: ancak mevcut takvim deneyimi için gerçekten gerekliyse.

Yeni bir paket eklemek zorunlu değildir. `pubspec.yaml` dosyası gereksiz paketlerle büyütülmemelidir.

## 11. Antigravity Çalışma Protokolü

Her görevde şu sırayı uygula:

1. İlgili dosyaları ve mimariyi incele.
2. Yapılacak değişikliği ve etkilenecek dosyaları belirle.
3. Mevcut kodla uyumlu en küçük çözümü seç.
4. Gerekli model, controller, data, widget ve view değişikliklerini yap.
5. İlgili testleri ekle veya güncelle.
6. `dart format` çalıştır.
7. `flutter analyze` çalıştır.
8. İlgili `flutter test` testlerini çalıştır.
9. Hataları düzelt ve kontrolleri yeniden çalıştır.
10. Sonucu ve doğrulanmış sınırlamaları özetle.

Gereksinim açık ve uygulanabilir olduğunda gereksiz onay soruları sorma. Ancak gerçek veri, harici entegrasyon veya kapsam değişikliği gibi kritik belirsizlikleri varsayımla çözme.

## 12. Tamamlanma Kontrol Listesi

Bir özellik tamamlandı olarak işaretlenmeden önce:

- [ ] Mimariye uygun dosyalara ayrıldı.
- [ ] İş kuralları controller katmanında bulunuyor.
- [ ] Mock veri ve UI ayrıldı.
- [ ] Tema sistemi kullanıldı.
- [ ] Etkileşimler gerçekten çalışıyor.
- [ ] Boş, hata ve başarı durumları ele alındı.
- [ ] Gerekli controller ve listener kaynakları temizleniyor.
- [ ] Birim testleri yazıldı veya güncellendi.
- [ ] `dart format` başarılı.
- [ ] `flutter analyze` hatasız.
- [ ] İlgili `flutter test` testleri başarılı.
- [ ] Yeni paketler gerekçelendirildi.
- [ ] Demo davranışları gerçek hizmet gibi sunulmuyor.

**Altın kural:** Yörünge'de temiz mimari, tutarlı tasarım ve gerçek işlevsellik birbirinden ayrı hedefler değildir. Her değişiklik bu üçüne birlikte hizmet etmelidir.