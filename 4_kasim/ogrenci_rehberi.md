# 📱 4 Kasım - Firebase Cloud Messaging (FCM), Yerel Bildirimler ve Storage Öğrenci Rehberi

Bu rehber; **4 Kasım** dersinde geliştirilen **`my_app`** ve **`my_app2`** projelerinin amacını, mimari kararlarını, kullanılan paketleri ve yazılan tüm dosyaların satır satır ne işe yaradığını anlatmak amacıyla hazırlanmıştır.

---

## 🧭 1. Büyük Resim: 4 Kasım'da Neler Yapıldı?

Modern mobil uygulamalarda kullanıcı etkileşimini ve veri yönetimini sağlayan en kritik iki unsur şunlardır:
1. **Anlık Bildirimler (Push Notifications):** Kullanıcı uygulamada olmasa bile ona haber ulaştırma (kampanya, yeni mesaj, duyuru vb.).
2. **Medya ve Bulut Depolama (Cloud Storage):** Kullanıcının galerisinden veya kamerasından seçtiği fotoğrafları buluta yükleme ve yönetme.

4 Kasım çalışmasında bu iki temel yetenek, iki aşamalı bir yaklaşımla ele alınmıştır:
- **1. Aşama (`my_app`):** Çekirdek servislerin kurulması. FCM izinleri, FCM Token alma, yerel bildirim kanalları kurma, kamera/galeri medya seçimi ve Firebase Storage yükleme görevi (UploadTask) prototiplendi.
- **2. Aşama (`my_app2`):** Yazılan servislerin **Katmanlı Mimari (Layered Architecture)** prensiplerine uygun olarak `models/`, `services/` ve `widgets/` katmanlarına bölünmesi; Topic (Konu) aboneliği, bildirim modeli (`BildirimModeli`), gelişmiş storage işlemleri (Download URL alma, dosya silme) ve dinamik bir **FCM Bildirim Merkezi Kartı** (`BildirimListesiKarti`) ile zenginleştirilmesi sağlandı.

---

## 🗂️ 2. Repository Klasör Düzeni ve İsimlendirme Standardı

Repository genelindeki tarihsel bütünlüğü sağlamak amacıyla klasör isimlendirmeleri tek tip formata kavuşturulmuştur:

| Eski Klasör Adı | Yeni Klasör Adı | Format Standardı | Açıklama |
| :--- | :--- | :--- | :--- |
| `2_kasim` | `2_kasim` | `[gün]_[ay]` | Dart 3 modern özellikleri ve router çalışmaları |
| `_3_kasim_veri` | `3_kasim` | `[gün]_[ay]` | Firebase Cloud Firestore entegrasyonu ve CRUD |
| `04.11.2026` | `4_kasim` | `[gün]_[ay]` | Firebase FCM, Yerel Bildirimler ve Storage |

> [!NOTE]
> **Neden `[gün]_[ay]` Tercih Edildi?**
> Repository'de önceki tüm günler `19_ekim`, `20_ekim`, `21_ekim`, `22_ekim` şeklinde adlandırılmıştır. Kasım klasörlerinin de `2_kasim`, `3_kasim`, `4_kasim` şeklinde düzenlenmesi tüm projede %100 isim standardı sağlamıştır.
> 
> **Kritik Bilgi:** `3_kasim` içindeki `pubspec.yaml` dosyasında paket adı `_3_kasim_veri` olarak tanımlıdır (çünkü Dart dilinde paket adları rakamla başlayamaz). Klasör adının `3_kasim` yapılması Dart/Flutter derleyicisini etkilemez; çünkü Flutter projelerinde importlar klasör adından değil, `pubspec.yaml` içindeki `name:` alanından çözümlenir.

---

## 📦 3. Kullanılan Kütüphaneler ve Amaçları

Her iki projede de aşağıdaki popüler ve endüstri standardı paketler kullanılmıştır:

| Paket Adı | Görevi / Kullanım Amacı |
| :--- | :--- |
| **`firebase_core`** | Firebase servislerinin başlatılması ve çekirdek yapılandırması. |
| **`firebase_messaging`** | Firebase Cloud Messaging (FCM) altyapısı ile uzaktan anlık bildirim alma, token yönetimi ve konu abonelikleri. |
| **`flutter_local_notifications`** | Cihaz üzerinde yerel bildirim kanalları oluşturma ve uygulama ön plandayken (foreground) ekranın üstünde açılır bildirim (heads-up banner) gösterme. |
| **`firebase_storage`** | Görsellerin Firebase Storage bulut havuzuna yüklenmesi, meta verilerinin atanması, indirme URL'lerinin alınması ve silinmesi. |
| **`image_picker`** | Kullanıcının kamera veya fotoğraf albümü (galeri) aracılığıyla görsel seçmesini sağlama. |

