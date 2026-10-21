# StajTakip — Aşamalı Geliştirme ve Stitch Dönüşüm Planı (plan.md)

Bu plan; `project.md`, `architecture.md`, `design-system.md` ve `skills.md` belgelerinde tanımlanan kesin kurallar, mimari prensipler ve tasarım standartları doğrultusunda hazırlanmıştır. 

Geliştirme sürecinde bu planın adımlarına hiyerarşik bir sıralamayla kesin olarak uyulacak; kullanıcı bir sonraki komutu ve Stitch tasarımını verene kadar herhangi bir kod geliştirme işlemine başlanmayacaktır.

---

## 0. Temel İlkeler ve Kırmızı Çizgiler

1. **Görsel ve Mimari Denge:** Stitch tasarımına yüksek görsel sadakat gösterilecek; ancak HTML/CSS yapıları asla körü körüne kopyalanmayacak, Flutter'ın temiz widget ağacına ve mimarisine adapte edilecektir.
2. **Katman İzolasyonu:** Ekranlar (View) ve Cubit sınıfları doğrudan Firebase SDK'sını çağırmayacaktır. Tüm veri iletişimi `Repository` katmanında toplanacaktır (`View -> Cubit -> Repository -> Firebase SDK`).
3. **Güvenlik ve Roller:** Rol ve izin kontrolleri sadece arayüzde buton gizlemekle sınırlı kalmayacak; Firestore ve Storage güvenlik kurallarıyla desteklenecek, kayıt ekranından rastgele yetki alınamayacaktır.
4. **Çift Aşamalı Onay Mekanizması:** Kurum Yetkilisi onayı ve Akademik Danışman onayı ayrı ayrı izlenecektir. Tek bir boolean alan ile süreç belirsizleştirilmeyecektir.
5. **Kusursuz Türkçe Arayüz:** Kullanıcıya görünen tüm metinler, hata açıklamaları, etiketler ve PDF çıktıları doğru Türkçe karakterleri destekleyecektir.
6. **Sahte Veri Yasağı:** Geliştirme tamamlandığında üretim kodu sabit sahte verilerle (mock data) bırakılmayacak; gerçek Firestore/Storage akışı bağlanacaktır.
7. **Adım Adım İlerleme:** Her adım tamamlandığında `dart format`, `flutter analyze` ve ilgili test kontrolleri yapılarak bir sonraki aşamaya geçilecektir.

---

## Hiyerarşik İş Planı ve İlerleme Durumu

