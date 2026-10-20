# RotaRent — Tasarım Sistemi (Design System)

## 1. Giriş ve Tasarım Felsefesi

RotaRent Tasarım Sistemi; Stitch UI araç kiralama prototipinden ilham alınarak geliştirilmiş, Google Material Design 3 (M3) prensiplerini modern mobil kullanıcı deneyimiyle harmanlayan kapsamlı bir tasarım kılavuzudur.

### Temel Tasarım İlkeleri:
1. **Netlik ve Hiyerarşi (Clarity & Hierarchy):** Kullanıcının araçları incelerken, fiyatları karşılaştırırken ve tarih seçerken karmaşadan uzak, net ve okunabilir bir arayüzle karşılaşması sağlanır.
2. **Güvenilirlik ve Prestij (Trust & Elegance):** Safir laciverti (Deep Sapphire/Navy) ve canlı okyanus mavisi (Electric Blue/Cyan) tonları kurumsal güven, kalite ve modernliği yansıtır.
3. **Akıllı ve Dinamik Geri Bildirim (Dynamic Feedback):** Müsait olmayan tarihler takvimde anında kırmızı ile vurgulanır; doluluk, yakıt seviyesi ve indirim bilgisi anlık geri bildirimlerle kullanıcıya hissettirilir.
4. **Çift Tema Mükemmelliği (Adaptive Light & Dark):** Hem açık temada hem de koyu temada kontrast oranları WCAG standartlarına uygun tutulmuş, gözü yormayan premium bir atmosfer oluşturulmuştur.

---

## 2. Renk Paleti (Color Tokens)

### 2.1. Birincil ve Marka Renkleri
| Token Adı | HEX Kodu | Kullanım Alanı |
| :--- | :--- | :--- |
| `primary` | `#1A56DB` | Ana butonlar, aktif sekmeler, seçili tarih aralıkları |
| `primaryLight` | `#3B82F6` | Koyu temada birincil vurgu, gradyan geçişleri |
| `primaryDark` | `#1E40AF` | Hover/press durumları, gölge efektleri |
| `secondary` | `#0D9488` | İkincil aksiyonlar, özellik ikonları |
| `tertiary` | `#F59E0B` | Uyarılar, indirim rozetleri, dikkat çekici etiketler |

### 2.2. Açık Tema (Light Theme Tokens)
| Token Adı | HEX Kodu | Kullanım Alanı |
| :--- | :--- | :--- |
| `surface` | `#FFFFFF` | Diyaloglar, bottom sheetler, üst çubuk |
| `background` | `#F8FAFC` | Sayfa arka planı (Slate-50) |
| `cardSurface` | `#FFFFFF` | Araç ve rezervasyon kartları |
| `textPrimary` | `#0F172A` | Başlıklar ve birincil metinler (Slate-900) |
| `textSecondary` | `#475569` | Açıklama metinleri ve etiketler (Slate-600) |
| `border` | `#E2E8F0` | Kart çerçeveleri ve ayırıcı çizgiler |

### 2.3. Koyu Tema (Dark Theme Tokens)
| Token Adı | HEX Kodu | Kullanım Alanı |
| :--- | :--- | :--- |
| `surfaceDark` | `#1E293B` | Kartlar, alt pencereler, modal yüzeyleri (Slate-800) |
| `backgroundDark` | `#0F172A` | Sayfa arka planı (Slate-900) |
| `surfaceContainerDark` | `#334155` | Çip ve girdi alanı yüzeyleri (Slate-700) |
| `textPrimaryDark` | `#F8FAFC` | Koyu mod başlık ve ana metinler |
| `textSecondaryDark`| `#94A3B8` | Koyu mod ikincil açıklamalar |
| `borderDark` | `#334155` | Koyu mod kart kenarlıkları |

### 2.4. Durum ve Takvim Renkleri
| Token Adı | HEX Kodu | Anlamı ve Kullanım Yeri |
| :--- | :--- | :--- |
| `unavailable` | `#EF4444` | **Dolu Tarih:** Takvimde başka bir kiralamaya ayrılmış günler |
| `available` | `#10B981` | Müsait gün ve onaylandı durumu |
| `pending` | `#F59E0B` | Beklemede / onay aşamasındaki rezervasyonlar |
| `selectedRange` | `#1A56DB` | Seçilen başlangıç ve bitiş tarih aralığı |
| `rangeHighlight`| `rgba(26,86,219,0.12)` | İki tarih arasındaki günlerin hafif dolgu rengi |

### 2.5. Araç Kategori Rozet Renkleri
Her araç sınıfı benzersiz bir kurumsal renkle ayırt edilir:
- **Basic:** Gri / Nötr Mavi (`#64748B`)
- **Basic+:** Çivit Mavisi (`#3B82F6`)
- **Flex:** Zümrüt Yeşili (`#10B981`)
- **Flex+:** Turkuaz / Camgöbeği (`#06B6D4`)
- **Lux:** Amber / Altın Sarısı (`#D97706`)
- **Ultra Lux:** Kraliyet Moru (`#8B5CF6`)

---

## 3. Tipografi Hiyerarşisi (Typography Scale)

RotaRent, modern geometrik grotesk karakter tipografisine sahip sistem yazı tiplerini (`Roboto`, `SF Pro Display`, `Inter` uyumlu) benimser.

