# Yörünge — Girişimcilik Platformu Geliştirme Planı ve İlerleme Raporu (plan.md)

Bu plan ve takip dokümanı, `docs/project.md`, `docs/architecture.md`, `docs/design-system.md` ve `docs/skills.md` belgelerinde tanımlanan teknik kurallar, mimari prensipler ve işlevsel gereksinimler doğrultusunda hazırlanmış ve adım adım hayata geçirilmiştir.

---

## 📌 Genel Bakış ve Mimari İlkeler
- **Uygulama Adı:** Yörünge — Girişimcilik Platformu
- **Teknoloji:** Flutter 3.47.6, Dart 3.13.5, Material 3
- **Tasarım:** "Derin Uzay" (Deep Space) çift tema (Dark/Light), `StarfieldBackground`, `GlowCard`, `SectionHeader`
- **Durum Yönetimi:** `ValueNotifier<T>` ve `ValueListenableBuilder<T>` (Dış paketler olmadan saf reaktif yapı)
- **Mimari:** Feature-first ve 5 katmanlı modül ayrımı (`models`, `data`, `controller`, `widget`, `view`)
- **Kalite Standartları:** 40 satır build kuralı, immutable modeller, controller bazlı iş mantığı, %100 birim test başarısı, sıfır analiz uyarısı.

---

## 🚀 Fazlar ve İlerleme Takibi

### 🔹 Faz 1: Altyapı ve Yapılandırma (Infrastructure & Setup)
- [x] **1.1 Flutter Proje Başlatımı:** `20_ekim_girisimcilik_projesi` kök dizininde `yorunge` paketi oluşturuldu.
- [x] **1.2 Bağımlılık Yönetimi:** `pubspec.yaml` dosyasına `intl`, `shared_preferences`, `url_launcher` eklendi.
- [x] **1.3 Statik Analiz Yapılandırması:** `analysis_options.yaml` kuralları ve hariç tutulan dizinler yapılandırıldı.
- [x] **1.4 Varlıklar (Assets):** Logo, uzay temalı ikonlar (`assets/images/`, `assets/icons/`), Android ve Web ikonları entegre edildi.
- [x] **1.5 Bağımlılık İndirme:** `flutter pub get` başarıyla çalıştırıldı ve kilitlendi.

### 🔹 Faz 2: .agents ve Ajan Standartları (.agents Ecosystem)
- [x] **2.1 Standartlar ve Kurallar:** `.agents/skills/SKILL.md` ve `references/architecture_and_rules.md` yapılandırıldı.
- [x] **2.2 State Akış Referansı:** `references/state_flow.md` ile reaktif akış prensipleri ve Mermaid diyagramları eklendi.
- [x] **2.3 Örnek Ekran Şablonu:** `examples/sample_screen.dart` derlenebilir referans olarak oluşturuldu.
- [x] **2.4 Feature Üretim Betiği:** `script/generate_feature.sh` scaffold aracı eklendi (`chmod +x`).

### 🔹 Faz 3: Core Katmanı (Tasarım Sistemi & Çekirdek Bileşenler)
- [x] **3.1 Sabitler (Constants):**
  - `app_colors.dart`: Derin Uzay (`#05070F`, `#0C1224`, `#FF6B2C`, `#22D3EE`, `#A3E635`, `#8B5CF6`) & Şafak Fırlatışı renk paletleri.
  - `app_spacing.dart`: Spacing (4px grid), radius ve layout token'ları.
  - `app_strings.dart`: Merkezi metinler, başlıklar ve terimler.
- [x] **3.2 Uzantılar (Extensions):** `context_extensions.dart` (`context.spaceColors`, `context.textTheme`).
- [x] **3.3 Tema Sistemi:** `ThemeController` (`ValueNotifier<ThemeMode>`, `SharedPreferences` kalıcılığı) ve `app_theme.dart` (Material 3 Dark/Light ThemeData).
- [x] **3.4 Ortak UI Bileşenleri:**
  - `starfield_background.dart`: `CustomPainter` ile optimize deterministik arka plan.
  - `glow_card.dart`: Kontrollü parıltılı (glow) yüzey kartı.
  - `section_header.dart`: Başlık, alt başlık ve eylem butonu içeren hiyerarşik başlık.