---

## 🚀 4. Proje 1 Analizi: `4_kasim/my_app` (Temel Servisler)

`my_app` projesinde `lib/` dizini altında 5 adet dosya bulunmaktadır:

```
4_kasim/my_app/lib/
 ┣ 📄 bildirim_controller.dart  -> Yerel bildirim yöneticisi (flutter_local_notifications)
 ┣ 📄 bildirim_servisi.dart     -> FCM izinleri, token alma ve arka plan işleyicisi
 ┣ 📄 medya_secicisi.dart       -> Galeri ve kameradan optimize görsel seçimi
 ┣ 📄 storage_servisi.dart      -> Firebase Storage'a yükleme ve yükleme yüzdesi dinleme
 ┗ 📄 main.dart                 -> Uygulama giriş noktası ve UI şablonu
```

### 1) `bildirim_controller.dart` (`YerelBildirimYoneticisi`)
- **Neden Yazıldı?** FCM, uygulama açıkken (ön planda) gelen bildirimleri sistem çubuğuna otomatik basmaz. Bu bildirimi kullanıcıya göstermek için yerel bildirim eklentisi devreye girer.
- **`kurulum()` Metodu:**
  - `AndroidInitializationSettings('@mipmap/ic_launcher')`: Bildirim simgesi olarak uygulamanın varsayılan launcher ikonunu belirler.
  - `DarwinInitializationSettings()`: iOS ve macOS için izin ve bildirim başlatıcılarını ayarlar.
  - `_yerelBildirim.initialize()`: Bildirim motorunu hazır hale getirir.
- **`bildirimGoster(RemoteMessage message)` Metodu:**
  - `AndroidNotificationDetails`: Android 8.0+ için zorunlu olan bildirim kanalını (`softito_kanal_id`, `Softito Bildirimleri`) tanımlar. `importance: Importance.max` ve `priority: Priority.high` ile bildirimin ekranın tepesinden pop-up şeklinde düşmesini (heads-up banner) sağlar.
  - `message.hashCode`: Her bildirime benzersiz bir sayısal ID verir.
  - `_yerelBildirim.show()`: Bildirimi ekranda patlatır.

### 2) `bildirim_servisi.dart` (`BildirimServisi`)
- **`_firebaseMessagingBackgroundHandler(RemoteMessage message)`:**
  - `@pragma('vm:entry-point')`: Dart derleyicisinin (AOT/tree-shaking) bu fonksiyonu "kullanılmıyor" sanarak silmesini engeller. Uygulama kapalıyken işletim sistemi ayrı bir Dart izolatı (isolate) ayağa kaldırarak bu fonksiyonu çağırır.
- **`baslat()` Metodu:**
  - `requestPermission(alert: true, badge: true, sound: true)`: iOS ve Android 13+ (API 33+) cihazlarda kullanıcıdan çalışma zamanında (runtime) bildirim izni talep eder.
  - `getToken()`: Cihaza özel tekil **FCM Token** üretir. Bu token backend sunucusuna iletilerek kullanıcıya özel bildirim gönderimi sağlanır.

### 3) `medya_secicisi.dart` (`MedyaSecicisiService`)
- **`galeridenSec()`:** Kullanıcının albümünü (`ImageSource.gallery`) açar.
- **`kameradanSec()`:** Cihaz kamerasını (`ImageSource.camera`) açar.
- **Performans Optimizasyonları:**
  - `imageQuality: 80`: Fotoğraf kalitesini %80'e optimize ederek megabaytlarca gereksiz veri transferini engeller.
  - `maxWidth: 1200`: Fotoğrafın maksimum genişliğini 1200 piksele düşürür. Böylece hem bellek taşması (Out Of Memory - OOM) riski önlenir hem de Firebase Storage yükleme hızı katbekat artar.
  - `secilen == null`: Kullanıcı fotoğraf seçmeden vazgeçerse uygulamanın çökmesini engeller ve `null` döner.

