# VERDANT — GELİŞTİRME BECERİLERİ VE UYGULAMA REHBERİ

## 1. Bu Dosyanın Amacı

Bu dosya, Verdant projesini geliştirirken uyulacak teknik uygulama yöntemlerini açıklar.

Amaç yalnızca çalışan kod üretmek değildir. Kod:
- Anlaşılır.
- Test edilebilir.
- Tasarımla uyumlu.
- Performanslı.
- Yeniden kullanılabilir.
- Dart ve Flutter standartlarına uygun.

olmalıdır.

Proje gereksinimleri için `project.md`, mimari için `architecture.md`, çalışma kuralları için `.agents.md`, görsel kararlar için `design-system.md` esas alınmalıdır.

## 2. Flutter ve Dart Uygulama Becerileri

### Widget tasarımı

- Küçük ve sorumluluğu belirgin widget'lar oluştur.
- Gereksiz yere her satırı ayrı bir widget'a dönüştürme.
- Tek widget içinde çok fazla sorumluluk biriktirme.
- Tekrar eden tasarımları ortak bileşenlere ayır.
- Gereksiz `setState` kullanma.
- Cubit ile yönetilen verileri yerel widget state'i içinde tekrar tutma.
- `const` kullanımını uygun yerlerde tercih et.
- Liste öğelerinde kararlı kimlikler kullan.
- Uzun listelerde performansı dikkate al.

### Dart modelleri

Modeller tip güvenli olmalıdır.

- Uygun alan türleri tanımla.
- Gereksiz `dynamic` kullanma.
- Durumlar için enum veya benzeri açık tipler kullan.
- Model güncellemelerini kontrollü yap.
- Gerekli olduğunda `copyWith` benzeri yöntemler kullan.
- Tarih ve miktar alanlarının anlamlarını açık tut.
- Ekran metinlerini veri modelinin içine gereksiz yere yerleştirme.

## 3. Cubit ve State Yönetimi

Cubit, bir ekranın veya özelliğin iş durumunu yönetmelidir.

### State tasarımı

State en azından gerekli durumları temsil etmelidir:
- İlk durum.
- Veri hazır.
- İşlem devam ediyor.
- Hata oluştu.

Her küçük işlem için gereksiz yüklenme ekranı gösterme. Basit yerel işlemlerde uygun ve hızlı bir güncelleme tercih edilebilir.

### Cubit kuralları

- Repository üzerinden veri al.
- İş mantığını widget'a bırakma.
- Durum güncellemelerini açık ve anlaşılır yap.
- Aynı veriyi gereksiz biçimde birden fazla state içinde çoğaltma.
- Asenkron işlemlerde yaşam döngüsünü dikkate al.
- Hata durumlarını kullanıcıya uygun Türkçe mesajlarla yansıt.
- Cubit kapatılırken kaynakları doğru şekilde temizle.

### Gereksiz Cubit oluşturma

Her buton, ikon, form alanı veya animasyon için ayrı Cubit oluşturma.

Bir formun geçici seçili rengi veya açık/kapalı bölümü gibi basit durumlar gerektiğinde yerel state ile yönetilebilir.

Ancak ana alışkanlık listesi, takvim verisi, istatistikler ve uygulama gezinmesi uygun mimari katmanlarda kalmalıdır.

## 4. GoRouter Uygulaması

GoRouter yapılandırması tek bir merkezi yerde tutulmalıdır.

Gerekli rotalar:
- `/welcome`
- `/register`
- `/home`
- `/habits`
- `/calendar`
- `/statistics`

Ana uygulama ekranları ortak alt gezinme yapısını paylaşmalıdır.

### Demo giriş akışı

- Karşılama ekranında Demo ile Devam Et butonu bulunmalıdır.
- Butona basıldığında kullanıcı doğrudan ana uygulamaya geçmelidir.
- Gerçek authentication çağrısı yapılmamalıdır.
- Demo giriş akışı sahte bir backend varmış gibi davranmamalıdır.

### Modal davranışı

Alışkanlık ekleme/düzenleme formu bir modal veya bottom sheet olarak açılmalıdır.

Modal açmak için yeni bir ana sekme oluşturma.

