# RotaRent — Geliştirme Kuralları ve Antigravity Rehberi

## 1. Bu Dosyanın Amacı

Bu dosya, RotaRent projesini geliştiren yapay zekâ destekli kodlama aracının uyması gereken kuralları tanımlar.

Amaç yalnızca çalışan kod üretmek değil; mevcut tasarıma uygun, anlaşılır, düzenli ve Flutter öğrenen bir geliştiricinin inceleyebileceği bir uygulama oluşturmaktır.

Bu dosya, `project.md`, `architecture.md` ve `design-system.md` dosyalarıyla birlikte değerlendirilmelidir.

## 2. Öncelik Sırası

Proje üzerinde çalışırken aşağıdaki öncelik sırası uygulanmalıdır:

1. Kullanıcının açıkça belirttiği gereksinimler.
2. `project.md` dosyasındaki kapsam ve kabul kriterleri.
3. `design-system.md` dosyasındaki tasarım kararları.
4. `architecture.md` dosyasındaki mimari ilkeler.
5. Bu dosyadaki geliştirme kuralları.
6. Gerekli durumlarda Flutter ve Dart'ın güncel, kararlı uygulama standartları.

Belgeler arasında çelişki varsa çelişki sessizce geçiştirilmemelidir. Çelişkinin etkisi değerlendirilmeli ve proje kapsamını genişletmeden en uygun çözüm seçilmelidir.

## 3. Geliştirme Öncesi İnceleme

Kod yazmaya başlamadan önce:

- Projenin mevcut klasör yapısını incele.
- `pubspec.yaml` dosyasını kontrol et.
- Flutter ve Dart sürümlerini belirle.
- `lib/` altındaki mevcut dosyaları incele.
- Stitch'ten alınan tasarım dosyalarını ve görselleri bul.
- Mevcut bileşenlerin hangi ekranlarla ilişkili olduğunu belirle.
- Belgelerde tanımlanan gereksinimleri mevcut kodla karşılaştır.

Mevcut dosyaları incelemeden yeni bir mimari kurma.

Çalışan kodları gerekçesiz silme veya baştan yazma.

## 4. Stitch Tasarımını Flutter'a Dönüştürme

Stitch'ten alınan kaynak kodlar web teknolojileri içeriyorsa bunları doğrudan Flutter projesine kopyalama.

HTML, CSS, JavaScript veya React bileşenlerini uygun Dart ve Flutter widget'larına dönüştür.

Dönüşüm sırasında:

- Ekranların temel yerleşimini koru.
- Tasarımdaki Türkçe metinleri koru.
- Renkleri ve tipografiyi tasarım sistemine aktar.
- Kart, buton, filtre ve form alanlarını tekrar kullanılabilir şekilde oluştur.
- Ekranlar arasında ortak bir görsel dil kullan.
- Mobil cihazlara uygun esnek yerleşimler oluştur.
- Web'e özgü bileşenlerin Flutter karşılıklarını kullan.
- Eksik görselleri ve bozuk varlık yollarını kontrol et.
- Tasarımda bulunan işlevsel etkileşimleri çalışır hâle getir.

Stitch tarafından üretilen tasarım yalnızca bir görsel referans değildir. Uygulamanın arayüzü bu tasarım temel alınarak oluşturulmalıdır.

Ancak web kodunun yapısını birebir korumak zorunlu değildir. Flutter'a uygun bir bileşen mimarisi oluşturulmalıdır.

## 5. Flutter ve Dart Kodlama Kuralları

### 5.1. Genel kurallar

- Dart'ın null safety özelliklerini doğru kullan.
- Değişkenleri mümkün olduğunca `final` veya `const` tanımla.
- Uygun yerlerde `const` widget'lar kullan.
- Değişken ve fonksiyon isimlerinde anlaşılır İngilizce isimlendirme tercih et.
- Sınıf isimlerinde `UpperCamelCase` kullan.
- Dosya isimlerinde `snake_case` kullan.
- Aynı işlevi farklı dosyalarda tekrar yazma.
- Gereksiz paket veya bağımlılık ekleme.
- Kullanılmayan kodları projede bırakma.
- Uzun ve karmaşık widget ağaçlarını gerektiğinde alt widget'lara ayır.
- Kodun okunabilirliğini gereksiz soyutlamaların önünde tut.

### 5.2. Yeni başlayan geliştiriciye uygunluk

