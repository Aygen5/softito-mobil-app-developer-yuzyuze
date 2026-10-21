# StajTakip — Proje Tanımı ve Gereksinimler

## 1. Proje Özeti

StajTakip, öğrencilerin staj süreçlerini dijital ortamda yönetmesini sağlayan bir Flutter mobil uygulamasıdır. Öğrenciler günlük çalışma kayıtlarını oluşturabilir, dosya ve belge ekleyebilir, staj ilerlemelerini takip edebilir ve staj defterlerini PDF formatında oluşturabilir. Kurum yetkilileri ve akademik danışmanlar ise kendilerine atanmış öğrencilerin raporlarını inceleyebilir, onaylayabilir, düzeltme isteyebilir ve yetkileri dahilinde değerlendirme yapabilir.

Uygulama tek bir mobil uygulama olarak geliştirilecektir. Kullanıcıların ekranları ve işlem izinleri, yetkili süreçle belirlenen rollerine göre değişecektir.

## 2. Projenin Amacı

- Geleneksel staj defteri ve imza süreçlerini dijitalleştirmek.
- Günlük staj kayıtlarını düzenli ve erişilebilir şekilde saklamak.
- Öğrenci, kurum yetkilisi ve akademik danışman arasındaki onay sürecini kolaylaştırmak.
- Staj ilerlemesini şeffaf biçimde göstermek.
- Onaylı staj kayıtlarından PDF formatında staj defteri oluşturmak.
- Yetkisiz erişimi engellemek ve işlem geçmişini korumak.

## 3. Kesin Teknolojiler

- Flutter ve Dart.
- Material 3 tabanlı mobil arayüz.
- GoRouter ile sayfa yönlendirme ve oturum kontrolü.
- StatefulShellRoute.indexedStack ile alt menü navigasyonu.
- flutter_bloc ve Cubit ile durum yönetimi.
- Firebase Authentication ile kullanıcı kimlik doğrulama.
- Cloud Firestore ile kalıcı veri yönetimi.
- Firebase Storage ile dosya ve belge depolama.
- pdf ve printing paketleriyle PDF oluşturma ve çıktı işlemleri.
- file_picker ile cihazdan dosya seçme.
- flutter_test ve uygun test araçlarıyla otomatik testler.

Paketlerin sürümleri projenin mevcut Flutter/Dart sürümleriyle uyumlu seçilmelidir. Gereksiz paket eklenmemelidir.

## 4. Kullanıcı Rolleri

### 4.1. Öğrenci

- Giriş yapabilir ve hesabıyla ilişkili profil bilgilerini görüntüleyebilir.
- Kendisine ait staj bilgilerini görüntüleyebilir.
- Günlük çalışma raporu oluşturabilir ve taslak kaydedebilir.
- İzin verilen durumlarda kendi raporlarını düzenleyebilir.
- Raporlara belge veya dosya ekleyebilir.
- Raporlarını onaya gönderebilir.
- Onay, bekleme ve düzeltme durumlarını takip edebilir.
- Düzeltme istenen raporları düzenleyip yeniden gönderebilir.
- Staj gün sayısı ilerlemesini görüntüleyebilir.
- Uygun kayıtlarından PDF staj defteri oluşturabilir.
- Kendi profilini görüntüleyebilir ve oturumu kapatabilir.

### 4.2. Kurum Yetkilisi

- Yalnızca kendisine atanmış stajyerleri ve izin verilen kayıtları görüntüleyebilir.
- İnceleme bekleyen günlük raporları açabilir.
- Rapor açıklamalarını ve ekli belgeleri inceleyebilir.
- Raporu onaylayabilir veya açıklama girerek düzeltme isteyebilir.
- Kendisine tanımlanmışsa değerlendirme puanı verebilir.
- Atanmış öğrencilerin ilerlemelerini takip edebilir.

### 4.3. Akademik Danışman

- Yalnızca yetkili olduğu öğrencileri ve kayıtları görüntüleyebilir.
- Gerekli önceki onay aşaması tamamlanan raporları inceleyebilir.
- Raporu onaylayabilir veya düzeltme isteyebilir.
- Yetkisi dahilinde puanlama ve değerlendirme yapabilir.
- Öğrencilerin staj ilerlemelerini ve eksik kayıtlarını takip edebilir.

