# StajTakip — Firebase Kurulum ve Manuel İşlemler Rehberi

Bu belge, **StajTakip** uygulamasının Firebase altyapısının kurulumu, veri tabanı kuralları ve test kullanıcılarının yapılandırılması için gerekli kılavuzdur.

---

## 1. Firebase Proje Özeti

- **Proje Adı:** `stajtakip-6fd05`
- **Giriş Yöntemi:** Email / Password Authentication
- **Veri Tabanı:** Cloud Firestore
- **Depolama:** Firebase Storage
- **Platformlar:** Android, iOS, macOS, Web, Windows

---

## 2. Kullanıcı Tarafından Tamamlanmış Manuel İşlemler ✅

1. **Firebase Projesi Oluşturuldu:** `stajtakip-6fd05` projesi aktif.
2. **Email/Password Authentication Etkinleştirildi:** Konsol üzerinden E-posta/Şifre ile oturum açma açıldı.
3. **Cloud Firestore Oluşturuldu:** Veritabanı başlatıldı.
4. **3 Test Kullanıcısı Authentication'a Eklendi:**
   - Öğrenci (`student`)
   - Akademik Danışman (`academicAdvisor`)
   - Şirket Yetkilisi (`companyRepresentative`)
5. **FlutterFire CLI Yapılandırıldı:** `lib/firebase_options.dart` üretildi ve platform appId'leri bağlandı.
6. **Firestore `users` Koleksiyonu Oluşturuldu:** 3 test kullanıcısının profil belgeleri oluşturuldu.
7. **Firebase Paketleri Kuruldu:** `pubspec.yaml` bağımlılıkları tamamlandı.
8. **Firestore Güvenlik Kuralları Yayınlandı:** `firestore.rules` Firebase Console'da yayınlandı.
9. **`internships` Koleksiyonu ve `staj_001` Belgesi Oluşturuldu:** Öğrenci, danışman ve şirket yetkilisi ilişkisi kuruldu.

---

## 3. Ücretsiz Spark Planı ve Depolama (Storage) Durumu 💡

- **Ücretsiz Spark Planı:** Faturalandırma ve kredi kartı gerektiren Blaze planına geçilmemiştir; uygulama tamamen ücretsiz Spark planı ile çalışacak şekilde kurgulanmıştır.
- **Firebase Storage:** Yeni projelerde Storage aktivasyonu Blaze planı gerektirebildiğinden dosya yükleme zorunluluğu ertelenmiştir.
- **Fonksiyonellik Etkilenmez:** Rapor formundaki ek dosya alanı (`attachmentPaths`) isteğe bağlıdır (opsiyonel). Öğrenci dosya eklemeden de raporunu yazabilir, taslak kaydedebilir, onaya gönderebilir; kurum yetkilisi ve danışman onaylayabilir ve PDF staj defteri üretilebilir.
- *(İleride Blaze planı veya yerel emülatör etkinleştirildiğinde `storage.rules` doğrudan uygulanabilecektir).*

---

### Adım 4: Firestore'da Örnek `internships` Belgesi Oluşturma
Öğrencinin staj paneline girdiğinde aktif bir staj görmesi, kurum yetkilisinin ve danışmanın stajyeri inceleyebilmesi için bir ilişkilendirme belgesi gereklidir:

1. Firebase Console -> **Cloud Firestore** -> **Data** sekmesine gidin.
2. **Start collection (Koleksiyon başlat)** diyerek koleksiyon adını `internships` yapın.
3. Belge kimliği (Document ID) olarak `staj_001` (veya otomatik id) girin.
4. Aşağıdaki alanları ekleyin:
   - `id`: `staj_001` (string)
   - `studentId`: `<Öğrenci hesabının Authentication UID değeri>` (string)
   - `companySupervisorId`: `<Şirket yetkilisi hesabının Authentication UID değeri>` (string)
   - `academicAdvisorId`: `<Akademik danışman hesabının Authentication UID değeri>` (string)
   - `companyName`: `Softito Yazılım Teknolojileri A.Ş.` (string)
   - `startDate`: `2026-06-01T00:00:00Z` (timestamp)
   - `endDate`: `2026-07-31T00:00:00Z` (timestamp)
   - `requiredDays`: `40` (number)
   - `status`: `active` (string)
5. **Save (Kaydet)** butonuna tıklayın.

---

## 4. Firestore Veri Şeması ve Koleksiyon Referansı

| Koleksiyon | Açıklama | Anahtar Alanlar |
|---|---|---|
| `users` | Kullanıcı profilleri | `uid`, `fullName`, `email`, `role`, `institutionId`, `isActive`, `createdAt` |
| `internships` | Staj ilişkileri ve takvimi | `id`, `studentId`, `companySupervisorId`, `academicAdvisorId`, `companyName`, `startDate`, `endDate`, `requiredDays`, `status` |
| `dailyReports` | Günlük staj raporları | `id`, `internshipId`, `studentId`, `workDate`, `tasks`, `learnings`, `hoursWorked`, `attachmentPaths`, `status`, `companyApproved`, `advisorApproved`, `revisionComment`, `createdAt` |
| `reviews` | Onay / düzeltme denetim izi | `id`, `reportId`, `reviewerId`, `reviewerRole`, `decision`, `comment`, `score`, `createdAt` |

---

## 5. Doğrulama ve Test Adımları

Manuel işlemler tamamlandıktan sonra:
1. Öğrenci kullanıcısı ile giriş yapın -> Dashboard'da `Softito Yazılım Teknolojileri A.Ş.` stajı ve 0/40 gün ilerleme kartı görünmeli.
2. "Yeni Rapor Ekle" butonu ile günlük çalışma raporu ve PDF/belge yükleyin -> Taslak veya onaya gönderin.
3. Şirket yetkilisi ile giriş yapın -> İnceleme bekleyen raporu görüntüleyin, onaylayın veya düzeltme isteyin.
4. Akademik danışman ile giriş yapın -> Kurum onayı tamamlanan raporu görüntüleyin, puanlayın ve nihai onayı verin.
5. Öğrenci ekranına dönüp onaylanan rapordan PDF Staj Defteri çıktısını görüntüleyin.