Proje öğrenme amaçlıdır.

Bu nedenle:

- Anlaşılır çözümleri karmaşık çözümlere tercih et.
- Gereksiz tasarım desenleri kullanma.
- Basit bir işlem için birden fazla katman oluşturma.
- Birbirine çok benzeyen küçük dosyalarla projeyi parçalama.
- Gereksiz generic sınıflar ve soyutlamalar ekleme.
- Kritik iş mantığına kısa ve açıklayıcı yorumlar ekle.
- Yorumlarla kodun zaten açık olan anlamını tekrar etme.

Kod profesyonel standartlara uygun olmalı ancak yeni başlayan biri tarafından takip edilemeyecek kadar karmaşık olmamalıdır.

## 6. Mimari ve Dosya Düzeni

- `main.dart` dosyasını mümkün olduğunca sade tut.
- Uygulama yapılandırmasını `app.dart` içinde yönet.
- Ekranları ilgili özellik klasörlerinde tut.
- Ortak widget'ları `core/widgets/` altında topla.
- Renkleri ve tema tanımlarını merkezi olarak yönet.
- Veri modellerini ekran dosyalarının içine yerleştirme.
- JSON okuma işlemini ekranlardan ayır.
- Rezervasyon verilerini ortak bir yerel yönetim yapısı üzerinden paylaş.
- İş mantığını mümkün olduğunca kullanıcı arayüzünden ayır.

Önerilen klasör yapısı bağlayıcı bir dosya listesi değildir. Gereksiz dosyalar oluşturulmasın; ancak önemli sorumluluklar da tek bir büyük dosyada biriktirilmesin.

## 7. Veri Yönetimi Kuralları

Gerçek backend ve veritabanı kullanılmayacaktır.

Araç verileri yerel JSON dosyasından okunmalıdır.

Kurallar:

- JSON dosyası `pubspec.yaml` içinde doğru şekilde tanımlanmalıdır.
- JSON verileri uygun Dart modellerine dönüştürülmelidir.
- Farklı ekranlarda birbirinden bağımsız araç listeleri oluşturulmamalıdır.
- Araç kimlikleri benzersiz olmalıdır.
- Görsel yolları kontrol edilmelidir.
- Filtreleme ve sıralama orijinal veriyi bozmamalıdır.
- Yeni rezervasyonlar ortak rezervasyon listesine eklenmelidir.
- Rezervasyonlar aynı uygulama oturumu boyunca tutarlı biçimde gösterilmelidir.

Rezervasyonların uygulama kapatıldıktan sonra korunması zorunlu değildir. Kalıcı depolama eklenmeden önce bunun gerçekten gerekli olup olmadığı değerlendirilmelidir.

## 8. Dinamik Takvim ve Rezervasyon Kuralları

Dinamik takvim projenin en önemli işlevsel gereksinimidir.

Takvim yalnızca tasarımsal bir bileşen olarak bırakılmamalıdır.

Uygulanması gereken davranışlar:

- Seçilen araca ait dolu tarih aralıkları okunmalıdır.
- Geçmiş tarihler seçilememelidir.
- Dolu tarihler takvimde görsel olarak ayrılmalıdır.
- Kullanıcı alış ve dönüş tarihlerini seçebilmelidir.
- Seçilen tarih aralığı çakışma açısından kontrol edilmelidir.
- Çakışan rezervasyonlar engellenmelidir.
- Form geçerli değilse başarı diyaloğu açılmamalıdır.
- Başarılı rezervasyon sonraki müsaitlik kontrollerine dahil edilmelidir.
- Kullanıcıya Türkçe hata ve başarı mesajları gösterilmelidir.

Önemli: Yalnızca rezervasyon butonunu devre dışı bırakmak yeterli değildir. Rezervasyon oluşturma fonksiyonunun içinde de müsaitlik kontrolü yapılmalıdır.

Takvimde kullanılan müsaitlik kontrolü ile rezervasyon işleminin kullandığı kontrol aynı iş kuralına dayanmalıdır.

Tarih ve saat karşılaştırmaları tutarlı yapılmalıdır. Dönüş anında başka bir rezervasyonun başlayabilmesine izin veren bitişik rezervasyon kuralı desteklenmelidir.

## 9. Form ve Doğrulama Kuralları

Formlarda Flutter'ın yerleşik doğrulama mekanizmalarını kullan.