```text
[x] Flutter Kurulumu ve Proje Yapılandırması (staj_takip projesi oluşturuldu, paketler ve klasörler kuruldu)
[x] Faz 0: Stitch Tasarım Analizi & Token Tespiti (Tamamlandı)
  ├── [x] 0.1 Stitch çıktısının incelenmesi (6 Ekran ve ID eşleşmeleri tamamlandı)
  ├── [x] 0.2 Renk, tipografi ve boşluk token'larının doğrulanması (AppColors & Typography)
  └── [x] 0.3 Eksik durum ve ekranların belirlenmesi (Loading, Empty, Error, SafeArea)

[x] Faz 1: Çekirdek Altyapı, Tasarım Sistemi & Ortak Bileşenler (Tamamlandı)
  ├── [x] 1.1 Proje iskeleti ve paket bağımlılıklarının yapılandırılması
  ├── [x] 1.2 Klasör mimarisinin oluşturulması
  ├── [x] 1.3 Core: Tema, Renkler (AppColors), Tipografi ve Sabitler
  ├── [x] 1.4 Hata sınıfları ve yardımcı araçlar (Utils)
  └── [x] 1.5 Common: Yeniden kullanılabilir ortak UI bileşenleri

[x] Faz 2: Veri Katmanı (Data Layer: Modeller & Repository'ler) (Tamamlandı)
  ├── [x] 2.1 Veri modelleri ve Enum tanımları
  ├── [x] 2.2 Repository sözleşmeleri (Interfaces)
  ├── [x] 2.3 Firebase Repository implementasyonları
  └── [x] 2.4 Veri katmanı birim testleri

[ ] Faz 3: Navigasyon ve Kimlik Doğrulama (GoRouter & Auth)
  ├── [ ] 3.1 Merkezi GoRouter ve Korumalı Rota (Guard) altyapısı
  ├── [ ] 3.2 StatefulShellRoute.indexedStack ile alt menü navigasyonu
  ├── [ ] 3.3 AuthCubit ve durum yönetimi
  └── [ ] 3.4 Ekran 1: Giriş, Kayıt ve Şifre Sıfırlama (Stitch -> Flutter)

[ ] Faz 4: Öğrenci Akışı ve Ekranları
  ├── [ ] 4.1 DashboardCubit & Ekran 2: Öğrenci Ana Paneli
  ├── [ ] 4.2 DailyReportsCubit, DailyReportFormCubit & Ekran 3: Rapor Listesi ve Formu
  ├── [ ] 4.3 Firebase Storage ile Belge/Dosya Ekleme Entegrasyonu
  ├── [ ] 4.4 InternshipCubit & Ekran 5: İlerleme, Takvim Geçmişi ve Eksik Gün Motoru
  └── [ ] 4.5 ProfileCubit & Profil Ekranı ve Oturum Kapatma

[ ] Faz 5: Kurum Yetkilisi ve Akademik Danışman Onay Akışları
  ├── [ ] 5.1 Kurum Yetkilisi ve Danışman Ana Panelleri
  ├── [ ] 5.2 ApprovalsCubit & Ekran 4: Onay, Puanlama ve Düzeltme Arayüzü
  └── [ ] 5.3 Onay İş Akışı ve İki Aşamalı Güvenlik Kontrolleri

[ ] Faz 6: PDF Staj Defteri Modülü
  ├── [ ] 6.1 features/documents/services/ altında PDF Üretim Servisi
  ├── [ ] 6.2 Türkçe font ve sayfa taşma yönetimi
  └── [ ] 6.3 DocumentsCubit & Ekran 6: PDF Önizleme, Paylaşma ve Dışa Aktarma

[ ] Faz 7: Güvenlik, Test ve Entegrasyon Doğrulaması
  ├── [ ] 7.1 Firestore & Storage Security Rules dosyasının hazırlanması
  ├── [ ] 7.2 Manuel Firebase Kurulum Rehberi (Firebase Console adımları)
  ├── [ ] 7.3 Cubit durum geçiş ve widget testleri
  └── [ ] 7.4 flutter analyze ve dart format kontrolü

[ ] Faz 8: Nihai Kabul, Görsel Doğrulama ve Teslim
  ├── [ ] 8.1 Stitch tasarımı ile nihai görsel karşılaştırma
  ├── [ ] 8.2 Responsive, güvenli alan (SafeArea) ve klavye etkileşim kontrolleri
  └── [ ] 8.3 Proje kabul kriterleri (project.md Madde 11) denetimi
```

---

## Faz Detayları ve Uygulama Adımları

### FAZ 0: Stitch Tasarım Analizi & Token Tespiti [TAMAMLANDI ✅]
- **Adım 0.1: Stitch Çıktısının İncelenmesi ve Eşleştirme [x]**
  - **Proje:** StajTakip Flutter UI/UX System (ID: `7251685105678112873`)
  - **Screen 1 (`44b2b9512de04dd28192a08022130bbc`) -> Ekran 1:** Giriş ve Hesap İşlemleri (`features/auth/`)
  - **Screen 2 (`d09a475d717a40d4a124671fa4a3f99d`) -> Ekran 2:** Rol Bazlı Ana Panel (`features/dashboard/`)
  - **Screen 3 (`bd64f547fba0496f8e4ddc2ec47f27f9`) -> Ekran 3:** Staj Günlüğü ve Rapor Formu (`features/daily_reports/`)
  - **Screen 4 (`6bdb43d10c8b4d0081c50a21a3939a2f`) -> Ekran 4:** Onay ve Puanlama Ekranı (`features/approvals/`)
  - **Screen 5 (`daa10d3d98c64a69add3bd3c50e65e85`) -> Ekran 5:** İlerleme, Geçmiş ve Profil (`features/internship/` & `features/profile/`)
  - **Screen 6 (`7256f0979d954b038d904a924b3656eb`) -> Ekran 6:** PDF Staj Defteri (`features/documents/`)
