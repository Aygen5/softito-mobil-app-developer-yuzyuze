# StajTakip — Flutter Mimari Rehberi

## 1. Mimari Hedefler

Proje, Flutter ve Dart kullanılarak geliştirilecek; anlaşılır, test edilebilir, güvenli ve gerektiğinde genişletilebilir bir mimariye sahip olacaktır.

Temel ilkeler:
- Sorumlulukların ayrılması.
- Tekrarlanan kodun azaltılması.
- Firebase erişiminin Repository katmanında tutulması.
- Cubit ile ekran durumlarının yönetilmesi.
- GoRouter ile merkezi navigasyon.
- Rol ve veri erişim güvenliğinin birlikte uygulanması.
- Gereksiz soyutlamalardan kaçınılması.

Ağır bir Clean Architecture yapısı veya ihtiyaç duyulmayan katmanlar eklenmeyecektir.

## 2. Klasör Yapısı

```text
staj_takip/
├── lib/
│   ├── main.dart
│   ├── app.dart
│   │
│   ├── core/
│   │   ├── config/
│   │   │   └── firebase_options.dart
│   │   ├── constants/
│   │   ├── errors/
│   │   ├── router/
│   │   │   ├── app_router.dart
│   │   │   └── route_names.dart
│   │   ├── theme/
│   │   │   ├── app_theme.dart
│   │   │   ├── app_colors.dart
│   │   │   └── app_text_styles.dart
│   │   └── utils/
│   │
│   ├── common/
│   │   └── widgets/
│   │       ├── app_button.dart
│   │       ├── app_text_field.dart
│   │       ├── app_card.dart
│   │       ├── status_badge.dart
│   │       ├── loading_view.dart
│   │       ├── error_view.dart
│   │       └── empty_view.dart
│   │
│   ├── data/
│   │   ├── models/
│   │   │   ├── user_model.dart
│   │   │   ├── internship_model.dart
│   │   │   ├── daily_report_model.dart
│   │   │   └── review_model.dart
│   │   └── repositories/
│   │       ├── auth_repository.dart
│   │       ├── user_repository.dart
│   │       ├── internship_repository.dart
│   │       ├── daily_report_repository.dart
│   │       ├── review_repository.dart
│   │       └── document_repository.dart
│   │
│   ├── features/
│   │   ├── auth/
│   │   │   ├── cubit/
│   │   │   ├── view/
│   │   │   └── widgets/
│   │   ├── dashboard/
│   │   │   ├── cubit/
│   │   │   ├── view/
│   │   │   └── widgets/
│   │   ├── internship/
│   │   │   ├── cubit/
│   │   │   ├── view/
│   │   │   └── widgets/
│   │   ├── daily_reports/
│   │   │   ├── cubit/
│   │   │   ├── view/
│   │   │   └── widgets/
│   │   ├── approvals/
│   │   │   ├── cubit/
│   │   │   ├── view/
│   │   │   └── widgets/
│   │   ├── documents/
│   │   │   ├── cubit/
│   │   │   ├── view/
│   │   │   └── services/
│   │   └── profile/
│   │       ├── cubit/
│   │       └── view/
│   │
│   └── firebase/
│       └── firebase_service.dart
│
├── test/
│   ├── models/
│   ├── repositories/
│   ├── cubits/
│   └── features/
│
├── pubspec.yaml
└── README.md
```

Bu yapı başlangıç hedefidir. Dosyalar ihtiyaç doğdukça oluşturulmalı, boş klasörler ve kullanılmayan soyutlamalar eklenmemelidir.

Firebase servislerinin doğrudan ekranlarda kullanılmasına izin verilmez. Firebase erişimi Repository sınıfları içinde toplanır. `firebase/` klasörü yalnızca gerçekten gerekli ortak Firebase başlatma veya altyapı yardımcılarını içermelidir; aynı işi yapan ikinci bir veri erişim katmanı oluşturulmamalıdır.

## 3. Katmanların Sorumlulukları

### 3.1. Presentation — `features/` ve `common/`

Ekranlar, widget'lar, formlar ve Cubit sınıfları bu katmanda bulunur.

- `view/`: Tam ekran widget'ları.
- `widgets/`: İlgili özelliğe özgü tekrar kullanılabilir widget'lar.
- `cubit/`: Ekran durumları ve kullanıcı eylemlerinin yönetimi.
- `common/widgets/`: Birden fazla özelliğin kullandığı genel UI bileşenleri.

Ekranlar Firebase SDK'sını doğrudan çağırmamalıdır.

### 3.2. Data — `data/`

Modeller ve Repository sınıfları burada bulunur.

