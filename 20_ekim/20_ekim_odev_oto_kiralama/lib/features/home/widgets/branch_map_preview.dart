import 'package:flutter/material.dart';

/// ---------------------------------------------------------------------------
/// 🗺️ BranchMapPreview — Temsili Hizmet Noktaları Haritası ve Şube Kartı
/// ---------------------------------------------------------------------------
/// Proje gereksinimine göre harici ağır harita API'leri (Google Maps vb.) yerine;
/// hafif, hızlı ve CustomPaint ile çizilmiş temsili bir ızgara harita üzerinde
/// Türkiye'deki şubelerimizi ve anlık müsait araç sayılarını sunar.
class BranchMapPreview extends StatefulWidget {
  const BranchMapPreview({super.key});

  @override
  State<BranchMapPreview> createState() => _BranchMapPreviewState();
}

class _BranchMapPreviewState extends State<BranchMapPreview> {
  // Seçili olan şubenin indeksi
  int _selectedBranchIndex = 0;

  /// Dart 3 Records ile tanımlanan şube listesi
  final List<({String city, String title, String address, int vehicleCount, String phone})> _branches = const [
    (
      city: 'İstanbul',
      title: 'İstanbul Havalimanı (IST) Ofisi',
      address: 'Havalimanı Çıkışı Gelen Yolcu Katı No: 14',
      vehicleCount: 42,
      phone: '0212 444 76 82',
    ),
    (
      city: 'İstanbul',
      title: 'Sabiha Gökçen (SAW) Ofisi',
      address: 'Gelen Yolcu Terminali Rent A Car Alanı No: 8',
      vehicleCount: 35,
      phone: '0216 444 76 82',
    ),
    (
      city: 'Ankara',
      title: 'Esenboğa Havalimanı (ESB) Şubesi',
      address: 'İç Hatlar Terminali Gelen Yolcu Salonu',
      vehicleCount: 28,
      phone: '0312 444 76 82',
    ),
    (
      city: 'İzmir',
      title: 'Adnan Menderes (ADB) Şubesi',
      address: 'İç Hatlar Terminali Çıkış Kapısı Yanı',
      vehicleCount: 24,
      phone: '0232 444 76 82',
    ),
    (
      city: 'Antalya',
      title: 'Antalya Havalimanı (AYT) Şubesi',
      address: 'Dış Hatlar & İç Hatlar Birleşimi Rent A Car Parkı',
      vehicleCount: 30,
      phone: '0242 444 76 82',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;
    final activeBranch = _branches[_selectedBranchIndex];

    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outline.withOpacity(isDark ? 0.3 : 0.6),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // -----------------------------------------------------------------
          // 🗺️ 1. Temsili Harita Görsel / Grafik Alanı
          // -----------------------------------------------------------------
          Container(
            height: 140,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(20)),
              gradient: LinearGradient(
                colors: isDark
                    ? [const Color(0xFF0F172A), const Color(0xFF1E293B)]
                    : [const Color(0xFFEFF6FF), const Color(0xFFDBEAFE)],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
            ),
            child: Stack(
              children: [
                /// 'CustomPaint':
                /// Arka plana koordinat ızgarası (Grid) deseni çizmek için
                /// doğrudan Flutter'ın düşük seviye grafik motorunu kullanır.
                Positioned.fill(
                  child: CustomPaint(
                    painter: _MapGridPainter(
                      color: isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.04),
                    ),
                  ),
                ),

                // Şehir Seçim Rozetleri (Harita Pinleri)
                Align(
                  alignment: Alignment.center,
                  child: SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: List.generate(_branches.length, (index) {
                        final isSelected = _selectedBranchIndex == index;
                        final branch = _branches[index];

                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              _selectedBranchIndex = index; // Tıklanan şubeyi aktif yap
                            });
                          },
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 200),
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                            margin: const EdgeInsets.symmetric(horizontal: 4),
                            decoration: BoxDecoration(
                              color: isSelected
                                  ? colorScheme.primary
                                  : (isDark ? const Color(0xFF334155) : Colors.white),
                              borderRadius: BorderRadius.circular(20),
                              boxShadow: [
                                BoxShadow(
                                  color: (isSelected ? colorScheme.primary : Colors.black).withOpacity(0.2),
                                  blurRadius: isSelected ? 8 : 4,
                                  offset: const Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  Icons.location_on_rounded,
                                  size: 14,
                                  color: isSelected ? Colors.white : colorScheme.primary,
                                ),
                                const SizedBox(width: 4),
                                Text(
                                  branch.city,
                                  style: TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w700,
                                    color: isSelected
                                        ? Colors.white
                                        : (isDark ? Colors.white : colorScheme.onSurface),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      }),
                    ),
                  ),
                ),