- **Adım 0.2: Tasarım Token'larının Doğrulanması [x]**
  - **Renkler (`AppColors`):** Primary Navy (`0xFF142D4E`), Primary Blue (`0xFF246BFD`), Accent Teal (`0xFF20A486`), Background (`0xFFF4F7FB`), Surface (`0xFFFFFFFF`), Text Primary (`0xFF182538`), Text Secondary (`0xFF69778B`), Border (`0xFFE3EAF2`), Success (`0xFF16845B`), Warning (`0xFFC78116`), Error (`0xFFC64747`).
  - **Tipografi:** Başlık (28px), Bölüm (20px), Gövde (15px), Yardımcı/Etiket (13px), Buton (15px) — Türkçe karakter uyumlu.
  - **Boşluk & Radius:** 8-pt grid (4, 8, 12, 16, 24, 32px), Buton ve kartlar için 12–16px, etiketler için 8px.
- **Adım 0.3: Durumlar ve Mobil Ergonomi Planlaması [x]**
  - Yükleniyor (`LoadingView`), Boş liste (`EmptyView`), Hata/Ağ hatası (`ErrorView`), Form validasyonları ve SafeArea/klavye payı kuralları netleştirildi.

---

### FAZ 1: Çekirdek Altyapı, Tasarım Sistemi & Ortak Bileşenler [TAMAMLANDI ✅]
- **Adım 1.1: Bağımlılıklar (`pubspec.yaml`) [x]**
  - `flutter_bloc`, `go_router`, `firebase_core`, `firebase_auth`, `cloud_firestore`, `firebase_storage`, `pdf`, `printing`, `file_picker`, `equatable`, `intl`, `mocktail`, `bloc_test` kuruldu.
- **Adım 1.2: Klasör Mimarisi [x]**
  - `architecture.md`'de belirtilen `core/`, `common/`, `data/`, `features/`, `firebase/` ve `test/` yapısı oluşturuldu.
- **Adım 1.3: Tasarım Token'ları & Tema (`core/theme/`) [x]**
  - `AppColors`: Stitch tasarımına göre onaylanmış kurumsal renkler (`app_colors.dart`).
  - `AppTextStyles`: Türkçe karakterleri destekleyen hiyerarşik yazı stilleri (`app_text_styles.dart`).
  - `AppTheme`: Material 3 uyumlu kurumsal açık tema (`app_theme.dart`).
- **Adım 1.4: Çekirdek Araçlar & Hatalar (`core/`) [x]**
  - `AppException` & `Failure`: Firebase hatalarını anlaşılır Türkçe mesajlara çeviren yapı (`app_exception.dart`, `failure.dart`).
  - `AppConstants`: Koleksiyon adları, regex'ler, dosya boyut sınırları (`app_constants.dart`).
  - `DateFormatter` & `WorkdayCalculator`: Türkçe tarih biçimlendirme ve staj çalışma günü/yüzde hesaplayıcı (`date_formatter.dart`, `workday_calculator.dart`).
