# StajTakip — Geliştirme Becerileri ve Çalışma Rehberi

## 1. Amaç

Bu belge, StajTakip projesini geliştiren AI ajanının kullanacağı teknik çalışma rehberidir. Hedef, yalnızca kod üretmek değil; mevcut projeyi anlayarak çalışan, test edilebilir, güvenli ve tasarımla uyumlu özellikler geliştirmektir.

Bu dosya, proje kapsamını belirleyen `project.md`, mimariyi tanımlayan `architecture.md` ve tasarım kurallarını tanımlayan `design-system.md` ile birlikte okunmalıdır.

## 2. Flutter ve Dart

Geliştirme sırasında:
- Null safety kurallarına uy.
- Asenkron işlemlerde `async` ve `await` kullanımını doğru yap.
- Widget ağacını anlaşılır ve küçük bileşenlere ayır.
- Gereksiz `setState` kullanımıyla Cubit sorumluluklarını karıştırma.
- `const` kullanımını uygun yerlerde tercih et.
- Kaynakları ve stream aboneliklerini doğru yönet.
- Hata ve boş veri durumlarını unutma.
- Projenin mevcut Dart/Flutter sürümleriyle uyumlu kod üret.

Kod çalıştırılmadan veya test edilmeden hatasız olduğu iddia edilmemelidir.

## 3. Cubit ve flutter_bloc

Cubit, ekran durumlarını ve kullanıcı işlemlerini yönetir.

Kurallar:
- Her Cubit'in açık bir sorumluluğu olsun.
- UI, Cubit durumunu `BlocBuilder` veya uygun Bloc widget'larıyla izlesin.
- Tek seferlik navigasyon ve bildirim etkileri için uygun `BlocListener` veya `BlocConsumer` kullanılsın.
- Firebase SDK çağrıları Cubit içine yazılmasın.
- Veri işlemleri Repository üzerinden yapılsın.
- Yükleniyor, başarı, boş veri ve hata durumları açıkça ele alınsın.
- İşlem sürerken aynı formun tekrar gönderilmesi engellensin.
- Asenkron işlem sonrasında kapatılmış Cubit'e durum gönderilmesin.
- Gereksiz Cubit oluşturulmasın.
- Birden fazla ekranda kullanılan durumlar doğru yaşam döngüsünde yönetilsin.

Test edilebilirlik için Repository bağımlılıkları Cubit'e enjekte edilmelidir.

## 4. GoRouter

GoRouter yapılandırması merkezi olmalıdır.

- Rota isimleri ve yolları tutarlı tanımlansın.
- Korumalı rotalar oturum durumunu kontrol etsin.
- Rol kontrolü yalnızca ekranda buton gizlemekle sınırlı kalmasın.
- Kullanıcı profili yüklenmeden rol bazlı yönlendirme yapılmasın.
- Giriş, kayıt, şifre sıfırlama, ana panel, rapor formu, onay ve PDF ekranlarının rotaları açıkça belirlensin.
- `StatefulShellRoute.indexedStack` ana alt menü navigasyonu için kullanılsın.
- Alt sayfalara giderken yanlışlıkla yeni bir ana navigasyon kabuğu oluşturulmasın.
- Oturum değişikliği, çıkış ve profil durumu değişiklikleri doğru yönlendirmeyi tetiklesin.
- Yönlendirme döngüleri ve geri tuşu problemleri test edilsin.

## 5. Firebase Authentication

Authentication için aşağıdaki işlemleri destekle:
- E-posta ve şifre ile kayıt.
- E-posta ve şifre ile giriş.
- Çıkış.
- Şifre sıfırlama.
- Oturum durumunu izleme.
- Authentication hatalarını kullanıcıya anlaşılır biçimde gösterme.

Güvenlik kuralları:
- Şifreleri Firestore'a kaydetme.
- Kullanıcı şifresini loglama.
- Rol bilgisini yalnızca formdan gelen değere göre güvenilir kabul etme.
- Kayıt sonrası profil oluşturma hatalarını ele al.
- Oturum kapatıldığında kullanıcıya ait ekran durumlarının temizlenmesini sağla.
- Pasif veya rolü doğrulanamayan kullanıcıya korumalı verilere erişim verme.

## 6. Cloud Firestore

