import 'dart:io';
import 'package:flutter/material.dart';

/// ============================================================================
/// GÖRSEL YÜKLEME VE MEDYA YÖNETİM KARTI (IMAGE UPLOAD WIDGET)
/// ============================================================================
/// Bu bileşen, Firebase Storage entegrasyonu için kullanıcıya görsel seçme
/// (Galeri / Kamera), seçilen görseli önizleme, yükleme ilerleme durumunu
/// (Progress Bar) izleme ve buluta yüklemeyi başlatma imkânı sunan modüler bir Card widget'ıdır.
///
/// 💡 Tekrar Kullanılabilirlik (Reusability):
/// Tamamen 'Stateless' tasarlanmış olup verilerini üst widget'tan parametre olarak
/// alır ve kullanıcı buton etkileşimlerini callback fonksiyonları ile üst widget'a iletir.
class GorselYuklemeKarti extends StatelessWidget {
  // Cihazdan (galeri/kamera) seçilen yerel görsel dosyası (henüz seçilmediyse null)
  final File? secilenDosya;

  // Buluta başarıyla yüklendikten sonra dönen HTTPS indirme bağlantısı (URL)
  final String? yuklenenUrl;

  // Firebase Storage yükleme yüzdesi (0.0 ile 1.0 arasında progress değeri)
  final double yuklemeOrani;

  // Yükleme işleminin arka planda devam edip etmediği bilgisi
  final bool yukleniyorMu;

  // Galeriden görsel seçme butonu tıklandığında tetiklenecek callback
  final VoidCallback onGaleridenSec;

  // Kameradan yeni fotoğraf çekme butonu tıklandığında tetiklenecek callback
  final VoidCallback onKameradanCek;

  // Buluta yükleme işlemini başlatan butona tıklandığında tetiklenecek callback
  final VoidCallback onBulutaYukle;

  const GorselYuklemeKarti({
    super.key,
    required this.secilenDosya,
    required this.yuklenenUrl,
    required this.yuklemeOrani,
    required this.yukleniyorMu,
    required this.onGaleridenSec,
    required this.onKameradanCek,
    required this.onBulutaYukle,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(color: Colors.grey.shade300),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            /// ----------------------------------------------------------------
            /// 1. BAŞLIK VE İKON ALANI
            /// ----------------------------------------------------------------
            const Row(
              children: [
                Icon(
                  Icons.cloud_upload_outlined,
                  color: Color.fromARGB(255, 41, 185, 41),
                ),
                SizedBox(width: 8),
                Text(
                  'Firebase Medya Yükleyici',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 237, 249, 16),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 14),

            /// ----------------------------------------------------------------
            /// 2. GÖRSEL ÖNİZLEME ALANI (PREVIEW CONTAINER)
            /// ----------------------------------------------------------------
            /// 3 farklı durum kontrol edilir:
            /// a) Cihazdan yerel dosya seçildiyse -> Image.file ile önizlenir.
            /// b) Buluttan URL geldiyse -> Image.network ile gösterilir.
            /// c) Hiçbiri yoksa -> Boş durum (Empty State) ikonu ve metni gösterilir.
            Container(
              height: 180,
              decoration: BoxDecoration(
                color: const Color.fromARGB(255, 12, 6, 37),
                borderRadius: BorderRadius.circular(12),
                border: Border.all(color: Colors.grey.shade300),
              ),
              alignment: Alignment.center,
              child: secilenDosya != null
                  // Durum A: Cihazdan seçilen yerel görsel
                  ? ClipRRect(
                      borderRadius: BorderRadius.circular(12),
                      child: Image.file(
                        secilenDosya!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    )
                  // Durum B: Buluta yüklenmiş olan görsel (URL üzerinden)
                  : (yuklenenUrl != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.network(
                            yuklenenUrl!,
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        )
                      // Durum C: Henüz görsel seçilmediğinde gösterilen boş durum
                      : Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.image_outlined,
                              size: 48,
                              color: Colors.grey.shade500,
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'Henüz bir görsel seçilmedi',
                              style: TextStyle(color: Colors.grey.shade600),
                            ),
                          ],
                        )),
            ),

            /// ----------------------------------------------------------------
            /// 3. İLERLEME ÇUBUĞU (PROGRESS BAR)
            /// ----------------------------------------------------------------
            /// Yükleme işlemi devam ederken (yukleniyorMu == true) yüzdelik
            /// ilerleme çubuğu ve anlık yükleme oranı gösterilir.
            if (yukleniyorMu) ...[
              const SizedBox(height: 12),
              // İlerleme yüzdesini görselleştiren gösterge
              LinearProgressIndicator(
                value: yuklemeOrani,
                backgroundColor: Colors.grey.shade200,
                color: const Color.fromARGB(255, 8, 69, 3),
                minHeight: 6,
                borderRadius: BorderRadius.circular(6),
              ),
              const SizedBox(height: 4),
              // Sayısal yüzde metni (Örn: %45)
              Text(
                'Yükleniyor: ${(yuklemeOrani * 100).toStringAsFixed(0)}%',
                textAlign: TextAlign.end,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],

            const SizedBox(height: 14),

            /// ----------------------------------------------------------------
            /// 4. MEDYA SEÇME BUTONLARI (GALERİ & KAMERA)
            /// ----------------------------------------------------------------
            /// Yükleme sırasında butonlar devre dışı (disabled / null) bırakılır.
            Row(
              children: [
                // Galeriden görsel seçme butonu
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: yukleniyorMu ? null : onGaleridenSec,
                    label: const Text('Galeri'),
                    icon: const Icon(Icons.photo_library_outlined),
                  ),
                ),
                const SizedBox(width: 8),
                // Kamerayı açıp yeni fotoğraf çekme butonu
                Expanded(
                  child: OutlinedButton.icon(
                    onPressed: yukleniyorMu ? null : onKameradanCek,
                    label: const Text('Kamera'),
                    icon: const Icon(Icons.camera_alt_outlined),
                  ),
                ),
              ],
            ),

            /// ----------------------------------------------------------------
            /// 5. BULUTA YÜKLEME BUTONU
            /// ----------------------------------------------------------------
            /// Sadece yerel bir dosya seçildiğinde görünür.
            if (secilenDosya != null) ...[
              const SizedBox(height: 8),
              FilledButton.icon(
                onPressed: yukleniyorMu ? null : onBulutaYukle,
                label: const Text('Buluta Yükle'),
                style: FilledButton.styleFrom(
                  backgroundColor: const Color.fromARGB(255, 0, 165, 94),
                ),
                icon: const Icon(Icons.cloud_upload),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
