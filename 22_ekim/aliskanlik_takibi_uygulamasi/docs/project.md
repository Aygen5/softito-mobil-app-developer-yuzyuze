# VERDANT — PROJE TANIMI VE GEREKSİNİMLER

## 1. Proje Tanımı

Verdant, kullanıcıların günlük alışkanlıklarını takip edebildiği, devamlılık serilerini görebildiği, geçmiş performansını inceleyebildiği ve başarı rozetleri kazanabildiği, sağlık ve kişisel gelişim odaklı bir mobil uygulamadır.

Uygulama Flutter ve Dart ile geliştirilecektir. Temel amaç, görsel açıdan kaliteli ve gerçek etkileşimlere sahip bir uygulama ortaya çıkarmaktır.

Uygulama sıradan bir yapılacaklar listesi olarak tasarlanmamalıdır. Kullanıcının ilerlemesini görselleştiren, motivasyon sağlayan, animasyonları anlamlı kullanan ve her ekranında tutarlı bir deneyim sunan bir ürün olmalıdır.

## 2. Kesin Teknoloji Kararları

- Mobil uygulama: Flutter.
- Programlama dili: Dart.
- Tasarım yaklaşımı: Material 3 temel alınarak özelleştirilmiş arayüz.
- Durum yönetimi: flutter_bloc paketinin Cubit yapısı.
- Sayfa yönlendirme: go_router.
- Grafikler: fl_chart veya uygun olduğunda Flutter'ın kendi çizim araçları.
- Bildirimler: flutter_local_notifications.
- Tarih ve saat işlemleri: Dart'ın `DateTime` yapısı ve gerektiğinde `intl`.
- Yerel tercihler: Gerekli basit ayarlar için shared_preferences kullanılabilir.
- Animasyonlar: Flutter'ın yerleşik animasyon API'leri ve gerektiğinde CustomPainter.
- İkonlar: Tutarlı bir ikon ailesi; tercihen Lucide veya Flutter'ın uygun ikonları.
- Veri kaynağı: Dart ile oluşturulan yerel, bellekte tutulan demo verileri.

Projeye uygun kararlı paket sürümleri kullanılmalıdır. Yeni bir paket eklemeden önce mevcut bağımlılıklar kontrol edilmelidir.

## 3. Kesinlikle Kullanılmayacak Teknolojiler

Bu proje kapsamında aşağıdakiler kullanılmayacaktır:

- Firebase.
- Supabase.
- PostgreSQL veya başka bir veritabanı.
- Node.js veya ayrı bir backend.
- REST API veya harici veri servisi.
- Gerçek kullanıcı kimlik doğrulama sistemi.
- CSV veya JSON dosyasından zorunlu veri okuma.
- Kullanıcı hesabı için sunucu bağlantısı.
- Backend gerektiren yapay zekâ servisleri.

Demo verileri Dart sınıfları ve yerel veri sağlayıcıları aracılığıyla oluşturulacaktır. Uygulamanın temel işlevleri internet bağlantısı olmadan çalışabilmelidir.

Dart kodunda örnek veriler oluşturulabilir. Bunun için ayrı bir JSON veya CSV dosyası oluşturmak zorunlu değildir.

## 4. Ekran Yapısı

Uygulamada iki giriş ekranı ve dört ana uygulama ekranı bulunur.

### Giriş ekranları

1. Karşılama ve giriş ekranı.
2. Kayıt ol ekranı.

Bu ekranlar yalnızca demo amaçlıdır. Gerçek authentication yapılmayacaktır.

Giriş ekranında kullanıcı:
- Giriş Yap butonunu kullanabilir.
- Hesap Oluştur ekranına geçebilir.
- Demo ile Devam Et seçeneğiyle doğrudan uygulamaya girebilir.

Giriş ve kayıt formları gerçek kullanıcı hesabı oluşturmaz. Demo akışı kullanıcıyı doğrudan ana uygulamaya yönlendirir. Formlarda uygun temel doğrulama ve kullanıcı geri bildirimi bulunabilir; ancak sahte bir backend bağlantısı oluşturulmayacaktır.

### Dört ana ekran

1. Ana Sayfa — günlük alışkanlıklar.
2. Takvim — alışkanlık geçmişi.
3. İstatistikler — grafikler ve başarı rozetleri.
4. Alışkanlıklar — alışkanlıkları listeleme ve yönetme.

