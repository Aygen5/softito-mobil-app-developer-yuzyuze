import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import '../../../common/widgets/app_modals.dart';
import '../../../common/widgets/loading_view.dart';
import '../../../common/widgets/theme_toggle_button.dart';
import '../../../core/router/route_names.dart';
import '../../../core/theme/app_colors.dart';
import '../../../data/models/daily_report_model.dart';
import '../../../data/repositories/daily_report_repository.dart';
import '../../../data/repositories/internship_repository.dart';
import '../../auth/cubit/auth_cubit.dart';
import '../cubit/internship_cubit.dart';
import '../cubit/internship_state.dart';

/// Ekran 4: Staj İlerlemesi, Kurum Detayları ve Kayıt Geçmişi (Stitch Screen 4 Tasarımına %100 Sadık).
class InternshipProgressView extends StatefulWidget {
  const InternshipProgressView({super.key});

  @override
  State<InternshipProgressView> createState() => _InternshipProgressViewState();
}

class _InternshipProgressViewState extends State<InternshipProgressView> {
  int _selectedTabIndex =
      0; // 0: Staj İlerlemesi, 1: Kurum Bilgileri, 2: Hesap Ayarları
  int _filterIndex = 0; // 0: Tümü, 1: Onaylanan, 2: Bekleyen, 3: Düzeltme