### 🔹 Faz 4: Shell ve Navigasyon Katmanı
- [x] **4.1 Shell Controller:** `ShellController` ile 4 sekmenin reaktif indeks yönetimi.
- [x] **4.2 Alt Navigasyon:** `app_bottom_navigation.dart` (Mentor, Yatırımcılar, Programlar, Topluluk).
- [x] **4.3 App Shell:** `shell_view.dart` üzerinde `IndexedStack` ile durum koruma, üst bar, tema değiştirici ve fikir durumu profil rozeti.

### 🔹 Faz 5: Analiz Modülü (8 Adımlı İş Planı Stepper'ı)
- [x] **5.1 Veri Modeli:** `business_plan.dart` (8 adımın immutable veri modeli, ekip üyeleri, Gantt görevleri).
- [x] **5.2 Controller & Kalıcılık:** `analysis_controller.dart` (Her adım için anlık doğrulama, `shared_preferences` taslak kaydı ve geri yükleme).
- [x] **5.3 UI & Stepper:**
  - `step_progress_header.dart`: İlerleme çubuğu ve adım göstergesi.
  - 8 adım formu: Fikir Özeti, Ekip, Traction, İnovasyon, Plan Tabloları, Pazar (TAM/SAM/SOM), Marka, Özet ve Gönderim.
  - `analysis_screen.dart`: Tam ekran başvuru akışı ve taslak temizleme.

### 🔹 Faz 6: Fikir Durumu ve Hukuki Süreç Modülü
- [x] **6.1 Veri & Model:** `idea_status.dart` ve `mock_idea_data.dart` (6 kabul edilmiş örnek girişim).
- [x] **6.2 Controller:** `idea_status_controller.dart` (Yol haritası durumu, avukat kartı ve aylık gelir destek hedefi).
- [x] **6.3 UI Bileşenleri:**
  - `company_timeline.dart`: T.C. mevzuatına uygun 6 aşamalı şirketleşme zaman çizelgesi.
  - `lawyer_card.dart`: Atanan ücretsiz avukat bilgi kartı.
  - `income_support_card.dart`: Aylık gelir desteği taahhüt kartı.
  - `idea_status_screen.dart`: Fikir durumu ekranı.

### 🔹 Faz 7: Mentor Modülü
- [x] **7.1 Veri & Model:** `mentor.dart` ve `mock_mentor_data.dart` (9 detaylı profil).
- [x] **7.2 Controller:** `mentor_controller.dart` (Metin arama, sektör & uzmanlık filtreleme, eşleşme durumu yönetimi).
- [x] **7.3 UI:** `mentor_card.dart`, öne çıkanlar yatay listesi, filtre chipleri ve `mentor_screen.dart`.

### 🔹 Faz 8: Yatırımcılar Modülü
- [x] **8.1 Veri & Model:** `investor.dart` ve `mock_investor_data.dart` (4 kategori x 4 = 16 profil).
- [x] **8.2 Controller:** `investor_controller.dart` (Kategori seçimi, aşama, bilet boyutu ve sektör filtreleri).
- [x] **8.3 UI:** `investor_card.dart`, bilet aralığı göstergeleri ve `investor_screen.dart`.

### 🔹 Faz 9: Destek Programları Modülü
- [x] **9.1 Veri & Model:** `support_program.dart` ve `mock_program_data.dart` (5 kategori x 3 = 15 program).
- [x] **9.2 Controller:** `program_controller.dart` (Kategori ve açık/yakında/kapandı durum filtreleri).
- [x] **9.3 UI:** `program_card.dart`, başvuru adımları modalı, takvim aksiyonu ve `program_screen.dart`.

### 🔹 Faz 10: Topluluk Modülü
- [x] **10.1 Veri & Model:** `community_post.dart` ve `mock_community_data.dart` (13 gönderi, tek seviyeli yanıtlar).
- [x] **10.2 Controller & Yetki Denetimi:** `community_controller.dart` (280 karakter sınırı, beğeni ve yanıt mantığı; **yalnızca onaylı girişimcilere etkileşim izni**).
- [x] **10.3 UI:** `post_card.dart`, gönderi oluşturma modalı, yetkisiz kullanıcı bilgilendirme diyaloğu ve `community_screen.dart`.