Alışkanlık ekleme ve düzenleme, ayrı bir ana sayfa değil; modal veya bottom sheet olarak açılacaktır.

Ana ekranlar arasında alt gezinme çubuğu bulunacaktır.

## 5. Uygulama Dili

Kullanıcıya gösterilen bütün metinler Türkçe olmalıdır.

Bu kurala şunlar dahildir:
- Sayfa başlıkları.
- Butonlar.
- Form etiketleri.
- Hata ve başarı mesajları.
- Bildirim metinleri.
- Rozet isimleri.
- Grafik etiketleri.
- Tarih gösterimleri.
- Boş durum mesajları.
- Yardım metinleri.

Türkçe karakterler doğru kullanılmalıdır: ç, ğ, ı, İ, ö, ş, ü.

Kod değişkenleri, sınıflar ve dosya isimleri İngilizce olabilir. Ancak arayüzde görünen metinler Türkçe kalmalıdır.

## 6. Tasarım Kimliği

Uygulamanın adı Verdant'tır.

Görsel yaklaşım:
- Premium.
- Koyu orman yeşili ve haki ağırlıklı.
- Sağlık ve kişisel gelişim temalı.
- Organik ve doğal detaylar.
- Yumuşak gölgeler.
- Katmanlı kartlar.
- Hafif ışık efektleri.
- Özenle tasarlanmış ikonlar.
- Dairesel ilerleme göstergeleri.
- Çubuk grafikler.
- GitHub katkı grafiğine benzer aktivite ızgarası.
- Kontrollü ve anlamlı animasyonlar.

Temel renkler:

- Arka plan: `#111711`
- İkincil arka plan: `#171F18`
- Kart: `#202A21`
- Yükseltilmiş kart: `#273329`
- Haki: `#87966A`
- Açık adaçayı: `#B6C6A0`
- Başarı yeşili: `#8FCA8A`
- Ana metin: `#F2F0E6`
- İkincil metin: `#A8B2A3`
- Soluk metin: `#6F7B6E`
- Devam eden durum: `#D7B66D`
- Uyarı: `#DFA477`
- İkincil vurgu: `#C1A7D9`

Renkler `design-system.md` dosyasında tanımlanan kurallara göre kullanılmalıdır.

## 7. Başlangıç Demo Verileri

Uygulama ilk açıldığında beş alışkanlık hazır bulunmalıdır. Boş bir dashboard gösterilmemelidir.

### 7.1. Günde 10.000 Adım

- Kategori: Hareket.
- Hedef: 10.000 adım.
- Durum: Tamamlanmış alışkanlık.
- Son 30 gün: Her gün tamamlanmış.
- Görsel durum: Canlı yeşil.
- Örnek seri: 30 günlük seri.

Bu alışkanlığın geçmişi, takvimde ve istatistiklerde eksiksiz biçimde tamamlanmış görünmelidir.

### 7.2. Sigarasız Yaşam

- Kategori: Sağlık.
- Hedef: 30 günlük sigarasız yaşam meydan okuması.
- İlerleme: 14/30 gün.
- Durum: Devam ediyor.
- Görsel durum: Haki ve amber.

Bu demo kaydı, kullanıcının gerçek sağlık durumu hakkında bir iddia değildir. Yalnızca örnek uygulama verisidir.

### 7.3. Spor Salonuna Git

- Kategori: Spor.
- Hedef: 3 aylık spor rutini.
- Durum: Henüz başlanmadı.
- Tamamlanan oturum: 0.
- Görsel durum: En soluk alışkanlık.

Bu alışkanlık diğerlerinden daha düşük görsel vurguyla gösterilmelidir. Ancak devre dışı bırakılmış gibi görünmemelidir.

İlgili ekranlarda başlangıç motivasyonu ve hatırlatma örnekleri bulunmalıdır.

### 7.4. Her Gün 100 Sayfa Oku

- Kategori: Kişisel Gelişim.
- Hedef: 100 sayfa.
- Durum: Yeni başladı.
- İlerleme: 2. gün.
- Görsel durum: Taze adaçayı yeşili.

Başlangıç aşamasını yansıtan kısa bir seri ve küçük ilerleme göstergesi kullanılmalıdır.

### 7.5. Günde 3 Litre Su

