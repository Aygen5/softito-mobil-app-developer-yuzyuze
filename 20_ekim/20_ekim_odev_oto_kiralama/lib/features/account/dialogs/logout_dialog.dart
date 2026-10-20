import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

/// ============================================================================
/// LOGOUT DIALOG (OTURUM KAPATMA ONAY DİYALOĞU)
/// ============================================================================
/// 
/// [LogoutDialog], kullanıcının yanlışlıkla çıkış yapmasını önlemek amacıyla
/// onay isteyen standart bir [AlertDialog] örneğidir.
/// 
/// ÖĞRENİLECEK KONULAR:
/// 1. YIKICI EYLEM TASARIMI (Destructive Action Design):
///    - Çıkış yapma, silme veya iptal etme gibi geri dönüşü olmayan ya da
///      oturum sonlandıran işlemler kırmızı renkle ([AppColors.errorRed])
///      vurgulanarak kullanıcıya eylemin ciddiyeti hissettirilir.
/// 
/// 2. CALLBACK KALIBI:
///    - `Navigator.pop(context)` ile önce diyalog kapatılır, ardından
///      [onConfirmed] fonksiyonu çalıştırılarak asıl çıkış mantığı işletilir.
class LogoutDialog extends StatelessWidget {
  /// Kullanıcı "Çıkış Yap" butonuna basıp onayladığında çalışacak callback
  final VoidCallback onConfirmed;

  const LogoutDialog({super.key, required this.onConfirmed});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      // Başlık: Kırmızı çıkış simgesi ve başlık metni
      title: const Row(
        children: [
          Icon(Icons.logout_rounded, color: AppColors.errorRed),
          SizedBox(width: 8),
          Text('Çıkış Yap', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        ],
      ),
      // Uyarı ve bilgilendirme metni
      content: const Text(
        'Hesabınızdan çıkış yapmak istediğinize emin misiniz? Demo oturumunuz sonlandırılacaktır.',
        style: TextStyle(fontSize: 13),
      ),
      // Aksiyon Butonları: Vazgeç ve Çıkış Yap
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context), // Değişiklik yapmadan kapat
          child: const Text('Vazgeç'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.errorRed, // Yıkıcı aksiyon uyarısı
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context); // Diyaloğu kapat
            onConfirmed(); // Onay fonksiyonunu tetikle
          },
          child: const Text('Çıkış Yap'),
        ),
      ],
    );
  }
}

