# Yörünge — Design System

## 1. Tasarım Vizyonu

Yörünge'nin görsel kimliği; uzay, yörünge, yıldızlar, nebula ve roket fırlatışı metaforları üzerine kuruludur.

Arayüz, kullanıcıya bir girişimin gelişimini ve ilerlemesini hissettirmelidir. Bu nedenle görsel dil modern, teknolojik, güven veren ve premium olmalıdır.

### Tasarım anahtar kelimeleri

- Deep Space
- Orbital Motion
- Controlled Glow
- Cosmic Gradients
- Premium Glass Surfaces
- Clear Information Hierarchy
- Purposeful Micro-interactions

**Temel ilke:** Uzay atmosferi dekoratif bir katmandır; uygulamanın gerçek içeriği ve kullanılabilirliği her zaman ön planda kalır.

## 2. Tasarım Kararları

- Varsayılan tema: Derin Uzay (Dark).
- Alternatif tema: Şafak Fırlatışı (Light).
- Tasarım altyapısı: Flutter Material 3.
- Köşe yapısı: Yumuşak ve modern.
- Kart yaklaşımı: Katmanlı yüzeyler, ince kenarlıklar, kontrollü gradyan.
- Animasyon yaklaşımı: Kısa, doğal ve işlevsel.
- İkon yaklaşımı: Tutarlı çizgi ikonları.
- Genel deneyim: Mobil öncelikli, içerik odaklı ve responsive.

Tasarım, standart Material 3 bileşenlerini tamamen terk etmez. Form alanları, modal yapıları, erişilebilirlik davranışları ve temel etkileşimler Material 3 prensiplerine dayanır; renkler, yüzeyler ve görsel bileşenler Yörünge kimliğine uyarlanır.

## 3. Renk Sistemi

### 3.1 Derin Uzay — Dark Theme

Varsayılan tema budur.

| Token | Hex | Kullanım |
|---|---|---|
| `background` | `#05070F` | Ana ekran arka planı |
| `surface` | `#0C1224` | Ana kart ve yüzeyler |
| `surfaceElevated` | `#131B33` | Yükseltilmiş kartlar ve modal yüzeyleri |
| `surfaceOverlay` | `#192440` | Seçili veya etkileşimli yüzeyler |
| `primary` | `#FF6B2C` | Ana aksiyonlar ve roket ateşi vurgusu |
| `secondary` | `#22D3EE` | Nebula, bilgi vurguları ve ikincil aksiyonlar |
| `tertiary` | `#8B5CF6` | Yıldız moru, seçili kategoriler ve özel vurgular |
| `success` | `#A3E635` | Olumlu durumlar ve ilerleme |
| `textPrimary` | `#F4F7FF` | Ana metin |
| `textSecondary` | `#A7B1C9` | İkincil metin |
| `textMuted` | `#737F9D` | Yardımcı ve düşük öncelikli metin |
| `border` | `#26324D` | Kart ve alan kenarlıkları |
| `error` | `#FF647C` | Hata ve kritik uyarılar |

Bu renkler tasarım token'larıdır. Widget içinde rastgele `Color(0xFF...)` tanımlamak yerine merkezi renk sistemi kullanılmalıdır.

### 3.2 Şafak Fırlatışı — Light Theme

| Token | Hex | Kullanım |
|---|---|---|
| `background` | `#F4F7FC` | Ana arka plan |
| `surface` | `#FFFFFF` | Kart ve yüzeyler |
| `surfaceElevated` | `#FFFFFF` | Modal ve yükseltilmiş yüzeyler |
| `surfaceOverlay` | `#EAF0FA` | Seçili yüzeyler |
| `primary` | `#D94B18` | Ana aksiyonlar |
| `secondary` | `#087F9A` | İkincil vurgu |
| `tertiary` | `#7042D8` | Özel vurgu |
| `success` | `#4D7C0F` | Olumlu durumlar |
| `textPrimary` | `#151B2B` | Ana metin |
| `textSecondary` | `#4C5871` | İkincil metin |
| `textMuted` | `#69758D` | Yardımcı metin |
| `border` | `#DCE4F0` | Kenarlıklar |
| `error` | `#C62846` | Hata durumları |

Açık tema yalnızca renkleri tersine çevirmekten ibaret olmamalıdır. Yüzeyler, gölgeler, metin kontrastı ve arka plan efektleri de açık temaya göre ayarlanmalıdır.

