# Günlüğüm — Proje Tanımı

## 1. Proje Amacı

Günlüğüm, kullanıcıların aylık takvim üzerinden bir gün seçerek o güne ait kişisel günlük yazısı yazmasını, kaydetmesini, görüntülemesini ve düzenlemesini sağlayan bir Flutter mobil uygulamasıdır.

Uygulama, başlangıç seviyesindeki Flutter konularına uygun ve öğrenilebilir bir yapıda geliştirilecektir.

## 2. Hedef Platform

- Android
- iOS, mevcut Flutter projesi destekliyorsa

## 3. Uygulama Dili

Uygulamadaki kullanıcıya görünen tüm metinler Türkçe olacaktır.

## 4. Temel Kullanıcı Akışı

1. Kullanıcı uygulamayı açar.
2. Aylık takvim ekranını görür.
3. Önceki veya sonraki aya geçebilir.
4. Takvimden bir gün seçer.
5. Seçilen tarihe ait günlük ekranı açılır.
6. Kullanıcı günlük metnini yazar.
7. Kaydet butonuyla metni kaydeder.
8. Aynı tarihe tekrar girdiğinde kayıtlı metnini görebilir ve düzenleyebilir.
9. Takvim ekranına döndüğünde günlük yazılmış tarihleri ayırt edebilir.

## 5. İlk Sürüm Özellikleri

- Aylık takvim görünümü
- Aylar arasında geçiş
- Gün seçimi
- Tarihe özel günlük ekranı
- Çok satırlı metin girişi
- Günlük kaydetme ve düzenleme
- Günlük bulunan tarihler için işaret
- Türkçe tarih gösterimi
- Stitch tasarımına uygun mobil arayüz

## 6. Kapsam Dışı Özellikler

İlk sürümde aşağıdakiler uygulanmayacaktır:

- Kullanıcı kaydı ve giriş
- Sunucu veya backend
- Bulut senkronizasyonu
- Yapay zekâ özellikleri
- PDF oluşturma veya PDF düzenleme
- Fotoğraf yükleme
- Gelişmiş animasyonlar
- Gelişmiş bildirim sistemi
- Onay alınmadan eklenen üçüncü taraf paketler

## 7. Teknik Kısıtlamalar

- Flutter ve Dart kullanılacaktır.
- Mevcut projenin Flutter ve Dart sürümleri korunacaktır.
- Öncelikle Flutter'ın yerleşik widget'ları kullanılacaktır.
- State yönetimi basit tutulacaktır.
- Gereksiz soyutlama ve karmaşık mimari oluşturulmayacaktır.
- Mevcut kodlar incelenmeden yeni dosyalar oluşturulmayacak veya dosyalar silinmeyecektir.

## 8. Veri Saklama

Her günlük, belirli bir tarihle ilişkilendirilecektir.

Aynı tarihte yeni kayıt oluşturmak yerine mevcut günlük düzenlenebilmelidir.

Verinin uygulama kapatıldıktan sonra da korunması istenmektedir. Kalıcı depolama yöntemi seçilmeden önce mevcut proje bağımlılıkları ve ders kapsamı incelenmelidir.

Yeni bir paket gerekiyorsa eklemeden önce gerekçesi açıklanmalıdır.

Kalıcı kayıt henüz uygulanmamışsa kullanıcıya bu durum açıkça bildirilmelidir.

## 9. Tamamlanma Kriterleri

- Uygulama sorunsuz açılır.
- Takvim doğru ay ve gün sayısını gösterir.
- Ay değiştirme kontrolleri çalışır.
- Seçilen gün doğru günlük ekranını açar.
- Her tarih kendi günlük metniyle eşleştirilir.
- Kaydetme ve tekrar açma işlevleri doğrulanır.
- Arayüz Stitch tasarımına mümkün olduğunca uygun olur.
- Kod analizinden kaynaklanan hatalar giderilir.
- Öğrenciye önemli kod değişiklikleri Türkçe ve anlaşılır şekilde açıklanır.