| Seviye | Boyut | Ağırlık (Weight) | Satır Yüksekliği | Kullanım Yeri |
| :--- | :--- | :--- | :--- | :--- |
| **Headline 1** | 26 px | Bold (800) | 32 px | Karşılama başlığı, ekran ana başlıkları |
| **Headline 2** | 22 px | Bold (700) | 28 px | Araç detay başlığı, modal başlıkları |
| **Title Medium**| 18 px | SemiBold (600) | 24 px | Kart başlıkları, bölüm başlıkları |
| **Body Large** | 15 px | Regular (400) | 22 px | Detay açıklamaları, sözleşme maddeleri |
| **Body Medium**| 13 px | Regular / Medium | 18 px | Araç özellikleri, filtre seçenekleri |
| **Label Bold** | 12 px | Bold (700) | 16 px | Kategori etiketleri, durum rozetleri |
| **Caption** | 11 px | Medium (500) | 14 px | Dipnotlar, tarih formatları, limit uyarıları |

---

## 4. Spacing, Yuvarlatma ve Gölgelendirme (Design Geometry)

### 4.1. Boşluk Skalası (Spacing Grid)
- `spacing-xs`: **4 px** (İkon içi boşluklar, minik etiketler)
- `spacing-sm`: **8 px** (Çipler arası boşluk, metin ile alt metin arası)
- `spacing-md`: **12 px** (Girdi kutuları içi, kompakt kart dolgusu)
- `spacing-lg`: **16 px** (Ekran kenar marjları, kart iç boşlukları)
- `spacing-xl`: **20 px** (Bölümler arası standart mesafe)
- `spacing-2xl`: **24 px** (Büyük diyalog iç dolguları)
- `spacing-3xl`: **32 px** (Ekran altı buton ayrımı)

### 4.2. Yuvarlatma Skalası (Border Radius)
- `radius-sm`: **8 px** (Butonlar, çip etiketleri)
- `radius-md`: **12 px** (Girdi kutuları, takvim gün hücreleri)
- `radius-lg`: **16 px** (Araç kartları, rezervasyon özet kartları)
- `radius-xl`: **20 px** (Öne çıkan araç afişleri, harita kartı)
- `radius-2xl`: **24 px** (Diyaloglar, modal alt pencereler)
- `radius-full`: **999 px** (Pill butonlar, dairesel durum ikonları)

### 4.3. Gölgelendirme (Elevation & Shadows)
- Açık temada yumuşak, bulanık gölgeler kullanılır: `box-shadow: 0 4px 14px rgba(15, 23, 42, 0.05)`.
- Koyu temada gölge yerine `border: 1px solid rgba(255, 255, 255, 0.08)` ince kontur çizgisi tercih edilerek derinlik sağlanır.

---

## 5. Bileşen Standartları (UI Components)

### 5.1. Butonlar (`AppButton`)
- **Yükseklik:** 48-52 px ergonomik dokunma alanı.
- **Birincil Buton:** Tam genişlik (`double.infinity`), birincil safir rengi zemin, beyaz kalın metin, sol tarafta tamamlayıcı ikon.
- **İkincil / Metin Butonu:** Kenarlıksız, marka renginde sade metin, hızlı vazgeçme veya filtre temizleme işlemleri için.

### 5.2. Çoklu Görünüm Araç Kartları (`VehicleCard`)
- **1 Sütun (Liste Görünümü):** Yatay geniş kart, solda araç görseli, sağda model, kategori rozeti, vites/yakıt özellikleri ve sağ altta belirgin günlük kira bedeli.
- **2 Sütun (Izgara Görünümü):** Dikey kart, üstte geniş görsel, ortada kategori ve model, altta büyük puntolu fiyat.
- **3 Sütun (Kompakt Görünüm):** Yoğun katalog görünümü; tek satırda araç adı, küçük görsel ve hızlı rezervasyon butonu.

### 5.3. Dinamik Müsaitlik Takvimi (`AvailabilityCalendar`)
- **Geçmiş Günler:** Gri ve pasif (dokunulamaz).
- **Dolu Günler:** Kırmızı yuvarlak zemin (`AppColors.unavailableDay`), beyaz metin, altında "Dolu" ibaresi. Tıklandığında kullanıcıya tarihin rezerve olduğu uyarısı verilir.
- **Müsait Günler:** Açık renk zemin, seçilebilir.
- **Seçili Başlangıç / Bitiş:** Koyu safir mavisi dolgu, aradaki günler yarı saydam mavi bant.
- **Aynı Gün Teslim & Alış Kuralı:** Bir rezervasyonun bitiş saatiyle yeni rezervasyonun başlangıç saati eşit olduğunda çakışma sayılmaz (ör. 10:00 teslim / 10:00 yeni kiralama).

### 5.4. Etkileşimli Yakıt Göstergesi (`FuelGaugeWidget`)
- Araç detay ekranında deponun doluluk yüzdesini dairesel ve modern bir göstergeyle görselleştirir.
- Göstergeye tıklandığında temsili güncel Türkiye akaryakıt litre fiyatlarını listeleyen bilgilendirici `FuelPricesDialog` penceresi açılır.

### 5.5. Alt Gezinme Çubuğu (`AppBottomNavigation`)
- 3 ana hedef:
  1. `Ana Sayfa` (İkon: `home_rounded`)
  2. `Araçlar` (İkon: `directions_car_rounded`)
  3. `Hesabım & Rezervasyonlar` (İkon: `person_rounded`)
- Material 3 `NavigationBar` tarzı pill indicator ve yumuşak geçiş animasyonu.

---

## 6. Erişilebilirlik ve Cihaz Uyumluluğu

- Minimum dokunmatik hedef boyutu: `48 x 48 dp`.
- Açık ve koyu mod renk kontrast oranı: `> 4.5:1` (WCAG AA standardı).
- Sistem font ölçekleme (`textScaleFactor`) ve farklı ekran çözünürlüklerine (küçük ekranlı telefonlardan tabletlere) duyarlı esnek (`Flex`, `Expanded`, `SingleChildScrollView`) düzenler.