### 3.3 Renk kullanım kuralları

- Turuncu, temel aksiyon rengidir; her kartı turuncuya boyamak için kullanılmaz.
- Camgöbeği, bilgi ve ikincil vurgular içindir.
- Mor, kategori veya özel vurgu rengidir.
- Limon yeşili, olumlu durumlar ve ilerleme için kullanılır.
- Kırmızı/pembe hata rengidir; normal durum etiketlerinde kullanılmaz.
- Büyük metin bloklarında neon renkler kullanılmaz.
- Metin ve arka plan arasında yeterli kontrast korunur.
- Renk tek başına anlam taşımamalıdır; durum etiketlerinde ikon veya metin de bulunmalıdır.

## 4. Tipografi

Flutter'ın Material 3 tipografi sistemi temel alınır.

### Tipografik hiyerarşi

| Stil | Önerilen boyut | Kullanım |
|---|---:|---|
| Display | 32–36 px | Açılış/hero alanındaki büyük başlıklar |
| Headline Large | 28 px | Ana ekran başlığı |
| Headline Medium | 24 px | Sayfa ve bölüm başlıkları |
| Title Large | 20 px | Kart başlığı veya ana alt başlık |
| Title Medium | 16 px | Liste öğesi başlığı |
| Body Large | 16 px | Ana içerik |
| Body Medium | 14 px | Açıklamalar |
| Body Small | 12 px | Yardımcı bilgi |
| Label Large | 14 px | Buton ve etiketler |
| Label Small | 11–12 px | Küçük durum etiketleri |

Boyutlar mantıksal piksel cinsindendir ve başlangıç değerleridir. Ekranın gerçek yoğunluğu, erişilebilirlik ve mevcut Material 3 ölçeği dikkate alınmalıdır.

### Tipografi kuralları

- Öncelik sistemin okunabilir varsayılan yazı tipindedir.
- Özel font ancak proje içinde gerçekten mevcutsa kullanılmalıdır.
- Başlıklar kısa ve net olmalıdır.
- Uzun açıklamalar 14–16 px aralığında okunabilir tutulmalıdır.
- Kartlarda metin taşması kontrol edilmelidir.
- Gereksiz büyük harf kullanımı yapılmamalıdır.
- Aşırı ince font ağırlıkları küçük metinlerde kullanılmamalıdır.

## 5. Spacing ve Layout Sistemi

Temel spacing birimi 4 px'tir.

| Token | Değer | Kullanım |
|---|---:|---|
| `xs` | 4 px | Çok küçük iç boşluk |
| `sm` | 8 px | İkon ve metin arası |
| `md` | 12 px | Sıkı bileşen içi boşluk |
| `lg` | 16 px | Standart kart iç boşluğu |
| `xl` | 24 px | Bölüm aralığı |
| `xxl` | 32 px | Büyük bölüm boşluğu |
| `section` | 40 px | Belirgin bölüm ayrımı |

### Layout kuralları

- Standart ekran yatay padding değeri 20 px'tir; dar ekranlarda 16 px'e düşürülebilir.
- Kartlar arasında çoğunlukla 12–16 px boşluk kullanılır.
- Bölüm başlıkları ile içerikleri arasında 12–16 px boşluk bulunur.
- Form alanları arasında yeterli dikey mesafe bırakılır.
- İçerik sistem çentikleri ve alt güvenli alanla çakışmamalıdır.
- Küçük ekranlarda yatay taşma oluşmamalıdır.
- Yatay listelerde kartların devam ettiği görsel olarak anlaşılmalıdır.

## 6. Köşe Yuvarlaklıkları ve Kenarlıklar

| Token | Değer | Kullanım |
|---|---:|---|
| `radiusSmall` | 8 px | Küçük etiketler ve kompakt alanlar |
| `radiusMedium` | 12 px | Giriş alanları ve küçük kartlar |
| `radiusLarge` | 18 px | Standart kartlar |
| `radiusXLarge` | 24 px | Öne çıkan kartlar |
| `radiusPill` | 999 px | Chip, rozet ve kapsül butonlar |

Kenarlıklar ince ve düşük kontrastlı olmalıdır. Glow efektleri kenarlığın yerine geçmemelidir.

## 7. Yüzeyler, Glow ve Gradyanlar

### 7.1 Glow yaklaşımı

