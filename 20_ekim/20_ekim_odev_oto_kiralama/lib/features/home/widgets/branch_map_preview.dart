import 'package:flutter/material.dart';

class BranchMapPreview extends StatefulWidget {
  const BranchMapPreview({super.key});

  @override
  State<BranchMapPreview> createState() => _BranchMapPreviewState();
}

class _BranchMapPreviewState extends State<BranchMapPreview> {
  int _selectedBranchIndex = 0;

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
          // Temsili Harita Görsel / Grafik Alanı
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
                // Arka plan harita deseni / Grid
                Positioned.fill(
                  child: CustomPaint(
                    painter: _MapGridPainter(
                      color: isDark ? Colors.white.withOpacity(0.04) : Colors.black.withOpacity(0.04),
                    ),
                  ),
                ),
                // Türkiye Şube Pinleri (Temsili görsel pinler)
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
                            _selectedBranchIndex = index;
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 200),
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
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
                // Bilgilendirme etiketi
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

          // Seçili Şube Ayrıntıları
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
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

class _MapGridPainter extends CustomPainter {
  final Color color;
  const _MapGridPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0;

    const step = 20.0;
    for (double x = 0; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = 0; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _MapGridPainter oldDelegate) => oldDelegate.color != color;
}
