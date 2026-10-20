import 'package:flutter/material.dart';

class RentalAgreementDialog extends StatelessWidget {
  const RentalAgreementDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      title: Row(
        children: [
          Icon(Icons.description_rounded, color: colorScheme.primary),
          const SizedBox(width: 8),
          const Text('Kiralama Sözleşmesi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        ],
      ),
      content: SizedBox(
        width: double.maxFinite,
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'RotaRent Araç Kiralama Genel Hüküm ve Koşulları',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              ),
              const SizedBox(height: 10),
              _buildClause('1. Taraflar ve Kapsam', 'Bu sözleşme RotaRent A.Ş. ile aracı kiralayan müşteri arasında yerel demo kuralları çerçevesinde akdedilmiştir.'),
              _buildClause('2. Kilometre Sınırı', 'Kiralama süresince günlük kullanım hakkı 250 kilometredir. Kilometre aşımı durumunda sözleşme şartları uygulanır.'),
              _buildClause('3. Teslim ve İade', 'Araç, kira başlangıcında belirtilen teslim yerinde alınır ve kira bitiminde anlaşılan şubeye teslim edilir.'),
              _buildClause('4. Yakıt Politikası', 'Araç teslim alındığı yakıt seviyesinde iade edilmelidir. Eksik yakıtla teslimlerde piyasa yakıt bedeli yansıtılır.'),
              _buildClause('5. Sigorta ve Güvenceler', 'Tüm araçlarımız Rent A Car Kaskosu ve Zorunlu Mali Sorumluluk Sigortası ile güvence altındadır.'),
              _buildClause('6. İptal ve Değişiklik', 'Kiralama başlangıç saatinden 24 saat öncesine kadar yapılan iptallerde ceza uygulanmaz.'),
            ],
          ),
        ),
      ),
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Okudum, Anladım'),
        ),
      ],
    );
  }

  Widget _buildClause(String title, String content) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(title, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 12)),
          const SizedBox(height: 2),
          Text(content, style: const TextStyle(fontSize: 12, height: 1.4)),
        ],
      ),
    );
  }
}