Glow, Yörünge'nin ayırt edici görsel unsurudur; ancak bütün bileşenlerde aynı güçte kullanılmamalıdır.

- Ana CTA: kontrollü turuncu vurgu.
- Öne çıkan mentor veya girişim kartı: hafif camgöbeği veya mor glow.
- Seçili durum: renkli kenarlık veya yüzey farkı.
- Standart kart: ince kenarlık; gerektiğinde çok hafif gölge.
- Açık tema: yoğun neon yerine kenarlık ve yumuşak gölge.

Glow hiçbir zaman metin okunabilirliğini azaltmamalıdır.

### 7.2 Gradyan kullanımı

Önerilen kombinasyonlar:

- Turuncudan koyu turuncuya: ana aksiyonlar.
- Mor ile camgöbeği: özel içerik ve hero alanları.
- Gece mavisi tonları: yüzey derinliği.

Gradyanlar dekoratif amaçla her alana eklenmemelidir. Her gradyanın görsel veya işlevsel bir amacı bulunmalıdır.

## 8. Temel Bileşenler

### 8.1 StarfieldBackground

Amaç: Derin uzay atmosferi oluşturmak.

Gereksinimler:

- `CustomPainter` ile çizilir.
- Gerektiğinde `RepaintBoundary` ile izole edilir.
- Yıldız noktaları deterministik biçimde üretilir.
- Her build işleminde yeni rastgele yıldız konumları oluşturulmaz.
- Yıldız yoğunluğu düşük tutulur.
- İçerik kontrastını bozmaz.
- Açık temada çok daha hafif bir arka plan yaklaşımı kullanır.
- Animasyon ancak gerçek bir fayda sağlıyorsa eklenir.

### 8.2 GlowCard

Amaç: İçeriği premium ve katmanlı bir yüzeyde sunmak.

Gereksinimler:

- Tema uyumlu arka plan.
- İnce kenarlık.
- İsteğe bağlı, kontrollü glow.
- Tutarlı radius ve padding.
- İsteğe bağlı dokunma etkileşimi.
- İçeriğin yüksekliğine göre doğal boyutlanma.

Kartlar iç içe aşırı kart kullanımıyla görsel açıdan ağırlaştırılmamalıdır.

### 8.3 SectionHeader

Amaç: Bölüm başlığı, kısa açıklama ve isteğe bağlı aksiyon sunmak.

Destekleyebileceği alanlar:

- Başlık.
- Alt başlık.
- Sağ tarafta isteğe bağlı aksiyon.
- Opsiyonel küçük ikon.

Tüm ana ekranlarda aynı başlık hiyerarşisini korumalıdır.

### 8.4 StatusBadge

Durumları metin ve renk ile ifade eder:

- Açık.
- Yakında.
- Kapandı.
- Beklemede.
- Eşleşti.
- Onaylandı.

Renkler anlamlı olmalıdır. Her durum için aynı parlak renk kullanılmamalıdır.

### 8.5 SearchField

- Görünür bir arama ipucu.
- Arama temizleme aksiyonu.
- Tema uyumlu yüzey.
- Klavyeye uygun giriş türü.
- Sonuçları gerçek zamanlı güncelleyen veya kontrollü biçimde uygulayan davranış.

### 8.6 FilterChip

- Seçili ve seçili olmayan durumları açıkça ayırır.
- Uzun metinlerde taşma kontrolü yapılır.
- Yatay kaydırmalı filtrelerde doğal kaydırma davranışı bulunur.
- Filtre temizleme seçeneği gerekiyorsa görünür olmalıdır.

### 8.7 PrimaryButton ve SecondaryButton

PrimaryButton:
- Ana turuncu aksiyon.
- Yeterli kontrast.
- Belirgin etkileşim alanı.
- Yükleme veya devre dışı durumu desteklenebilir.

SecondaryButton:
- Daha düşük görsel öncelik.
- Tema uyumlu yüzey veya outline.
- Ana aksiyonla rekabet etmeyen stil.

Bir ekranda birden fazla eşit derecede baskın ana aksiyon oluşturulmamalıdır.

### 8.8 EmptyState

Arama sonucu bulunmadığında, boş listelerde veya kullanıcı henüz bir işlem yapmadığında kullanılmalıdır.

İçerik:
- Uygun ikon veya sade illüstrasyon.
- Kısa başlık.
- Açıklayıcı bir cümle.
- Gerekiyorsa ilgili aksiyon.

