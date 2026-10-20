# Yörünge — Girişimcilik Platformu

## 1. Proje Kimliği

**Uygulama adı:** Yörünge  
**Ürün tanımı:** Girişimcileri mentorlar, yatırımcılar, destek programları ve diğer girişimcilerle buluşturan mobil platform.  
**Platform:** Flutter  
**Programlama dili:** Dart  
**Tasarım sistemi:** Material 3 üzerine kurulu, özel tasarım bileşenleriyle zenginleştirilmiş mobil arayüz.  
**Proje kapsamı:** Eğitim, portfolyo ve demo amaçlı mobil uygulama.

Yörünge, girişimcilik yolculuğunun farklı aşamalarındaki kişilerin ihtiyaç duydukları kaynakları tek bir mobil uygulama üzerinden keşfedebilmelerini amaçlar.

Uygulama; yalnızca girişim fikirlerinin sergilendiği bir katalog değil, fikir geliştirme, uzmanlarla bağlantı kurma, finansman seçeneklerini keşfetme ve şirketleşme sürecini anlama deneyimlerini bir araya getiren bütünleşik bir platform olarak tasarlanacaktır.

## 2. Vizyon ve Temel Problem

Bir girişimci, fikrini geliştirmek isterken birçok farklı soruyla karşılaşır:

- Fikrimi nasıl doğrulayabilirim?
- Hangi uzmanlardan mentorluk alabilirim?
- Hangi yatırımcılar benim sektörümle ilgileniyor?
- Hangi hibe ve destek programlarına başvurabilirim?
- Benim gibi girişimcilerle nasıl iletişim kurabilirim?
- Fikrimi şirketleştirmek için hangi aşamalardan geçmem gerekir?

Yörünge, bu ihtiyaçları tek bir deneyimde birleştirir.

### Temel değer önerisi

**Fikrini keşfet, doğru insanlarla buluş ve girişimini ileriye taşı.**

Uygulamanın görsel dili de bu vizyonu destekler. Uzay, yörünge, yıldızlar, nebula ve roket fırlatışı metaforları; kullanıcının bir fikirden sürdürülebilir bir girişime doğru ilerlemesini temsil eder.

## 3. Hedef Kullanıcılar

### Birincil kullanıcılar

- Henüz fikrini geliştirme aşamasında olan girişimciler.
- İş planını doğrulamak ve geliştirmek isteyen kurucular.
- Yatırım ve finansman olanaklarını araştıran girişimciler.
- Mentorluk ve sektörel bağlantı arayan kişiler.
- Şirketleşme süreci hakkında bilgi edinmek isteyen girişimciler.

### İkincil kullanıcılar

- Mentorlar ve sektör uzmanları.
- Melek yatırımcılar ve girişim sermayesi fonları.
- Kamu ve özel sektör destek programları.
- Kuluçka merkezleri ve hızlandırma programları.
- Girişimcilik topluluğunun diğer üyeleri.

### Desteklenen 5 Kullanıcı Rolü

Yörünge platformu, **tek uygulama ve tek ortak arayüz** prensibiyle 5 farklı rolü destekler:

1. **`entrepreneur` (Girişimci):** Fikir geliştiren, iş planı hazırlayan, mentorluk/yatırım talebi gönderen ve toplulukta (onaylandığında) paylaşım yapan birincil aktör.
2. **`investor` (Yatırımcı):** Girişimleri ve destek programlarını keşfeden, ekosistemi inceleyen, kendi yatırımcı profilini yöneten sermaye sağlayıcısı.
3. **`mentor` (Mentor):** Uzmanlık havuzunda yer alan, girişimleri inceleyen, kendi mentor profilini düzenleyen danışman. Kendisine mentorluk talebi gönderemez.
4. **`programProvider` (Kurum Temsilcisi / Program Sağlayıcı):** Destek, hibe ve hızlandırma programları açan, başvuru süreçlerini takip eden ve programlarını yöneten aktör.
5. **`admin` (Platform Yöneticisi):** Ekosistemin denetimini sağlayan, tüm operasyonel işlemleri ve demo kullanıcı yönetimini yürütebilen tam yetkili rol.