- **Adım 1.5: Ortak UI Bileşenleri (`common/widgets/`) [x]**
  - `AppButton`: Loading durumunda çift tıklamayı engelleyen buton (`app_button.dart`).
  - `AppTextField`: Şifre gizleme/gösterme, etiket ve hata destekli input (`app_text_field.dart`).
  - `AppCard`: Tutarlı radius, padding ve hafif kenarlıklı kart (`app_card.dart`).
  - `StatusBadge`: Rapor durumlarına (`draft`, `submitted`, `approved`, `revisionRequested`) özel renkli ve ikonlu etiket (`status_badge.dart`).
  - `ProgressCard`: Staj günü ve yüzde gösteren görsel kart (`progress_card.dart`).
  - `LoadingView`, `ErrorView`, `EmptyView`: Standart durum geri bildirimleri.
  - `AttachmentTile`: Dosya önizleme, silme ve yükleme progress çubuğu (`attachment_tile.dart`).
  - `SectionHeader`: Başlık ve aksiyon butonu içeren bölüm başlığı (`section_header.dart`).

---

### FAZ 2: Veri Katmanı (Data Layer: Modeller & Repository'ler) [TAMAMLANDI ✅]
- **Adım 2.1: Veri Modelleri (`data/models/`) [x]**
  - `UserModel`: `uid`, `fullName`, `email`, `role` (`UserRole` enum: student, company, advisor), `institutionId`, `isActive`, `createdAt`.
  - `InternshipModel`: `id`, `studentId`, `companySupervisorId`, `academicAdvisorId`, `companyName`, `startDate`, `endDate`, `requiredDays`, `status` (`InternshipStatus` enum).
  - `DailyReportModel`: `id`, `internshipId`, `studentId`, `workDate`, `tasks`, `learnings`, `hoursWorked`, `attachmentPaths`, `status` (`ReportStatus` enum), `companyApproved`, `advisorApproved`, `revisionComment`, `createdAt`, `updatedAt`, `submittedAt`.
  - `ReviewModel`: `id`, `reportId`, `reviewerId`, `reviewerRole` (`UserRole`), `decision` (`ReviewDecision` enum), `comment`, `score`, `createdAt`.
- **Adım 2.2: Repository Sözleşmeleri (`data/repositories/`) [x]**
  - `AuthRepository`: `signIn`, `signUp`, `signOut`, `sendPasswordReset`, `authStateChanges`, `currentUser`.
  - `UserRepository`: `getUserProfile`, `getUserProfileStream`, `createUserProfile`, `updateUserProfile`.
  - `InternshipRepository`: `getInternshipById`, `getActiveInternshipForStudent`, `getActiveInternshipStream`, `getInternshipsForSupervisor`, `getInternshipsForAdvisor`, `createInternship`, `updateInternship`.
  - `DailyReportRepository`: `getReportsForInternshipStream`, `getReportsForInternship`, `getReportById`, `createReport`, `updateReport`, `submitReport`, `deleteReport`, `hasReportOnDate`, `getApprovedReports`, `getPendingReportsForReview`.
  - `ReviewRepository`: `submitReview`, `getReviewsForReport`, `getReviewsForReportStream`.
  - `DocumentRepository`: `uploadFile`, `deleteFile`, `getDownloadUrl`.
- **Adım 2.3: Repository Implementasyonları [x]**
  - Firebase Auth, Firestore ve Storage çağrıları Repository sınıflarında kapsüllendi (`FirebaseAuthRepository`, `FirebaseUserRepository`, `FirebaseInternshipRepository`, `FirebaseDailyReportRepository`, `FirebaseReviewRepository`, `FirebaseDocumentRepository`).
  - Hata yakalama ve `Failure` nesnesine dönüştürme sağlandı.
  - İnceleme ekleme ve rapor durumu güncellemesinde Firestore `WriteBatch` atomik işlemi uygulandı.
  - Aynı staja aynı gün mükerrer rapor girilmesi engellendi (`hasReportOnDate`).
  - Dosya uzantısı ve 10 MB boyut sınırı denetlendi.
- **Adım 2.4: Model & Repository Testleri [x]**
  - `UserModel`, `InternshipModel`, `DailyReportModel`, `ReviewModel` serialization/deserialization testleri tamamlandı (`test/models/`).
  - `FirebaseAuthRepository` için mocktail tabanlı birim testleri tamamlandı (`test/repositories/auth_repository_test.dart`).

---

