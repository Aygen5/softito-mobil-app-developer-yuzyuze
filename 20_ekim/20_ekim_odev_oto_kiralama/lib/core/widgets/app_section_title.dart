import 'package:flutter/material.dart';

/// ---------------------------------------------------------------------------
/// 🏷️ AppSectionTitle — Sayfa Bölüm Başlığı Bileşeni
/// ---------------------------------------------------------------------------
/// Ana sayfa ve listelerde farklı bölümleri ("Kategoriler", "Öne Çıkan Araçlar",
/// "Aktif Rezervasyonlar") birbirinden ayırmak ve sağ tarafta "Tümünü Gör >" gibi
/// bir eylem bağlantısı sunmak için kullanılır.
class AppSectionTitle extends StatelessWidget {
  final String title;               // Ana başlık metni (örn: 'Öne Çıkan Araçlar')
  final String? subtitle;           // Opsiyonel alt açıklama metni
  final String? actionText;         // Sağdaki eylem metni (örn: 'Tümünü Gör')
  final VoidCallback? onActionTap;  // Eylem metnine tıklandığında çalışacak fonksiyon
  final EdgeInsetsGeometry padding; // Dış boşluk

  const AppSectionTitle({
    super.key,
    required this.title,
    this.subtitle,
    this.actionText,
    this.onActionTap,
    this.padding = const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Padding(
      padding: padding,
      child: Row(
        // 'CrossAxisAlignment.end': Başlık ile sağdaki 'Tümünü Gör' metninin alt tabanlarını hizalar
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          // Sol taraf: Başlık ve alt başlığı barındıran esnek sütun
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  title,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w700,
                    fontSize: 18,
                    letterSpacing: -0.2,
                  ),
                ),
                if (subtitle != null) ...[
                  const SizedBox(height: 2),
                  Text(
                    subtitle!,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: colorScheme.onSurfaceVariant,
                      fontSize: 13,
                    ),
                  ),
                ],
              ],
            ),
          ),
          // Sağ taraf: Tıklanabilir 'Tümünü Gör >' metni
          if (actionText != null && onActionTap != null)
            GestureDetector(
              onTap: onActionTap,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 2),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      actionText!,
                      style: TextStyle(
                        color: colorScheme.primary,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                    const SizedBox(width: 4),
                    Icon(
                      Icons.arrow_forward_ios_rounded,
                      size: 12,
                      color: colorScheme.primary,
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }
}