### Rol güvenliği

Kullanıcılar kayıt formundan kendilerine serbestçe yetki veremez. Rol ve öğrenci-danışman-kurum atamaları güvenilir bir süreçle yönetilmelidir.

Arayüzde buton gizlemek tek başına yetki kontrolü değildir. Yetkisiz okuma ve yazma işlemleri Firestore ve Storage güvenlik kurallarıyla da engellenmelidir.

## 5. Kesin Ekranlar

### Ekran 1: Giriş ve hesap işlemleri

- E-posta ve şifre ile giriş.
- Yeni hesap oluşturma.
- Şifre sıfırlama.
- Form doğrulama.
- Yükleniyor, başarılı ve hata durumları.
- Oturum açma ve çıkış işlemleri.

### Ekran 2: Rol bazlı ana panel

Öğrenci paneli:
- Staj ilerleme kartı.
- Tamamlanan ve zorunlu staj günü.
- Onaylanan, bekleyen ve düzeltme istenen rapor sayıları.
- Son raporlar.
- Günlük rapor ekleme kısayolu.

Kurum yetkilisi paneli:
- İnceleme bekleyen raporlar.
- Atanmış stajyerler.
- Onay ve düzeltme sayıları.

Akademik danışman paneli:
- Akademik inceleme bekleyen raporlar.
- Atanmış öğrenciler.
- Öğrenci ilerlemeleri ve değerlendirmeler.

### Ekran 3: Staj günlüğü ve rapor formu

Günlük rapor listesi:
- Tarih.
- Kısa iş özeti.
- Rapor durumu.
- Filtreleme.
- Yeni rapor oluşturma.

Rapor formu:
- Tarih seçimi.
- Yapılan işler.
- Öğrenilenler ve kazanımlar.
- Çalışma süresi.
- Belge ve dosya ekleme.
- Taslak kaydetme.
- Onaya gönderme.
- Düzeltme açıklamasını görüntüleme.

### Ekran 4: Onay ve puanlama

- İnceleme bekleyen rapor listesi.
- Rapor ayrıntıları.
- Ekli belgeler.
- Onay aşaması ve durum bilgisi.
- Onaylama.
- Açıklamalı düzeltme talebi.
- Yetkili kullanıcılar için puanlama ve değerlendirme.

### Ekran 5: İlerleme, geçmiş ve profil

- Staj günü ilerleme çubuğu.
- Tarihe göre rapor geçmişi.
- Rapor durumları.
- Staj başlangıç ve bitiş tarihleri.
- Eksik kayıtlar.
- Kullanıcı profili ve oturum kapatma.

### Ekran 6: PDF staj defteri

- Öğrenci ve kurum bilgileri.
- Staj tarih aralığı.
- Dahil edilecek günlük kayıtlar.
- Eksik veya onaysız kayıt kontrolü.
- PDF oluşturma.
- PDF önizleme.
- Uygun platformlarda kaydetme, paylaşma veya yazdırma.

Resmî PDF formatı, hedef üniversitenin sağladığı gerçek şablona göre uyarlanmalıdır. Şablon sağlanmadıysa genel, düzenlenebilir bir format hazırlanmalı ve resmî şablonla birebir uyum sağlandığı iddia edilmemelidir.

## 6. Temel İş Akışı

1. Kullanıcı Firebase Authentication ile giriş yapar.
2. Firestore üzerinden kullanıcı profili ve rol bilgisi yüklenir.
3. Kullanıcı, rolüne uygun ana panele yönlendirilir.
4. Öğrenci günlük raporunu oluşturur ve taslak olarak kaydedebilir.
5. Öğrenci raporunu onaya gönderir.
6. Kurum yetkilisi gerekli incelemeyi yapar.
7. Kurum onayından sonra rapor akademik danışmana iletilir.
8. Herhangi bir aşamada düzeltme istenirse açıklama kaydedilir ve rapor öğrenciye geri döner.
9. Gerekli onaylar tamamlandığında rapor kesinleşir.
10. Uygun ve onaylı kayıtlar PDF staj defterine dahil edilir.

