import 'package:flutter/material.dart';
import '../models/urun.dart';
import '../models/kategori.dart';
import 'stok_rozeti.dart';

// UrunKarti:
// Ürün listesindeki her bir satırı temsil eden, görselini ve özet bilgilerini gösteren kart bileşenimiz.
class UrunKarti extends StatelessWidget {
  final Urun urun;            // Kartta sergilenecek ürün verisi
  final VoidCallback? onTap;  // Karta tıklandığında çalışacak fonksiyon (Detay sayfasına gitmek için)

  const UrunKarti({
    super.key,
    required this.urun,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      clipBehavior: Clip.antiAlias, // Kart köşelerinden taşan çocukları kırpar
      // InkWell: Karta tıklandığında hem tıklamayı algılar hem de şık bir dalgalanma (ripple) efekti verir
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Hero Animasyonu:
              // Detay ekranındaki görselle aynı 'urun_resim_${urun.id}' etiketini paylaşır.
              // Karta tıklandığında görsel akıcı bir şekilde büyüyerek detay ekranına geçer.
              Hero(
                tag: 'urun_resim_${urun.id}',
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(12),
                  child: SizedBox(
                    width: 80,
                    height: 80,
                    child: Image.network(
                      urun.resimUrl,
                      fit: BoxFit.contain,
                      // Görsel yüklenirken dönen küçük çark gösterir
                      loadingBuilder: (context, child, loadingProgress) {
                        if (loadingProgress == null) return child;
                        return const Center(
                          child: CircularProgressIndicator(strokeWidth: 2),
                        );
                      },
                      // Resim linki bozuksa veya internet koparsa uygulamanın çökmesini önler, kırık resim ikonu basar
                      errorBuilder: (context, error, stackTrace) {
                        return Container(
                          color: Colors.grey.shade200,
                          child: const Icon(Icons.broken_image, color: Colors.grey),
                        );
                      },
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),

              // Expanded: Row içindeki kalan tüm yatay alanı kaplar.
              // Metinlerin ekrandan taşmasını (sarı-siyah şeritli overflow hatasını) önler!
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Üst Satır: Kategori adı ve Stok rozeti
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          urun.kategori.gorunenAd,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.w500,
                            color: Colors.grey.shade600,
                          ),
                        ),
                        StokRozeti(stoktaVarMi: urun.stoktaVarMi),
                      ],
                    ),
                    const SizedBox(height: 4),

                    // Ürün Başlığı (2 satır sınırlandırmalı)
                    Text(
                      urun.baslik,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis, // 2 satırı aşarsa sonuna '...' koyar
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 6),

                    // Puan ve Oy Sayısı Satırı
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(Icons.star, size: 16, color: Colors.amber),
                        const SizedBox(width: 4),
                        Text(
                          urun.degerlendirme.puan.toStringAsFixed(1),
                          style: const TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(width: 4),
                        Text(
                          '(${urun.degerlendirme.oySayisi})',
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey.shade500,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),

                    // Fiyat Metni
                    Text(
                      '${urun.fiyat.toStringAsFixed(2)} ₺',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: Colors.indigo.shade700,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