Modal kapatıldığında kullanıcı önceki ekranına dönmelidir.

Başarılı kayıttan sonra liste güncellenmelidir.

## 5. Demo Verileri Oluşturma

Beş başlangıç alışkanlığı ayrı ve anlaşılır Dart tanımlarında oluşturulmalıdır.

Önerilen yaklaşım:
- `demo_habits.dart`: Başlangıç alışkanlıkları.
- `demo_history.dart`: Günlük tamamlama kayıtları.
- `demo_data_factory.dart`: Başlangıç verilerini bir araya getiren üretici.

Bütün ekranlar aynı repository örneğini kullanmalıdır.

Her ekran kendi örnek alışkanlık listesini oluşturmamalıdır.

### Demo veri gereksinimleri

**Günde 10.000 Adım**
- Son 30 gün tamamlanmış.
- Takvimde bütün bu günler tamamlanmış görünmeli.
- İlgili seri ve istatistikler geçmişle tutarlı olmalı.

**Sigarasız Yaşam**
- 30 günlük meydan okumanın 14. gününde.
- Meydan okuma ilerlemesi 14/30.
- Meydan okuma süresi ile günlük tamamlama oranı birbirinden ayrılmalı.

**Spor Salonuna Git**
- Henüz başlanmamış.
- Tamamlama kaydı bulunmamalı.
- Başlanmamış durum başarısızlık olarak gösterilmemeli.

**Her Gün 100 Sayfa Oku**
- İkinci gününde.
- Yeni başlangıç görünümü kullanılmalı.
- İlgili geçmiş kayıtları bu durumu desteklemeli.

**Günde 3 Litre Su**
- Geçmişte tamamlanan, kısmi ve kaçırılan günler bulunmalı.
- Bugünkü örnek miktar 2.500/3.000 ml olmalı.
- İlerleme yüzdesi yaklaşık %83 olmalı.
- Henüz hedefe ulaşılmadıysa alışkanlık tamamlandı olarak işaretlenmemeli.

Demo verileri oluşturulurken güncel tarih ile örnek geçmişin birbiriyle tutarlı olması sağlanmalıdır. Sabit tarihler yalnızca örnek tasarımda kullanılabilir; uygulama çalışırken takvim hesaplarının doğru olması gerekir.

## 6. Alışkanlık Tamamlama Mantığı

Tamamlama işlemi sadece kart rengini değiştirmekten ibaret olmamalıdır.

Kullanıcı bir alışkanlığı tamamladığında:
1. İlgili gün için kayıt oluştur.
2. Aynı kayıt zaten varsa mükerrer kayıt oluşturma.
3. Alışkanlık hedefine göre tamamlanma durumunu hesapla.
4. Günlük ilerlemeyi güncelle.
5. Streak hesaplarını yenile.
6. Takvim geçmişini güncelle.
7. İstatistikleri yenile.
8. Yeni kazanılan rozetleri kontrol et.
9. Uygunsa başarı animasyonunu göster.

Kullanıcı tamamlamayı geri alabiliyorsa:
- İlgili kayıt doğru biçimde güncellenmeli veya kaldırılmalı.
- Grafikler ve sayılar yeniden hesaplanmalı.
- Artık koşulu karşılanmayan rozetler için iş kuralı açık olmalı.
- Aynı işlem ikinci kez yapıldığında veri bozulmamalı.

## 7. Streak Hesaplama

Streak hesaplama mantığını merkezi bir yardımcıda tut.

Bir seri:
- Alışkanlığın başlangıç tarihinden sonra başlar.
- Planlanan günler üzerinden hesaplanır.
- Geçmişteki planlı ve tamamlanmamış günlerde kesilebilir.
- Planlanmamış günleri atlayabilir.
- Gelecekteki günleri başarısız saymaz.
- Bugünün henüz tamamlanmamış olmasını otomatik olarak başarısızlık saymamalıdır.

Örneğin yalnızca pazartesi, çarşamba ve cuma yapılan bir alışkanlıkta salı gününün tamamlanmaması seriyi bozmamalıdır.

Meydan okuma ilerlemesi ile streak aynı değildir.

Örnek:
- Meydan okama ilerlemesi: 14/30 gün.
- Güncel streak: Planlanan günlere ve tamamlamalara göre hesaplanan değer.