### FAZ 3: Navigasyon ve Kimlik Doğrulama (GoRouter & Auth) [TAMAMLANDI ✅]
- **Adım 3.1: GoRouter Altyapısı (`core/router/`) [x]**
  - `route_names.dart` ve `app_router.dart` tamamlandı.
  - `redirect` mekanizması:
    - Giriş yapılmamışsa -> Login sayfasına.
    - Giriş yapılmış ve profil yüklenmişse -> Rolüne uygun dashboard'a (`/student`, `/advisor`, `/company`).
    - Profil yükleniyorsa -> Splash/Loading rotasına (`/splash`).
    - Pasif veya profili henüz açılmamış kullanıcılar -> Bekleme/Hata rotasına (`/pending-approval`).
    - Yetkisiz rotaya doğrudan erişim engellendi ve uygun panele yönlendirildi.
- **Adım 3.2: Alt Menü Navigasyonu (`StatefulShellRoute.indexedStack`) [x]**
  - Öğrenci: Ana Sayfa, Günlüğüm, İlerlemem, Profil (`StudentShell`).
  - Danışman: İncelemeler, Öğrencilerim, Profil (`AdvisorShell`).
  - Kurum Yetkilisi: İncelemeler, Stajyerlerim, Profil (`CompanyShell`).
- **Adım 3.3: `AuthCubit` [x]**
  - Giriş, kayıt, şifre sıfırlama, oturum izleme (`authStateChanges`), profil senkronizasyonu (`getUserProfileStream`).
  - Kendi kendine kayıt esnasında rol yetki yükseltmeyi önlemek için öğrenci (`student`) rolü zorunlu tutuldu.
  - Hata durumları `Failure` ile Türkçeleştirildi.
- **Adım 3.4: Ekran 1 — Giriş ve Hesap İşlemleri (Stitch -> Flutter) [x]**
  - Stitch Screen 1 tasarımına uygun `LoginView`, `RegisterView`, `ForgotPasswordView`, `PendingApprovalView` widget ağaçları tamamlandı.
  - Form validasyonları ve klavye/scroll uyumu sağlandı.
  - Unit ve widget testleri ile %100 başarılı sonuç alındı (24/24 test passed, 0 analyzer warning/error).

---

### FAZ 4: Öğrenci Akışı ve Ekranları [TAMAMLANDI ✅]
- **Adım 4.1: Ekran 2 — Öğrenci Ana Paneli (Dashboard) [x]**
  - `DashboardCubit` ve `DashboardState`: Aktif staj ve günlük rapor akışları, tamamlanan/zorunlu gün hesaplayıcı, sayaçlar (`StatCounterCard`) ve son raporlar listesi (`DashboardReportCard`).
  - `StudentDashboardView` (Stitch Screen 2): Karşılama başlığı, kurum etiketi, `ProgressCard`, durum sayaçları, "Yeni Rapor Ekle" hızlı butonu.
- **Adım 4.2: Ekran 3 — Staj Günlüğü ve Rapor Listesi [x]**
  - `DailyReportsCubit`: Dinamik arama, durum filtre çipleri (Tümü, Onaylananlar, İnceleniyor, Düzeltme İstenen, Taslaklar), taslak rapor silme.
  - `DailyReportsListView`: Arama çubuğu, yatay filtre çipleri, rapor kartları ve FloatingActionButton ile yeni rapora geçiş.
- **Adım 4.3: Rapor Formu (Ekleme / Düzenleme) [x]**
  - `DailyReportFormCubit`: Hafta sonu ve mükerrer gün denetimleri, `FilePicker` ile 10MB boyut ve tip kontrollü belge yükleme, taslak kaydetme ve onaya gönderme.
  - `DailyReportFormView` (Stitch Screen 3): Düzeltme talebi uyarı kartı, tarih seçici dialog, 4/6/8 saat seçimi, yapılan işler ve kazanımlar metin alanları, `AttachmentTile` dosya yönetimi.
