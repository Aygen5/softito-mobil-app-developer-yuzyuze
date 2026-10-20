import 'package:flutter/material.dart';
import 'app_button.dart';

/// ---------------------------------------------------------------------------
/// 📭 AppEmptyState — Boş Durum Kullanıcı Deneyimi (Empty State UX Pattern)
/// ---------------------------------------------------------------------------
/// Neden Boş Durum Widget'ı Yaparız?
/// 1. Kullanıcı arama yaptığında hiçbir araç bulunamazsa,
/// 2. Veya "Rezervasyonlarım" sekmesinde henüz hiç rezervasyon yoksa,
/// kullanıcıya bomboş beyaz/siyah bir ekran göstermek en kötü kullanıcı deneyimidir (Bad UX).
///
/// Bunun yerine ortada şık bir illüstrasyon/ikon, samimi bir açıklama ve
/// kullanıcıyı doğru yere yönlendiren bir buton ("Filtreleri Temizle" veya "Araç Kirala")
/// sunarak uygulamanın canlı ve rehberlik eden bir his vermesini sağlarız.
class AppEmptyState extends StatelessWidget {
  final IconData icon;              // Gösterilecek büyük merkez simge
  final String title;               // Başlık (örn: 'Araç Bulunamadı')
  final String description;         // Açıklama ipucu (örn: 'Farklı bir arama terimi deneyebilirsiniz.')
  final String? buttonText;         // Opsiyonel aksiyon buton metni
  final VoidCallback? onButtonPressed; // Butona basıldığında çalışacak fonksiyon

  const AppEmptyState({
    super.key,
    this.icon = Icons.search_off_rounded,
    required this.title,
    required this.description,
    this.buttonText,
    this.onButtonPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 40),
        child: Column(
          // 'MainAxisSize.min': Column'un tüm ekranı kaplamak yerine sadece içeriği kadar yer kaplamasını sağlar
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // İkonun arkasındaki yarı saydam dairesel fon
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color: isDark
                    ? colorScheme.primary.withOpacity(0.15)
                    : colorScheme.primary.withOpacity(0.08),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 40,
                color: colorScheme.primary,
              ),
            ),
            const SizedBox(height: 20),
            // Başlık metni
            Text(
              title,
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                fontSize: 18,
              ),
            ),
            const SizedBox(height: 8),
            // Açıklama metni
            Text(
              description,
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: colorScheme.onSurfaceVariant,
                height: 1.4,
              ),
            ),
            // Eğer buton metni ve fonksiyonu tanımlanmışsa aksiyon butonunu göster
            if (buttonText != null && onButtonPressed != null) ...[
              const SizedBox(height: 24),
              SizedBox(
                width: 200,
                child: AppButton(
                  text: buttonText!,
                  onPressed: onButtonPressed,
                  height: 44,
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

