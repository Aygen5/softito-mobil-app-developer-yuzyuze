# StajTakip — Dijital Staj Takip ve Defter Uygulaması

Flutter ve Firebase tabanlı, öğrenciler, kurum yetkilileri ve akademik danışmanlar için geliştirilmiş çift aşamalı onay ve PDF defter üretim mekanizmalı staj yönetim sistemi.

## 📱 Özellikler

- **Rol Bazlı Erişim Kontrolü:** Öğrenci, Kurum Yetkilisi (`companyRepresentative`) ve Akademik Danışman (`academicAdvisor`).
- **Öğrenci Paneli:** Staj ilerleme çubuğu, sayaçlar, günlük rapor oluşturma, düzenleme, taslak kaydetme ve 10MB dosya/belge eki.
- **Çift Aşamalı Onay Mekanizması:** Önce Şirket Yetkilisi incelemesi, ardından Akademik Danışman onayı ve puanlama.
- **Gerekçeli Düzeltme Akışı:** Eksik veya hatalı raporlarda açıklama zorunluluğu ile raporun öğrenciye geri yönlendirilmesi.
- **Eksik Gün Takip Motoru:** İş günü ve takvim hesabı ile raporsuz geçmiş günlerin uyarılması.
- **Resmî PDF Staj Defteri:** Sadece onaylanmış raporlardan Türkçe karakter ve sayfa taşma korumalı defter üretimi, önizleme ve yazdırma.
- **Güvenlik ve Kurallar:** Firestore ve Storage Security Rules ile istemci yetki yükseltmelerinin ve yetkisiz veri erişiminin engellenmesi.

---

## 🚀 Kurulum ve Çalıştırma

### 1. Bağımlılıkları Yükleme
```bash
flutter pub get
```

### 2. Statik Analiz ve Testler
```bash
dart analyze lib test
flutter test
```

### 3. Firebase Yapılandırması ve Manuel Adımlar
Firebase projesinin (`stajtakip-6fd05`) yapılandırılması, Storage aktivasyonu ve Firestore kuralları için detaylı rehbere göz atın:
👉 **[Firebase Kurulum ve Manuel İşlemler Rehberi](docs/firebase_setup_guide.md)**

---

## 🏛 Mimari ve Tasarım Belgeleri

- **[Proje Tanımı (project.md)](docs/project.md)**
- **[Mimari Kılavuzu (architecture.md)](docs/architecture.md)**
- **[Tasarım Sistemi (design-system.md)](docs/design-system.md)**
- **[Geliştirici Becerileri (skills.md)](docs/skills.md)**
- **[Aşamalı İş Planı (plan.md)](docs/plan.md)**
- **[Öğrenci & Yeni Başlayanlar İçin Kapsamlı Rehber (ogrenci_rehberi.md)](docs/ogrenci_rehberi.md)**

