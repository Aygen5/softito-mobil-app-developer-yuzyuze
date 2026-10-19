# Günlüğüm — Tasarım Sistemi

## 1. Tasarım Kaynağı

Ana tasarım referansı Stitch tarafından oluşturulan takvim ve günlük ekranlarıdır.

Stitch çıktıları mevcutsa şu konumlardan incelenmelidir:

- design_reference/calendar_screen.html
- design_reference/diary_screen.html
- design_reference/screenshots/

Bu dosyalar yoksa mevcut referans dosyaları ve ekran görüntüleri kontrol edilmelidir.

## 2. Tasarımın Genel Hissi

- Sade
- Modern
- Huzurlu
- Kişisel
- Okunabilir
- Mobil kullanıma uygun

Arayüz, fiziksel bir günlüğün sıcaklığını korurken modern bir mobil uygulama gibi davranmalıdır.

## 3. Renk Sistemi

Stitch tasarımı incelendikten sonra gerçek renkler belirlenmelidir.

Aşağıdaki renk grupları tanımlanacaktır:

- Ana arka plan
- İkincil arka plan
- Ana metin
- İkincil metin
- Ana vurgu rengi
- Seçili takvim günü
- Kenarlıklar ve ayırıcılar
- Kaydetme ve başarı durumu

Renkler mümkün olduğunca tek bir merkezî dosyadan yönetilmelidir.

Önerilen dosya: lib/theme/app_colors.dart

Bu dosya, mevcut proje yapısı ve gerçekten ihtiyaç duyulması durumunda oluşturulmalıdır.

## 4. Yazı Tipleri ve Metin Stilleri

- Ekran başlıkları belirgin olmalıdır.
- Tarih metinleri kolay okunmalıdır.
- Günlük yazma alanında uzun metin okumayı kolaylaştıran bir stil kullanılmalıdır.
- İkincil açıklamalar ana metinden daha düşük görsel önceliğe sahip olmalıdır.
- Yazı tipi boyutları tutarlı olmalıdır.

Stitch tasarımında özel bir font varsa mevcut proje ve lisans durumu kontrol edilmelidir. Gereksiz font paketi eklenmemelidir.

## 5. Boşluklar ve Yerleşim

- Ekran kenarlarında tutarlı boşluklar kullanılmalıdır.
- Kartlar ve bölümler arasında düzenli aralıklar olmalıdır.
- Metin alanı rahat yazmaya uygun büyüklükte olmalıdır.
- Takvim hücreleri dokunmaya elverişli olmalıdır.
- Küçük ekranlarda taşma olmamalıdır.

Kesin ölçüler Stitch çıktısı incelendikten sonra belirlenmelidir.

## 6. Tekrar Kullanılabilir Bileşenler

Gerekli olduğu ölçüde:

- Takvim günü hücresi
- Ay değiştirme kontrolleri
- Günlük yazma alanı
- Kaydet butonu
- Tarih başlığı

ayrı widget'lar olarak düzenlenebilir.

Her görsel parça için gereksiz yere yeni widget oluşturulmamalıdır.

## 7. Etkileşim Durumları

Aşağıdaki durumlar görsel olarak birbirinden ayırt edilebilmelidir:

- Normal takvim günü
- Seçili gün
- Günlük yazılmış gün
- Pasif kontrol
- Kaydetme işlemi
- Başarılı kayıt

Günlük kaydı bulunmayan tarihler, kayıtlı günlük varmış gibi gösterilmemelidir.

## 8. Flutter Uygulama Kuralları

- Tasarım Flutter widget'larıyla yeniden oluşturulmalıdır.
- Uygun olduğunda Material widget'ları tercih edilmelidir.
- HTML ve CSS doğrudan Dart kodu gibi kullanılmamalıdır.
- Stitch tasarımındaki görsel hiyerarşi korunmalıdır.
- Kullanıcıya görünen bütün metinler Türkçe olmalıdır.
- Ekranlar mobil cihazlarda düzgün görünmelidir.

## 9. Tasarım Tutarlılığı

Aynı renk, yazı stili, kenarlık ve boşluk değerleri farklı ekranlarda tutarlı kullanılmalıdır.

Tasarım değişikliği gerektiğinde mümkün olduğunca merkezî değerler güncellenmelidir.

Stitch tasarımında olmayan büyük özellikler, animasyonlar veya yeni ekranlar kendiliğinden eklenmemelidir.