Firestore verileri için:
- Açık veri modelleri kullan.
- Tarih alanlarını uygun Timestamp/DateTime dönüşümleriyle yönet.
- Enum alanlarını doğrula.
- Eksik veya bozuk veriyi kontrollü ele al.
- Sorguları ekranların ihtiyaçlarına göre tasarla.
- Gereksiz belge okumalarını azalt.
- Sayfalama gerekiyorsa uygula.
- Gerekli indeksleri tespit et.
- Kritik çoklu veri işlemlerinde transaction veya batch uygunluğunu değerlendir.
- Onay geçmişini koru.
- Kullanıcının yalnızca yetkili olduğu verileri okuyup yazmasına izin ver.

Firestore'dan gelen veriyi doğrudan, doğrulamasız şekilde UI'ya taşımak yerine uygun model dönüşümlerini kullan.

## 7. Firebase Storage ve Dosya Yükleme

Dosya işlemlerinde:
- `file_picker` ile uygun dosya seçimini yap.
- Desteklenen dosya türlerini ve boyut sınırlarını belirle.
- Dosya adı, türü ve yükleme durumunu göster.
- Yükleme sırasında progress göstergesi gerekiyorsa kullan.
- Başarısız yüklemelerde tekrar deneme olanağı sun.
- Firestore'a Storage dosya yolunu ve gerekli metadata bilgisini kaydet.
- Dosya erişimini kullanıcı ve rapor izinleriyle sınırla.
- Kullanıcı arayüzünde herkese açık erişim gerektirmeyen dosyaları açık bağlantılarla paylaşma.
- Dosya silme ve rapor silme işlemlerinde tutarsızlık riskini değerlendir.

Bir dosyanın uzantısı, içeriğinin güvenli olduğunu tek başına kanıtlamaz.

## 8. Repository Tasarımı

Repository'ler veri erişiminin tek giriş noktasıdır.

Örnek sorumluluklar:
- `AuthRepository`: Authentication işlemleri.
- `UserRepository`: Kullanıcı profilleri ve kontrollü profil güncellemeleri.
- `InternshipRepository`: Staj bilgileri ve atamalar.
- `DailyReportRepository`: Günlük rapor CRUD ve gönderme işlemleri.
- `ReviewRepository`: Onay, düzeltme, yorum ve değerlendirme.
- `DocumentRepository`: Dosya yükleme, erişim ve silme işlemleri.

Repository'ler:
- UI widget'larına bağımlı olmamalıdır.
- Gerektiğinde soyutlanabilir ve testte taklit edilebilir olmalıdır.
- Firebase hatalarını anlaşılır hata sonuçlarına dönüştürmelidir.
- İşlemin başarılı olduğunu doğrulamadan başarı sonucu döndürmemelidir.
- Yetki kontrollerini güvenlik kurallarının yerine geçecek şekilde yalnızca istemcide uygulamamalıdır.

## 9. Onay Süreci ve Veri Tutarlılığı

Onay iş akışı kritik bir iş kuralıdır.

- Kurum yetkilisinin ve danışmanın onayı ayrı ayrı izlenmelidir.
- Raporun mevcut durumu ve sıradaki inceleme aşaması açık olmalıdır.
- Düzeltme isteği açıklama içermelidir.
- Yetkisiz kullanıcı onay veya puanlama yapamamalıdır.
- Eski değerlendirmeler sessizce silinmemelidir.
- Raporun durumu yalnızca geçerli geçişlerle değişmelidir.
- İstemci tarafından gönderilen `approved` değeri tek başına güvenilir kabul edilmemelidir.

Güvenlik açısından kritik durum geçişleri için güvenilir sunucu tarafı doğrulama gereksinimi değerlendirilmelidir. Yalnızca UI kontrolü veya basit bir Firestore alanı, güvenli iş akışı garantisi vermez.

## 10. Staj İlerlemesi

İlerleme hesaplaması için:
- Zorunlu gün sayısı.
- Staj başlangıç ve bitiş tarihleri.
- Geçerli çalışma günleri.
- Aynı güne ait yinelenen kayıtlar.
- Onay koşulları.
- İstisnalar.

açıkça tanımlanmalıdır.

