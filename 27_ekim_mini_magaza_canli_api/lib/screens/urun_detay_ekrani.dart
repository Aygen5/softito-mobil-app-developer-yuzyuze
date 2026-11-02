import 'package:flutter/material.dart';
import '../models/urun.dart';
import '../models/kategori.dart';
import '../widgets/stok_rozeti.dart';

// UrunDetayEkrani:
// Listeden seçilen ürünün büyük fotoğrafını, tam başlığını, puanını, açıklamasını ve sepete ekleme butonunu gösteren detay sayfamız.
// Ekranda değişen bir durum olmadığı (sadece gelen ürünü gösterdiği) için StatelessWidget yaptık.
class UrunDetayEkrani extends StatelessWidget {
  final Urun urun; // Bir önceki ekrandan parametre olarak aktarılan ürün nesnesi

  const UrunDetayEkrani({
    super.key,
    required this.urun,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ürün Detayı'),
        centerTitle: true,
      ),
      // SingleChildScrollView: Uzun açıklamalı ürünlerde küçük ekranlarda taşma (overflow) olmasın, sayfa kaydırılabilsin diye kullandık.
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Hero animasyonu:
            // Bir önceki liste ekranındaki ürün görseliyle aynı tag'e ('urun_resim_${urun.id}') sahip.
            // Bu sayede sayfaya geçerken resim sanki uçarak büyüyormuş gibi akıcı bir geçiş animasyonu oluşur.
            Hero(
              tag: 'urun_resim_${urun.id}',
              child: Center(
                child: SizedBox(
                  height: 240,
                  child: Image.network(
                    urun.resimUrl,
                    fit: BoxFit.contain,
                    // loadingBuilder: İnternetten görsel inerken boş beyaz alan kalmasın, çark dönsün diye eklendi
                    loadingBuilder: (context, child, progress) {
                      if (progress == null) return child;
                      return const Center(child: CircularProgressIndicator());
                    },
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),

            // Kategori etiketi ve Stok durum rozetini yan yana dizen satır
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Kategori rozeti
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                  decoration: BoxDecoration(
                    color: Colors.indigo.shade50,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    urun.kategori.gorunenAd,
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.bold,
                      color: Colors.indigo.shade700,
                    ),
                  ),
                ),
                // Stok durumu rozeti (ayrı widget olarak tasarlandı)
                StokRozeti(stoktaVarMi: urun.stoktaVarMi),
              ],
            ),
            const SizedBox(height: 12),

            // Ürün Başlığı
            Text(
              urun.baslik,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),

            // Değerlendirme puanı (yıldız, ortalama ve oy sayısı)
            Row(
              children: [
                const Icon(Icons.star, size: 20, color: Colors.amber),
                const SizedBox(width: 4),
                Text(
                  urun.degerlendirme.puan.toStringAsFixed(1),
                  style: const TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  '(${urun.degerlendirme.oySayisi} değerlendirme)',
                  style: TextStyle(
                    fontSize: 13,
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),

            // Açıklama başlığı ve gövdesi
            const Text(
              'Ürün Açıklaması',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              urun.aciklama,
              style: TextStyle(
                fontSize: 14,
                height: 1.5, // Satırlar arası boşluk rahat okunsun diye verildi
                color: Colors.grey.shade800,
              ),
            ),
            // Alttaki sabit satın alma barının içeriği örtmemesi için boşluk bıraktık
            const SizedBox(height: 40),
          ],
        ),
      ),

      // bottomNavigationBar: Fiyat ve satın alma butonunun sayfa kaydırılsa bile ekranda sabit kalması için buraya yerleştirdik.
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.05),
              blurRadius: 10,
              offset: const Offset(0, -4),
            ),
          ],
        ),
        // SafeArea: iPhone gibi alt çizgisi olan telefonlarda butonun işletim sistemi barının altına kaçmasını önler
        child: SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              // Fiyat sütunu
              Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Toplam Fiyat',
                    style: TextStyle(fontSize: 12, color: Colors.grey.shade600),
                  ),
                  Text(
                    '${urun.fiyat.toStringAsFixed(2)} ₺',
                    style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: Colors.indigo.shade700,
                    ),
                  ),
                ],
              ),

              // Sepete Ekle Butonu
              // Flutter'da onPressed'e null verilirse buton otomatik pasif (disabled / tıklanamaz gri) duruma geçer.
              // Stok yoksa null vererek bu özelliği kullandık.
              ElevatedButton.icon(
                onPressed: urun.stoktaVarMi
                    ? () {
                        // ScaffoldMessenger.showSnackBar: İşlemin başarılı olduğunu gösteren geçici alt bildirim
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(
                            content: Text('${urun.baslik} sepete eklendi!'),
                            backgroundColor: Colors.green.shade700,
                            duration: const Duration(seconds: 2),
                          ),
                        );
                      }
                    : null,
                icon: const Icon(Icons.shopping_cart),
                label: Text(urun.stoktaVarMi ? 'Sepete Ekle' : 'Tükendi'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