- Kategori: Sağlık.
- Hedef: 3.000 ml.
- Durum: Devam ediyor.
- Geçmiş: Tamamlanmış, kısmen tamamlanmış ve kaçırılmış günler içermeli.
- Örnek bugünkü tüketim: 2.500/3.000 ml.
- Görsel durum: Su mavisi veya uyumlu açık adaçayı vurgusu; genel paletle çatışmamalıdır.

Kullanıcıya şu tür mesajlar gösterilebilir:

- "Harika gidiyorsun, hedefine çok yaklaştın!"
- "Bir bardak daha suyla hedefine ulaşabilirsin."
- "Bugün 2,5 litreye ulaştın."

Bu mesajlar tüketim miktarıyla tutarlı olmalıdır.

## 8. Demo Verilerinde Tutarlılık

Beş alışkanlık tek bir ortak demo veri kaynağından yönetilmelidir.

Aynı günün tamamlanma durumu:
- Ana sayfada.
- Takvimde.
- Aktivite ızgarasında.
- İstatistiklerde.
- Başarı hesaplamalarında.

birbiriyle çelişmemelidir.

Streak, tamamlama yüzdesi ve rozetler ayrı ayrı sabit sayılarla gösterilmemelidir. Bunlar mevcut kayıtlar üzerinden hesaplanmalıdır.

İlerleme oranlarının hangi tarih aralığını kapsadığı açık olmalıdır. Örneğin 30 günlük meydan okuma ilerlemesi ile günlük tamamlama oranı aynı kavram değildir.

Demo verilerinde gerekli geçmiş kayıtları önceden oluşturulmalıdır.

## 9. Ana Sayfa Gereksinimleri

Ana sayfada:
- Türkçe tarih.
- Karşılama mesajı.
- Günlük tamamlanma göstergesi.
- Tamamlanan/toplam alışkanlık sayısı.
- Beş alışkanlık kartı.
- Her alışkanlığın mevcut streak veya ilerleme bilgisi.
- Alışkanlık tamamlama kontrolü.
- Yeni alışkanlık ekleme butonu.
- Dinamik motivasyon sözü.
- Su tüketimiyle ilgili bilgilendirme kartı.
- Dört öğeli alt gezinme çubuğu.

Bir alışkanlık tamamlandığında:
- Kartın görünümü değişmeli.
- Tamamlama kontrolü güncellenmeli.
- Günlük ilerleme değişmeli.
- İlgili grafikler ve geçmiş verileri güncellenmeli.
- Uygun olduğunda başarı animasyonu gösterilmeli.

## 10. Alışkanlık Yönetimi Gereksinimleri

Kullanıcı:
- Yeni alışkanlık ekleyebilmeli.
- Alışkanlık düzenleyebilmeli.
- Alışkanlık silebilmeli.
- Ad belirleyebilmeli.
- Kategori seçebilmeli.
- İkon seçebilmeli.
- Renk seçebilmeli.
- Günlük hedef belirleyebilmeli.
- Tekrarlanacak günleri seçebilmeli.
- Hatırlatma saatini belirleyebilmeli.
- Hatırlatmayı açıp kapatabilmeli.

Her alışkanlık kendi ikonuna ve rengine sahip olmalıdır.

Alışkanlık silme işleminde onay alınmalıdır.

## 11. Takvim Gereksinimleri

Takvim ekranında:
- Aylık görünüm.
- Önceki ve sonraki aya geçiş.
- Türkçe ay ve gün isimleri.
- Seçilen günün vurgulanması.
- Günlük tamamlanma durumu.
- GitHub katkı grafiğine benzeyen aktivite ızgarası.
- Seçilen günün alışkanlık kayıtları.
- Alışkanlık bazlı filtreleme.
- Tamamlanan, kısmen tamamlanan ve tamamlanmayan günlerin ayrımı.

Geçmişte tamamlanmış kayıtlar, sonraki güne aitmiş gibi gösterilmemelidir. Gelecekteki planlı günler de başarısız gün olarak değerlendirilmemelidir.

## 12. İstatistik Gereksinimleri

İstatistik ekranında:
- Toplam tamamlama sayısı.
- Güncel streak.
- En uzun streak.
- Haftalık başarı yüzdesi.
- Aylık başarı yüzdesi.
- Günlere göre tamamlanma grafiği.
- Dairesel ilerleme grafiği.
- Alışkanlık bazlı karşılaştırma.
- En istikrarlı alışkanlık.
- Geliştirilmesi gereken alışkanlık.
- Başarı rozetleri.
- Kilitli rozetler ve kazanılma koşulları.