İlerleme hesabını farklı ekranlarda farklı şekilde tekrar yazma. Mümkün olduğunca ortak, test edilebilir bir iş mantığı oluştur.

## 11. PDF Üretimi

PDF işlemlerinde:
- `pdf` paketini belge oluşturmak için kullan.
- `printing` paketini uygun önizleme, yazdırma ve paylaşım işlemleri için kullan.
- Türkçe karakterleri destekleyen fontları kontrol et.
- Uzun açıklamaların sayfa düzenini bozmasını engelle.
- Sayfa numarası ve gerekli belge bilgilerini ekle.
- Onaylanmamış kayıtlar için tanımlı iş kuralını uygula.
- PDF'nin gerçek rapor verilerinden oluşturulmasını sağla.
- Önizleme ile son dosyanın aynı veri ve şablona dayanmasını sağla.

Belirli bir üniversitenin resmî formatı sağlanmamışsa birebir uyumluluk iddia etme.

## 12. Test Becerileri

Her kritik özellikte uygun testler oluştur:
- Model testleri.
- Repository testleri.
- Cubit durum geçiş testleri.
- Form ve widget testleri.
- Router ve oturum testleri.
- Firebase Security Rules testleri.
- Dosya yükleme ve PDF testleri.
- Temel kullanıcı akışı entegrasyon testleri.

Önemli senaryolar:
- Başarısız giriş.
- Eksik kullanıcı profili.
- Yetkisiz role erişim.
- Boş günlük rapor formu.
- Aynı güne tekrar kayıt.
- Başarısız dosya yükleme.
- Düzeltme talebi açıklamasının eksik olması.
- Kurum onayı olmadan danışman aşamasına geçilmesi.
- Öğrencinin başka öğrencinin raporuna erişmeye çalışması.
- Onaysız raporlarla PDF oluşturma isteği.

## 13. Manuel Firebase Kurulumu

Firebase Console üzerinde kullanıcı tarafından yapılması gereken işlemleri otomatik tamamlanmış gibi gösterme.

Gerektiğinde şu adımları tek tek açıkla:
1. Firebase projesini oluşturma.
2. Uygulama platformlarını kaydetme.
3. Paket adı veya bundle identifier doğrulama.
4. FlutterFire CLI kurulumu ve yapılandırma.
5. Authentication yöntemini etkinleştirme.
6. Firestore Database oluşturma.
7. Storage'ı etkinleştirme.
8. Güvenlik kurallarını yapılandırma ve yayımlama.
9. Geliştirme kullanıcılarını ve rollerini hazırlama.
10. Test ve üretim ayarlarını ayırma.

Her adımda yapılacak işlemi, nedenini ve doğrulama yöntemini anlat. Gerekli yetki, faturalandırma veya plan gereksinimi varsa kullanıcıya bildir.

## 14. Stitch Tasarımlarını Uygulama

Stitch tasarımı veya kodu sağlandığında:
1. Tasarımı incele.
2. Mevcut Flutter projesini kontrol et.
3. Ortak bileşenleri ve token'ları belirle.
4. Tasarımı Flutter widget'larına dönüştür.
5. Gerçek veri ve Cubit bağlantısını ekle.
6. Responsive davranışı kontrol et.
7. Görsel karşılaştırma yap.
8. Testleri ve analizi çalıştır.

HTML/CSS kodunu doğrudan Dart dosyasına yapıştırma. Tasarımın görünümünü ve etkileşimini Flutter mimarisine uygun biçimde yeniden oluştur.

## 15. İş Bitirme Kontrol Listesi

Bir görev tamamlandığında:
- Kod ilgili dosyalara yerleştirilmiş olmalı.
- Mevcut mimari korunmuş olmalı.
- Gerçek veri akışı bağlanmış olmalı.
- Hata ve loading durumları ele alınmış olmalı.
- Yetki kontrolleri incelenmiş olmalı.
- İlgili testler çalıştırılmış olmalı.
- `dart format` uygulanmış olmalı.
- `flutter analyze` sonuçları kontrol edilmiş olmalı.
- Manuel Firebase işlemleri gerekiyorsa belgelenmiş olmalı.
- Yapılanlar ve kalan sorunlar kısa şekilde raporlanmış olmalı.

Gerçekten çalıştırılmayan testler başarılı olarak bildirilmemelidir.