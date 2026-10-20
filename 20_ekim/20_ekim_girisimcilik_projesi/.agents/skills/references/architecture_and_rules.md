# Yörünge Mimari Kurallar ve Kırmızı Çizgiler Kılavuzu

Bu doküman, Yörünge projesinde kod kalitesini, sürdürülebilirliği ve yüksek performansı korumak için uyulması zorunlu olan teknik prensipleri içerir.

---

## 1. Mimari Katman Haritası

Proje, **Feature-Driven (Özellik Bazlı)** ve katmanlı bir dosya hiyerarşisi izler:

```text
lib/
  main.dart                      # Uygulama başlatma, tema dinleme, kök Scaffold
  core/                          # Tüm modüllerin ortak kullandığı temel yapı taşları
    constants/
      app_colors.dart            # Temel ham renk paleti (Hex kodları yalnızca burada tanımlanır)
      app_spacing.dart           # Boşluk (padding/margin), köşe yuvarlama (radius) sabitleri
      app_strings.dart           # Uygulama içi tüm Türkçe statik metinler
    theme/
      app_theme.dart             # ThemeData (Light/Dark) ve SpaceColors ThemeExtension
      theme_controller.dart      # ValueNotifier<ThemeMode> ile hafif tema yöneticisi
    extensions/
      context_extensions.dart    # context.spaceColors, context.textTheme pratik erişimleri
    widgets/
      starfield_background.dart  # Derin uzay hissi veren CustomPainter yıldız tarlası
      glow_card.dart             # İnce parlama (glow) kenarlıklı, gradyanlı Material 3 kart
      section_header.dart        # Standart başlık ve alt bilgi bileşeni
  features/                      # Her özellik kendi bağımsız klasöründe yaşar
    shell/                       # Alt gezinme çubuğu (Bottom Navigation) ve IndexedStack
    analiz/                      # Girişimci iş planı çok sayfalı analiz formu (Stepper)
    fikir_durumu/                # Şirketleşme süreci, avukat ve gelir taahhüt takibi
    mentor/                      # Mentor havuzu, uzmanlık filtreleri ve eşleşme akışı
    yatirimci/                   # Şirket, melek, fon yatırımcıları ve bilet filtreleri
    programlar/                  # Hibe, devlet ve kuluçka destek programları
    topluluk/                    # Onaylı girişimcilere özel mikro-paylaşım akışı
test/
  features/                      # Controller birim testleri
```

---

## 2. Kırmızı Çizgiler (Kesinlikle Yasak Olanlar)

1. **Ağır Durum Yönetimi Paketleri Yasaktır:**
   - `provider`, `riverpod`, `flutter_bloc`, `get`/`getx`, `mobx`, `redux` kurulamaz ve import edilemez.
   - Durumlar yalnızca yerel `ValueNotifier<T>` nesneleriyle yönetilir.
2. **Sabit Renk ve Stil Kullanımı Yasaktır:**
   - Widget dosyalarında asla `Color(0xFF...)` veya satır içi `TextStyle(fontSize: 16)` yazılmaz.
   - Renkler `context.spaceColors`, stiller `Theme.of(context).textTheme` üzerinden tüketilir.
3. **40 Satırdan Uzun build Metotları Yasaktır:**
   - `build` metotları 40 satırı geçtiği anda alt özel widget'lara bölünür.
4. **Tek Dosyada Kod Yığma Yasaktır:**
   - Bir dosya hem UI'ı, hem veri modelini, hem iş mantığını içeremez.
5. **Kontrolsüz Asenkron Çağrılar Yasaktır:**
   - `await` sonrasında `BuildContext` kullanılacaksa mutlaka `if (!context.mounted) return;` yazılır.

---

## 3. Mock Veri Standartları
- Tüm veriler yerel `mock_<feature>_data.dart` dosyalarından okunur.
- Minimum veri hacimleri:
  - Mentor: En az 8 mentor profili
  - Yatırımcı: 4 kategori x en az 4 yatırımcı (en az 16 profil)
  - Programlar: 5 kategori x en az 3 program (en az 15 program)
  - Topluluk: En az 12 gönderi ve yanıtlar
  - Fikir Durumu: En az 6 farklı aşamada örnek fikir
