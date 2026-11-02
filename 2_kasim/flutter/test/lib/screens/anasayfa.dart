// lib/screens/anasayfa.dart
import 'package:flutter/material.dart';
import '../services/urun_servisi.dart'; // Servis dosyanızın yolu (kendinize göre güncelleyin)

class Anasayfa extends StatefulWidget {
  const Anasayfa({super.key});

  @override
  State<Anasayfa> createState() => _AnasayfaState();
}

class _AnasayfaState extends State<Anasayfa> {
  // Yazdığınız servis sınıfından bir nesne üretiyoruz
  final IUrunServisi _urunServisi = CanliApiUrunServisi();
  
  // API isteğini tutacak olan Future değişkenimiz
  late Future<List<UrunModel>> _urunlerFuture;

  @override
  void initState() {
    super.initState();
    // Sayfa ilk açıldığında verileri çekmeye başlıyoruz
    _urunlerFuture = _urunServisi.urunleriGetir();
  }

  @override
  Widget build(BuildContext context) {
    // İnternetten veri beklediğimiz için FutureBuilder kullanıyoruz
    return FutureBuilder<List<UrunModel>>(
      future: _urunlerFuture,
      builder: (context, snapshot) {
        // 1. Durum: Veriler yükleniyorsa (Yükleme İkonu Göster)
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(
            child: CircularProgressIndicator(color: Colors.green),
          );
        }
        
        // 2. Durum: Bir hata oluştuysa (Hata Mesajı Göster)
        else if (snapshot.hasError) {
          return Center(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Hata Oluştu: ${snapshot.error}',
                textAlign: TextAlign.center,
                style: const TextStyle(color: Colors.red, fontWeight: FontWeight.bold),
              ),
            ),
          );
        }
        
        // 3. Durum: Veriler başarıyla geldiyse ve boş değilse
        else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          final urunler = snapshot.data!;
          
          // Gelen ürünleri dikeyde şık bir liste halinde diziyoruz
          return ListView.builder(
            padding: const EdgeInsets.all(12),
            itemCount: urunler.length,
            itemBuilder: (context, index) {
              final urun = urunler[index];
              
              // Her bir ürünü temsil eden modern kart tasarımı
              return Card(
                margin: const EdgeInsets.symmetric(vertical: 8),
                elevation: 2,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                child: Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    children: [
                      // Ürün Resmi (Sınırlandırılmış alan içinde)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(8),
                        child: Image.network(
                          urun.resimUrl,
                          width: 80,
                          height: 80,
                          fit: BoxFit.cover,
                          // Resim yüklenirken veya hata verdiğinde yedek resim gösterir
                          errorBuilder: (context, error, stackTrace) => const Icon(Icons.image, size: 80),
                        ),
                      ),
                      const SizedBox(width: 16),
                      
                      // Ürün Bilgileri Bölümü (Patlamayı/Taşmayı önleyen Expanded mimarisi!)
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              urun.baslik,
                              maxLines: 2,
                              overflow: TextOverflow.ellipsis, // Başlık çok uzarsa sonuna "..." koyar
                              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              urun.kategori.toUpperCase(),
                              style: TextStyle(color: Colors.grey.shade600, fontSize: 12, letterSpacing: 1),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              '\$${urun.fiyat.toStringAsFixed(2)}',
                              style: const TextStyle(
                                color: Colors.green,
                                fontWeight: FontWeight.bold,
                                fontSize: 16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        }
        
        // 4. Durum: Gelen veri listesi boş ise
        return const Center(
          child: Text('Gösterilecek ürün bulunamadı.'),
        );
      },
    );
  }
}

extension on List<UrunModel> {
  int? get count => null;
}