Bu iki değer gerektiğinde ayrı ayrı gösterilmelidir.

## 8. İstatistik Hesaplamaları

İstatistikler sabit sayılarla yazılmamalıdır.

Aşağıdaki değerler ilgili kayıtlar üzerinden hesaplanmalıdır:
- Toplam tamamlama sayısı.
- Günlük tamamlanma oranı.
- Haftalık tamamlanma oranı.
- Aylık tamamlanma oranı.
- Güncel streak.
- En uzun streak.
- Alışkanlık bazlı tamamlanma oranı.
- En istikrarlı alışkanlık.
- Geliştirilmesi gereken alışkanlık.
- Rozet kazanma koşulları.

### Payda seçimi

Tamamlanma oranında payda, ilgili dönemde alışkanlığın planlandığı gün sayısı olmalıdır.

Örneğin bir alışkanlık haftada üç gün planlanıyorsa, haftalık başarı yüzdesi yedi güne bölünerek hesaplanmamalıdır.

O dönemde hiç planlı gün yoksa sıfıra bölme hatası oluşmamalıdır. Bu durum uygun bir boş değer veya açıklama ile gösterilmelidir.

### Kısmi hedefler

Su tüketimi gibi miktar hedeflerinde:
- Gerçek miktar gösterilmeli.
- Hedef yüzdesi hesaplanmalı.
- Tamamlanma kuralı ayrı değerlendirilmelidir.

2.500/3.000 ml yaklaşık %83 ilerlemedir, fakat hedef tamamen tamamlanmış değildir.

## 9. Rozet Sistemi

Rozet kazanma koşullarını merkezi bir yerde tanımla.

Örnekler:

- İlk Adım: İlk geçerli alışkanlık tamamlaması.
- 7 Günlük Seri: Yedi planlı gün üst üste tamamlanmış.
- 30 Günlük İstikrar: Tanımlı 30 günlük meydan okuma tamamlanmış.
- Su Kaşifi: Su hedefi için belirlenmiş başarı koşulu.
- Kitap Kurdu: Okuma alışkanlığı için belirlenmiş tamamlama sayısı.
- Hareket Ustası: Adım hedefi için belirlenmiş başarı koşulu.
- Yeniden Başla: Bir aradan sonra alışkanlığı yeniden tamamlama.
- Kararlılık: Belirlenen sayıda geçerli tamamlama.
- Erken Başlangıç: İlk kez yeni bir alışkanlık başlatma.
- İlk Ay: Bir aylık alışkanlık dönüm noktasına ulaşma.

Her rozetin koşulu kodda açıkça belirtilmelidir.

Kullanıcı henüz koşulu karşılamamışsa rozet kilitli görünmelidir.

Kazanılmış rozetler için animasyon gösterimi, veri hesaplamasından ayrı tutulmalıdır. Animasyonun tekrar tekrar gösterilmesi yeni rozet kazanıldığı anlamına gelmemelidir.

## 10. Takvim ve Aktivite Izgarası

Takvim için ortak tarih yardımcıları kullan.

- Ayın gün sayısını doğru hesapla.
- Ay geçişlerinde yıl değişimini destekle.
- Haftanın başlangıç gününü belirle.
- Tarihleri saat bileşeninden arındırarak karşılaştır.
- Seçili günün kayıtlarını ortak repository üzerinden getir.
- Alışkanlık filtresini bütün ilgili göstergelere uygula.

### Aktivite yoğunluğu

Aktivite ızgarası, ilgili tarihteki planlı alışkanlıkların tamamlanma oranına göre renklenmelidir.

- Kayıt yok: Nötr durum.
- Düşük oran: Soluk yeşil.
- Orta oran: Orta yeşil.
- Yüksek oran: Canlı yeşil.
- Tam başarı: En belirgin yeşil.

Henüz gelmemiş tarihler, kaçırılmış geçmiş günlerle aynı şekilde gösterilmemelidir.

Filtre değiştirildiğinde hem takvim hem aktivite ızgarası seçili alışkanlığa göre güncellenmelidir.

## 11. Grafik Uygulaması

Grafikler `fl_chart` ile veya ihtiyaca uygun Flutter çizim bileşenleriyle uygulanabilir.