### 4) `storage_servisi.dart` (`StorageServisi`)
- **`yuklemeBaslat(...)` Metodu:**
  - `_storage.ref().child(hedefDizin).child(dosyaAdi)`: Firebase Storage üzerindeki depolama yolunu (referans) oluşturur.
  - `SettableMetadata`: Dosya tipini (`image/jpeg`) ve audit/izleme amaçlı özel meta veriyi (`customMetadata: {'yukleyen': 'çervo'}`) dosyaya iliştirir.
  - `referans.putFile(dosya, metadata)`: Yükleme işlemini asenkron olarak başlatır ve geriye bir **`UploadTask`** nesnesi döner.
  - `task.snapshotEvents.listen(...)`: Yükleme akışını (stream) dinleyerek aktarılan bayt miktarından anlık yükleme yüzdesini hesaplar (`bytesTransferred / totalBytes * 100`).

---

## 🏗️ 5. Proje 2 Analizi: `4_kasim/my_app2` (Katmanlı Mimari ve Gelişmiş Özellikler)

`my_app2` projesinde kodlar katmanlarına (`models`, `services`, `widgets`) ayrılmıştır:

```
4_kasim/my_app2/lib/
 ┣ 📁 models/
 ┃ ┗ 📄 bildirim_modeli.dart       -> İmmutable bildirim veri modeli (copyWith destekli)
 ┣ 📁 services/
 ┃ ┣ 📄 fcm_bildirim_servisi.dart  -> Topic abonelikleri ve yerel bildirim tetiklemeli FCM servisi
 ┃ ┗ 📄 storage_service.dart       -> Medya seçimi, buluta yükleme, URL alma ve silme servisi
 ┣ 📁 widgets/
 ┃ ┗ 📄 bildirim_listesi_kartı.dart -> FCM kontrol merkezi ve token kopyalama kartı
 ┗ 📄 main.dart                    -> Giriş noktası
```

### 1) `models/bildirim_modeli.dart` (`BildirimModeli`)
- Tip güvenli veri tutucudur: `id`, `baslik`, `icerik`, `tarih`, `okunduMu`.
- Tüm alanları `final` olduğu için nesne **değişmezdir (immutable)**.
- **`copyWith` Deseni:** Bir bildirimi "okundu" olarak işaretlemek istediğimizde var olan nesneyi bozmadan yalnızca `okunduMu: true` olan yeni bir kopyasını üretmemizi sağlar:
  ```dart
  final guncelBildirim = bildirim.copyWith(okunduMu: true);
  ```

### 2) `services/fcm_bildirim_servisi.dart` (`FcmBildirimServisi`)
- **Ön Plan Dinleyicisi (`FirebaseMessaging.onMessage.listen`):** Uygulama açıkken mesaj geldiğinde hem `_yerelBildirimGoster` ile heads-up bildirim patlatır hem de `onMesajGeldi` callback'i ile UI'daki listeyi günceller.
- **Konu (Topic) Aboneliği:**
  - `konudanAboneOl(String konu)`: `_firebaseMessaging.subscribeToTopic(konu)`
  - `konudanAyrıl(String konu)`: `_firebaseMessaging.unsubscribeFromTopic(konu)`
  - *Topic Avantajı:* Tek tek binlerce cihazın token'ını veritabanında arayıp döngüyle mesaj atmak yerine, Firebase sunucusuna tek bir emir vererek konuya abone olan tüm cihazlara (Örn: `tum_sinif`) aynı anda yayın (broadcast) yapılır.

### 3) `services/storage_service.dart` (`StorageServisi`)
- Medya seçimi (`gorselSec`) ile depolama işlemlerini tek bir serviste birleştirmiştir.
- **`urlGetir(Reference ref)`:** Dosya yüklendikten sonra `ref.getDownloadURL()` çağırarak görselin internetten görüntülenebileceği HTTPS bağlantısını alır. Bu URL genellikle Firestore veritabanına kaydedilir.
- **`dosyaSil(String dosyaYolu)`:** `ref.delete()` çağırarak artık gerekmeyen dosyayı buluttan siler ve depolama kotasını korur.

