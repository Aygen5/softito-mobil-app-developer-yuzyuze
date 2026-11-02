import 'package:flutter/material.dart';
import '../models/urun.dart';
import '../models/kategori.dart';
import '../services/i_urun_servisi.dart';
import '../services/api_urun_servisi.dart';
import '../widgets/urun_karti.dart';
import 'urun_detay_ekrani.dart';

// UrunListesiEkrani:
// FakeStore API'den canlı verileri çeken, kategori ve arama filtresi uygulayan ana ekranımız.
// Durumlar (loading, error, liste) zamanla değiştiği için StatefulWidget olarak tasarlandı.
class UrunListesiEkrani extends StatefulWidget {
  const UrunListesiEkrani({super.key});

  @override
  State<UrunListesiEkrani> createState() => _UrunListesiEkraniState();
}

class _UrunListesiEkraniState extends State<UrunListesiEkrani> {
  // IUrunServisi referansı ile API servisimizi bağlıyoruz (Polimorfizm)
  final IUrunServisi _servis = ApiUrunServisi();

  // Arama kutusuna girilen metni takip etmek ve gerektiğinde temizlemek için kontrolcü
  final TextEditingController _aramaKontrolcusu = TextEditingController();

  // API'den gelen orijinal ham liste (filtreler değiştiğinde veriyi kaybetmemek için saklıyoruz)
  List<Urun> _tumUrunler = [];
  // Ekranda o an gösterilen (arama ve kategori uygulanmış) filtrelenmiş liste
  List<Urun> _filtrelenmisUrunler = [];

  // Durum değişkenleri:
  bool _yukleniyor = true;          // Veri internetten çekilirken çark dönsün mü?
  String? _hataMesaji;              // İnternet koparsa veya hata olursa mesaj tutucu
  Kategori _seciliKategori = Kategori.hepsi; // O an seçili olan kategori çipi (varsayılan: Tümü)

  @override
  void initState() {
    super.initState();
    // Sayfa ekrana ilk geldiğinde API isteğini hemen başlatıyoruz
    _urunleriYukle();
  }

  @override
  void dispose() {
    // Controller'ı bellek sızıntısı (memory leak) olmasın diye dispose ediyoruz
    _aramaKontrolcusu.dispose();
    super.dispose();
  }

  // API'den ürünleri asenkron olarak çeken fonksiyonumuz
  Future<void> _urunleriYukle() async {
    setState(() {
      _yukleniyor = true;  // Yükleniyor durumuna geç
      _hataMesaji = null;  // Varsa önceki hata mesajını temizle
    });

    try {
      final urunler = await _servis.urunleriGetir();
      
      // if (!mounted) return kontrolü çok önemli:
      // Kullanıcı veriler henüz inerken sayfadan geri çıkarsa,
      // var olmayan bir ekranda setState() çağrılıp uygulama çökmesin diye kontrol ediyoruz.
      if (!mounted) return;

      setState(() {
        _tumUrunler = urunler;
        _filtrelenmisUrunler = urunler;
        _yukleniyor = false; // Yükleme bitti
      });
      // Varsa önceki arama kriterlerini yeni listeye hemen yansıt
      _filtreleriUygula();
    } catch (hata) {
      if (!mounted) return;
      setState(() {
        _hataMesaji = 'Ürünler yüklenirken bir sorun oluştu.\nİnternet bağlantınızı kontrol edin.';
        _yukleniyor = false;
      });
    }
  }

  // Kullanıcı arama kutusuna yazı yazdığında veya kategori değiştirdiğinde listeyi filtreleyen metot
  void _filtreleriUygula() {
    final aramaMetni = _aramaKontrolcusu.text.toLowerCase().trim();

    setState(() {
      _filtrelenmisUrunler = _tumUrunler.where((urun) {
        // Kategori şartı: Tümü seçiliyse veya ürünün kategorisi seçilenle eşleşiyorsa
        final kategoriUygun = _seciliKategori == Kategori.hepsi || urun.kategori == _seciliKategori;
        // Arama şartı: Arama kutusu boşsa veya ürün başlığında aranan kelime geçiyorsa
        final aramaUygun = aramaMetni.isEmpty || urun.baslik.toLowerCase().contains(aramaMetni);
        return kategoriUygun && aramaUygun;
      }).toList();
    });
  }