Kullanılabilecek grafikler:
- Dairesel ilerleme.
- Haftalık çubuk grafik.
- Aylık karşılaştırma.
- Alışkanlık bazlı ilerleme çubukları.
- Aktivite ısı haritası.

Grafik paketinin mevcut sürümü kontrol edilmelidir. Kullanılan API'ler paketin gerçek sürümüyle uyumlu olmalıdır.

Grafikler:
- Responsive olmalı.
- Ekran dışına taşmamalı.
- Türkçe etiketleri desteklemeli.
- Boş veri durumunu ele almalı.
- Aynı demo kayıtlarından beslenmeli.
- Gerektiğinde animasyonlu güncellenmeli.

Sırf görsel dolu görünsün diye rastgele grafik değerleri ekleme.

## 12. Alışkanlık Formu

Form şu alanları desteklemelidir:

- Alışkanlık adı.
- Kategori.
- İkon.
- Renk.
- Günlük hedef.
- Hedef birimi.
- Tekrarlanacak günler.
- Hatırlatma ayarı.
- Hatırlatma saati.

### Form doğrulaması

- Alışkanlık adı boş olamaz.
- Hedef sayısal ve geçerli olmalıdır.
- Gün seçimi gerektiğinde en az bir gün içermelidir.
- Hatırlatma açıkken saat geçerli olmalıdır.
- Seçilen ikon ve renk kaydedilen alışkanlığa ait olmalıdır.

### Ekleme

Kaydetme sonrasında:
- Modal kapanmalı.
- Alışkanlık listesi yenilenmeli.
- Yeni alışkanlık takvim ve istatistik hesaplarına uygun şekilde dahil edilmelidir.
- Hatırlatma açıksa bildirim planlaması yapılmalıdır.

### Düzenleme

Mevcut alışkanlık güncellenirken geçmiş kayıtları yanlışlıkla silinmemelidir.

Hedef veya program değişikliği geçmiş hesaplarını etkiliyorsa iş kuralı açık olmalıdır. Önceki tamamlamalar korunmalı; yeni program ileriye dönük uygulanmalıdır.

### Silme

Silme işlemi onay gerektirmelidir.

Silinen alışkanlığın:
- Aktif listeden çıkarılması.
- Bildirimlerinin iptal edilmesi.
- Takvim ve istatistik ekranlarında doğru şekilde ele alınması.

sağlanmalıdır.

Gerekirse geçmişi korumak için arşivleme tercih edilebilir. Ancak kullanıcıya silme denildiğinde kayıt sessizce aktif kalmamalıdır.

## 13. Yerel Bildirimler

`flutter_local_notifications` kullanmadan önce paketin sürümünü ve platform gereksinimlerini kontrol et.

Uygulama:
- Hatırlatma iznini uygun zamanda istemeli.
- Bildirim saatini kullanıcıdan almalı.
- Haftanın seçili günlerinde tekrarlama yapabilmeli.
- Hatırlatma değiştiğinde eski planı güncelleyebilmeli.
- Alışkanlık silindiğinde ilgili bildirimi iptal etmeli.
- İzin reddedildiğinde çalışmaya devam etmeli.

Bildirim metni alışkanlığın adına uygun olmalıdır.

Örnekler:
- "Kısa bir hareket molası zamanı!"
- "Kitap okumak için kendine biraz zaman ayır."
- "Su molanı unutma."
- "Bugün spor için küçük bir adım atabilirsin."

Bildirimlerin kesin zamanlaması platform ve işletim sistemi kısıtlamalarına bağlı olabilir. Bu nedenle gerçek cihazlarda test edilmelidir.

Uygulama açıkken gösterilen hatırlatma kartı ile işletim sistemi bildirimi birbirinden ayrılmalıdır.

## 14. Motivasyon Sözleri

Motivasyon sözlerini bir Dart listesinde veya uygun sabit veri kaynağında tut.

Sözler:
- Kısa.
- Türkçe.
- Alışkanlık temalı.
- Doğal.
- Yargılayıcı olmayan.

olmalıdır.

Ana sayfa her yeniden açıldığında uygun yeni bir söz seçilebilir.

