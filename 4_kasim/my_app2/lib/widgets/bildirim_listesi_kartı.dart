import 'package:flutter/material.dart';
import '../models/bildirim_modeli.dart';

/// ============================================================================
/// BİLDİRİM LİSTESİ VE FCM YÖNETİM KARTI (NOTIFICATION CENTER WIDGET)
/// ============================================================================
/// Bu widget, Firebase Cloud Messaging (FCM) durumunu, cihazın FCM Token'ını,
/// genel sınıf/grup konusuna (Topic) abone olma anahtarını ve gelen bildirimlerin
/// listesini tek bir şık panelde toplayan modüler bir UI bileşenidir.
/// 
/// 💡 Tekrar Kullanılabilirlik (Reusability):
/// Tamamen 'Stateless' tasarlanmış olup verilerini üst widget'tan parametre olarak
/// alır ve kullanıcı etkileşimlerini (örneğin switch değişimi) callback ile iletir.
class BildirimListesiKarti extends StatelessWidget {
  // Gelen bildirimlerin dinamik listesi
  final List<BildirimModeli> bildirimler;

  // Firebase'den alınan cihaz Token'ı (henüz yüklenmediyse null olabilir)
  final String? token;

  // Kullanıcının 'tum_sinif' yayınına abone olup olmadığı bilgisi
  final bool konuyaAboneMi;

  // Abone switch'i açılıp kapandığında üst widget'a haber veren tetikleyici (callback)
  final ValueChanged<bool> onAboneDegisti;

  const BildirimListesiKarti({
    super.key,
    required this.bildirimler,
    required this.token,
    required this.konuyaAboneMi,
    required this.onAboneDegisti,
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
            /// 1. BAŞLIK VE KONU ABONELİĞİ (SWITCH) SATIRI
            /// ----------------------------------------------------------------
            Row(
              children: [
                const Icon(
                  Icons.notifications_active_outlined,
                  color: Color(0xFF006C4A),
                ),
                const SizedBox(width: 8),
                const Expanded(
                  child: Text(
                    'FCM Bildirim Merkezi',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF1E293B),
                    ),
                  ),
                ),
                // Kullanıcının konuya abone olup olmamasını sağlayan Switch butonu
                Switch(
                  value: konuyaAboneMi,
                  onChanged: onAboneDegisti,
                  activeThumbColor: const Color(0xFF006C4A),
                ),
              ],
            ),

            /// Abonelik durumuna göre anlık bilgilendirme metni
            Text(
              konuyaAboneMi ? 'Tüm sınıf yayını aktif' : 'Yayın kapalı',
              style: TextStyle(
                fontSize: 12,
                color: konuyaAboneMi
                    ? const Color(0xFF006C4A)
                    : Colors.grey.shade600,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 12),

            /// ----------------------------------------------------------------
            /// 2. CİHAZIN FCM TOKEN GÖSTERİM KUTUSU
            /// ----------------------------------------------------------------
            /// Cihazın FCM Token'ı çok uzundur ve Firebase Console'dan test mesajı
            /// atarken kopyalanması gerekir. Bu sebeple SelectableText kullanılmıştır.
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A), // Koyu konsol teması
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Cihazın FCM Tokeni (Kopyalanabilir):",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(height: 4),
                  // SelectableText sayesinde öğrenci/geliştirici token'ı uzun basarak seçip kopyalayabilir
                  SelectableText(
                    token ?? 'Token alınıyor...',
                    style: const TextStyle(
                      color: Color(0xFF38BDF8),
                      fontSize: 11,
                      fontFamily: 'monospace',
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 14),

            /// ----------------------------------------------------------------
            /// 3. GELEN BİLDİRİMLER LİSTESİ BAŞLIĞI
            /// ----------------------------------------------------------------
            Text(
              'Gelen Bildirimler (${bildirimler.length}):',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 14,
                color: Color(0xFF1E293B),
              ),
            ),
            const SizedBox(height: 8),

            /// ----------------------------------------------------------------
            /// 4. DİNAMİK BİLDİRİM LİSTESİ VEYA BOŞ DURUM (EMPTY STATE)
            /// ----------------------------------------------------------------
            bildirimler.isEmpty
                ? Container(
                    padding: const EdgeInsets.all(24),
                    alignment: Alignment.center,
                    child: Text(
                      'Henüz gelen bildirim yok',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey.shade500,
                      ),
                    ),
                  )
                : ListView.separated(
                    shrinkWrap: true, // Card içinde yükseklik taşmasını önler
                    physics: const NeverScrollableScrollPhysics(), // Ana ekranın kaymasını engellemez
                    itemCount: bildirimler.length,
                    separatorBuilder: (_, _) => const Divider(height: 1),
                    itemBuilder: (context, index) {
                      final item = bildirimler[index];
                      return ListTile(
                        dense: true,
                        contentPadding: EdgeInsets.zero,
                        leading: CircleAvatar(
                          radius: 16,
                          backgroundColor: item.okunduMu
                              ? Colors.grey.shade200
                              : const Color(0xFFE0F2FE),
                          child: Icon(
                            item.okunduMu
                                ? Icons.mark_email_read_outlined
                                : Icons.mark_email_unread_outlined,
                            size: 16,
                            color: item.okunduMu
                                ? Colors.grey
                                : const Color(0xFF0284C7),
                          ),
                        ),
                        title: Text(
                          item.baslik ?? 'Başlıksız Bildirim',
                          style: TextStyle(
                            fontWeight: item.okunduMu ? FontWeight.normal : FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                        subtitle: Text(
                          item.icerik ?? '',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(fontSize: 12),
                        ),
                        trailing: Text(
                          '${item.tarih.hour.toString().padLeft(2, '0')}:${item.tarih.minute.toString().padLeft(2, '0')}',
                          style: TextStyle(fontSize: 10, color: Colors.grey.shade500),
                        ),
                      );
                    },
                  ),
          ],
        ),
      ),
    );
  }
}
