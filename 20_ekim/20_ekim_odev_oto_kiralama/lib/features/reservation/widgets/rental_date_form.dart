import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';

/// ============================================================================
/// RENTAL DATE FORM (REZERVASYON DETAY VE SAAT/LOKASYON FORMU)
/// ============================================================================
/// 
/// [RentalDateForm], araç kiralama rezervasyonunda kullanıcının şube (lokasyon),
/// alış/dönüş saati ve opsiyonel hedef şehir bilgilerini girdiği form bileşenidir.
/// 
/// BU BİLEŞENİN GÖREVLERİ VE ÖĞRENİLECEK KONULAR:
/// 1. FORM YÖNETİMİ (Form & `GlobalKey<FormState>`):
///    - Üst ekrandan geçirilen [formKey] ile form alanlarının validasyonu ve
///      durum takibi merkezi olarak yönetilir.
/// 
/// 2. INPUTDECORATOR KALIBI (InputDecorator Pattern):
///    - TextFormField olmayan (tıklanınca picker veya bottomsheet açılan)
///      özel alanlara tam olarak Material `InputDecoration` görünümü (kenarlık,
///      yüzen etiket/floating label, dolgu) kazandırmak için [InputDecorator] kullanılır.
///    - Bu sayede formdaki tüm alanlar görsel olarak %100 uyumlu ve standart durur.
/// 
/// 3. ASENKRON SEÇİCİLER (Async Pickers):
///    - [showModalBottomSheet] ile şube listesi açılır ve seçim yaptırılır.
///    - [showTimePicker] asenkron olarak açılarak saat ve dakika seçtirilir.
/// 
/// 4. METİN BİÇİMLENDİRME (padLeft):
///    - Saati gösterirken tek basamaklı sayıların başına sıfır eklemek için
///      `time.hour.toString().padLeft(2, '0')` tekniği kullanılır (Örn: 9:5 -> 09:05).
class RentalDateForm extends StatelessWidget {
  /// Formun doğrulama anahtarı
  final GlobalKey<FormState> formKey;
  
  /// Seçili alış şubesi (Örn: "İstanbul - Kadıköy Rıhtım Ofisi")
  final String pickupLocation;
  
  /// Seçili dönüş şubesi (Farklı bir ofise teslimat imkanı)
  final String returnLocation;
  
  /// Aracın teslim alınacağı saat
  final TimeOfDay pickupTime;
  
  /// Aracın teslim edileceği saat
  final TimeOfDay returnTime;
  
  /// Kullanıcının isteğe bağlı girebileceği varış/hedef şehir metin denetleyicisi
  final TextEditingController destinationCityController;
  
  /// Alış yeri değiştiğinde üst ekranı bilgilendiren callback
  final ValueChanged<String> onPickupLocationChanged;
  
  /// Dönüş yeri değiştiğinde üst ekranı bilgilendiren callback
  final ValueChanged<String> onReturnLocationChanged;
  
  /// Alış saati seçildiğinde tetiklenen callback
  final ValueChanged<TimeOfDay> onPickupTimeChanged;
  
  /// Dönüş saati seçildiğinde tetiklenen callback
  final ValueChanged<TimeOfDay> onReturnTimeChanged;

