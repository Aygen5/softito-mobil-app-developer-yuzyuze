# RotaRent — Uygulama Geliştirme Planı

Bu belge; `docs/project.md`, `docs/architecture.md`, `docs/skills.md` ve `docs/design-system.md` kuralları doğrultusunda RotaRent araç kiralama mobil uygulamasının adım adım geliştirme yol haritasını, bağımlılıklarını ve test adımlarını tanımlar.

---

## 📋 İş Paketleri ve Yol Haritası

### Faz 1: Proje Kurulumu ve Mimari Altyapı
- [x] **Adım 1.1:** Flutter projesinin oluşturulması ve bağımlılıkların yapılandırılması (`flutter create`, Material 3, Türkçe yerelleştirme ve gerekli temel ayarlar).
- [x] **Adım 1.2:** Mimari klasör yapısının (`core/`, `models/`, `data/`, `features/`, `assets/`) oluşturulması.
- [x] **Adım 1.3:** Tasarım sistemi ve tema altyapısının kurulması (`app_colors.dart`, `app_theme.dart`, `theme_controller.dart`, Açık/Koyu tema).
- [x] **Adım 1.4:** Yardımcı araçlar ve biçimlendiricilerin yazılması (`date_utils.dart`, `price_utils.dart`, para birimi ve Türkçe tarih formatlayıcılar).
- [x] **Adım 1.5:** Ortak UI bileşenlerinin oluşturulması (`app_button.dart`, `app_bottom_navigation.dart`, `app_empty_state.dart`, `app_section_title.dart`).

### Faz 2: Veri Katmanı ve İş Mantığı
- [x] **Adım 2.1:** Veri modellerinin tanımlanması (`Vehicle`, `UnavailableRange`, `Reservation`).
- [x] **Adım 2.2:** Gerçekçi Türkçe araç veritabanının oluşturulması (`assets/data/vehicles.json` — Basic, Basic+, Flex, Flex+, Lux, Ultra Lux kategorileri, dolu tarih aralıkları, teknik özellikler, fiyatlar).
- [x] **Adım 2.3:** Araç veri kaynağının yazılması (`vehicle_data_source.dart` — JSON okuma, hata yönetimi).
- [x] **Adım 2.4:** Bellek içi rezervasyon yönetim deposunun yazılması (`reservation_store.dart` — yeni rezervasyonları saklama, dinamik çakışma kontrolüne dahil etme, reaktif bildirim).
- [x] **Adım 2.5:** Fiyat hesaplama mantığı ve uzun dönem indirim kurallarının uygulanması (%15 indirim 7 gün ve üzeri için).
- [x] **Adım 2.6:** Dinamik müsaitlik ve takvim çakışma doğrulama fonksiyonunun geliştirilmesi (geçmiş tarih yasağı, dolu gün kontrolü, bitişik saat kuralı).
- [x] **Adım 2.7:** Veri modelleri, fiyat hesaplama ve müsaitlik mantığı için birim testlerinin yazılması.

### Faz 3: Ekranların Geliştirilmesi
- [x] **Adım 3.1:** **Ana Sayfa (`HomeScreen`)**:
  - Marka alanı, karşılama mesajı, arama alanı.
  - Örnek alış/dönüş noktaları ve tarih özeti.
  - Kategori çipleri (Basic, Basic+, Flex, Flex+, Lux, Ultra Lux).
  - Öne çıkan araç kartları yatay listesi.
  - Temsili Türkiye şube haritası kartı.
  - Alt navigasyon barı (`BottomNavigationBar` / `NavigationBar`).
- [x] **Adım 3.2:** **Araç Listesi (`VehicleListScreen`)**:
  - Araç kartları (fotoğraf, marka/model/yıl, kategori, vites, yakıt, fiyat).
  - Çoklu görünüm modu: Tek sütun (liste), iki sütun (ızgara), üç sütun (kompakt).
  - Sıralama alt penceresi (`vehicle_sort_sheet.dart` — fiyata göre artan/azalan, model yılı, km).
  - Filtreleme alt penceresi (`vehicle_filter_sheet.dart` — kategori, marka, vites, min/max fiyat aralığı, filtreleri temizle).
  - Boş sonuç durumu (`AppEmptyState`).
- [x] **Adım 3.3:** **Araç Detayı ve Rezervasyon (`VehicleDetailScreen`)**:
  - Araç galeri görselleri, detaylı teknik özellikler (menzil, yakıt seviyesi, 250 km bilgi notu).
  - Yakıt göstergesi dokunma etkileşimi ve temsili yakıt fiyatları diyaloğu (`fuel_prices_dialog.dart`).
  - Dinamik Müsaitlik Takvimi (`availability_calendar.dart` — dolu günlerin kırmızı vurgusu, aralık seçimi, anlık müsaitlik geri bildirimi).
  - Rezervasyon formu (`rental_date_form.dart` — alış/dönüş yeri, tarih ve saatler, gidilecek şehir).
  - Fiyat özeti kartı (`rental_price_summary.dart`).
  - Rezervasyon doğrulama ve sonuç diyaloğu (`reservation_result_dialog.dart` — rezervasyon kodu, özet).
- [x] **Adım 3.4:** **Hesabım ve Rezervasyonlarım (`AccountScreen`)**:
  - Demo kullanıcı profil kartı.
  - Rezervasyon sekmeleri: Aktif ve Geçmiş rezervasyonlar.
  - Rezervasyon kartları ve durum etiketleri (Onaylandı, Bekliyor, Tamamlandı).
  - Kiralama sözleşmesi diyaloğu (`rental_agreement_dialog.dart`).
  - Açık / Koyu tema değiştirici (`ValueNotifier<ThemeMode>`).
  - Güvenli çıkış yapma onay diyaloğu (`logout_dialog.dart`).

### Faz 4: Tasarım Bütünlüğü, Test ve Doğrulama
- [x] **Adım 4.1:** Stitch tasarım kodlarının ve görsel dilinin incelenmesi, `docs/design-system.md` dosyasının doldurulması.
- [x] **Adım 4.2:** Açık ve Koyu temanın tüm 4 ana ekranda tutarlılığının kontrolü.
- [x] **Adım 4.3:** `flutter analyze` ile kod kalitesi, null safety ve const optimizasyonu denetimi (0 issue).
- [x] **Adım 4.4:** `flutter test` ile tüm iş kuralları ve widget testlerinin başarıyla geçirilmesi (12/12 test geçti).
- [x] **Adım 4.5:** Kabul kriterlerinin eksiksiz sağlandığının doğrulanması ve projenin teslimi.