Boş ekranlar anlamsız dekoratif öğelerle doldurulmamalıdır.

## 9. Ana Ekran Tasarım Rehberi

### 9.1 Genel shell

Üst alan:

- Yörünge logosu veya wordmark.
- Gerektiğinde kısa karşılama metni.
- Tema değiştirme butonu.
- Fikir Durumu rozetine erişim.

Alt navigasyon:

- Mentorlar.
- Yatırımcılar.
- Programlar.
- Topluluk.

Aktif sekme kolayca ayırt edilmelidir. Navigasyon ikonları ve etiketleri tutarlı olmalıdır.

### 9.2 Mentor ekranı

Önerilen görsel sıra:

1. Başlık ve kısa yönlendirici açıklama.
2. Mentor arama alanı.
3. Yatay öne çıkan mentorlar bölümü.
4. Uzmanlık veya sektör filtreleri.
5. Filtrelenebilir mentor listesi.

Mentor kartında:
- Profil görseli veya tutarlı avatar.
- İsim.
- Uzmanlık.
- Sektör.
- Kısa deneyim bilgisi.
- Eşleşme aksiyonu veya durum etiketi.

### 9.3 Yatırımcı ekranı

Önerilen görsel sıra:

1. Sayfa başlığı.
2. Yatırımcı kategori seçimi.
3. Yatırım aşaması ve sektör filtreleri.
4. Gerekirse yatırım aralığı filtresi.
5. Sonuç sayısı ve yatırımcı listesi.

Yatırımcı kartlarında önemli bilgiler kolay taranabilir olmalıdır. Tüm bilgiler aynı görsel ağırlıkta sunulmamalıdır.

### 9.4 Programlar ekranı

- Kategori seçimi.
- Program kartları.
- Açık/yakında/kapandı durumu.
- Son başvuru tarihi.
- Destek türü veya kısa özet.
- Ayrıntılar ve başvuru adımları aksiyonu.

Tarihler görsel olarak anlaşılır olmalıdır. Kapalı programlar aktif başvuru çağrısı gibi sunulmamalıdır.

### 9.5 Topluluk ekranı

- Akışın başında kısa topluluk başlığı.
- Yetkili kullanıcılar için paylaşım oluşturma alanı.
- Gönderilerde metin, yazar, zaman bilgisi ve etkileşimler.
- Yanıtların ana gönderiyle ilişkisi açıkça görünür olmalıdır.
- Uzun metinler ekran genişliğini aşmamalıdır.
- Yetkisiz kullanıcıya okuma erişimi korunurken etkileşim için neden izin verilmediği anlaşılır biçimde açıklanmalıdır.

### 9.6 Analiz formu

- Üstte ilerleme göstergesi.
- Mevcut adımın numarası ve başlığı.
- Kısa açıklama.
- Birbiriyle ilişkili form alanları.
- Alt bölümde Geri ve Devam aksiyonları.
- Son adımda özet ve gönderim.

Form, tek bir uzun ve yorucu sayfa gibi tasarlanmamalıdır. Her adım kullanıcıya neyi tamamladığını göstermelidir.

### 9.7 Fikir Durumu

- Özet durum kartı.
- Görsel olarak ayrıştırılmış altı aşamalı zaman çizelgesi.
- Mevcut ve tamamlanan adımlar.
- Örnek avukat kartı.
- Gelir desteği hedef/ilerleme göstergesi.
- Diğer örnek girişimlerin durumları.

Demo kapsamındaki hukuki ve mali bilgiler gerçek hizmet izlenimi vermeyecek şekilde etiketlenmelidir.

### 9.8 Giriş ve Kayıt Ekranları (Login & Register)

Tasarım sistemiyle bütünleşme:
- **Arka Plan:** `StarfieldBackground` ile derin uzay yıldız alanı ve atmosferik zemin korunur.
- **Marka Kimliği:** `YorungeLogo` (merkezi vektörel yörünge ve roket motifi) ekranın üst merkezinde yer alır.
- **Bilgilendirme Kartı (`AuthBanner`):** `nebulaCyan` renginin `%8` saydamlık yüzeyi ve `%25` kenarlık vurgusuyla uygulamanın sunucusuz yerel demo ortamı olduğu belirtilir. Sabit demo hesabı tek tıkla otomatik form doldurma butonuna (`Doldur`) sahiptir.
- **Form Alanları (`AuthTextField`):**
  - Koyu temada `surfaceDark`, açık temada `nightBlue` dolgu rengi.
  - Odak ve hata durumlarında dinamik kenarlık renkleri (`errorRed`, `border`).
  - Şifre alanında dinamik görünürlük ikonu (göz ikonu).