                // Sağ üst köşe bilgilendirme etiketi
                Positioned(
                  top: 10,
                  right: 12,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.55),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(Icons.info_outline_rounded, size: 12, color: Colors.white70),
                        SizedBox(width: 4),
                        Text(
                          'Temsili Harita',
                          style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.w500),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),

          // -----------------------------------------------------------------
          // 🏢 2. Seçili Şube Ayrıntıları Bölümü
          // -----------------------------------------------------------------
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Şube Başlığı ve Müsait Araç Sayısı Rozeti
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        activeBranch.title,
                        style: theme.textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          fontSize: 15,
                        ),
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: colorScheme.primary.withOpacity(0.12),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        '${activeBranch.vehicleCount} Müsait Araç',
                        style: TextStyle(
                          color: colorScheme.primary,
                          fontSize: 11,
                          fontWeight: FontWeight.w700,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 6),

                // Açık Adres
                Row(
                  children: [
                    Icon(Icons.pin_drop_outlined, size: 14, color: colorScheme.onSurfaceVariant),
                    const SizedBox(width: 6),
                    Expanded(
                      child: Text(
                        activeBranch.address,
                        style: TextStyle(
                          fontSize: 12,
                          color: colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),

                // Telefon İrtibat Numarası
                Row(
                  children: [
                    Icon(Icons.phone_in_talk_outlined, size: 14, color: colorScheme.onSurfaceVariant),
                    const SizedBox(width: 6),
                    Text(
                      activeBranch.phone,
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: colorScheme.primary,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// 🎨 _MapGridPainter — Harita Izgarası Çizici (CustomPainter)
/// ---------------------------------------------------------------------------
/// 'CustomPainter': Flutter'da doğrudan Canvas üzerine piksel piksel çizim yapmayı sağlar.
/// Burada harita arka planı için yatay ve dikey ızgara çizgileri çekiyoruz.
class _MapGridPainter extends CustomPainter {
  final Color color; // Çizgilerin rengi

  const _MapGridPainter({required this.color});

  /// 'paint': Çizim fonksiyonudur.
  /// [canvas]: Çizim yaptığımız tuval nesnesi.
  /// [size]: Çizim alanının genişlik ve yükseklik boyutları.
  @override
  void paint(Canvas canvas, Size size) {
    // Fırça (Paint) nesnesi oluşturuluyor
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0;

    const step = 20.0; // Izgara karelerinin kenar uzunluğu (20 piksel)

    // Dikey çizgileri çiz: Soldan sağa x koordinatını 20'şer artırarak
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Yatay çizgileri çiz: Yukarıdan aşağıya y koordinatını 20'şer artırarak
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  /// 'shouldRepaint':
  /// Widget yeniden render olduğunda çizimin tekrar yapılıp yapılmayacağını belirler.
  /// Eğer çizgi rengi değişmemişse false dönerek gereksiz CPU/GPU çizimini engeller.
  @override
  bool shouldRepaint(covariant _MapGridPainter oldDelegate) => oldDelegate.color != color;
}