- Model sınıfları Firestore verilerinin Dart nesnelerine dönüştürülmesini sağlar.
- Repository sınıfları veri okuma, oluşturma, güncelleme ve silme işlemlerini yönetir.
- Firebase SDK'sı ile doğrudan iletişim Repository katmanında tutulur.
- Firestore hataları uygun, anlaşılır uygulama hatalarına dönüştürülür.

### 3.3. Core — `core/`

Uygulama genelindeki altyapıyı içerir:
- Router.
- Tema.
- Genel hata türleri.
- Sabitler.
- Gerçekten ortak kullanılan yardımcılar.

### 3.4. Common — `common/`

Birden fazla ekranda kullanılan genel görsel bileşenleri barındırır. İş kurallarına özgü widget'lar burada tutulmaz; ilgili `features` klasöründe kalır.

## 4. Önerilen Bağımlılık Yönü

```text
View / Widget
     ↓
Cubit
     ↓
Repository
     ↓
Firebase SDK
     ↓
Authentication / Firestore / Storage
```

Model sınıfları, veri dönüşümünde Repository tarafından kullanılır.

Bağımlılıklar mümkün olduğunca yukarıdan aşağıya ilerlemelidir. Repository, ekran widget'larına veya Cubit sınıflarına bağımlı olmamalıdır.

## 5. Uygulama Başlatma

`main.dart` sorumlulukları:
1. Flutter binding başlatma.
2. Firebase'in başlatılması.
3. Gerekli Repository ve servislerin hazırlanması.
4. `runApp` çağrısı.

`app.dart` sorumlulukları:
- MaterialApp.router.
- Global tema.
- Router yapılandırması.
- Gerekli üst seviye BlocProvider ve RepositoryProvider tanımları.

Firebase başlatılmadan Firebase servisleri kullanılmamalıdır. Başlatma başarısız olursa uygulama anlaşılır bir hata durumu göstermelidir.

## 6. Firebase Authentication ve Kullanıcı Profili

Authentication, kullanıcı kimliğini ve oturumunu yönetir. Uygulama rolü ve staj atamaları Firestore'da tutulur.

Kayıt akışı:
1. Firebase Authentication hesabı oluşturulur.
2. Yetkili kayıt politikasına göre kullanıcı profili oluşturulur veya yönetici tarafından atanır.
3. Kullanıcı profili doğrulanır.
4. Profil ve rol geçerliyse uygulama ekranlarına erişim verilir.

Hesabın oluşturulması ile profil oluşturulmasının farklı işlemler olduğu unutulmamalıdır. İkinci işlem başarısız olursa tutarsız hesabın nasıl yönetileceği belirlenmelidir.

Rol, istemciden gelen güvenilmeyen bir alan olarak kabul edilmemelidir. Yönetici yetkisi gerekiyorsa güvenilir sunucu tarafı mekanizması veya kontrollü yönetim süreci kullanılmalıdır.

## 7. GoRouter ve Oturum Koruması

Router merkezi olarak `core/router/app_router.dart` içinde tanımlanır.

Kurallar:
- Giriş yapmamış kullanıcı korumalı ekranlara erişemez.
- Oturum açmış kullanıcı gereksiz yere giriş ekranında tutulmaz.
- Oturum durumu yüklenirken yanlış yönlendirme yapılmaz.
- Kullanıcı profili yüklenmeden rol bazlı yönlendirme tamamlanmaz.
- Geçersiz, pasif veya eksik profiller için kontrollü bir hata/erişim bekleme ekranı gösterilir.
- Yetkisiz rol, korumalı rotaya doğrudan URL veya rota adıyla erişemez.
- Yönlendirme döngüleri oluşturulmaz.
- Çıkış işleminden sonra korumalı sayfaya geri dönülemez.

Oturum değişiklikleri GoRouter'ın yeniden değerlendirebileceği bir mekanizmayla takip edilmelidir. Yalnızca ilk açılışta okunan bir oturum değişkenine güvenilmemelidir.

### StatefulShellRoute.indexedStack

Giriş sonrası ana navigasyonda kullanılmalıdır.

Öğrenci sekmeleri:
- Ana Sayfa.
- Günlüğüm.
- İlerlemem.
- Profil.

Kurum yetkilisi ve danışmanın sekme içerikleri role göre uyarlanabilir. Alt menü dışında kalan form, detay ve PDF ekranları uygun korumalı alt rotalar olarak tanımlanmalıdır.

## 8. Cubit Tasarımı