Bu sürümde bütün roller tek bir mobil demo deneyimi içerisinde temsil edilir. Gerçek sunucu yetkilendirmesi veya harici veritabanı bulunmaz; tüm yetki kontrolleri yerel `PermissionService` ile yönetilir.

## 4. Temel Ürün İlkeleri

1. **Keşfedilebilirlik:** Kullanıcı aradığı mentor, yatırımcı veya programı kolayca bulabilmelidir.
2. **Tutarlılık:** Bütün ekranlar ortak bir tasarım sistemi kullanmalıdır.
3. **Güvenilir sunum:** Örnek içerikler gerçek işlem, gerçek yatırım teklifi veya resmî onay gibi gösterilmemelidir.
4. **Anlamlı etkileşim:** Arama, filtreleme, eşleşme, form doldurma, taslak kaydetme ve topluluk etkileşimleri çalışmalıdır.
5. **Yerel veriyle işlevsellik:** Demo kapsamındaki işlemler uygulama içinde tutarlı biçimde çalışmalıdır.
6. **Genişletilebilirlik:** Yeni özellikler mevcut mimariyi bozmadan eklenebilmelidir.
7. **Erişilebilirlik:** Okunabilir metinler, yeterli kontrast, uygun dokunma alanları ve erişilebilir etiketler kullanılmalıdır.

## 5. Teknik ve İşlevsel Kapsam

Uygulama Flutter ve Dart ile geliştirilecektir. Material 3 kullanılacak, ancak varsayılan Material bileşenleri Yörünge'nin özel tasarım sistemiyle uyumlu hâle getirilecektir.

### Veri ve entegrasyon sınırları

- Mentor, yatırımcı, destek programı, topluluk gönderileri ve kabul edilmiş girişim örnekleri yerel mock verilerden sağlanır.
- Gerçek backend, uzak API, veritabanı sunucusu veya üçüncü taraf ödeme entegrasyonu bulunmaz.
- Tema tercihi ve iş planı taslağı cihazda saklanır.
- Tema tercihi ve taslak saklama için `shared_preferences` kullanılabilir.
- Harici bağlantı açma veya takvime ekleme işlemleri destekleniyorsa, platformun mevcut imkânları üzerinden başlatılır. Bu işlemler gerçek başvuru, ödeme veya rezervasyon tamamlandığı anlamına gelmez.
- İnternet bağlantısı gerektiren bir servis varmış gibi sahte yükleme veya başarı mesajları üretilmez.

### Örnek veri ve gerçeklik ilkesi

Mock veri, yalnızca uygulamanın demo içeriğidir. Gerçek dünyaya ait kurumlar veya programlar gösteriliyorsa içerikler doğrulanmış güncel bilgi gibi sunulmamalıdır. Gerçeklik doğrulanamıyorsa örnek adlar kullanılmalı ve demo içeriği olduğu açıkça belirtilmelidir.

Hukuki süreç, şirketleşme, yatırım ve gelir desteği ekranları bilgilendirici demo ekranlarıdır. Hiçbir içerik hukuki danışmanlık, yatırım garantisi, resmî kabul veya kesin gelir taahhüdü olarak sunulamaz.

## 6. Uygulama Navigasyonu

Uygulamanın ana ekranı dört temel sekmeden oluşur:

1. Mentorlar
2. Yatırımcılar
3. Programlar
4. Topluluk

Üst alanda uygulama kimliği, tema değiştirme kontrolü ve kullanıcının fikir durumuna ulaşabileceği profil/durum rozeti bulunur.

Ana sekmeler `IndexedStack` ile korunur. Kullanıcı başka bir sekmeye geçip geri döndüğünde önceki sekmenin kaydırma konumu ve filtre durumu mümkün olduğunca korunmalıdır.

Fikir Durumu ve Analiz ekranları ana alt navigasyona ek birer ana sekme değildir. Bunlara ilgili aksiyonlardan, durum rozetinden veya başvuru akışından ulaşılır.

## 7. Özellikler

### 7.1 Mentorlar

Amaç: Girişimcilerin ihtiyaçlarına uygun mentorları keşfetmesi ve eşleşme talebinde bulunması.

Kapsam:

- En az 9 ayrıntılı mentor profili.
- İsim, uzmanlık, sektör, deneyim ve kısa tanıtım bilgileri.
- Metin araması.
- Sektör ve uzmanlık filtreleri.
- Öne çıkan mentorların yatay listesi.
- Mentor detay ekranı veya ayrıntılı profil görünümü.
- Eşleşme isteği akışı.

Eşleşme durumları:

- İstek yok.
- Beklemede.
- Eşleşti.

Bu durumlar demo kapsamında yerel controller üzerinden yönetilir. Gerçek mentora bildirim gönderilmez.

### 7.2 Yatırımcılar

Amaç: Girişimcilerin farklı yatırımcı türlerini ve yatırım profillerini keşfetmesi.

Kategoriler:

- Şirketler.
- Holdingler.
- Melek yatırımcılar.
- Girişim sermayesi fonları (VC).

Veri kapsamı: Her kategoride 4 profil olmak üzere en az 16 yatırımcı.

Filtreler:

- Yatırım kategorisi.
- Yatırım aşaması: örneğin tohum, erken aşama ve Seri A.
- Yatırım bileti büyüklüğü aralığı.
- İlgilenilen sektör.

Profil içeriği:

- İsim ve kategori.
- Yatırım odağı.
- İlgilendiği sektörler.
- Yatırım aşamaları.
- Uygun olduğunda örnek yatırım aralığı.
- Demo kapsamına uygun iletişim aksiyonu.

Yatırım tutarları ve yatırımcı profilleri örnek içerik olarak açıkça işaretlenmelidir. Gerçek yatırım taahhüdü veya yatırımcı onayı izlenimi verilmemelidir.

### 7.3 Destek Programları

Amaç: Girişimcilerin farklı destek ve hızlandırma seçeneklerini keşfetmesi.

Kategoriler:

- Hibe programları.
- Devlet destekleri.
- Yurt dışı destekleri.
- Özel sektör fonları.
- Kuluçka ve hızlandırma merkezleri.

Veri kapsamı: Her kategoride 3 program olmak üzere en az 15 destek programı.

Her program aşağıdaki bilgileri içerebilir:

- Program adı.
- Kategori.
- Kısa açıklama.
- Hedef kitle.
- Destek türü.
- Örnek destek aralığı veya destek biçimi.
- Son başvuru tarihi.
- Başvuru durumu.

Durumlar:

- Açık.
- Yakında.
- Kapandı.

Etkileşimler:

- Kategori filtreleme.
- Program ayrıntıları.
- Başvuru adımlarını gösteren modal veya alt sayfa.
- Takvime ekleme aksiyonu.

Tarih ve durumlar demo verileridir. Gerçek tarihler doğrulanmadıkça güncel başvuru bilgisi olarak gösterilmemelidir. Takvime ekleme işlemi platform tarafından desteklenmiyorsa başarılı olmuş gibi davranılmamalıdır.

### 7.4 Topluluk

Amaç: Girişimcilerin fikirlerini paylaşabileceği ve diğer girişimcilerin deneyimlerini keşfedebileceği mikro-paylaşım akışı sunmak.

Kapsam:

- En az 13 örnek gönderi.
- Gönderi metni için 280 karakter sınırı.
- Gönderi beğenme.
- Tek seviyeli yanıtlar.
- Gönderi oluşturma.
- Gönderi ve yanıt sayaçları.
- Onaylı girişimci durumuna bağlı etkileşim yetkisi.

Yetkilendirme kuralı:

- Onaylanmamış kullanıcılar gönderileri okuyabilir.
- Yalnızca onaylanmış girişimciler paylaşım yapabilir, beğenebilir ve yanıt yazabilir.
- Bu kural sadece arayüzde değil, `ToplulukController` içinde de uygulanır.
- Yetki yoksa controller işlemi reddeder ve UI anlaşılır bir bilgilendirme gösterir.

Demo kullanıcı durumu yerel olarak tanımlanabilir. Bu mekanizma gerçek kimlik doğrulama veya güvenli sunucu yetkilendirmesi yerine geçmez.

### 7.5 Analiz — 8 Adımlı İş Planı

Amaç: Girişimcinin iş fikrini yapılandırılmış bir form üzerinden değerlendirmeye hazırlaması.

Form adımları:

1. **Fikir Özeti:** Fikir adı, sektör, problem, çözüm ve hedef kitle.
2. **Ekip:** Kişi sayısı, eğitim, roller ve ekip yetkinlikleri.
3. **Traction:** Müşteri sayısı, ciro ve hedeflere yakınlık.
4. **İnovasyon:** Ar-Ge niteliği ve mevcut alternatiflerden fark.
5. **Plan Tabloları:** Görevler, kilometre taşları, takvim ve bütçe.
6. **Pazar Analizi:** TAM, SAM, SOM ve rakipler.
7. **Marka:** Konumlandırma ve pazarlama kanalları.
8. **Özet ve Gönderim:** Girilen bilgilerin gözden geçirilmesi ve demo başvurusunun tamamlanması.

İşlevsel gereksinimler:

- Her adımın kendi doğrulaması olmalıdır.
- Zorunlu alanlar tamamlanmadan sonraki adıma geçilmemelidir.
- Önceki adımlara dönülebilmelidir.
- İlerleme göstergesi bulunmalıdır.
- Taslak, `shared_preferences` aracılığıyla yerel olarak saklanmalıdır.
- Kullanıcı uygulamayı yeniden açtığında kaydedilmiş taslak geri yüklenmelidir.
- Kullanıcı taslağını temizleyebilmeli veya tamamlanmış formu gözden geçirebilmelidir.
- Gönderimden önce özet ekranı gösterilmelidir.
- Demo gönderimi, gerçek bir uzman incelemesi başlatmaz.

Form verileri için uygun immutable modeller ve açık bir doğrulama yapısı kullanılmalıdır. Karmaşık form mantığı doğrudan widget içinde tutulmamalıdır.

### 7.6 Fikir Durumu ve Hukuki Süreç

Amaç: Girişimcinin örnek kabul süreci, şirketleşme aşamaları ve destek hedefleri hakkında bilgi edinebileceği bir durum ekranı sunmak.

Örnek şirketleşme yol haritası:

1. Avukat atama aşaması.
2. Şirket türünün belirlenmesi: A.Ş. veya Ltd. Şti.
3. MERSİS ve ticaret sicili işlemleri.
4. Vergi dairesi kaydı ve açılış yoklaması.
5. TÜRKPATENT marka tescil başvurusu.
6. Hissedarlar sözleşmesi ve ortaklık protokolü.

Ekranda bulunabilecek bileşenler:

- Mevcut durum kartı.
- Altı aşamalı zaman çizelgesi.
- Örnek avukat bilgi kartı.
- Aylık gelir desteği hedefi ve demo ilerleme göstergesi.
- Farklı aşamalarda bulunan en az 6 örnek girişim fikri.
- Analiz formuna yönlendiren başvuru aksiyonu.

Bu akış, Türkiye'deki her şirket için zorunlu ve değişmez bir hukuki süreç olarak sunulamaz. Gereken işlemler şirket türüne ve koşullara göre değişebilir. Demo verileri gerçek avukat ataması, resmî şirket tescili, marka başvurusu veya gelir desteği anlamına gelmez.

## 8. Kullanıcı Deneyimi Gereksinimleri

- Arama ve filtreler sonuçları gerçekten değiştirmelidir.
- Butonlar işlevsiz dekoratif öğeler olarak bırakılmamalıdır.
- Modal ve alt sayfalar kapatılabilir olmalıdır.
- Form doğrulama mesajları alanla ilişkili ve anlaşılır olmalıdır.
- Boş liste, hata, başarı ve yüklenme durumları tasarlanmalıdır.
- Uzun içerikler küçük ekranlarda taşmamalıdır.
- Sistem tema ayarından bağımsız olarak kullanıcı açık veya koyu temayı seçebilmelidir.
- Ekranlar Türkçe içeriklerle hazırlanmalıdır.
- Metinler, tarih ve para birimi biçimleri Türkiye'deki kullanıcıya uygun olmalıdır.
- Her ekranda geri dönüş ve navigasyon davranışı tutarlı olmalıdır.

## 9. Başarı Kriterleri

Yörünge'nin tamamlanmış sayılması için:

1. Dört ana sekme ve iki yardımcı akış kullanılabilir olmalıdır.
2. En az 9 mentor, 16 yatırımcı, 15 program ve 13 topluluk gönderisi bulunmalıdır.
3. Mentor arama ve filtreleri çalışmalıdır.
4. Yatırımcı ve program filtreleri çalışmalıdır.
5. Eşleşme durumları controller üzerinden değiştirilebilmelidir.
6. Topluluk yetkileri controller düzeyinde kontrol edilmelidir.
7. Sekiz adımlı form doğrulama ve taslak saklama işlevlerine sahip olmalıdır.
8. Fikir Durumu ekranında altı aşamalı yol haritası yer almalıdır.
9. Koyu ve açık tema tutarlı biçimde çalışmalıdır.
10. Uygulama `flutter analyze` kontrollerinden hatasız geçmelidir.
11. Birim testleri kritik iş kurallarını doğrulamalıdır.
12. Uygulama web ortamında derlenebilmeli ve desteklenen mobil ekran boyutlarında kullanılabilmelidir.
13. Mock içerik ile gerçek işlem arasındaki sınır açık olmalıdır.

### 7.7 Kimlik Doğrulama ve Demo Oturumu (Auth & Demo Session)

Amaç: Kullanıcıya profesyonel bir giriş ve kayıt akışı sunarak ekosisteme kişiselleştirilmiş demo deneyimiyle erişmesini sağlamak.

Kullanıcı akışları:
1. **Sabit Demo Hesabı ile Giriş:** Kullanıcı tanımlı demo bilgileriyle (`demo@yorunge.app` / `yorunge123`) oturum açabilir.
2. **Kayıt Ol (Register):** Ad soyad, e-posta, şifre ve şifre tekrarı alanlarıyla form doğrulaması sonrası yerel demo oturumu başlatılır.
3. **Demo Olarak Devam Et:** Form doldurma zorunluluğu olmadan tek tıkla doğrudan demo oturumu açılır.
4. **Hızlı Demo Hesabı Oluştur ve Devam Et:** Kayıt ekranında tek tıkla dinamik demo kurucu hesabı üretilir ve ana ekrana yönlendirilir.

### 7.8 Çok Rollü Demo Kullanıcı ve Merkezi Yetkilendirme Sistemi

Amaç: Tek bir uygulama ve tek ortak Derin Uzay arayüzü içinde beş farklı kullanıcı rolünü desteklemek, role bağlı yetkileri merkezi otorite üzerinden yönetmek.

Desteklenen Demo Hesapları:
| Rol | Ad Soyad | E-posta | Demo Şifre | Özel Durum |
|---|---|---|---|---|
| `entrepreneur` | Deniz Yörünge | `girisimci@yorunge.demo` | `demo123` | Onaylı (Tam topluluk yetkisi) |
| `entrepreneur` | Barış Yeni | `aday.girisimci@yorunge.demo` | `demo123` | Onaysız (Etkileşim kısıtlı) |
| `investor` | Leyla Fon | `yatirimci@yorunge.demo` | `demo123` | Fon Yöneticisi |
| `mentor` | Dr. Kerem Danışman | `mentor@yorunge.demo` | `demo123` | Kıdemli Danışman |
| `programProvider` | Selin Destek | `kurum@yorunge.demo` | `demo123` | TÜBİTAK & Hibe Koordinatörü |
| `admin` | Yönetici Atlas | `admin@yorunge.demo` | `demo123` | Platform Yöneticisi |