- **Adım 4.4: Ekran 5 — İlerleme, Geçmiş ve Eksik Gün Motoru [x]**
  - `InternshipCubit`: Staj başlangıç-bitiş takvimi kronolojik iş günü motoru, eksik gün tespiti (geçmiş raporsuz günler) ve onaylı gün oranları.
  - `InternshipProgressView` (Stitch Screen 5): Büyük ilerleme kartı, eksik gün uyarı bildirim bandı, tıklanabilir iş günü geçmişi zaman çizelgesi.
- **Adım 4.5: Profil Ekranı [x]**
  - `ProfileCubit` ve `StudentProfileView`: Profil kartı, kurum/öğrenci no detayları, aktif staj bilgileri, uygulama sürümü ve onay diyaloglu güvenli çıkış.
- **Router Entegrasyonu [x]**:
  - `StudentShell` içerisindeki tüm alt sekmeler gerçek görünümlerle bağlandı, `/student/journal/form` alt rotası eklendi.
- **Test ve Analiz Doğrulaması [x]**:
  - `flutter analyze lib test` -> `No issues found!`.
  - `flutter test` -> 26/26 test başarılı.

---

### FAZ 5: Kurum Yetkilisi ve Danışman Onay Akışları [TAMAMLANDI ✅]
- **Adım 5.1: Yetkili Ana Panelleri [x]**
  - Kurum Yetkilisi & Akademik Danışman rolleri için rol bazlı bekleyen onay kuyruğu (`ApprovalsCubit`, `ApprovalsListView`).
  - Kurum Yetkilisi için `companyApproved == false`, Danışman için `companyApproved == true && advisorApproved == false` filtreleme mantığı.
  - Atanmış stajyerlerin tam listesi, ilerleme çubukları ve tamamlanan gün oranları (`SupervisedInternsCubit`, `SupervisedInternsListView`).
  - Yetkili profil ve oturum kapatma ekranı (`ReviewerProfileView`).
- **Adım 5.2: Ekran 4 — Onay ve Puanlama Arayüzü [x]**
  - `ApprovalDetailCubit` ve `ApprovalDetailView` (Stitch Screen 4): Öğrenci profili, staj tarihleri, çalışma saatleri, yapılan işler, kazanımlar ve ekli belgeler.
  - İki kademeli onay düğmesi: Kurum Yetkilisi onayladığında rapor `companyApproved = true` ve durum `underReview` kalarak danışmana sevk edilir. Akademik Danışman onayladığında rapor `advisorApproved = true` ve nihai `approved` durumuna geçerek deftere işlenir.
  - Düzeltme İste modal diyaloğu: Zorunlu açıklama girilmeden istek gönderilemez; raporu `revisionRequested` durumuna çevirir ve öğrencinin rapor formuna düzenleme için geri gönderir.
  - Puanlama & değerlendirme: Danışman onayında 100 üzerinden başarı puanı girişi ve doğrulaması.
- **Adım 5.3: Çift Aşamalı Onay Veri Tutarlılığı [x]**
  - `reviews` alt/bağımsız koleksiyonuna atomik `WriteBatch` ile denetim izi (audit log) kaydı (`reviewRepository.submitReview`).
  - Rapor üzerindeki önceki tüm inceleme geçmişi zaman çizelgesi olarak listelenir.
- **Router ve Test Doğrulaması [x]**:
  - `AdvisorShell` ve `CompanyShell` placeholder'ları gerçek görünümlerle donatıldı; `/advisor/approvals/detail` ve `/company/approvals/detail` rotaları eklendi.
  - `flutter analyze lib test` -> `No issues found!`.
  - `flutter test` -> 28/28 test başarılı.

---