  const RentalDateForm({
    super.key,
    required this.formKey,
    required this.pickupLocation,
    required this.returnLocation,
    required this.pickupTime,
    required this.returnTime,
    required this.destinationCityController,
    required this.onPickupLocationChanged,
    required this.onReturnLocationChanged,
    required this.onPickupTimeChanged,
    required this.onReturnTimeChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Form(
      key: formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // -------------------------------------------------------------
          // 1. ALIŞ & DÖNÜŞ NOKTALARI SEÇİM ALANLARI (Yan yana 2 Dropdown)
          // -------------------------------------------------------------
          Row(
            children: [
              Expanded(
                child: _buildLocationDropdown(
                  context: context,
                  label: 'Alış Noktası',
                  value: pickupLocation,
                  icon: Icons.trip_origin_rounded,
                  onChanged: onPickupLocationChanged,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildLocationDropdown(
                  context: context,
                  label: 'Dönüş Noktası',
                  value: returnLocation,
                  icon: Icons.place_rounded,
                  onChanged: onReturnLocationChanged,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // -------------------------------------------------------------
          // 2. ALIŞ & DÖNÜŞ SAATLERİ (Saat Seçici Butonları)
          // -------------------------------------------------------------
          Row(
            children: [
              Expanded(
                child: _buildTimePicker(
                  context: context,
                  label: 'Alış Saati',
                  time: pickupTime,
                  onTimeSelected: onPickupTimeChanged,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildTimePicker(
                  context: context,
                  label: 'Dönüş Saati',
                  time: returnTime,
                  onTimeSelected: onReturnTimeChanged,
                ),
              ),
            ],
          ),

          const SizedBox(height: 12),

          // -------------------------------------------------------------
          // 3. İSTEĞE BAĞLI GİDİLECEK ŞEHİR (Serbest Metin Alanı)
          // -------------------------------------------------------------
          TextFormField(
            controller: destinationCityController,
            decoration: const InputDecoration(
              labelText: 'Gidilecek Şehir (İsteğe Bağlı)',
              hintText: 'Örn: Ankara, İzmir, Bursa...',
              prefixIcon: Icon(Icons.alt_route_rounded),
            ),
          ),

          const SizedBox(height: 10),

          // -------------------------------------------------------------
          // 4. ŞİRKET POLİTİKASI: 250 KM GÜNLÜK SINIR BİLGİLENDİRME KUTUSU
          // -------------------------------------------------------------
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              children: [
                Icon(Icons.speed_rounded, size: 16, color: colorScheme.primary),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'RotaRent araçlarında günlük ${AppConstants.dailyKmAllowance} km kullanım hakkı bulunmaktadır.',
                    style: TextStyle(
                      fontSize: 11,
                      fontWeight: FontWeight.w500,
                      color: colorScheme.onSurfaceVariant,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Şube seçimi için özel alt sayfa (Modal BottomSheet) açan yardımcı metot
  Widget _buildLocationDropdown({
    required BuildContext context,
    required String label,
    required String value,
    required IconData icon,
    required ValueChanged<String> onChanged,
  }) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return InkWell(
      onTap: () {
        // Tıklanınca ekranın altından şubelerin listelendiği şık bir çekmece açılır
        showModalBottomSheet(
          context: context,
          builder: (ctx) => SafeArea(
            child: ListView(
              shrinkWrap: true,
              children: [
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: Text(label, style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16)),
                ),
                // AppConstants içindeki tüm şubeleri ListTile olarak dönüyoruz
                ...AppConstants.pickupLocations.map((loc) => ListTile(
                  leading: Icon(icon, color: colorScheme.primary),
                  title: Text(loc, style: const TextStyle(fontSize: 13)),
                  selected: loc == value, // Seçili olan şubeyi vurgular
                  onTap: () {
                    onChanged(loc); // Üst widget'a seçimi bildir
                    Navigator.pop(ctx); // Çekmeceyi kapat
                  },
                )),
              ],
            ),
          ),
        );
      },
      // InputDecorator: Klasik bir TextField çerçevesi simüle eder
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Text(
                // "İstanbul - Kadıköy Rıhtım Ofisi" metninden sadece "Kadıköy Rıhtım Ofisi" kısmını gösterir
                value.split(' - ').last,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.w600),
              ),
            ),
            const Icon(Icons.arrow_drop_down, size: 20),
          ],
        ),
      ),
    );
  }

  /// Saat seçimi için Flutter'ın yerleşik [showTimePicker] diyaloğunu açan yardımcı metot
  Widget _buildTimePicker({
    required BuildContext context,
    required String label,
    required TimeOfDay time,
    required ValueChanged<TimeOfDay> onTimeSelected,
  }) {
    return InkWell(
      onTap: () async {
        // Asenkron olarak kullanıcıdan saat seçmesini bekleriz
        final picked = await showTimePicker(
          context: context,
          initialTime: time,
        );
        // Kullanıcı iptal etmediyse ve bir saat seçtiyse callback'i tetikleriz
        if (picked != null) {
          onTimeSelected(picked);
        }
      },
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: label,
          contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            // padLeft(2, '0'): Sayı tek haneliyse (örn: 9) başına '0' ekleyerek "09" yapar
            Text(
              '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}',
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w700),
            ),
            const Icon(Icons.schedule_rounded, size: 18),
          ],
        ),
      ),
    );
  }
}

