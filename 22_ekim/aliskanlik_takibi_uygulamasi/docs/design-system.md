# VERDANT — TASARIM SİSTEMİ

## 1. Tasarımın Amacı

Verdant; sağlık, alışkanlık kazanma ve kişisel gelişim odaklı, premium bir mobil uygulamadır.

Tasarım yalnızca koyu renkli kartlardan oluşmamalıdır. Derinlik, görsel hiyerarşi, anlamlı renk kullanımı, özel ikonlar, veri görselleştirmeleri ve kontrollü animasyonlarla özgün bir kimlik oluşturulmalıdır.

Temel tasarım ilkeleri:

- Doğal ve sakin görünüm.
- Premium ve modern arayüz.
- Yüksek okunabilirlik.
- Tutarlı bileşenler.
- Görsel olarak zengin veri sunumu.
- Duruma göre değişen kart görünümleri.
- Anlamlı animasyonlar.
- Ekranlar arasında görsel bütünlük.

## 2. Renk Paleti

Renkler tek bir merkezi dosyada tanımlanmalıdır.

### Arka plan renkleri

- `background`: `#111711`
- `backgroundSecondary`: `#171F18`
- `surface`: `#202A21`
- `surfaceElevated`: `#273329`

### Ana marka renkleri

- `primary`: `#87966A`
- `primaryLight`: `#B6C6A0`
- `success`: `#8FCA8A`

### Metin renkleri

- `textPrimary`: `#F2F0E6`
- `textSecondary`: `#A8B2A3`
- `textMuted`: `#6F7B6E`

### Durum renkleri

- `inProgress`: `#D7B66D`
- `warning`: `#DFA477`
- `accentLavender`: `#C1A7D9`
- `border`: Düşük kontrastlı adaçayı tonu.

### Renk kullanım kuralları

- Ana arka plan tüm ekranlarda tutarlı olmalıdır.
- Kartlar arka plandan yeterince ayrılmalıdır.
- Ana metin yüksek okunabilirliğe sahip olmalıdır.
- İkincil metin daha düşük kontrasta sahip olabilir ancak okunamayacak kadar soluk olmamalıdır.
- Yeşil tamamlanma ve ilerlemeyi temsil etmelidir.
- Amber devam eden süreçleri vurgulayabilir.
- Gri-yeşil başlanmamış veya kilitli durumlarda kullanılmalıdır.
- Rozet renkleri kategoriye göre çeşitlenebilir.
- Aynı durum bütün ekranlarda aynı anlamı taşımalıdır.

Renkler widget dosyalarına rastgele sabit değerlerle yazılmamalıdır.

## 3. Tipografi

Tipografi sade, modern ve okunabilir olmalıdır.

- Büyük sayılar: Güçlü ağırlık, net kontrast.
- Ekran başlıkları: Belirgin ve dengeli.
- Kart başlıkları: Orta veya yarı kalın.
- Açıklamalar: Normal ağırlık.
- Yardım metinleri: Küçük fakat okunabilir.
- Grafik etiketleri: Kısa ve anlaşılır.
- Motivasyon sözleri: Daha zarif ve editoryal bir görünüm.

Türkçe karakterleri destekleyen bir yazı tipi kullanılmalıdır.

Özel bir font projede mevcut değilse uygulamanın derlenmesini bozacak şekilde harici fonta bağımlılık oluşturma. Uygun bir sistem fontu kullanılabilir.

Tipografi ölçekleri merkezi tanımlanmalı ve ekranlar arasında tutarlı olmalıdır.

## 4. Boşluk Sistemi

Tutarlı bir boşluk sistemi kullan:

- 4 birim: Çok küçük ikon ve metin aralıkları.
- 8 birim: Küçük iç boşluklar.
- 12 birim: Kompakt bileşen aralıkları.
- 16 birim: Standart kart ve sayfa içi boşluk.
- 20 birim: Bölümler arası boşluk.
- 24 birim: Büyük bölüm aralığı.
- 32 birim: Önemli görsel ayrımlar.

Bu değerler katı biçimde her yerde aynı olmak zorunda değildir; ancak rastgele aralıklar kullanılmamalıdır.

Ekran kenarlarında tutarlı yatay boşluklar kullanılmalıdır.

## 5. Köşe Yarıçapları

Bileşen türüne göre tutarlı yarıçaplar belirle:

- Küçük kontroller: 8–12.
- Butonlar: 14–18.
- Standart kartlar: 18–24.
- Büyük hero kartları: 24–30.
- Bottom sheet üst köşeleri: 28–32.
- Rozetler ve dairesel göstergeler: Tasarımın gerektirdiği şekilde dairesel.

Kartların köşeleri her ekranda farklılaşmamalıdır.

## 6. Gölge ve Derinlik

Derinlik kontrollü kullanılmalıdır.