Sayılar dümdüz metin halinde bırakılmamalıdır. Veriler dairesel göstergeler, çubuk grafikler, ilerleme çubukları ve ısı haritalarıyla desteklenmelidir.

## 13. Rozet Sistemi

Başlangıçta çeşitli rozetler tasarlanmalıdır:

- İlk Adım.
- 7 Günlük Seri.
- 30 Günlük İstikrar.
- Su Kaşifi.
- Kitap Kurdu.
- Hareket Ustası.
- Yeniden Başla.
- Kararlılık.
- Erken Başlangıç.
- İlk Ay.

Rozetlerin kazanılma koşulları açık ve kod içinde tanımlı olmalıdır.

Henüz kazanılmamış rozetler soluk gösterilmelidir. Kazanılan rozetler daha canlı, detaylı ve belirgin olmalıdır.

Sırf ekranda boşluk kalmasın diye kazanılmamış bir rozet kazanılmış gibi gösterilmemelidir.

## 14. Bildirim Gereksinimleri

Kullanıcı her alışkanlık için hatırlatma açıp kapatabilmelidir.

Hatırlatma bilgileri:
- Alışkanlık kimliği.
- Hatırlatma saati.
- Aktif/pasif durumu.
- Gerekli tekrarlama günleri.

Yerel bildirimler cihaz üzerinde planlanmalıdır. Sunucu veya uzaktan bildirim altyapısı kurulmayacaktır.

İzin verilmemesi veya platform kısıtlamaları durumunda uygulama çökmemeli; kullanıcıya uygun Türkçe geri bildirim verilmelidir.

## 15. Animasyon ve Canlılık

Aşağıdaki etkileşimler animasyonla desteklenmelidir:
- Alışkanlığı tamamlama.
- İlerleme halkasının değişmesi.
- Tamamlama sayısının değişmesi.
- Modal açılışı ve kapanışı.
- Sayfa geçişleri.
- Rozet kazanma.
- Grafiklerin görünür hale gelmesi.
- Buton dokunma geri bildirimi.

Tamamlama animasyonunda kısa bir parıltı veya sınırlı parçacık efekti kullanılabilir.

Bütün ekranlarda sürekli çalışan, performansı düşüren animasyonlar kullanılmamalıdır.

## 16. Kalıcılık Sınırı

Bu projenin ilk sürümünde backend ve veritabanı yoktur.

Demo verileri uygulama çalışırken bellekte tutulabilir. Basit ayarlar ve kullanıcı tercihleri gerekirse yerel tercihlerle saklanabilir.

Ancak kullanıcı verilerinin kalıcı olarak saklandığı iddia edilmemelidir. Uygulama yeniden başlatıldığında demo durumunun başlangıç haline dönmesi kabul edilebilir.

Gerçek kalıcı alışkanlık kayıtları istenirse bu, sonraki bir geliştirme aşaması olarak ele alınmalıdır.

## 17. Tamamlanma Kriterleri

Proje tamamlanmış sayılabilmesi için:

1. Giriş ve kayıt ekranları çalışmalıdır.
2. Demo ile giriş yapılabilmelidir.
3. Dört ana ekran arasında gezinilebilmelidir.
4. Beş başlangıç alışkanlığı görüntülenebilmelidir.
5. Yeni alışkanlık eklenebilmelidir.
6. Alışkanlık düzenlenip silinebilmelidir.
7. İkon ve renk seçimi çalışmalıdır.
8. Tamamlama işlemi ilgili verileri güncellemelidir.
9. Streak hesapları gerçek kayıtlarla tutarlı olmalıdır.
10. Takvim geçmişi doğru gösterilmelidir.
11. Grafikler ortak veri kaynağından beslenmelidir.
12. Rozetler koşullara göre hesaplanmalıdır.
13. Yerel hatırlatmalar uygun cihazlarda çalışmalıdır.
14. Türkçe arayüz tutarlı olmalıdır.
15. `dart format` ve `flutter analyze` temiz sonuç vermelidir.
16. Temel iş kuralları için testler bulunmalıdır.
17. Uygulama Flutter destekli hedef platformda çalıştırılabilmelidir.

Bu dosya, proje kapsamı açısından temel referanstır. Diğer dokümanlar bu gereksinimlerle çelişemez.