### 🔹 Faz 11: main.dart, Testler ve Kalite Doğrulama
- [x] **11.1 Uygulama Girişi:** `lib/main.dart` başlangıç, tema yükleme ve `ShellView` bağlama.
- [x] **11.2 Birim Testleri:**
  - `theme_controller_test.dart` (5 test)
  - `shell_controller_test.dart` (1 test)
  - `mentor_controller_test.dart` (4 test)
  - `yatirimci_controller_test.dart` (3 test)
  - `programlar_controller_test.dart` (3 test)
  - `topluluk_controller_test.dart` (3 test)
  - `analiz_controller_test.dart` (5 test)
  - `fikir_durumu_controller_test.dart` (3 test)
  - **Toplam:** **27 Birim Testi — %100 Başarı**
- [x] **11.3 Doğrulama Süreci:**
  - `dart format .` (61 dosya biçimlendirildi, 0 hata)
  - `flutter analyze` (0 hata, 0 uyarı)
  - `flutter test` (27/27 test geçti)
  - `flutter build web` (Başarıyla derlendi)

### 🔹 Faz 12: Kimlik Doğrulama, Demo Oturum Akışı ve Açılış Ekranı
- [x] **12.1 Veri ve Durum Yönetimi Katmanı (features/auth/):**
  - `user_model.dart`: Değişmez `UserModel` (id, adSoyad, email, rol, isDemo, olusturulmaTarihi, toJson, fromJson).
  - `auth_mock_data.dart`: Sabit demo hesabı (`demo@yorunge.app` / `yorunge123`), varsayılan ve dinamik hızlı demo kullanıcı üreteçleri.
  - `auth_controller.dart`: `ValueNotifier` tabanlı saf reaktif oturum yöneticisi (`currentUser`, `isLoading`, `errorMessage`), form doğrulama kuralları, `SharedPreferences` oturum kalıcılığı (şifresiz).
- [x] **12.2 Arayüz Bileşenleri (features/auth/widget/):**
  - `auth_text_field.dart`: Yörünge uzay temalı, parıltılı odaklanma, şifre görünürlük kontrolü ve Türkçe hata bildirimli form alanı.
  - `auth_banner.dart`: Demo ortamı bilgilendirme kartı ve sabit demo bilgilerini tek tıkla forma aktaran `Doldur` aksiyonu.
- [x] **12.3 Ekranlar ve Navigasyon Entegrasyonu (features/auth/view/):**
  - `login_view.dart`: Yörünge logolu karşılama, demo giriş formu, tek tıkla "Demo Olarak Devam Et" aksiyonu ve kayıt bağlantısı.
  - `register_view.dart`: Ad Soyad, E-posta, Şifre ve Şifre Tekrarı doğrulama formu, "⚡ Hızlı Demo Hesabı Oluştur ve Devam Et" seçeneği.
  - `splash_screen.dart`: Açılış animasyonunun ardından oturum durumuna göre `ShellView` veya `LoginView`'a yumuşak geçiş (`FadeTransition`).
  - `shell_view.dart`: AppBar üzerinde kullanıcı profil bilgisi ve güvenli çıkış diyaloğu (`_showLogoutDialog`).
- [x] **12.4 Birim Testleri:**
  - `auth_controller_test.dart`: 12 senaryo (başlangıç durumu, geçerli demo girişi, hatalı giriş, 4 adet form doğrulama kuralı, hızlı demo, çıkış, SharedPreferences kalıcılığı).
  - **Genel Test Durumu:** **39 Birim Testi — %100 Başarı**
- [x] **12.5 Kalite ve Derleme Kontrolleri:**
  - `dart format .` (71 dosya, 0 hata)
  - `flutter analyze` (0 hata, 0 uyarı)
  - `flutter test` (39/39 test geçti)
  - `flutter build web` (Başarıyla derlendi)
- [x] **12.6 Dokümantasyon:**
  - `docs/project.md`, `docs/architecture.md`, `docs/design-system.md`, `docs/skills.md` ve `ogrenci_rehberi.md` güncellendi.

### 🔹 Faz 13: Çok Rollü Demo Kullanıcı ve Merkezi Yetkilendirme Sistemi
- [x] **13.1 Rol Modeli ve Merkezi Yetki Servisi (features/auth/):**
  - `user_role.dart`: 5 rolü tanımlayan enum (`entrepreneur`, `investor`, `mentor`, `programProvider`, `admin`), `displayName`, `description`, `icon` ve `fromString`.
  - `user_model.dart`: Rol alanının `UserRole` olarak güncellenmesi ve `isApproved` (onaylı girişimci) alanının eklenmesi.
  - `permission_service.dart`: 12 farklı aksiyon için merkezi yetki ve Türkçe ret mesajı otoritesi (`canSendMentorshipRequest`, `canSendInvestmentRequest`, `canCreateBusinessPlan`, `canViewIdeaStatus`, `canManagePrograms`, `canPostInCommunity`, `canInteractInCommunity`, `canEditMentorProfile`, `canEditInvestorProfile`, `canEditProgramProviderProfile`, `canManageUsers`, `canDiscoverStartups`).