Tercih edilen bileşenler:

- `Form`
- `GlobalKey<FormState>`
- `TextFormField`
- `validator`
- `DateTime`
- `TimeOfDay`

Kurallar:

- Zorunlu alanlar kontrol edilmelidir.
- Tarih sırası kontrol edilmelidir.
- Geçersiz kiralama süresi engellenmelidir.
- Kullanıcıya anlaşılır hata mesajı gösterilmelidir.
- Form doğrulaması başarılı olmadan rezervasyon oluşturulmamalıdır.
- Klavye açıldığında formun kullanılabilirliği korunmalıdır.

Gerçek kullanıcı kimliği doğrulaması yapılmadığı açıkça korunmalıdır.

## 10. Fiyat Hesaplama

Fiyat hesaplaması tek bir yerde tanımlanmalı ve ekranlar arasında aynı sonuç kullanılmalıdır.

Hesaplamada:

- Seçilen araç.
- Saatlik veya günlük fiyat.
- Kiralama başlangıcı ve bitişi.
- Kiralama süresi.
- Varsa tanımlı indirim.

dikkate alınmalıdır.

Saatlik ve günlük ücretlerin birlikte kullanıldığı durumlarda yuvarlama ve süre hesaplama kuralları açıkça belirlenmelidir.

Aynı kiralama için farklı ekranlarda farklı toplam fiyatlar gösterilmemelidir.

250 km günlük kullanım hakkı bilgilendirme amacı taşır. Gerçek rota hesaplaması veya ek kilometre ücretlendirmesi, gerekli veri ve kurallar tanımlanmadan gerçek bir hizmet gibi uygulanmamalıdır.

## 11. Tema ve Tasarım Kuralları

- Material Design 3 kullanılmalıdır.
- Açık ve koyu tema desteklenmelidir.
- Temalar merkezi olarak tanımlanmalıdır.
- Ekranlarda sabit renk kodları gelişigüzel kullanılmamalıdır.
- Renkler `ColorScheme` üzerinden mümkün olduğunca alınmalıdır.
- Araç fotoğrafları doğru boyutlandırılmalıdır.
- Kart ve buton stilleri tutarlı olmalıdır.
- Tasarım sistemiyle çelişen rastgele renkler eklenmemelidir.
- Bütün ekranlar farklı temalarda kontrol edilmelidir.

## 12. Navigasyon ve Etkileşimler

İlk sürümde Flutter'ın yerleşik `Navigator` yapısını kullan.

- İkincil ekranlar için `Navigator.push` kullanılabilir.
- Geri dönüş için `Navigator.pop` kullanılabilir.
- Filtreleme ve sıralama için alt pencereler kullanılmalıdır.
- Başarı, hata ve çıkış onayları için diyaloglar kullanılmalıdır.
- Butonlar gerçek işlevlere bağlanmalıdır.
- Sadece görsel olarak çalışan, işlevi olmayan butonlar bırakılmamalıdır.
- Başarılı işlem mesajları yalnızca işlem gerçekten tamamlandıktan sonra gösterilmelidir.

## 13. Hata Yönetimi ve Kullanıcı Mesajları

Kullanıcıya teknik hata ayrıntıları veya gereksiz İngilizce hata mesajları gösterme.

Mesajlar kısa ve Türkçe olmalıdır.

Örnekler:

- "Araç bilgileri yüklenemedi."
- "Lütfen geçerli bir tarih aralığı seçin."
- "Seçtiğiniz tarih aralığında araç müsait değil."
- "Rezervasyonunuz başarıyla oluşturuldu."
- "Lütfen gerekli alanları kontrol edin."

Beklenmeyen hatalar sessizce yok sayılmamalıdır.

## 14. Görsel Varlıklar

Araç fotoğrafları uygulamanın önemli bir parçasıdır.

- Projede bulunan gerçek görseller kullanılmalıdır.
- Görsel yolları `pubspec.yaml` içinde doğru tanımlanmalıdır.
- Görsel dosyalarının gerçekten mevcut olduğu kontrol edilmelidir.
- Kırık görsel bağlantıları bırakılmamalıdır.
- Görsellerin yerine sebepsiz yere emoji veya düz renkli kutular kullanılmamalıdır.
- Bir görselin eksik olması durumunda kontrollü bir yedek görünüm sağlanmalıdır.
- Rastgele harici görsel URL'leri eklenmemelidir.