- Standart kartlar: Hafif gölge veya düşük kontrastlı kenarlık.
- Yükseltilmiş kartlar: Biraz daha belirgin gölge.
- Ana ilerleme kartı: Hafif yeşil ışık hissi.
- Modal: Arka plandan net biçimde ayrılan yükseltilmiş yüzey.
- Floating action button: Hafif yeşil gölge.
- Rozet kazanma: Kısa süreli ışık ve parıltı.

Her kartta güçlü gölge kullanma.

Aşırı blur ve yoğun glassmorphism kullanma. Yüzeylerin derinliği, kontrast ve gölgeyle dengeli oluşturulmalıdır.

## 7. Ana Sayfa Tasarımı

Ana sayfa en önemli ekrandır.

### Üst alan

- Kullanıcıya özel karşılama.
- Gün ve tarih.
- Profil simgesi.
- Bildirim simgesi.

Üst alan kompakt olmalı ve ana içeriği gereksiz yere aşağı itmemelidir.

### Günlük ilerleme kartı

Bu kart görsel odağı oluşturmalıdır.

İçerik:
- Günlük tamamlanma sayısı.
- Toplam planlı alışkanlık.
- Dairesel ilerleme göstergesi veya dikkat çekici progress bar.
- Kısa motivasyon metni.

İlerleme halkası, tamamlanma durumuna göre animasyonla güncellenmelidir.

### Alışkanlık kartları

Her kartta:
- İkon.
- Alışkanlık adı.
- Kategori.
- Hedef.
- Streak veya ilerleme.
- Tamamlama kontrolü.

Kartlar aynı temel yapıyı paylaşmalı ancak alışkanlığın rengine ve durumuna göre görsel olarak özelleşebilmelidir.

### Motivasyon sözü kartı

- Ayrı bir yüzey.
- Zarif tırnak işareti veya yaprak simgesi.
- Kısa Türkçe söz.
- İkincil başlık.

Söz kartı alışkanlık listesinin önüne geçmemelidir.

### Su tüketimi kartı

- Su damlası simgesi.
- Tüketilen miktar.
- Günlük hedef.
- İlerleme göstergesi.
- Duruma uygun motivasyon mesajı.

Bu karttaki miktar ve yüzde aynı veri kaynağından gelmelidir.

### Yeni alışkanlık butonu

Özel bir floating action button kullanılmalıdır.

- Belirgin artı simgesi.
- Yuvarlak veya yumuşak köşeli form.
- Ana marka rengi.
- Kontrollü gölge.
- Dokunma geri bildirimi.

Buton ekran içeriğini kapatmamalı ve alt gezinme alanıyla çakışmamalıdır.

## 8. Alışkanlık Durumlarının Görsel Tasarımı

### Tamamlanmış

- Canlı yeşil vurgu.
- Belirgin onay işareti.
- Dolu ilerleme göstergesi.
- Gerektiğinde kısa parıltı.
- Yüksek görsel güven hissi.

### Devam eden

- Haki ve amber vurguları.
- Kısmi ilerleme.
- Mevcut seri veya geçen gün sayısı.
- Açık ve motive edici mesaj.

### Yeni başlanmış

- Adaçayı yeşili.
- Küçük ilerleme göstergesi.
- Yeni başlangıç etiketi.
- Teşvik edici metin.

### Henüz başlanmamış

- Daha düşük doygunluk.
- Soluk ikon arka planı.
- Daha az belirgin ilerleme çizgisi.
- Başlamaya teşvik eden mesaj.

Henüz başlanmamış alışkanlık silik olabilir; fakat metinler okunabilir ve kontroller kullanılabilir kalmalıdır.

Başlanmamış durum ile kaçırılmış gün birbirinden farklıdır.

## 9. Alışkanlık Ekleme Modalı

Modal uygulamanın önemli bir görsel bileşenidir.

- Koyu yükseltilmiş yüzey.
- Büyük üst köşe yarıçapı.
- Hafif gölge.
- İnce adaçayı kenarlık.
- Başlığın çevresinde küçük yaprak süslemeleri.
- Bölümlere ayrılmış form.
- İkon seçici.
- Renk seçici.
- Gün seçimi.
- Hatırlatma saati.
- Belirgin kaydet butonu.

Dekoratif öğeler form alanlarını kapatmamalıdır.

Form uzun olduğunda kaydırma desteklenmelidir.

Seçilen ikon ve renk hemen görünür hale gelmelidir.

## 10. Takvim Tasarımı

Takvim sade bir standart takvim gibi bırakılmamalıdır.

- Ay başlığı.
- Önceki/sonraki ay kontrolleri.
- Haftanın günleri.
- Seçili gün vurgusu.
- Günlük durum işaretleri.
- Aktivite yoğunluğu ızgarası.
- Renk açıklamaları.
- Seçilen günün detay kartı.
- Alışkanlık filtreleme kontrolü.

### Aktivite ızgarası

GitHub katkı grafiğinden esinlenebilir ancak Verdant'ın görsel kimliğine uyarlanmalıdır.

