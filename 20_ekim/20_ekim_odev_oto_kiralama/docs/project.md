# RotaRent — Proje Tanımı

## 1. Projeye Genel Bakış

RotaRent, Flutter ve Dart kullanılarak geliştirilecek Türkçe bir araç kiralama ve rezervasyon mobil uygulamasıdır.

Uygulamanın temel amacı; araçları listelemek, araç detaylarını incelemek, müsait tarihleri takvim üzerinden seçmek, rezervasyon oluşturmak ve oluşturulan rezervasyonları görüntülemektir.

Proje, Flutter'ın temel geliştirme konularını gerçekçi bir senaryo üzerinden uygulamayı hedefleyen eğitim amaçlı bir projedir.

Uygulama yalnızca istemci tarafında çalışacaktır. Backend, veritabanı, harici API veya gerçek bir kimlik doğrulama servisi kullanılmayacaktır.

## 2. Projenin Amaçları

- Flutter ve Dart ile çalışan bir mobil uygulama geliştirmek.
- Material Design 3 tasarım ilkelerini uygulamak.
- Açık ve koyu tema desteği sağlamak.
- Araç verilerini yerel JSON dosyasından okumak.
- Araç listeleme, filtreleme ve sıralama özelliklerini uygulamak.
- Dinamik araç müsaitlik takvimi oluşturmak.
- Rezervasyon formu ve form doğrulaması geliştirmek.
- Rezervasyon ücretini yerel olarak hesaplamak.
- Demo rezervasyonlarını uygulama belleğinde yönetmek.
- Sayfa geçişleri, butonlar, diyaloglar ve alt pencereler kullanmak.
- Okunabilir ve sürdürülebilir bir Flutter klasör yapısı oluşturmak.

## 3. Teknolojiler ve Genel Kurallar

- Programlama dili: Dart
- Mobil uygulama çatısı: Flutter
- Tasarım sistemi: Material Design 3
- Uygulama dili: Türkçe
- Para birimi: Türk lirası (₺)
- Tarih gösterimi: `20.10.2026` gibi Türkçe tarih biçimi
- Veri kaynağı: Yerel JSON dosyaları
- Rezervasyon yönetimi: Uygulama belleğinde tutulan yerel veriler
- Tema yönetimi: Açık ve koyu tema
- Navigasyon: Flutter'ın yerleşik `Navigator` yapısı

Geliştirme sürecinde mevcut Flutter sürümüyle uyumlu, kararlı ve gereksiz karmaşıklık yaratmayan çözümler tercih edilmelidir.

## 4. Uygulamanın Dört Ana Ekranı

### 4.1. Ana Sayfa

Ana sayfa, kullanıcıların araçları keşfetmesini sağlar.

İçerik:

- RotaRent marka alanı.
- Kullanıcıyı karşılayan kısa bir mesaj.
- Araç arama alanı.
- Örnek alış ve dönüş noktaları.
- Tarih seçimi özeti.
- Araç kategorileri: Basic, Basic+, Flex, Flex+, Lux ve Ultra Lux.
- Öne çıkan araç kartları.
- Türkiye haritasını temsil eden basit bir görsel ve örnek şube işaretleri.
- Ana Sayfa, Rezervasyonlarım ve Hesabım alt navigasyonu.

Harita yalnızca görsel bir temsil olacaktır. Gerçek harita servisi veya konum API'si kullanılmayacaktır.

### 4.2. Araç Listesi

Araç listesi, seçilen kategoriye veya arama kriterlerine uyan araçları gösterir.

Özellikler:

- Araçların fotoğrafı, markası, modeli ve model yılı.
- Günlük kiralama fiyatı.
- Vites türü ve yakıt türü.
- Araç kategorisi.
- Tek sütunlu, iki sütunlu ve üç sütunlu görünüm seçeneği.
- Fiyata göre artan ve azalan sıralama.
- Model yılına göre sıralama.
- Kilometreye göre sıralama.
- Kategori, marka ve vites türüne göre filtreleme.
- Minimum ve maksimum fiyat aralığı filtresi.
- Filtreleri temizleme.
- Sonuç bulunamadığında boş durum mesajı.

Tüm filtreleme ve sıralama işlemleri yerel araç listesi üzerinde gerçekleştirilecektir.

### 4.3. Araç Detayı ve Rezervasyon

Bu ekran projenin temel işlevlerini bir araya getirir.

Araç bilgileri:

- Araç fotoğrafları.
- Marka, model ve model yılı.
- Araç kategorisi.
- Vites ve yakıt türü.
- Kilometre bilgisi.
- Yakıt seviyesi ve tahmini kalan menzil.
- Araç açıklaması.
- Saatlik ve günlük kiralama fiyatı.
- Uzun süreli kiralamalarda örnek indirim.
- Günlük 250 km kullanım hakkı hakkında bilgilendirme.

Rezervasyon alanı:

- Alış ve dönüş tarihleri.
- Alış ve dönüş saatleri.
- Alış ve dönüş noktaları.
- İsteğe bağlı gidilecek şehir.
- Tahmini toplam ücret.
- Dinamik müsaitlik takvimi.
- Rezervasyon oluşturma butonu.

Yakıt göstergesine basıldığında örnek benzin, dizel ve LPG fiyatlarını gösteren bir diyalog açılabilir. Fiyatlar temsili olacaktır; gerçek zamanlı fiyat verisi olarak sunulmayacaktır.

### 4.4. Hesabım ve Rezervasyonlarım

Kullanıcı bilgileri ve rezervasyonları aynı ekranda gösterilecektir.

İçerik:

- Demo kullanıcı profili.
- Aktif ve geçmiş rezervasyonlar.
- Araç fotoğrafı ve adı.
- Rezervasyon tarihleri.
- Tahmini toplam ücret.
- Rezervasyon durumunu gösteren etiket.
- Örnek kiralama sözleşmesini görüntüleme.
- Açık/koyu tema seçimi.
- Çıkış yapma işlemi.

Rezervasyonlar için örnek durumlar: Onaylandı, Bekliyor ve Tamamlandı.

Çıkış yapma işlemi öncesinde onay diyaloğu açılmalıdır.

## 5. Dinamik Müsaitlik Takvimi

Dinamik takvim projenin zorunlu ve en önemli özelliğidir.

Her araç için yerel verilerde dolu tarih aralıkları tanımlanacaktır. Kullanıcının seçtiği tarih aralığı, ilgili aracın dolu tarih aralıklarıyla karşılaştırılacaktır.

Kurallar:

1. Geçmiş tarihler için yeni rezervasyon oluşturulamaz.
2. Dolu tarihler takvimde kırmızı veya belirgin bir uyarı rengiyle gösterilir.
3. Müsait tarihler seçilebilir.
4. Seçilen alış ve dönüş tarihleri farklı biçimlerde vurgulanır.
5. Seçilen aralığın içindeki dolu günler kontrol edilir.
6. Tarih aralığında çakışma varsa rezervasyon oluşturulamaz.
7. Kullanıcıya Türkçe ve anlaşılır bir hata mesajı gösterilir.
8. Dönüş tarihi alış tarihinden önce olamaz.
9. Aynı araç için uygulama belleğinde oluşturulan yeni rezervasyonlar da müsaitlik kontrolüne dahil edilir.

Rezervasyon tarihleri, uygulamanın kullandığı tarih aralığı kuralına göre kontrol edilmelidir. Aynı gün teslim ve yeni kiralama senaryosunu doğru yönetmek için alış ve dönüş zamanları da değerlendirilmelidir.

Bu sistem yalnızca yerel demo verileriyle çalışır. Gerçek kullanıcıların farklı cihazlarda yaptığı rezervasyonları takip etmez.

## 6. Rezervasyon ve Fiyatlandırma

Rezervasyon formu doğrulanmadan işlem tamamlanmamalıdır.

Asgari kontroller:

- Araç seçilmiş olmalıdır.
- Alış ve dönüş tarihleri geçerli olmalıdır.
- Tarih aralığı müsait olmalıdır.
- Alış ve dönüş saatleri mantıklı olmalıdır.
- Alış ve dönüş noktaları boş bırakılamamalıdır.
- Ücret geçerli kiralama süresine göre hesaplanmalıdır.

Saatlik ve günlük ücretler yerel araç verilerinde tanımlanacaktır.

Uzun süreli kiralama indirimi uygulanacaksa indirim oranı sabit ve anlaşılır bir iş kuralı olarak tanımlanmalıdır.

250 km günlük kullanım hakkı bilgilendirme amaçlı gösterilecektir. Gidilecek şehir girildiğinde gerçek rota veya mesafe servisi bulunmadığı için gerçek kilometre hesabı yapılmayacaktır. Bu alan, gerekli durumda örnek mesafe üzerinden açıklayıcı bir demo olarak sunulabilir.

Rezervasyon başarılı olduğunda kullanıcıya rezervasyon özeti, örnek rezervasyon numarası ve başarı mesajı gösterilir.

## 7. Yerel Veri Yönetimi

Araç bilgileri JSON dosyasında tutulacaktır.

Örnek alanlar:

- `id`
- `brand`
- `model`
- `year`
- `category`
- `transmission`
- `fuelType`
- `mileage`
- `hourlyPrice`
- `dailyPrice`
- `description`
- `image`
- `images`
- `fuelLevel`
- `estimatedRange`
- `unavailableRanges`

JSON dosyası Flutter varlığı olarak tanımlanmalı ve uygulama başlangıcında okunmalıdır.

Rezervasyonlar başlangıçta boş veya örnek verilerle oluşturulabilir. Yeni rezervasyonlar çalışma sırasında bellekte saklanır. Uygulama kapatıldığında bu verilerin korunacağı garanti edilmez.

Gerçek backend, veritabanı, bulut senkronizasyonu veya kalıcı kullanıcı hesabı oluşturulmayacaktır.

## 8. Kapsam Dışındaki Özellikler

Aşağıdaki özellikler ilk sürümde geliştirilmeyecektir:

- Gerçek kullanıcı kaydı ve giriş sistemi.
- T.C. kimlik doğrulama.
- NFC ile ehliyet okutma.
- Gerçek ödeme sistemi.
- Gerçek zamanlı yakıt fiyatları.
- Gerçek Türkiye haritası ve rota servisi.
- Backend ve veritabanı.
- Çok kullanıcılı rezervasyon senkronizasyonu.
- Gelişmiş yönetici paneli.
- Araç bakım ve muayene yönetim sistemi.
- Gerçek SMS veya e-posta gönderimi.

Giriş deneyimi gerekiyorsa yerel demo kullanıcı bilgileri veya basit bir demo giriş diyaloğu kullanılabilir.

## 9. Kabul Kriterleri

Proje tamamlandığında:

- Dört ana ekran çalışmalıdır.
- Araçlar yerel JSON verisinden yüklenmelidir.
- Araç kartından detay ekranına geçilebilmelidir.
- Filtreleme, sıralama ve görünüm değiştirme çalışmalıdır.
- Açık ve koyu tema bütün ekranlarda tutarlı olmalıdır.
- Takvim araç bazında müsaitlik kontrolü yapmalıdır.
- Dolu tarih aralığı