  @override
  Widget build(BuildContext context) {
    final authState = context.watch<AuthCubit>().state;
    final user = (authState is AuthAuthenticated) ? authState.user : null;

    if (user == null) {
      return const Scaffold(
        body: Center(
          child: LoadingView(message: 'Oturum bilgisi yükleniyor...'),
        ),
      );
    }

    return BlocProvider<InternshipCubit>(
      create: (context) => InternshipCubit(
        studentId: user.uid,
        internshipRepository: context.read<InternshipRepository>(),
        dailyReportRepository: context.read<DailyReportRepository>(),
      ),
      child: Scaffold(
        backgroundColor: Theme.of(context).brightness == Brightness.dark
            ? AppColors.darkBackground
            : const Color(0xFFF8FAFC),
        appBar: AppBar(
          backgroundColor: Theme.of(context).brightness == Brightness.dark
              ? AppColors.darkSurface
              : Colors.white,
          elevation: 0,
          scrolledUnderElevation: 1,
          titleSpacing: 16,
          title: Row(
            children: [
              Container(
                width: 34,
                height: 34,
                decoration: BoxDecoration(
                  color: AppColors.primaryNavy,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.school_rounded,
                  color: Colors.white,
                  size: 19,
                ),
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'StajTakip',
                    style: TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.darkTextPrimary
                          : AppColors.textPrimary,
                    ),
                  ),
                  Text(
                    'İlerlemem',
                    style: TextStyle(
                      fontSize: 11,
                      color: Theme.of(context).brightness == Brightness.dark
                          ? AppColors.darkTextSecondary
                          : AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            const ThemeToggleButton(),
            Stack(
              children: [
                IconButton(
                  icon: const Icon(Icons.notifications_none_rounded),
                  onPressed: () => AppModals.showWeeklyTipModal(context),
                ),
                Positioned(
                  right: 12,
                  top: 12,
                  child: Container(
                    width: 7,
                    height: 7,
                    decoration: const BoxDecoration(
                      color: AppColors.primaryBlue,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.only(right: 16, left: 4),
              child: CircleAvatar(
                radius: 16,
                backgroundColor: AppColors.primaryBlue.withValues(alpha: 0.15),
                child: const Text(
                  'D',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: AppColors.primaryBlue,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
          ],
        ),
        body: _buildProgressBody(context),
      ),
    );
  }

  Widget _buildProgressBody(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final authState = context.watch<AuthCubit>().state;
    final user = (authState is AuthAuthenticated) ? authState.user : null;

    final displayName = user?.fullName.isNotEmpty == true
        ? user!.fullName
        : 'Deniz Yılmaz';
    final studentNo = user?.institutionId ?? '150200142';

    return BlocBuilder<InternshipCubit, InternshipState>(
      builder: (context, state) {
        if (state is InternshipLoading || state is InternshipInitial) {
          return const LoadingView(message: 'İlerleme takvimi hesaplanıyor...');
        }

        return RefreshIndicator(
          onRefresh: () => context.read<InternshipCubit>().refresh(),
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 32),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // 1. Öğrenci Profil Kartı (Screenshot 4)
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.border,
                    ),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 28,
                        backgroundColor: AppColors.primaryBlue.withValues(
                          alpha: 0.12,
                        ),
                        child: Text(
                          displayName.isNotEmpty
                              ? displayName[0].toUpperCase()
                              : 'D',
                          style: const TextStyle(
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryBlue,
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
                                  displayName,
                                  style: TextStyle(
                                    fontSize: 17,
                                    fontWeight: FontWeight.bold,
                                    color: isDark
                                        ? AppColors.darkTextPrimary
                                        : AppColors.textPrimary,
                                  ),
                                ),
                                const SizedBox(width: 6),
                                const Icon(
                                  Icons.verified_rounded,
                                  size: 16,
                                  color: AppColors.primaryBlue,
                                ),
                              ],
                            ),
                            const SizedBox(height: 3),
                            Text(
                              'Öğrenci No: $studentNo',
                              style: TextStyle(
                                fontSize: 12,
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.textSecondary,
                              ),
                            ),
                            const SizedBox(height: 2),
                            const Text(
                              'İTÜ Bilgisayar ve Bilişim Fakültesi',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: AppColors.primaryBlue,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // 2. Segmentli Sekme Butonları (Staj İlerlemesi, Kurum Bilgileri, Hesap Ayarları)
                Container(
                  padding: const EdgeInsets.all(4),
                  decoration: BoxDecoration(
                    color: isDark
                        ? AppColors.darkSurface
                        : const Color(0xFFEFF2F6),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      _buildTabItem(
                        title: 'Staj İlerlemesi',
                        index: 0,
                        isDark: isDark,
                      ),
                      _buildTabItem(
                        title: 'Kurum Bilgileri',
                        index: 1,
                        isDark: isDark,
                      ),
                      _buildTabItem(
                        title: 'Hesap Ayarları',
                        index: 2,
                        isDark: isDark,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 16),

                // 3. Zorunlu Staj Durumu Kartı (3 Renkli İlerleme Çubuğu - Screenshot 4)
                Container(
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.border,
                    ),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              const Icon(
                                Icons.bar_chart_rounded,
                                size: 20,
                                color: AppColors.primaryBlue,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'Zorunlu Staj Durumu',
                                style: TextStyle(
                                  fontSize: 15,
                                  fontWeight: FontWeight.bold,
                                  color: isDark
                                      ? AppColors.darkTextPrimary
                                      : AppColors.textPrimary,
                                ),
                              ),
                            ],
                          ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: isDark
                                  ? AppColors.darkSurfaceVariant
                                  : const Color(0xFFEFF6FF),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Text(
                              '30 İş Günü',
                              style: TextStyle(
                                fontSize: 11,
                                fontWeight: FontWeight.bold,
                                color: AppColors.primaryBlue,
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 14),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            '%77 Tamamlanan/İncelenen',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? AppColors.darkTextPrimary
                                  : AppColors.textPrimary,
                            ),
                          ),
                          Text(
                            '23 / 30 Gün',
                            style: TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.bold,
                              color: isDark
                                  ? AppColors.darkTextSecondary
                                  : AppColors.textSecondary,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),

                      // 3 Parçalı Segmentli İlerleme Çubuğu (Yeşil, Mavi, Açık Gri)
                      ClipRRect(
                        borderRadius: BorderRadius.circular(6),
                        child: Row(
                          children: [
                            Expanded(
                              flex: 20, // 20 gün onaylı
                              child: Container(
                                height: 8,
                                color: const Color(0xFF059669),
                              ),
                            ),
                            Expanded(
                              flex: 3, // 3 gün inceleniyor
                              child: Container(
                                height: 8,
                                color: AppColors.primaryBlue,
                              ),
                            ),
                            Expanded(
                              flex: 7, // 7 gün kalan
                              child: Container(
                                height: 8,
                                color: isDark
                                    ? AppColors.darkSurfaceVariant
                                    : const Color(0xFFE2E8F0),
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 14),

                      // 3'lü Metrik Hapları
                      Row(
                        children: [
                          Expanded(
                            child: _buildProgressStatPill(
                              dotColor: const Color(0xFF059669),
                              label: 'Onaylandı',
                              value: '20 Gün (%67)',
                              isDark: isDark,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: _buildProgressStatPill(
                              dotColor: AppColors.primaryBlue,
                              label: 'İncelemede',
                              value: '3 Gün (%10)',
                              isDark: isDark,
                            ),
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: _buildProgressStatPill(
                              dotColor: isDark
                                  ? AppColors.darkTextSecondary
                                  : const Color(0xFF94A3B8),
                              label: 'Kalan',
                              value: '7 Gün (%23)',
                              isDark: isDark,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // 4. Firma Yetkilisi & Danışman Kartları (Screenshot 4)
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.border,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(9),
                        decoration: BoxDecoration(
                          color: AppColors.primaryBlue.withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.business_center_outlined,
                          color: AppColors.primaryBlue,
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Firma Yetkilisi',
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.textSecondary,
                              ),
                            ),
                            Text(
                              'Müh. Ahmet Kaya',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              'Kıdemli Yazılım Mühendisi • Trendyol Tech',
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),

                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    color: isDark ? AppColors.darkSurface : Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: isDark ? AppColors.darkBorder : AppColors.border,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(9),
                        decoration: BoxDecoration(
                          color: const Color(0xFF6366F1).withValues(alpha: 0.1),
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: const Icon(
                          Icons.school_outlined,
                          color: Color(0xFF6366F1),
                          size: 20,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Akademik Danışman',
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.textSecondary,
                              ),
                            ),
                            Text(
                              'Prof. Dr. Ayşe Demir',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.bold,
                                color: isDark
                                    ? AppColors.darkTextPrimary
                                    : AppColors.textPrimary,
                              ),
                            ),
                            Text(
                              'İTÜ Bölüm Başkanlığı',
                              style: TextStyle(
                                fontSize: 11,
                                color: isDark
                                    ? AppColors.darkTextSecondary
                                    : AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 20),

                // 5. Günlük Kayıt Geçmişi (Toplam 23 Girdi)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        const Icon(
                          Icons.history_rounded,
                          size: 20,
                          color: AppColors.primaryBlue,
                        ),
                        const SizedBox(width: 8),
                        Text(
                          'Günlük Kayıt Geçmişi',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: isDark
                                ? AppColors.darkTextPrimary
                                : AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                    Text(
                      'Toplam 23 Girdi',
                      style: TextStyle(
                        fontSize: 12,
                        color: isDark
                            ? AppColors.darkTextSecondary
                            : AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),

                // Filtreleme Çipleri (Tümü, Onaylanan, Bekleyen, Düzeltme)
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildHistoryFilterChip(
                        label: 'Tümü (23)',
                        index: 0,
                        isDark: isDark,
                      ),
                      _buildHistoryFilterChip(
                        label: 'Onaylanan (15)',
                        index: 1,
                        isDark: isDark,
                      ),
                      _buildHistoryFilterChip(
                        label: 'Bekleyen (3)',
                        index: 2,
                        isDark: isDark,
                      ),
                      _buildHistoryFilterChip(
                        label: 'Düzeltme (2)',
                        index: 3,
                        isDark: isDark,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 14),

                // Geçmiş Kartları (Screenshot 4)
                _buildHistoryCard(
                  context: context,
                  date: '21 Ekim 2024 • 8 saat',
                  statusLabel: '✓ Onaylandı',
                  statusColor: const Color(0xFF059669),
                  statusBg: const Color(0xFFE8F5EE),
                  title: 'PostgreSQL indeksleme optimizasyonu ve sorgu maliyeti analiz raporu hazırlandı.',
                  attachmentText: '2 Ek Dosya',
                  isDark: isDark,
                ),
                _buildHistoryCard(
                  context: context,
                  date: '20 Ekim 2024 • 8 saat',
                  statusLabel: 'İnceleme Bekliyor',
                  statusColor: AppColors.primaryBlue,
                  statusBg: const Color(0xFFEBF5FF),
                  title: 'Swagger dokümantasyonu ve API testleri; Postman collection kurgusu tamamlandı.',
                  attachmentText: '1 Ek Dosya',
                  isDark: isDark,
                ),
                _buildHistoryCard(
                  context: context,
                  date: '19 Ekim 2024 • 8 saat',
                  statusLabel: 'Düzeltme İstendi',
                  statusColor: AppColors.error,
                  statusBg: const Color(0xFFFDEEEE),
                  title: 'Mikroservis entegrasyon testleri ve auth middleware doğrulama döngüleri.',
                  revisionQuote:
                      'Müh. Ahmet Kaya: "Test kapsam oranını detaylandırın."',
                  attachmentText: 'Düzenle',
                  isDark: isDark,
                  isRevision: true,
                ),
                _buildHistoryCard(
                  context: context,
                  date: '18 Ekim 2024 • 8 saat',
                  statusLabel: '✓ Onaylandı',
                  statusColor: const Color(0xFF059669),
                  statusBg: const Color(0xFFE8F5EE),
                  title: 'Docker Compose ile yerel geliştirme ortamı konteyner mimarisine taşındı.',
                  attachmentText: '3 Ek Dosya',
                  isDark: isDark,
                ),
                const SizedBox(height: 20),

                // 6. Aksiyon Butonları (PDF Oluştur, Bilgileri Düzenle, Güvenli Çıkış)
                ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryBlue,
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    elevation: 0,
                  ),
                  onPressed: () {
                    context.pushNamed(
                      RouteNames.studentPdfPreviewName,
                      extra: 'staj_demo_001',
                    );
                  },
                  icon: const Icon(Icons.picture_as_pdf_outlined, size: 20),
                  label: const Text(
                    'Staj Defteri Oluştur (PDF)',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),

                OutlinedButton.icon(
                  style: OutlinedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14),
                    ),
                    side: BorderSide(
                      color: isDark ? AppColors.darkBorder : AppColors.border,
                    ),
                  ),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text('Hesap ayarları modalı açılıyor...'),
                      ),
                    );
                  },
                  icon: const Icon(Icons.manage_accounts_outlined, size: 20),
                  label: const Text(
                    'Hesap Bilgilerini Düzenle',
                    style: TextStyle(fontWeight: FontWeight.w600),
                  ),
                ),
                const SizedBox(height: 10),

                Container(
                  decoration: BoxDecoration(
                    color: const Color(0xFFFDEEEE),
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: TextButton.icon(
                    style: TextButton.styleFrom(
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      foregroundColor: AppColors.error,
                    ),
                    onPressed: () {
                      context.read<AuthCubit>().signOut();
                    },
                    icon: const Icon(Icons.logout_rounded, size: 18),
                    label: const Text(
                      'Güvenli Çıkış Yap',
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildTabItem({
    required String title,
    required int index,
    required bool isDark,
  }) {
    final isSelected = _selectedTabIndex == index;
    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedTabIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? AppColors.darkSurfaceVariant : Colors.white)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(10),
            boxShadow: isSelected
                ? [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.05),
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ]
                : null,
          ),
          child: Text(
            title,
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected
                  ? (isDark ? AppColors.darkTextPrimary : AppColors.textPrimary)
                  : (isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressStatPill({
    required Color dotColor,
    required String label,
    required String value,
    required bool isDark,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 8),
      decoration: BoxDecoration(
        color: isDark ? AppColors.darkSurfaceVariant : const Color(0xFFF8FAFC),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: isDark ? AppColors.darkBorder : AppColors.border,
        ),
      ),
      child: Column(
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 7,
                height: 7,
                decoration: BoxDecoration(
                  color: dotColor,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 5),
              Text(
                label,
                style: TextStyle(
                  fontSize: 11,
                  color: isDark
                      ? AppColors.darkTextSecondary
                      : AppColors.textSecondary,
                ),
              ),
            ],
          ),
          const SizedBox(height: 3),
          Text(
            value,
            style: TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
              color: isDark ? AppColors.darkTextPrimary : AppColors.textPrimary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHistoryFilterChip({
    required String label,
    required int index,
    required bool isDark,
  }) {
    final isSelected = _filterIndex == index;
    return Padding(
      padding: const EdgeInsets.only(right: 8),
      child: GestureDetector(
        onTap: () => setState(() => _filterIndex = index),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 7),
          decoration: BoxDecoration(
            color: isSelected
                ? (isDark ? AppColors.primaryBlue : AppColors.primaryNavy)
                : (isDark ? AppColors.darkSurface : Colors.white),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isSelected
                  ? Colors.transparent
                  : (isDark ? AppColors.darkBorder : AppColors.border),
            ),
          ),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 12,
              fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
              color: isSelected
                  ? Colors.white
                  : (isDark
                        ? AppColors.darkTextSecondary
                        : AppColors.textSecondary),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildHistoryCard({
    required BuildContext context,
    required String date,
    required String statusLabel,
    required Color statusColor,
    required Color statusBg,
    required String title,
    required String attachmentText,
    required bool isDark,
    String? revisionQuote,
    bool isRevision = false,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(16),
          onTap: () {
            final dummyReport = DailyReportModel(
              id: 'rep_dummy',
              internshipId: 'staj_demo_001',
              studentId: 'demo_student_uid',
              workDate: DateTime.now(),
              tasks: title,
              learnings: 'Kapsamlı teknik dokümantasyon ve mimari entegrasyon prensipleri incelendi.',
              hoursWorked: 8,
              status: isRevision
                  ? ReportStatus.revisionRequested
                  : ReportStatus.approved,
              revisionComment: revisionQuote,
              createdAt: DateTime.now(),
              updatedAt: DateTime.now(),
            );
            AppModals.showReportDetailModal(context, dummyReport);
          },
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: isDark ? AppColors.darkSurface : Colors.white,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: isDark ? AppColors.darkBorder : AppColors.border,
              ),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          Icons.calendar_today_outlined,
                          size: 14,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          date,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: isDark
                            ? statusColor.withValues(alpha: 0.15)
                            : statusBg,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        statusLabel,
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.bold,
                          color: statusColor,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 10),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.bold,
                    height: 1.35,
                    color: isDark
                        ? AppColors.darkTextPrimary
                        : AppColors.textPrimary,
                  ),
                ),
                if (revisionQuote != null) ...[
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: AppColors.error.withValues(alpha: 0.08),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Text(
                      revisionQuote,
                      style: const TextStyle(
                        fontSize: 11,
                        color: AppColors.error,
                      ),
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Icon(
                          isRevision
                              ? Icons.edit_note_rounded
                              : Icons.attach_file_rounded,
                          size: 15,
                          color: isDark
                              ? AppColors.darkTextSecondary
                              : AppColors.textSecondary,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          attachmentText,
                          style: TextStyle(
                            fontSize: 12,
                            color: isDark
                                ? AppColors.darkTextSecondary
                                : AppColors.textSecondary,
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Text(
                          'Detayı Gör',
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: AppColors.primaryBlue,
                          ),
                        ),
                        const SizedBox(width: 2),
                        const Icon(
                          Icons.chevron_right_rounded,
                          size: 16,
                          color: AppColors.primaryBlue,
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