- Düşük aktivite: Soluk yeşil.
- Orta aktivite: Orta ton.
- Yüksek aktivite: Canlı yeşil.
- Tamamlanmamış gün: Nötr veya düşük yoğunluk.
- Henüz gelmemiş gün: Ayrı ve yanıltıcı olmayan görünüm.

Izgaradaki renkler hesaplanan tamamlama oranını yansıtmalıdır.

## 11. İstatistik Ekranı

İstatistikler yalnızca rakam ve metinlerden oluşmamalıdır.

Kullanılacak görseller:
- Dairesel ilerleme göstergeleri.
- Haftalık çubuk grafik.
- Aylık başarı göstergesi.
- Alışkanlık bazlı ilerleme çubukları.
- Mini istatistik kartları.
- Rozet koleksiyonu.
- En istikrarlı alışkanlık kartı.
- Geliştirilmesi gereken alışkanlık kartı.

Grafiklerde:
- Anlaşılır eksenler.
- Okunabilir etiketler.
- Dengeli boşluk.
- Yeterli kontrast.
- Gereksiz çizgilerden kaçınma.
- Gerçek demo verilerinden türetilmiş değerler.

kullanılmalıdır.

### Rozetler

Kazanılan rozetler:
- Canlı renkler.
- Belirgin ikonlar.
- Hafif parlama.
- Daha güçlü görsel ağırlık.

Kilitli rozetler:
- Soluk renkler.
- Kilit simgesi.
- Kısa kazanılma koşulu.

Rozetler birbirinden ayırt edilebilir olmalıdır.

## 12. Animasyon Sistemi

Animasyonlar merkezi ve tutarlı davranmalıdır.

Önerilen süreler:
- Küçük dokunma geri bildirimi: 100–180 ms.
- Standart geçişler: 200–300 ms.
- Modal açılışı: 250–350 ms.
- Grafik ilerlemesi: 350–600 ms.
- Başarı parıltısı: Kısa, kontrollü ve tek seferlik.

Bunlar başlangıç değerleridir; animasyonun türüne göre ayarlanabilir.

### Tamamlama animasyonu

Kullanıcı alışkanlığı tamamladığında:
1. Tamamlama kontrolü animasyonla değişir.
2. Onay işareti görünür.
3. Kartın vurgu rengi canlanır.
4. İlerleme halkası güncellenir.
5. Uygun bir başarı parıltısı veya küçük parçacık efekti gösterilebilir.

Efekt, kullanıcının dokunuşuna doğrudan bağlı olmalıdır.

### Rozet kazanma animasyonu

- Rozet kısa bir ölçek animasyonuyla belirir.
- Hafif yeşil veya altın parıltı oluşur.
- Küçük parçacıklar kullanılabilir.
- Türkçe başarı mesajı gösterilir.

Ekranı kaplayan ve kullanımı engelleyen efektler kullanılmamalıdır.

## 13. Hareket ve Performans

- Gereksiz sürekli animasyon kullanma.
- Liste kaydırmasını yavaşlatan efektlerden kaçın.
- Büyük widget ağaçlarında gereksiz yeniden oluşturmayı azalt.
- Animasyon controller'larını doğru zamanda kapat.
- Erişilebilirlik için hareket azaltma tercihlerini mümkün olduğunda dikkate al.
- Efektleri düşük performanslı cihazlarda da kullanılabilir tut.

## 14. Boş, Hata ve Yüklenme Durumları

Her ekran yalnızca ideal veriyle tasarlanmamalıdır.

Gerekli durumlar:
- Takvimde kayıt olmayan tarih.
- Filtrede sonuç bulunmaması.
- Henüz kazanılmamış rozetler.
- Boş alışkanlık listesi.
- Geçersiz form.
- Bildirim izninin verilmemesi.
- Başarılı kayıt.
- Silme onayı.

Boş durumlar da aynı premium tasarım dilini korumalıdır.

## 15. Erişilebilirlik

- Metin ve arka plan kontrastı yeterli olmalıdır.
- İkonlar yalnızca renkle anlamlandırılmamalıdır.
- Tıklanabilir alanlar yeterli büyüklükte olmalıdır.
- Metinler küçük ekranlarda taşmamalıdır.
- Form alanları anlaşılır etiketlere sahip olmalıdır.
- Grafiklerin önemli sayısal bilgileri metinle de erişilebilir olmalıdır.
- Alt gezinme öğeleri erişilebilir etiketlere sahip olmalıdır.

## 16. Tasarımın Korunması

Yeni bir ekran oluşturulurken mevcut tasarım sistemi kullanılmalıdır.

Yeni renk, yazı boyutu, boşluk, köşe yarıçapı veya gölge gerekiyorsa önce mevcut token'lar kontrol edilmelidir.

Sırf hızlı geliştirmek için tasarım sistemi atlanmamalıdır.

Stitch referansında bulunan önemli görsel ayrıntılar Flutter ile uygulanabilecek alternatiflerle korunmalıdır.