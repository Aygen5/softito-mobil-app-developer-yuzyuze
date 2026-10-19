---
name: flutter-diary-scaffold
description: Günlüğüm Flutter uygulamasında Stitch tasarımını incelemek, tasarımı Flutter widget'larına dönüştürmek ve takvim ile günlük ekranlarını başlangıç seviyesine uygun şekilde geliştirmek için kullanılır.
---

# Flutter Diary Scaffold Skill

## 1. Amaç

Günlüğüm projesini mevcut proje kurallarına uygun, anlaşılır ve düzenli Flutter koduyla geliştirmek.

Öncelikli görevler:

- Stitch tasarımını incelemek.
- Tasarımı Flutter widget'larına dönüştürmek.
- Kodları doğru dosyalara yerleştirmek.
- Takvim ve günlük ekranlarını işlevsel hâle getirmek.
- Öğrenciye yapılan değişiklikleri açıklamak.

## 2. İşe Başlamadan Önce

1. Mevcut proje dosyalarını incele.
2. `project.md`, `architecture.md` ve `design-system.md` dosyalarını oku.
3. Stitch referanslarının konumlarını kontrol et.
4. Mevcut Flutter ve Dart sürümlerini incele.
5. Kullanılan paketleri ve mevcut kodları kontrol et.
6. Dosya oluşturmadan önce mevcut yapıyla çelişki olup olmadığını belirle.

Mevcut çalışan kodu gereksiz yere silme veya baştan yazma.

## 3. Stitch Tasarımını Flutter'a Dönüştürme

Stitch çıktısı HTML, CSS veya başka bir biçimde olabilir.

Bu çıktıları doğrudan Dart kodu olarak kabul etme.

Önce tasarımın yapısını incele:

- Ekran düzeni
- Renkler
- Yazı stilleri
- Boşluklar
- Takvim hücreleri
- Butonlar
- Metin alanları
- Etkileşimler

Ardından bunları uygun Flutter widget'larıyla yeniden oluştur.

Örnek eşleştirmeler:

- Sayfa yapısı: Scaffold
- Dikey düzen: Column
- Yatay düzen: Row
- Metin: Text
- Dokunulabilir gün hücresi: InkWell veya uygun bir Material bileşeni
- Günlük metin girişi: TextField
- Boşluk: SizedBox
- Kenarlıklı yüzey: Container veya uygun bir Material widget'ı

Bu eşleştirmeler zorunlu bir liste değildir. Mevcut Flutter sürümüne ve tasarıma uygun olan en basit widget'ı seç.

HTML, CSS, JavaScript veya web framework'lerini Flutter uygulamasına gereksiz bağımlılık olarak ekleme.

## 4. Kodları Doğru Dosyalara Yerleştirme

`architecture.md` dosyasındaki sorumlulukları takip et.

- Model kodu model dosyasında olmalıdır.
- Ekran düzeni ilgili ekran dosyasında bulunmalıdır.
- Birden fazla yerde kullanılan arayüz parçaları uygun widget dosyalarına ayrılmalıdır.
- Uygulamanın başlangıç kodu gereksiz yere büyütülmemelidir.

Mevcut proje yapısına aykırı değişiklik yapmadan önce gerekçesini açıkla.

## 5. Takvim Ekranı

- Ay ve yıl bilgisini göster.
- Önceki ve sonraki ay geçişlerini uygula.
- Ayın gerçek gün sayısını hesapla.
- Haftanın günlerini doğru sırada yerleştir.
- Kullanıcının seçtiği günü görsel olarak ayırt et.
- Bir güne dokunulduğunda ilgili tarihi günlük ekranına aktar.

Takvim günlerini sabit bir örnek liste olarak kodlama.

## 6. Günlük Ekranı

- Seçilen tarihi başlıkta göster.
- Günlük metnini yazmak için bir metin alanı oluştur.
- Kaydet butonunu işlevsel hâle getir.
- Aynı tarih için var olan metni yükle.
- Metnin düzenlenebilmesini sağla.
- Başka bir güne geçildiğinde önceki günün metnini yanlışlıkla gösterme.

## 7. State ve Navigasyon

Öncelikle derste işlenebilecek basit Flutter araçlarını kullan:

- `setState`
- `Navigator.push`
- `Navigator.pop`
- `TextField`
- `StatelessWidget`
- `StatefulWidget`

Gerekli olduğunda `ValueNotifier` ve `ValueListenableBuilder` kullanılabilir.

Bunları yalnızca ihtiyaç varsa kullan. Aynı problem için birden fazla state yönetimi yöntemi ekleme.

İleri seviye mimari, harici state yönetimi paketi veya karmaşık navigasyon sistemi ekleme.

## 8. Kaydetme ve Veri Saklama

Önce mevcut veri yapısını incele.

Verinin yalnızca uygulama belleğinde tutulmasıyla kalıcı olarak saklanması arasındaki farkı gözet.

Kalıcı kayıt isteniyorsa uygun yerel depolama seçeneğini belirle. Yeni paket eklemeden önce neden gerekli olduğunu açıkla.

Kullanıcıya kalıcı kayıt özelliği tamamlanmamışken kayıtların uygulama yeniden başlatıldığında korunacağını söyleme.

## 9. Kod Kalitesi

- Uygun yerlerde `const` kullan.
- Büyük ve karmaşık widget yapılarını uygun parçalara ayır.
- İsimlendirmeyi tutarlı tut.
- Kaynakların yaşam döngüsünü doğru yönet.
- Gereksiz paket, dosya veya soyutlama ekleme.
- Var olan testleri silme veya etkisizleştirme.

## 10. Kontrol ve Raporlama

Değişikliklerden sonra uygun oldukça:

flutter analyze
flutter test
flutter run

komutlarını çalıştır.

Çalıştırılamayan kontrolleri açıkça bildir.

Kullanıcıya şunları kısa şekilde açıkla:

1. Hangi dosyalar oluşturuldu veya değiştirildi?
2. Her dosya ne işe yarıyor?
3. Hangi Flutter konuları kullanıldı?
4. Neler test edildi?
5. Bilinen eksikler var mı?

Amaç, sadece çalışan kod üretmek değil, öğrencinin kodu anlayabilmesini de sağlamaktır.