- [x] **13.2 Demo Hesapları ve Çoklu Rol Oturumu (features/auth/data/ & controller/):**
  - `auth_mock_data.dart`: 5 farklı rolü temsil eden 6 demo hesabı (`girisimci@yorunge.demo` [onaylı], `aday.girisimci@yorunge.demo` [onaysız], `yatirimci@yorunge.demo`, `mentor@yorunge.demo`, `kurum@yorunge.demo`, `admin@yorunge.demo`).
  - `auth_controller.dart`: `currentRole` ve `isApproved` reaktif getter'ları, `switchDemoAccount()` ile hesap değiştirme ve kalıntı bırakmadan oturum güncelleme.
  - `auth_banner.dart` & `login_view.dart`: Tek tıkla herhangi bir demo rolünü seçip formu otomatik doldurma chip'leri.
- [x] **13.3 Çift Katmanlı Koruma Mimarisi (UI + Controller):**
  - `MentorController` & `MentorView`: `eslesmeIste` metoduna `currentRole` kontrolü eklendi; yetkisiz rollerde (yatırımcı, mentor) işlem durdurulur ve bilgilendirici SnackBar verilir.
  - `YatirimciController` & `YatirimciView`: `iletisimTalebiGonder` metoduna `currentRole` kontrolü eklendi; yetkisiz rollerde engellenir.
  - `ProgramlarController` & `ProgramlarView`: `programDuzenle` metodu eklendi; `canManagePrograms` kontrolü uygulandı.
  - `ToplulukController` & `ToplulukView`: `paylasabilir` getter'ı `PermissionService.canPostInCommunity(role, isApproved)` ile bağlandı. Onaysız girişimciler ve yatırımcı/mentor için kısıtlandı.
  - `AnalizController` & `AnalizView`: `basvuruGonder` metoduna `canCreateBusinessPlan` eklendi; gözlemci roller için uyarı banner'ı ve buton kilit kontrolü eklendi.
  - `FikirDurumuController` & `FikirDurumuView`: `hukukiAdimIlerle` metoduna `canViewIdeaStatus` eklendi; gözlemci roller için bilgilendirme şeridi eklendi.
- [x] **13.4 Tek ve Ortak Arayüz, Profil ve Hızlı Rol Değiştirici:**
  - `shell_view.dart`: Tek shell ve ortak sekmeler korundu; AppBar'daki profil modalı (`_showProfileDialog`) üzerinden kullanıcının aktif rolü, adı, e-postası ve onay durumu gösterildi.
  - Modal içinde tüm demo hesapları listelendi; geliştirici/test kullanıcısının tek dokunuşla rol değiştirmesi sağlandı (`switchDemoAccount`).
- [x] **13.5 Birim Testleri:**
  - `role_permission_test.dart`: 11 zorunlu test senaryosu eksiksiz yazıldı ve doğrulandı (beş rol tanımı, girişimci izinleri, onaysız girişimci kısıtlaması, onaylı girişimci etkileşimi, yatırımcı kısıtlaması, mentor kısıtlaması, kurum yetkileri, admin yetkileri, controller seviyesinde engelleme, oturum geçişinde rol temizliği, Türkçe ret mesajları).
  - **Genel Test Durumu:** **50 Birim Testi — %100 Başarı (0 Hata)**
- [x] **13.6 Kalite ve Derleme Kontrolleri:**
  - `dart format .` (74 dosya biçimlendirildi, 0 hata)
  - `flutter analyze` (0 hata, 0 uyarı - No issues found!)
  - `flutter test` (50/50 test geçti)
  - `flutter build web` (✓ Built build/web - Başarıyla derlendi)
- [x] **13.7 Dokümantasyon:**
  - `docs/project.md`, `docs/architecture.md`, `docs/design-system.md`, `docs/skills.md`, `plan.md` ve `ogrenci_rehberi.md` güncellendi.