Rol Bazlı Yetki Matrisi:
| Modül / İşlem | Girişimci | Yatırımcı | Mentor | Kurum Temsilcisi | Admin |
|---|---|---|---|---|---|
| Mentorları görüntüleme | İzinli | İzinli | İzinli | İzinli | İzinli |
| Mentorluk talebi gönderme | İzinli | Yasak | Yasak | Yasak | İzinli |
| Yatırımcıları görüntüleme | İzinli | İzinli | İzinli | İzinli | İzinli |
| Yatırımcıya iletişim talebi gönderme | İzinli | Yasak | Yasak | Yasak | İzinli |
| Destek programlarını görüntüleme | İzinli | İzinli | İzinli | İzinli | İzinli |
| Yeni iş planı oluşturma/düzenleme | İzinli | Yasak | Yasak | Yasak | İzinli |
| Kendi fikir durumunu görüntüleme | İzinli | Yasak | Yasak | Yasak | İzinli |
| Başvuru durumunu takip etme | İzinli | Yasak | Yasak | İzinli | İzinli |
| Topluluk gönderilerini görüntüleme | İzinli | İzinli | İzinli | İzinli | İzinli |
| Toplulukta paylaşım yapma | Onaylıysa | Yasak | Yasak | Yasak | İzinli |
| Topluluk gönderilerini beğenme/yanıtlama | Onaylıysa | Yasak | Yasak | Yasak | İzinli |
| Girişimleri keşfetme | İzinli | İzinli | İzinli | İzinli | İzinli |
| Girişim bilgilerini değerlendirme/kaydetme | İzinli | İzinli | İzinli | İzinli | İzinli |
| Mentor profilini düzenleme | Yasak | Yasak | İzinli | Yasak | İzinli |
| Yatırımcı profilini düzenleme | Yasak | İzinli | Yasak | Yasak | İzinli |
| Kurum/program profilini düzenleme | Yasak | Yasak | Yasak | İzinli | İzinli |
| Kullanıcıları ve rolleri yönetme | Yasak | Yasak | Yasak | Yasak | İzinli |
| Demo rolünü değiştirme | Demo araçları | Demo araçları | Demo araçları | Demo araçları | Demo araçları |

İş kuralları ve ilkeler:
- **Tek ve Ortak Arayüz:** Her rol için ayrı ana ekran veya ayrı shell oluşturulmaz. Tüm kullanıcılar `ShellView` ve aynı sekmeleri görür.
- **Çift Katmanlı Koruma:** Yetkisiz işlem butonuna tıklandığında UI seviyesinde açıklayıcı Türkçe SnackBar/diyalog sunulur; eşzamanlı olarak controller katmanında da işlem durdurulur.
- **Onay Durumu Ayrımı:** Girişimci olmak doğrudan paylaşım hakkı vermez; `isApproved` bayrağı aranır.
- **Gözlemci Modu:** Ekranı görmek ile işlemi yapabilmek ayrılmıştır. Yatırımcı iş planı veya fikir durumu ekranına bakabilir, ancak işlem yapamaz.
- **Backend Yoktur:** Yetkilendirme tamamen istemci tarafında `PermissionService` ile simüle edilir.

## 10. Kapsam Dışı Özellikler

Bu demo sürümünde aşağıdakiler geliştirilmez:

- Gerçek bulut tabanlı kimlik doğrulama sunucusu (Firebase Auth, Supabase, OAuth vb.).
- E-posta aktivasyonu, SMS OTP ve şifre sıfırlama servisleri.
- Canlı sunucu veritabanı veya REST/GraphQL backend.
- Gerçek mentor eşleştirme servisi.
- Gerçek yatırımcı iletişimi veya yatırım işlemleri.
- Gerçek hukuki danışmanlık ve avukat ataması.
- Gerçek gelir desteği ödemesi.
- Gerçek başvuru değerlendirme sistemi.
- Canlı topluluk senkronizasyonu ve push bildirimleri.
- Üçüncü taraf ödeme işlemleri.

## 11. Geliştirme Yaklaşımı

Geliştirme sırasında önce mevcut Flutter projesi, dosyaları, testleri ve varsa `.agents/` yapılandırması incelenmelidir.

Mevcut çalışan kod gereksiz yere yeniden yazılmamalıdır. Geliştirme, eksiklerin tespiti ve kontrollü iyileştirme üzerinden ilerlemelidir.

Her yeni özellik:

1. Model ve veri yapısıyla tanımlanır.
2. Controller üzerinden iş kurallarına bağlanır.
3. Tekrar kullanılabilir widget'larla sunulur.
4. İlgili ekrana entegre edilir.
5. Birim testleriyle doğrulanır.
6. Analiz ve biçimlendirme kontrollerinden geçirilir.

**Ürün hedefi:** Yörünge, girişimcilik sürecini anlaşılır kılan, görsel açıdan güçlü ve teknik olarak sürdürülebilir bir Flutter mobil demo uygulaması olmalıdır.