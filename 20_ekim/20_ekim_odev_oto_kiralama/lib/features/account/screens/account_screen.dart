import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/theme_controller.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/widgets/app_empty_state.dart';
import '../../../data/reservation_store.dart';
import '../../../models/reservation.dart';
import '../widgets/reservation_card.dart';
import '../dialogs/rental_agreement_dialog.dart';
import '../dialogs/logout_dialog.dart';

class AccountScreen extends StatefulWidget {
  final int initialTabIndex;

  const AccountScreen({super.key, this.initialTabIndex = 0});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  late int _selectedTab;

  @override
  void initState() {
    super.initState();
    _selectedTab = widget.initialTabIndex;
  }

  void _showAgreementDialog() {
    showDialog(
      context: context,
      builder: (_) => const RentalAgreementDialog(),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (_) => LogoutDialog(
        onConfirmed: () {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Demo oturumundan başarıyla çıkış yapıldı.'),
              backgroundColor: AppColors.primaryBlue,
            ),
          );
        },
      ),
    );
  }

  void _cancelReservation(Reservation reservation) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Rezervasyon İptali'),
        content: Text('${reservation.vehicleName} için oluşturulan ${reservation.id} numaralı rezervasyonu iptal etmek istiyor musunuz?'),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: const Text('Vazgeç')),
          ElevatedButton(
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.errorRed),
            onPressed: () {
              reservationStore.cancelReservation(reservation.id);
              Navigator.pop(ctx);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Rezervasyon iptal edildi.')),
              );
            },
            child: const Text('İptal Et'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hesabım & Rezervasyonlarım'),
        actions: [
          IconButton(
            icon: const Icon(Icons.description_outlined),
            tooltip: 'Sözleşme',
            onPressed: _showAgreementDialog,
          ),
          IconButton(
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Çıkış Yap',
            onPressed: _showLogoutDialog,
          ),
        ],
      ),
      body: Column(
        children: [
          // Profil Kartı
          Container(
            margin: const EdgeInsets.fromLTRB(20, 8, 20, 14),
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: theme.cardTheme.color,
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: colorScheme.outline.withOpacity(isDark ? 0.35 : 0.65),
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(isDark ? 0.25 : 0.04),
                  blurRadius: 12,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Column(
              children: [
                Row(
                  children: [
                    CircleAvatar(
                      radius: 26,
                      backgroundColor: colorScheme.primaryContainer,
                      child: Text(
                        AppConstants.demoUserName.split(' ').map((e) => e[0]).take(2).join(),
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: colorScheme.onPrimaryContainer,
                        ),
                      ),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Text(
                                AppConstants.demoUserName,
                                style: theme.textTheme.titleMedium?.copyWith(
                                  fontWeight: FontWeight.w800,
                                  fontSize: 16,
                                ),
                              ),
                              const SizedBox(width: 8),
                              Container(
                                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                                decoration: BoxDecoration(
                                  color: AppColors.accentAmber.withOpacity(0.15),
                                  borderRadius: BorderRadius.circular(10),
                                  border: Border.all(color: AppColors.accentAmber.withOpacity(0.5)),
                                ),
                                child: const Text(
                                  AppConstants.demoUserRole,
                                  style: TextStyle(
                                    color: AppColors.accentAmber,
                                    fontSize: 9,
                                    fontWeight: FontWeight.w700,
                                  ),
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 2),
                          Text(
                            AppConstants.demoUserEmail,
                            style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
                          ),
                          Text(
                            AppConstants.demoUserPhone,
                            style: TextStyle(fontSize: 11, color: colorScheme.onSurfaceVariant),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                const Divider(height: 18),
                // Tema Switch
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isDark ? Icons.dark_mode_rounded : Icons.light_mode_rounded,
                          size: 18,
                          color: colorScheme.primary,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          isDark ? 'Koyu Tema' : 'Açık Tema',
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 13),
                        ),
                      ],
                    ),
                    Switch(
                      value: isDark,
                      onChanged: (_) => themeController.toggleTheme(),
                    ),
                  ],
                ),
              ],
            ),
          ),

          // Özel Sekme Çubuğu (Segmented Tabs)
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 20),
            padding: const EdgeInsets.all(4),
            decoration: BoxDecoration(
              color: colorScheme.surfaceVariant,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTab = 0),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: _selectedTab == 0 ? colorScheme.primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Aktif Rezervasyonlar',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: _selectedTab == 0 ? Colors.white : colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ),
                Expanded(
                  child: GestureDetector(
                    onTap: () => setState(() => _selectedTab = 1),
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                        color: _selectedTab == 1 ? colorScheme.primary : Colors.transparent,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Text(
                        'Geçmiş Kiralama',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 13,
                          fontWeight: FontWeight.w700,
                          color: _selectedTab == 1 ? Colors.white : colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: 12),

          // Liste Görünümü
          Expanded(
            child: ValueListenableBuilder<List<Reservation>>(
              valueListenable: reservationStore,
              builder: (context, allReservations, _) {
                final list = _selectedTab == 0
                    ? allReservations.where((r) => r.isActive).toList()
                    : allReservations.where((r) => r.isCompleted).toList();

                if (list.isEmpty) {
                  return AppEmptyState(
                    icon: _selectedTab == 0
                        ? Icons.calendar_today_outlined
                        : Icons.history_rounded,
                    title: _selectedTab == 0 ? 'Aktif Rezervasyon Yok' : 'Geçmiş Kiralama Yok',
                    description: _selectedTab == 0
                        ? 'Şu anda onaylanmış veya bekleyen bir araç rezervasyonunuz bulunmamaktadır.'
                        : 'Daha önce tamamlanmış bir kiralama kaydınız bulunmamaktadır.',
                  );
                }

                return ListView.separated(
                  padding: const EdgeInsets.fromLTRB(20, 4, 20, 32),
                  itemCount: list.length,
                  separatorBuilder: (_, __) => const SizedBox(height: 14),
                  itemBuilder: (context, index) {
                    final res = list[index];
                    return ReservationCard(
                      reservation: res,
                      onShowAgreement: _showAgreementDialog,
                      onCancel: res.isActive ? () => _cancelReservation(res) : null,
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