### 4) `widgets/bildirim_listesi_kartı.dart` (`BildirimListesiKarti`)
- Gelişmiş, modüler bir arayüz kartıdır:
  1. **FCM Bildirim Merkezi Başlığı & Switch:** Kullanıcı tek bir dokunuşla tüm sınıf yayınına abone olabilir veya abonelikten çıkabilir.
  2. **Kopyalanabilir FCM Token Konsolu:** `SelectableText` kullanılmıştır. Cihazın uzun FCM Token'ı ekranda şık koyu renkli bir kutuda gösterilir; geliştirici token'a uzun basarak kopyalayabilir ve Firebase Console'da test edebilir.
  3. **Gelen Bildirimler Listesi:** `bildirimler.isEmpty` kontrolü ile boş durum (`Empty State`) uyarısı verir. Bildirimler geldiğinde ise `ListView.separated` ile okunmuş/okunmamış simgesi ve saat bilgisiyle listeler.

---

## ⚖️ 6. `my_app` ve `my_app2` Arasındaki Mimari Evrim

| Özellik | `my_app` (Aşama 1) | `my_app2` (Aşama 2) |
| :--- | :--- | :--- |
| **Mimari Yaklaşım** | Düz dosya yapısı (Flat structure) | Katmanlı Mimari (`models/`, `services/`, `widgets/`) |
| **Bildirim Yönetimi** | İki ayrı sınıfta (`BildirimServisi` + `YerelBildirimYoneticisi`) | Tek ve bütünleşik servis (`FcmBildirimServisi`) |
| **Konu (Topic) Mesajlaşma** | Yok (Yalnızca tekil token alma) | Var (`subscribeToTopic`, `unsubscribeFromTopic`) |
| **Veri Temsili** | Ham metin / doğrudan `RemoteMessage` | Tip güvenli `BildirimModeli` + `copyWith` |
| **Storage Yetenekleri** | Yalnızca `putFile` ve yükleme takibi | `gorselSec`, `putFile`, `getDownloadURL`, `delete` |
| **Arayüz (UI) Bileşeni** | Standart sayaç ekranı | Zengin `BildirimListesiKarti` (Switch + Token kutusu + Liste) |

---

## 🛠️ 7. Karşılaşılabilecek Hatalar ve Çözüm İpuçları

1. **Android 13+ (API 33) Bildirim İzni Sorunu:**
   - Android 13 ve üzerinde bildirim gönderebilmek için `AndroidManifest.xml` içine şu izin satırının eklenmesi gerekir:
     ```xml
     <uses-permission android:name="android.permission.POST_NOTIFICATIONS"/>
     ```
2. **Ön Planda Bildirimin Görünmemesi:**
   - FCM varsayılan olarak ön plandayken bildirim basmaz. Çözüm, `FirebaseMessaging.onMessage.listen` içinde `flutter_local_notifications` eklentisiyle yerel bildirim tetiklemektir.
3. **Arka Plan Fonksiyonunun Derleyici Tarafından Silinmesi:**
   - `_firebaseMessagingBackgroundHandler` fonksiyonunun başına `@pragma('vm:entry-point')` eklenmezse, Release derlemelerinde bildirim arka planda çalışmaz.
4. **Firebase Storage `object-not-found` veya `unauthorized` Hatası:**
   - Firebase Console -> Storage -> Rules sekmesinde güvenlik kurallarının test ortamı için açık olduğundan emin olunmalıdır:
     ```javascript
     rules_version = '2';
     service firebase.storage {
       match /b/{bucket}/o {
         match /{allPaths=**} {
           allow read, write: if true; // Test aşaması için
         }
       }
     }
     ```

---

## 🎯 8. Öğrencinin Kendini Denemesi İçin Pekiştirme Görevleri

1. **Tamamlama Görevi:** `my_app2` projesinin `main.dart` dosyasındaki sayaç şablonunu kaldırıp, `BildirimListesiKarti` bileşenini ekrana yerleştirin.
2. **Storage UI Entegrasyonu:** `StorageServisi.gorselSec()` ile seçilen görseli ekranda `Image.file` ile gösterip, "Buluta Yükle" butonuyla Firebase Storage'a yükleyin ve `urlGetir()` ile dönen URL'i ekrana yazdırın.
3. **Test Bildirimi Gönderme:** Cihazı emülatörde veya gerçek cihazda çalıştırıp ekrandaki FCM Token'ı kopyalayın. Firebase Console -> **Messaging** sekmesinden bu token'a özel ilk test bildiriminizi gönderin!