Önerilen Cubit'ler:
- `AuthCubit`
- `DashboardCubit`
- `InternshipCubit`
- `DailyReportsCubit`
- `DailyReportFormCubit`
- `ApprovalsCubit`
- `DocumentsCubit`
- `ProfileCubit`

Her Cubit yalnızca ilişkili işlevin durumlarını yönetmelidir.

Örnek durumlar:
- Initial.
- Loading.
- Success.
- Empty.
- Failure.
- Form validation veya submission durumları.

Birden fazla bağımsız yükleme durumunu tek bir boolean ile yönetmek yerine uygun state sınıfları veya kontrollü durum alanları kullanılmalıdır.

Cubit kuralları:
- Firebase çağrısı doğrudan yapılmaz.
- Repository üzerinden işlem yapılır.
- Hata kullanıcıya gösterilebilecek şekilde ele alınır.
- Asenkron işlem sonrasında Cubit kapatılmışsa emit yapılmaz.
- Çift gönderim ve tekrarlanan işlem riskleri azaltılır.
- İşlem başarıyla tamamlanmadan başarı durumu gösterilmez.

## 9. Veri Modelleri

### UserModel

Önerilen alanlar:
- `uid`
- `fullName`
- `email`
- `role`
- `institutionId`
- `isActive`
- `createdAt`

Rol değerleri kontrollü enum olarak tanımlanmalıdır:
- `student`
- `company`
- `advisor`

İhtiyaç duyulan alanlar, gerçek iş akışına göre genişletilebilir.

### InternshipModel

Önerilen alanlar:
- `id`
- `studentId`
- `companySupervisorId`
- `academicAdvisorId`
- `companyName`
- `startDate`
- `endDate`
- `requiredDays`
- `status`

Birden fazla öğrenci veya danışman ilişkisi gerekiyorsa veri modeli açıkça genişletilmelidir.

### DailyReportModel

Önerilen alanlar:
- `id`
- `internshipId`
- `studentId`
- `workDate`
- `tasks`
- `learnings`
- `hoursWorked`
- `attachmentPaths`
- `status`
- `createdAt`
- `updatedAt`
- `submittedAt`

### ReviewModel

Önerilen alanlar:
- `id`
- `reportId`
- `reviewerId`
- `reviewerRole`
- `decision`
- `comment`
- `score`
- `createdAt`

Puan isteğe bağlı olabilir; yalnızca yetkili rolün değerlendirme yapması durumunda kullanılmalıdır.

## 10. Firestore Veri Yapısı

Başlangıç koleksiyonları:

```text
users/{uid}
internships/{internshipId}
dailyReports/{reportId}
reviews/{reviewId}
```

`users` kullanıcı profilini, `internships` staj ilişkilerini, `dailyReports` günlük kayıtları, `reviews` ise onay ve düzeltme geçmişini tutar.

İnceleme geçmişi ayrı tutulmalıdır. Yeni bir değerlendirme, önceki kararları sessizce ezmemelidir.

Rapor durumları için kontrollü enum kullanılmalıdır. Örneğin:
- `draft`
- `submitted`
- `revisionRequested`
- `approved`

Kurum ve danışman onaylarının ayrı ayrı tutulması gerekir. Tek bir rapor durumu, tüm onay aşamalarını belirsiz hale getirmemelidir. Nihai onay, gerekli aşamaların tamamlandığı doğrulandıktan sonra belirlenmelidir.

Firestore sorguları, indeks ihtiyacı ve koleksiyon yapısı gerçek ekranların veri gereksinimlerine göre tasarlanmalıdır. Gereksiz iç içe koleksiyonlar veya aşırı veri kopyalama kullanılmamalıdır.

## 11. Repository Sözleşmeleri

Repository'ler uygulamanın veri erişim API'sidir.

Örnek sorumluluklar:

- `AuthRepository`: Giriş, kayıt, çıkış, şifre sıfırlama ve oturum akışı.
- `UserRepository`: Profil okuma ve yetkili profil güncelleme.
- `InternshipRepository`: Staj kayıtları ve atamalar.
- `DailyReportRepository`: Rapor oluşturma, okuma, güncelleme ve gönderme.
- `ReviewRepository`: Onay, düzeltme, yorum ve değerlendirme kayıtları.
- `DocumentRepository`: Storage dosya yükleme, indirme veya erişim işlemleri.

İstemcide yapılan rol kontrolleri kullanıcı deneyimini yönetir; gerçek yetki denetimi Firestore ve Storage kurallarıyla sağlanır.

Bir işlem birden fazla kritik veri güncellemesi gerektiriyorsa Firestore transaction veya batch uygunluğu değerlendirilmelidir. İstemci tarafında doğrulanan kuralların, kötü niyetli istekleri de engelleyeceği varsayılmamalıdır.

