# Günlüğüm — Mimari Kurallar

## 1. Mimari Yaklaşım

Uygulama, başlangıç seviyesine uygun basit ve modüler bir Flutter yapısıyla geliştirilecektir.

Amaç, kodları sorumluluklarına göre ayırmak; ancak gereksiz katmanlar ve ileri seviye mimari desenleri eklememektir.

## 2. Hedef Klasör Yapısı

lib/
  main.dart
  models/
    diary_entry.dart
  screens/
    calendar_screen.dart
    diary_screen.dart
  widgets/
    calendar_grid.dart
    diary_editor.dart

Mevcut proje yapısı önce incelenmeli ve gerekiyorsa bu yapıya uyarlanmalıdır.

## 3. Dosya Sorumlulukları

### main.dart

- Uygulamayı başlatır.
- MaterialApp yapılandırmasını içerir.
- İlk ekranı belirler.
- Gereksiz uygulama mantığı içermez.

### models/diary_entry.dart

Bir günlük kaydını temsil eder.

Başlangıçta şu alanlar yeterlidir:

- Tarih
- Günlük metni

Model, gereksiz alanlarla veya karmaşık metotlarla büyütülmemelidir.

### screens/calendar_screen.dart

- Seçili ay ve yılı takip eder.
- Önceki ve sonraki ayı gösterir.
- Takvim ekranını oluşturur.
- Gün seçimini yönetir.
- Seçilen tarihi günlük ekranına aktarır.

### screens/diary_screen.dart

- Seçilen tarihi alır.
- O tarihe ait günlük metnini yükler.
- Metin girişini gösterir.
- Kaydetme işlemini gerçekleştirir.
- Geri dönüş navigasyonunu destekler.

### widgets/calendar_grid.dart

- Haftanın günlerini ve ayın günlerini gösterir.
- Seçili günü görsel olarak belirtir.
- Gün seçimi için gerekli etkileşimi sağlar.
- Takvim ekranının gereksiz büyümesini önler.

### widgets/diary_editor.dart

- Günlük metni için çok satırlı giriş alanını oluşturur.
- Yazma alanının görsel düzenini sağlar.
- Kaydetme işlemini çağırmak için gerekli arayüzü sunar.

## 4. Ekranlar Arası İletişim

Takvim ekranından günlük ekranına geçilirken seçilen tarih açıkça aktarılmalıdır.

Başlangıç seviyesine uygun olduğunda `Navigator.push` ve `Navigator.pop` kullanılabilir.

Geri dönüldüğünde takvimdeki günlük işaretleri güncel kayıt durumuna göre yenilenmelidir.

## 5. State Yönetimi

Öncelik, en basit anlaşılır çözümdür.

- Küçük ve yerel ekran durumları için `setState` kullanılabilir.
- Birden fazla widget'ın dinlemesi gereken basit durumlarda `ValueNotifier` ve `ValueListenableBuilder` kullanılabilir.
- Aynı problem için gereksiz yere birden fazla state yönetimi yöntemi kullanılmamalıdır.
- İzin alınmadan yeni state yönetimi paketi eklenmemelidir.

## 6. Controller ve Kaynak Yönetimi

`TextEditingController` gibi kaynaklar oluşturuluyorsa yaşam döngüleri doğru yönetilmelidir.

Bir `StatefulWidget` içinde oluşturulan controller, uygun olduğunda `dispose()` içinde temizlenmelidir.

Bir `StatelessWidget` içinde kontrolsüz biçimde oluşturulmuş ve yaşam döngüsü yönetilemeyen kaynaklar bırakılmamalıdır.

## 7. Tarih ve Günlük Eşleştirmesi

Her tarih için tek bir günlük kaydı bulunmalıdır.

Tarih karşılaştırmalarında saat ve dakika farklılıkları yanlış eşleşmeye neden olmamalıdır.

Ay değiştirme ve takvim hücreleri hesaplanırken ayın gerçek gün sayısı ve haftanın başlangıç günü dikkate alınmalıdır.

Bir tarihin metni başka bir tarihin metniyle karıştırılmamalıdır.

## 8. Veri Saklama

Önce mevcut proje bağımlılıkları incelenmelidir.

Veriler yalnızca uygulama belleğinde tutuluyorsa uygulama yeniden başlatıldığında kaybolabilecekleri belirtilmelidir.

Kalıcı depolama gerekiyorsa en basit uygun çözüm seçilmeli ve yeni bağımlılık eklenmeden önce gerekçesi açıklanmalıdır.

Backend, bulut veritabanı veya hesap sistemi oluşturulmamalıdır.

## 9. Kod Kalitesi

- Tekrarlanan arayüzler yeniden kullanılabilir widget'lara ayrılmalıdır.
- Uygun widget'larda `const` kullanılmalıdır.
- Gereksiz dosya ve sınıflar oluşturulmamalıdır.
- Dosya ve sınıf isimleri tutarlı olmalıdır.
- Kod öğrenci tarafından takip edilebilecek açıklıkta yazılmalıdır.

## 10. Doğrulama

Değişikliklerden sonra uygun oldukça şu komutlar çalıştırılmalıdır:

flutter analyze
flutter test
flutter run

Çalıştırılmayan testler çalıştırılmış gibi raporlanmamalıdır.