  // Çiplerden birine tıklandığında aktif kategoriyi güncelleyen metot
  void _kategoriDegistir(Kategori yeniKategori) {
    setState(() {
      _seciliKategori = yeniKategori;
    });
    _filtreleriUygula();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Mini Mağaza (Canlı API)'),
        centerTitle: true,
        actions: [
          // Sayfayı elle yenilemek için sağ üstteki yenile butonu
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _urunleriYukle,
            tooltip: 'Yenile',
          ),
        ],
      ),
      body: Column(
        children: [
          // 1. KISIM: Canlı Arama Kutusu (TextField)
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: TextField(
              controller: _aramaKontrolcusu,
              // onChanged: Kullanıcı her yeni harf yazdığında filtrelemeyi anlık tetikler
              onChanged: (_) => _filtreleriUygula(),
              decoration: InputDecoration(
                hintText: 'Ürün ara...',
                prefixIcon: const Icon(Icons.search),
                // Yazı varsa sağ tarafta çarpı ikonu çıkartıp tek tıkla temizleme imkanı veriyoruz
                suffixIcon: _aramaKontrolcusu.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _aramaKontrolcusu.clear();
                          _filtreleriUygula();
                        },
                      )
                    : null,
                filled: true,
                fillColor: Colors.grey.shade100,
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),

          // 2. KISIM: Yatay Kaydırılabilir Kategori Çipleri (ChoiceChip)
          SizedBox(
            height: 48,
            child: ListView.separated(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: Kategori.values.length,
              separatorBuilder: (context, index) => const SizedBox(width: 8),
              itemBuilder: (context, index) {
                final kategori = Kategori.values[index];
                final seciliMi = _seciliKategori == kategori;

                return ChoiceChip(
                  label: Text(kategori.gorunenAd),
                  selected: seciliMi,
                  onSelected: (secildi) {
                    if (secildi) _kategoriDegistir(kategori);
                  },
                  selectedColor: Colors.indigo.shade100,
                  labelStyle: TextStyle(
                    color: seciliMi ? Colors.indigo.shade900 : Colors.grey.shade800,
                    fontWeight: seciliMi ? FontWeight.bold : FontWeight.normal,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 4),

          // 3. KISIM: 4 UI Durumunu Yöneten Ana Gövde
          // Ekranın kalan tüm alanını kaplasın diye Expanded kullandık
          Expanded(
            child: _durumaGoreGovdeyiOlustur(),
          ),
        ],
      ),
    );
  }

  // 4 Temel Durum (Loading, Error, Empty, Success) Yönetimi:
  // API işlemlerinde bu 4 durumu ele almak kullanıcı deneyimi için zorunludur.
  Widget _durumaGoreGovdeyiOlustur() {
    // DURUM 1: Yükleniyor (Loading)
    if (_yukleniyor) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(),
            SizedBox(height: 16),
            Text('FakeStore API\'den ürünler yükleniyor...'),
          ],
        ),
      );
    }

    // DURUM 2: Hata Durumu (Error State)
    if (_hataMesaji != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Icon(Icons.cloud_off, size: 64, color: Colors.redAccent),
              const SizedBox(height: 16),
              Text(
                _hataMesaji!,
                textAlign: TextAlign.center,
                style: const TextStyle(fontSize: 16, color: Colors.black87),
              ),
              const SizedBox(height: 20),
              // Kullanıcının bağlantıyı tekrar denemesini sağlayan buton
              ElevatedButton.icon(
                onPressed: _urunleriYukle,
                icon: const Icon(Icons.refresh),
                label: const Text('Tekrar Dene'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // DURUM 3: Boş Liste (Empty State)
    // Arama sonucu eşleşen ürün bulunamadığında boş beyaz ekran yerine bilgi veriyoruz
    if (_filtrelenmisUrunler.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey.shade400),
            const SizedBox(height: 16),
            Text(
              'Aradığınız kriterlere uygun ürün bulunamadı.',
              style: TextStyle(fontSize: 15, color: Colors.grey.shade600),
            ),
          ],
        ),
      );
    }

    // DURUM 4: Başarılı Liste (Success State)
    // RefreshIndicator: Listeyi yukarıdan aşağıya çekince (pull-to-refresh) yenilenmesini sağlar
    return RefreshIndicator(
      onRefresh: _urunleriYukle,
      child: ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 24),
        itemCount: _filtrelenmisUrunler.length,
        itemBuilder: (context, index) {
          final urun = _filtrelenmisUrunler[index];
          return UrunKarti(
            urun: urun,
            // Karta tıklandığında Navigator ile Detay ekranına geçiyoruz ve seçilen ürünü parametre gönderiyoruz
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => UrunDetayEkrani(urun: urun),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