## 12. Firebase Storage ve Dosya İşlemleri

- Dosyalar Storage'da tutulur.
- Firestore'da dosyanın yolu, adı, türü ve gerekirse boyutu tutulur.
- Dosya uzantısına tek başına güvenilmez.
- Dosya türü ve boyutu kontrol edilir.
- Yükleme sırasında loading, success ve failure durumları gösterilir.
- Yetkisiz kullanıcılar dosyalara erişemez.
- Silme veya değiştirme işlemleri dosya sahipliği ve rapor durumuna göre korunur.
- Kullanılmayan dosyalar için güvenli temizlik stratejisi belirlenir.

Storage erişim bağlantılarının herkese açık olmasına gerek yoksa kalıcı herkese açık bağlantılar kullanılmamalıdır.

## 13. PDF Üretimi

PDF oluşturma mantığı UI widget'larından ayrılmalıdır.

`features/documents/services/` altında gerektiğinde bir PDF oluşturma servisi tutulabilir.

Servis:
- Onay koşullarını kontrol etmek için gerekli veriyi alır.
- Raporları tarih sırasına göre düzenler.
- Tanımlanmış şablona göre sayfa düzenini üretir.
- Türkçe karakterleri destekleyen font kullanır.
- Uzun metinlerin sayfaya taşmasını yönetir.
- Sayfa numarası ve gerekli üstbilgi/altbilgi alanlarını ekler.
- PDF çıktısını `printing` ile önizleme, paylaşma veya yazdırma akışına aktarır.

PDF üretimi sırasında eksik raporlar veya tamamlanmamış onaylar varsa kullanıcıya anlaşılır açıklama gösterilir.

## 14. Hata Yönetimi

Hatalar kullanıcıya ham Firebase hata mesajlarıyla gösterilmemelidir.

- Ağ hataları.
- Yetki hataları.
- Doğrulama hataları.
- Oturum hataları.
- Dosya yükleme hataları.
- PDF üretim hataları.

Bu durumlar anlaşılır kullanıcı mesajlarına dönüştürülmelidir. Geliştirme sırasında hata ayrıntıları güvenli biçimde loglanabilir; şifre, token ve kişisel belge içerikleri loglanmamalıdır.

## 15. Test Mimarisi

- Model dönüşüm testleri.
- Repository testleri.
- Cubit durum geçiş testleri.
- Widget testleri.
- GoRouter yönlendirme testleri.
- Firestore ve Storage Security Rules testleri.
- Temel kullanıcı akışları için entegrasyon testleri.

Repository testlerinde uygun yerlerde sahte veya taklit veri kaynakları kullanılabilir. Bu test verileri uygulamanın gerçek çalışma zamanındaki kalıcı veri kaynağı değildir.

Firebase Local Emulator Suite, güvenlik kurallarını gerçek projeye zarar vermeden test etmek için tercih edilmelidir.

## 16. Kod Kalitesi

- Anlamlı sınıf ve değişken adları kullan.
- Tek dosyada gereğinden fazla sorumluluk toplama.
- Gereksiz soyutlama ve bağımlılık ekleme.
- İş mantığını widget'ların içine gömme.
- Sabitleri ve renkleri merkezi tanımla.
- Hata durumlarını göz ardı etme.
- Asenkron işlemleri doğru yönet.
- `dart format` ve `flutter analyze` çalıştır.
- Kritik davranışlar için test yaz.
- Çalışmayan kodu çalışıyormuş gibi raporlama.

## 17. Manuel Firebase İşlemleri

AI, yerel kodu hazırlayabilir; ancak kullanıcı hesabındaki Firebase Console işlemlerinin yapıldığını varsayamaz.

Gerektiğinde kullanıcıya adım adım şu işlemleri anlat:
1. Firebase projesi oluşturma.
2. Android/iOS uygulamalarını projeye ekleme.
3. Uygulama kimliklerini doğrulama.
4. FlutterFire CLI ile yapılandırma.
5. Authentication giriş yöntemlerini etkinleştirme.
6. Firestore Database oluşturma.
7. Storage'ı etkinleştirme ve uygun plan/konum gereksinimlerini kontrol etme.
8. Güvenlik kurallarını yayımlama.
9. Test kullanıcıları ve rol atamalarını hazırlama.
10. Geliştirme ve üretim ortamlarını ayırma.

Her adımda ne yapılacağı, neden gerektiği ve işlemin tamamlandığının nasıl doğrulanacağı kısa ve anlaşılır şekilde açıklanmalıdır.