Kurum onayı ile akademik danışman onayının hangi sırayla tamamlanacağı iş akışında açıkça belirtilmelidir. Tek bir onay alanı, iki farklı onay aşamasını temsil etmek için kullanılmamalıdır.

## 7. Staj Günü Hesaplama Kuralları

- Tamamlanan gün sayısı yalnızca rapor sayısından hesaplanmamalıdır.
- Geçerli staj tarihi ve çalışma günü kuralları dikkate alınmalıdır.
- Aynı staj için aynı tarihe birden fazla geçerli günlük kayıt oluşturulması engellenmelidir.
- Bir günün tamamlanmış sayılması için gereken onay koşulları açıkça tanımlanmalıdır.
- İlerleme hiçbir durumda zorunlu gün sayısını aşan hatalı bir yüzde göstermemelidir.
- Başlangıç, bitiş, hafta sonu, resmî tatil ve istisna kuralları gerektiğinde ayrıca tanımlanmalıdır.
- Onaylanan kayıtların sayısı ile tamamlanan staj günü sayısı farklı kavramlar olarak ele alınmalıdır.

## 8. Veri Yönetimi

Veriler CSV veya elle hazırlanmış JSON dosyalarından okunmayacaktır. Kalıcı uygulama verileri Cloud Firestore'da tutulacaktır.

Başlangıç koleksiyonları:
- `users`
- `internships`
- `dailyReports`
- `reviews`

Dosyalar Firebase Storage'da tutulacak; Firestore'da dosya yolları ve gerekli metadata bilgileri saklanacaktır.

Temel veri modelleri:
- UserModel
- InternshipModel
- DailyReportModel
- ReviewModel

Alanlar, doğrulamalar ve veri dönüşümleri `architecture.md` dosyasındaki kurallara uygun geliştirilmelidir.

## 9. Arayüz ve Tasarım

- Bütün kullanıcıya görünen metinler Türkçe olmalıdır.
- Türkçe karakterler doğru kullanılmalıdır.
- Mobil ekranlara uygun, responsive Flutter arayüzü hazırlanmalıdır.
- Stitch tasarımları için `design-system.md` kuralları uygulanmalıdır.
- Ekranlar ortak renk, tipografi, boşluk ve bileşen sistemini kullanmalıdır.
- Yükleniyor, boş veri, hata, başarılı işlem ve form doğrulama durumları tasarlanmalıdır.
- Sahte veriler üretim kodunda kalıcı veri kaynağı olarak kullanılmamalıdır.

## 10. Kapsam Dışı İşler

İlk sürümde gereksiz karmaşıklık eklenmemelidir. Aşağıdaki özellikler zorunlu değildir:
- Sohbet sistemi.
- Yapay zekâ ile rapor yazma.
- Karmaşık yönetici analitiği.
- Push bildirim altyapısı.
- Birden fazla üniversiteye özel gelişmiş yönetim paneli.

Bunlar ancak temel özellikler tamamlandıktan ve açık bir ihtiyaç oluştuğunda değerlendirilebilir.

## 11. Tamamlanma Kriterleri

Proje ancak aşağıdaki koşullar sağlandığında temel sürüm açısından tamamlanmış kabul edilir:

- Firebase Authentication giriş ve çıkış işlemleri çalışır.
- Kullanıcı profili ve rol bilgisi güvenilir şekilde yüklenir.
- GoRouter korumalı rotaları doğru yönetir.
- Rol bazlı paneller doğru kullanıcıya açılır.
- Günlük rapor oluşturma, listeleme ve düzenleme işlemleri çalışır.
- Dosya yükleme ve dosya erişimi güvenli şekilde uygulanır.
- Kurum ve akademik danışman onayları ayrı ayrı yönetilir.
- Düzeltme talebi ve açıklaması kaydedilir.
- Staj ilerlemesi tanımlanmış kurallara göre hesaplanır.
- PDF oluşturma ve önizleme çalışır.
- Firestore ve Storage güvenlik kuralları test edilir.
- Kritik işlevler için otomatik testler yazılır.
- README dosyasında kurulum ve manuel Firebase adımları açıklanır.