- **Aksiyon Butonları:**
  - Birincil aksiyon: `rocketFlame` gradyanlı, gölgeli ve yükseklikli `ElevatedButton`.
  - İkincil aksiyon: `ascensionLime` vurgulu ikon içeren `OutlinedButton` ("Demo Olarak Devam Et" ve "⚡ Hızlı Demo Hesabı").
- **Klavye & Responsive Uyum:**
  - `SingleChildScrollView` ve `SafeArea` ile klavye açıldığında form öğeleri kaydırılabilir kalır; küçük ekranlarda overflow engellenir.
- **Hata ve Başarı Durumları:**
  - Doğrulama hataları kırmızı uyarı kutusu (`errorRed`) ve alan altı metinleriyle Türkçe açıklanır.
  - Başarılı kayıt sonrası yeşil `ascensionLime` yüzen `SnackBar` geri bildirimi sunulur.

## 10. İkonografi ve Görsel Varlıklar

- Mümkün olduğunca tek bir ikon ailesi kullan.
- Flutter Material Icons kullanılabilir.
- Aynı işlev için farklı ikon stillerini karıştırma.
- Anlamı belirsiz dekoratif ikonlardan kaçın.
- Emoji, ana navigasyon ikonlarının yerine kullanılmamalıdır.
- Profil görselleri mevcutsa doğru varlıklar kullanılmalıdır.
- Görsel bulunmuyorsa tutarlı bir avatar veya ikon fallback'i gösterilmelidir.

Gerçek varlıklar mevcutsa bunlar kontrol edilmeden yeni ve benzer varlıklar üretilmemelidir.

## 11. Animasyon ve Mikro Etkileşimler

Animasyonlar kısa ve ölçülü tutulmalıdır.

Önerilen süreler:
- Küçük etkileşimler: 120–180 ms.
- Kart ve durum geçişleri: 180–240 ms.
- Modal geçişleri: 200–280 ms.

Kullanılabilecek animasyonlar:

- Buton basılma tepkisi.
- Sekme değişimi.
- Filtre seçimi.
- Eşleşme durumu geçişi.
- Form adımları arasında geçiş.
- Başarı göstergesi.

Animasyonlar işlevi yavaşlatmamalı, sürekli dikkat dağıtmamalı ve gereksiz yere tekrar etmemelidir. Hareket azaltma tercihleri mümkün olduğunca dikkate alınmalıdır.

## 12. Responsive ve Erişilebilir Tasarım

- Küçük telefonlarda yatay taşma olmamalıdır.
- Büyük ekranlarda içerik kontrolsüz biçimde genişlememelidir.
- Formlar klavye açıldığında kullanılabilir kalmalıdır.
- Güvenli alanlar dikkate alınmalıdır.
- Dokunma alanları mümkün olduğunca en az 48 × 48 mantıksal piksel hedefini karşılamalıdır.
- Sadece renge dayalı anlam aktarılmamalıdır.
- Metin ölçeklendirme desteklenmelidir.
- İkon butonlarında erişilebilir etiket bulunmalıdır.
- Form alanlarının etiketleri ve hata mesajları anlaşılır olmalıdır.
- Açık ve koyu temada kontrast kontrol edilmelidir.

## 13. Tasarım Token'larının Kodda Kullanımı

Tüm renk, spacing ve tema değerleri merkezi kaynaklardan yönetilmelidir.

Önerilen yapı:

```text
lib/core/constants/
  app_colors.dart
  app_spacing.dart
  app_strings.dart

lib/core/theme/
  app_theme.dart
  theme_controller.dart

lib/core/extensions/
  context_extensions.dart

lib/core/widgets/
  glow_card.dart
  starfield_background.dart
  section_header.dart
```

Widget kullanımında:

- `context.spaceColors`
- `context.textTheme`

kullanılır.

Bu uzantılar mevcut projede bulunmuyorsa Antigravity bunları `architecture.md` ve `skills.md` kurallarına uygun biçimde oluşturmalıdır.

Yeni bir renk rolüne ihtiyaç duyulduğunda önce merkezi tema sistemi güncellenmelidir.

