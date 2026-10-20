import 'package:flutter/material.dart';
import '../../../core/theme/app_colors.dart';

class LogoutDialog extends StatelessWidget {
  final VoidCallback onConfirmed;

  const LogoutDialog({super.key, required this.onConfirmed});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: const Row(
        children: [
          Icon(Icons.logout_rounded, color: AppColors.errorRed),
          SizedBox(width: 8),
          Text('Çıkış Yap', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        ],
      ),
      content: const Text(
        'Hesabınızdan çıkış yapmak istediğinize emin misiniz? Demo oturumunuz sonlandırılacaktır.',
        style: TextStyle(fontSize: 13),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Vazgeç'),
        ),
        ElevatedButton(
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.errorRed,
            foregroundColor: Colors.white,
          ),
          onPressed: () {
            Navigator.pop(context);
            onConfirmed();
          },
          child: const Text('Çıkış Yap'),
        ),
      ],
    );
  }
}
