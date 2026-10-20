import 'package:flutter/material.dart';

/// ============================================================================
/// RENTAL AGREEMENT DIALOG (ARAÇ KİRALAMA SÖZLEŞMESİ VE KOŞULLARI POPUP'I)
/// ============================================================================
/// 
/// [RentalAgreementDialog], kullanıcının kiralama öncesinde veya sonrasında
/// hukuki şartları, 250 km günlük sınırını, yakıt politikasını ve kasko
/// güvencelerini okuyabilmesi için tasarlanmış kaydırılabilir bir [AlertDialog]'dur.
/// 
/// BU BİLEŞENİN GÖREVLERİ VE ÖĞRENİLECEK KONULAR:
/// 1. DİYALOG İÇİNDE KAYDIRILABİLİR İÇERİK (Scrollable Dialog Content):
///    - Dialog pencerelerinde içerik ekrandan taşarsa "RenderFlex overflowed" hatası
///      alınır. Bunu önlemek için `SingleChildScrollView` kullanılır.
/// 
/// 2. GENİŞLİK KONTROLÜ (SizedBox with double.maxFinite):
///    - `SizedBox(width: double.maxFinite)` kullanılarak içeriğin diyalog izin verdiği
///      maksimum genişliğe yayılması sağlanır ve dar/sıkışık görünüm engellenir.
/// 
/// 3. METİN OKUNABİLİRLİĞİ (Typography & Line Height):
///    - Hukuki maddelerde satır arası boşluk `height: 1.4` verilerek
///      uzun metinlerin gözü yormadan rahatça okunması sağlanır.
class RentalAgreementDialog extends StatelessWidget {
  const RentalAgreementDialog({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return AlertDialog(
      // Başlık: Belge simgesi ve başlık metni
      title: Row(
        children: [
          Icon(Icons.description_rounded, color: colorScheme.primary),
          const SizedBox(width: 8),
          const Text('Kiralama Sözleşmesi', style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700)),
        ],
      ),
      // İçerik: Kaydırılabilir sözleşme maddeleri
      content: SizedBox(
        width: double.maxFinite, // Diyaloğun enine genişlemesine izin ver
        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'RotaRent Araç Kiralama Genel Hüküm ve Koşulları',
                style: TextStyle(fontWeight: FontWeight.w700, fontSize: 13),
              ),
              const SizedBox(height: 10),
              // Sözleşme Maddeleri (Maddeler _buildClause ile tek tip oluşturulur)
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
      // Aksiyon Butonu: Onay ve kapatma
      actions: [
        ElevatedButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Okudum, Anladım'),
        ),
      ],
    );
  }

  /// Her bir sözleşme maddesini başlık ve açıklama paragrafı olarak oluşturan yardımcı metot
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