Söz seçimi için son gösterilen sözün tekrar seçilmesini önleyen basit bir mekanizma kullanılabilir.

Sözler sağlık konusunda kesin veya yanıltıcı iddialar içermemelidir.

## 15. Animasyonlar ve Başarı Efektleri

Flutter'ın yerleşik animasyonlarını öncelikli olarak kullan.

Uygun araçlar:
- AnimatedContainer.
- AnimatedOpacity.
- AnimatedScale.
- TweenAnimationBuilder.
- AnimationController.
- CustomPainter.

Her efekt için yeni bir paket eklemek zorunlu değildir.

### Tamamlama efekti

- Kontrolün yeşile geçişi.
- Onay işaretinin görünmesi.
- Kartın kısa süreli vurgulanması.
- İlerleme halkasının güncellenmesi.
- Küçük ve kontrollü parçacıklar.

### Rozet efekti

- Rozetin kısa ölçek animasyonu.
- Işık veya parıltı.
- Kısa başarı mesajı.
- İsteğe bağlı küçük parçacık animasyonu.

Efektler performansı düşürmemelidir.

Aynı başarı için gereksiz yere animasyon tekrar oynatılmamalıdır.

## 16. Test Yazma

İş mantığı testleri ekran tasarımından bağımsız yazılmalıdır.

Öncelikli test senaryoları:

1. Günlük alışkanlık tamamlama.
2. Tamamlamayı geri alma.
3. Aynı güne mükerrer kayıt eklenmemesi.
4. Planlanmamış günün streak'i bozmaması.
5. Geçmişte kaçırılmış planlı günün streak'i kesmesi.
6. Gelecekteki günün başarısız sayılmaması.
7. Su tüketiminin doğru yüzdesi.
8. Haftalık başarı oranı.
9. Aylık başarı oranı.
10. Rozet kazanma koşulları.
11. Alışkanlık ekleme ve düzenleme.
12. Alışkanlık silme.
13. Takvimde ay geçişleri.
14. Seçili alışkanlık filtresi.
15. Demo verilerinin tutarlılığı.

Tarih testlerinde sabit referans tarihi kullan. Testler yalnızca sistemin o anki tarihine bağlı olmamalıdır.

## 17. Hata Ayıklama

Bir hata görüldüğünde:

1. Hatanın tekrar üretilebilir olup olmadığını kontrol et.
2. İlgili kodu incele.
3. Hatanın kaynağını belirle.
4. En küçük doğru düzeltmeyi yap.
5. İlgili testleri çalıştır.
6. `flutter analyze` çalıştır.
7. Başka ekranların etkilenmediğini kontrol et.

Sadece hata mesajını bastıran çözümler üretme.

## 18. Kod Kalitesi ve Teslim

Her önemli geliştirme aşamasında:

```bash
dart format .
flutter analyze
flutter test
```

komutlarını uygun proje kökünde çalıştır.

Bir komut hata verirse nedenini incele. Testler geçmiyorsa aşamayı tamamlanmış olarak raporlama.

Yeni paket eklediğinde:
- Neden gerekli olduğunu belirt.
- `pubspec.yaml` değişikliğini kontrol et.
- Platform gereksinimlerini incele.
- Paket sürümüyle uyumlu API kullan.
- Gereksiz bağımlılık ekleme.

## 19. Son Teknik Hedef

Verdant'ın nihai hali:
- Dört ana sekmeye sahip.
- Giriş ve kayıt ekranları bulunan.
- Demo ile giriş yapılabilen.
- Beş başlangıç alışkanlığı içeren.
- Yerel demo verileriyle çalışan.
- Alışkanlık ekleme, düzenleme ve silme işlemlerini destekleyen.
- Günlük tamamlama ve streak hesapları tutarlı olan.
- Takvim ve aktivite ızgarası bulunan.
- Grafik ve rozetleri gerçek hesaplamalarla üreten.
- Yerel hatırlatmaları destekleyen.
- Özel animasyonlar ve premium tasarım dili kullanan.
- Test edilebilir ve bakımı kolay.

bir Flutter uygulaması olmalıdır.

Backend, veritabanı veya gerçek authentication eklemek bu projenin tamamlanması için gerekli değildir.