## 14. Tema Yönetimi

`ThemeController`, `ValueNotifier<ThemeMode>` üzerinden tema tercihini yönetir.

- Varsayılan değer `ThemeMode.dark` olmalıdır.
- Kullanıcının seçimi `shared_preferences` ile saklanmalıdır.
- Uygulama açılışında kayıtlı tercih yüklenmelidir.
- Yükleme tamamlanmadan tema tercihi yanlışlıkla varsayılan değere kalıcı olarak yazılmamalıdır.
- Tema değişimi bütün uygulamaya yansımalıdır.
- Controller dispose edilmelidir.

`MaterialApp` içindeki `theme`, `darkTheme` ve `themeMode` alanları merkezi tema sisteminden yönetilir.

## 15. Tasarım Tamamlanma Kontrolü

- [ ] Koyu tema varsayılan olarak açılıyor.
- [ ] Açık tema tüm ekranlarda çalışıyor.
- [ ] Renkler merkezi token'lardan geliyor.
- [ ] Tipografi tutarlı.
- [ ] Kart, buton ve alan stilleri tekrar kullanılabilir.
- [ ] Starfield arka planı performanslı.
- [ ] Glow efektleri ölçülü.
- [ ] Küçük ekranlarda taşma yok.
- [ ] Boş, hata ve başarı durumları tasarlanmış.
- [ ] Erişilebilir etiketler ve uygun dokunma alanları mevcut.
- [ ] Form klavye ile kullanılabilir.
- [ ] Gerçek ve demo içerikler açıkça ayrılıyor.

## 16. Çok Rollü Sistem ve Yetki Tasarım Dili

### 16.1 Ortak Arayüz ve Görünürlük İlkesi
- **Tek Shell:** Her rol için ayrı navigasyon veya farklı tema şablonu oluşturulmaz. Tüm roller aynı Derin Uzay tasarımını ve sekmeleri paylaşır.
- **İçerik Şeffaflığı:** Ekranı görmek bir haktır; işlemi icra etmek ise role bağlı bir yetkidir. Örneğin yatırımcı, iş planı analiz adımlarını ve fikir durumunu inceleyebilir.

### 16.2 Rol Rozetleri ve Profil Tasarımı
- **Görsel Kimlik:** Her rol için tanımlı bir ikon ve renk vurgusu kullanılır:
  - Girişimci (Onaylı): 🚀 Roket Alevi (`rocketFlame`) & Doğrulanmış rozet (`ascensionLime`).
  - Aday Girişimci (Onaysız): ⏳ Kum saati & Kilit uyarısı (`warningAmber`).
  - Yatırımcı: 💼 Çanta ikonu & Nebula Camgöbeği (`nebulaCyan`).
  - Mentor: 🎓 Danışman şapkası & Yıldız Moru (`starPurple`).
  - Kurum Temsilcisi: 🏢 Bina ikonu & Açık Mavi.
  - Platform Yöneticisi: 🛡️ Kalkan ikonu & Parlak vurgu.
- **Profil Modal:** Kullanıcının mevcut rolü, adı ve e-postası Derin Uzay kartı üzerinde belirgin şekilde gösterilir.

### 16.3 Kilitli İşlemler ve Yetki Uyarıları
- **Etkileşimli Geri Bildirim:** Yetkisiz butonlar tamamen gizlenmek yerine pedagojik olarak kilitli ikon veya kısıtlı etiket ile sunulabilir; tıklandığında `PermissionService` kaynaklı anlaşılır bir SnackBar veya Dialog açılır.
- **Gözlemci Modu Banner'ı:** Rolün işlem yapmaya yetkili olmadığı ekranların (İş Planı Analizi, Fikir Durumu) en üstünde `warningAmber` (%15 alfa) arka planlı, zarif bordürlü bir bilgilendirme şeridi yer alır.
- **Light / Dark Tema Uyumu:** Yetki uyarıları ve dialog arka planları `colors.surfaceDark` / `colors.surfaceSubtle` token'ları üzerinden türetildiği için hem Derin Uzay (karanlık) hem de Şafak (aydınlık) modunda tam kontrast ve okunabilirlik sunar.

**Tasarım hedefi:** Yörünge, uzay temalı olduğu için oyuncak gibi görünmemeli; premium, güven veren, çağdaş ve gerçek bir girişimcilik ürünü hissi vermelidir.