### FAZ 6: PDF Staj Defteri Modülü [TAMAMLANDI ✅]
- **Adım 6.1: PDF Üretim Servisi (`features/documents/services/pdf_generator_service.dart`) [x]**
  - Yalnızca çift aşamalı onayı tamamlanmış (`approved` / `advisorApproved == true`) raporları dahil etme kuralı.
  - Resmî kapak sayfası: Öğrenci, kurum, danışman bilgileri, başlangıç-bitiş tarihleri, onaylanan/zorunlu gün ve çalışma saati istatistikleri, imza/kaşe blokları.
  - Kronolojik günlük raporlar: Gün sıra numarası, tarih, çalışma süresi, yapılan işler, kazanımlar ve onay damgaları.
  - Türkçe karakter desteği: `PdfGoogleFonts.roboto` ile tam UTF-8 desteği ve birim testler için yerel font enjeksiyonu.
  - `MultiPage` sayfa taşması ve otomatik sayfa numaralandırma ("Sayfa X / Y").
- **Adım 6.2: Ekran 6 — PDF Önizleme ve İndirme [x]**
  - `DocumentsCubit` ve `DocumentsState`: Firestore üzerinden staj, onaylı raporlar ve yetkili profillerini birleştirip PDF üretimi.
  - `PdfPreviewView` (Stitch Screen 6): Eksik gün varsa uyarı bandı, tamamsa tebrik bandı; özet istatistik çipleri (gün, saat); interaktif `PdfPreview` (yazdırma, paylaşma, PDF kaydetme).
  - Rota ve Erişim: `RouteNames.studentPdfPreview` rotası eklendi; `InternshipProgressView` ve `StudentProfileView` üzerinden doğrudan erişim sağlandı.
- **Test ve Analiz Doğrulaması [x]**:
  - `test/features/documents/pdf_generator_service_test.dart` ve `test/cubits/documents_cubit_test.dart`.
  - `flutter analyze lib test` -> `No issues found!`.
  - `flutter test` -> 32/32 test başarılı.

---

### FAZ 7: Güvenlik, Test ve Entegrasyon Doğrulaması [SIRADAKİ ADIM ⏳]
- **Adım 7.1: Firebase Security Rules**
  - `firestore.rules`: Kullanıcıların yalnızca kendi staj/rapor verilerini okuyup yazabilmesi; kurum ve danışmanın yalnızca atanmış öğrencileri inceleyebilmesi; rol alanının istemciden değiştirilememesi.
  - `storage.rules`: Rapor belgelerine yalnızca ilgili öğrenci ve onay yetkililerinin erişebilmesi.
- **Adım 7.2: Manuel Firebase Kurulum Dokümantasyonu**
  - Konsol üzerinde yapılacak Authentication, Firestore, Storage ve FlutterFire CLI adımlarının listelenmesi.
- **Adım 7.3: Kapsamlı Testler**
  - Model serileştirme testleri.
  - Cubit durum geçiş testleri (Loading -> Success / Error).
  - Kritik widget ve rota testleri.
- **Adım 7.4: Statik Analiz**
  - `dart format .`
  - `flutter analyze` ile 0 warning, 0 error hedefi.

---

### FAZ 8: Nihai Kabul, Görsel Doğrulama ve Teslim
- **Adım 8.1: Stitch Görsel Karşılaştırması**
  - Tipografi, renkler, padding'ler ve ikonların referans tasarımla piksel ve hiyerarşik uyumunun teyidi.
- **Adım 8.2: Mobil Kullanılabilirlik**
  - Klavye açıldığında form taşmalarının (`SingleChildScrollView`, `bottomInset`) önlenmesi.
  - Farklı ekran genişliklerinde responsive testler.
- **Adım 8.3: `project.md` Madde 11 Kriterleri Karşılaştırması**
  - 13 tamamlama kriterinin tek tek doğrulanıp raporlanması.

---

## Sonraki Adım

> [!IMPORTANT]
> Bu plan onaylandıktan sonra geliştirme yapılmayacaktır. Bir sonraki mesajda kullanıcıdan Stitch ekran tasarımları, HTML/CSS kodları ve varsa görsel referanslar beklenecektir. Tasarım geldiğinde Faz 0 (Tasarım Analizi) ile süreç başlatılacaktır.
