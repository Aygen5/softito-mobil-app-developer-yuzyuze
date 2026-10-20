import 'package:flutter/material.dart';

/// ---------------------------------------------------------------------------
/// 🔘 AppButton — Yeniden Kullanılabilir Birincil Dolgulu Buton (ElevatedButton)
/// ---------------------------------------------------------------------------
/// Neden özel bir buton bileşeni (Custom Widget) yazarız?
/// 1. Tasarım Tutarlılığı: Uygulamanın her yerinde butonların yüksekliği, köşe yuvarlaklığı
///    ve yazı tipi birebir aynı olur.
/// 2. 'isLoading' Yeteneği: Form gönderilirken veya veri beklenirken buton içine
///    otomatik döner gösterge (CircularProgressIndicator) koyar ve butonu pasif yapar.
/// 3. Erişilebilirlik (Accessibility): Mobil cihazlarda parmakla rahat basılabilmesi için
///    standart en az 48px dokunmatik yükseklik kuralı uygulanır (burada 52px).
class AppButton extends StatelessWidget {
  final String text;                  // Buton üzerindeki metin
  final VoidCallback? onPressed;       // Butona tıklandığında çalışacak fonksiyon (null ise buton pasifleşir)
  final IconData? icon;                // Opsiyonel sol ikon
  final bool isLoading;               // İşlem devam ediyor mu (dönen çark gösterilsin mi)?
  final bool isFullWidth;             // Buton bulunduğu satırı boydan boya kaplasın mı?
  final Color? backgroundColor;       // Özel arka plan rengi (boşsa temadaki primary kullanılır)
  final Color? foregroundColor;       // Özel metin/ikon rengi (boşsa beyaz kullanılır)
  final double height;                // Buton yüksekliği

  const AppButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isLoading = false,
    this.isFullWidth = true,
    this.backgroundColor,
    this.foregroundColor,
    this.height = 52.0,
  });

  @override
  Widget build(BuildContext context) {
    // Mevcut aktif temanın renk ve parlaklık bilgilerini alıyoruz
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    /// Buton içeriği:
    /// 'isLoading == true' ise dönen yükleme simgesi göster;
    /// 'false' ise ikon ve metni yan yana diz.
    final btnContent = isLoading
        ? SizedBox(
            width: 22,
            height: 22,
            child: CircularProgressIndicator(
              strokeWidth: 2.5,
              color: foregroundColor ?? Colors.white,
            ),
          )
        : Row(
            mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // Eğer ikon tanımlanmışsa ikonu ve aradaki 8 piksellik boşluğu ekle
              if (icon != null) ...[
                Icon(icon, size: 20),
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),
            ],
          );

    return SizedBox(
      // 'isFullWidth' true ise genişliği sonsuz yaparak ekrana yayılmasını sağlar
      width: isFullWidth ? double.infinity : null,
      height: height,
      child: ElevatedButton(
        // Yükleniyor durumundayken tıklamayı engellemek için 'null' verilir
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor ?? theme.colorScheme.primary,
          foregroundColor: foregroundColor ?? Colors.white,
          // Buton pasif (disabled) olduğunda açık/koyu temaya göre opaklık ayarı
          disabledBackgroundColor: isDark
              ? Colors.white.withOpacity(0.12)
              : Colors.black.withOpacity(0.12),
          disabledForegroundColor: isDark
              ? Colors.white.withOpacity(0.38)
              : Colors.black.withOpacity(0.38),
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        child: btnContent,
      ),
    );
  }
}

/// ---------------------------------------------------------------------------
/// 🔲 AppOutlinedButton — İkincil Kenarlıklı Buton
/// ---------------------------------------------------------------------------
/// İptal etme, filtre temizleme veya geri dönme gibi ikinci planda kalan eylemlerde
/// kullanıcının dikkatini dağıtmamak için içi boş, kenarlıklı buton kullanılır.
class AppOutlinedButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final IconData? icon;
  final bool isFullWidth;
  final Color? borderColor;
  final Color? textColor;
  final double height;

  const AppOutlinedButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.icon,
    this.isFullWidth = true,
    this.borderColor,
    this.textColor,
    this.height = 50.0,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SizedBox(
      width: isFullWidth ? double.infinity : null,
      height: height,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: textColor ?? theme.colorScheme.primary,
          side: BorderSide(
            color: borderColor ?? theme.colorScheme.primary.withOpacity(0.5),
            width: 1.5,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14),
          ),
          padding: const EdgeInsets.symmetric(horizontal: 20),
        ),
        child: Row(
          mainAxisSize: isFullWidth ? MainAxisSize.max : MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            if (icon != null) ...[
              Icon(icon, size: 20),
              const SizedBox(width: 8),
            ],
            Text(
              text,
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