Stitch çıktısında görsel dosyaları varsa önce bunlar incelenmeli ve projeye uygun şekilde aktarılmalıdır.

## 15. Test ve Doğrulama

Her önemli geliştirme aşamasından sonra mümkün olduğunda aşağıdaki kontroller yapılmalıdır:

1. `flutter pub get`
2. `flutter analyze`
3. İlgili birim testleri.
4. Uygulamanın gerçek cihazda veya emülatörde açılması.
5. Ekran geçişlerinin kontrolü.
6. Açık ve koyu temanın kontrolü.
7. Filtreleme ve sıralamanın kontrolü.
8. Dolu ve müsait tarihlerle takvimin denenmesi.
9. Geçersiz ve geçerli rezervasyonların denenmesi.
10. Rezervasyonların hesap ekranında görüntülenmesi.

Komutların başarılı olduğu doğrulanmadan testlerin geçtiği söylenmemelidir.

## 16. Kapsam Kontrolü

İlk sürümde aşağıdakiler eklenmemelidir:

- Backend.
- Veritabanı.
- Gerçek API bağlantıları.
- Gerçek ödeme sistemi.
- NFC entegrasyonu.
- Gerçek zamanlı yakıt fiyatları.
- Karmaşık harita ve rota servisleri.
- Gereksiz yönetici paneli.
- Projede kullanılmayan paketler.
- İhtiyaç duyulmayan durum yönetimi kütüphaneleri.

Yeni bir özellik önerildiğinde önce mevcut proje hedeflerine gerçekten katkı sağlayıp sağlamadığı değerlendirilmelidir.

## 17. Geliştirme Süreci Kuralları

- Önce mevcut projeyi ve tasarımı anla.
- Belgelere aykırı varsayımlarda bulunma.
- Büyük değişikliklerden önce etkilenecek dosyaları belirle.
- Mevcut dosyaları gerekçesiz silme.
- Tasarımı ve işlevleri birlikte değerlendir.
- Her özelliği mümkün olduğunca küçük ve test edilebilir parçalara ayır.
- İşlevi tamamlanmamış butonları veya sahte başarı mesajlarını bırakma.
- Yapılan değişikliklerin sonuçlarını kontrol et.
- Çalışan özellikleri yeni geliştirmeler sırasında bozma.
- Proje kapsamını gereksiz yere genişletme.

## 18. Projeyi Anlama ve Planlama Talimatı

Geliştirmeye başlamadan önce `project.md`, `architecture.md`, `design-system.md` ve `skills.md` dosyalarının tamamını oku.

Ardından mevcut Flutter projesini ve Stitch'ten alınan tasarım dosyalarını incele.

Bu aşamada hemen bütün uygulamayı kodlamaya başlama.

Önce:

- Mevcut durum ile hedeflenen uygulama arasındaki farkları belirle.
- Eksik görselleri ve varlıkları tespit et.
- Mimari açıdan gerekli dosyaları belirle.
- Dinamik takvimin veri ve doğrulama mantığını açıkla.
- Tasarımın Flutter'a nasıl aktarılacağını değerlendir.
- Uygulama sırasını ve test adımlarını belirle.

Bu analizden sonra proje kök dizininde `plan.md` oluştur. Planı, mevcut proje durumuna ve bu dört belgeye dayanarak kendin hazırla.

`plan.md` dosyası bu belgelerin yerine geçmemeli; uygulama adımlarını, bağımlılıkları, tamamlanma ölçütlerini ve testleri tanımlamalıdır.

Plan oluşturulduktan sonra geliştirmeye bu plana göre devam et. Belirsizlik veya gerçek bir engel yoksa kullanıcıdan her küçük adım için tekrar onay isteme.

## 19. Tamamlanma Kriteri

Bir özellik yalnızca arayüzü oluşturulduğu için tamamlanmış sayılmaz.

Özellik:

- Tasarıma uygun olmalı.
- Gerçek yerel verilerle çalışmalı.
- İlgili etkileşimleri yerine getirmeli.
- Gerekli doğrulamaları uygulamalı.
- Hata durumlarını ele almalı.
- Mümkün olduğunda test edilmeli.
- Diğer ekranlarla tutarlı çalışmalıdır.

Projenin tamamlanmış sayılması için `project.md` dosyasındaki kabul kriterleri karşılanmalıdır.

