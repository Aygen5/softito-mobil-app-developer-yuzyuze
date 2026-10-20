import 'package:flutter/material.dart';

import '../../../core/constants/app_strings.dart';
import '../../../core/extensions/context_extensions.dart';
import '../../auth/controller/permission_service.dart';
import '../../auth/models/user_role.dart';
import '../controller/analiz_controller.dart';
import '../models/analiz_model.dart';

class AnalizAdimOzet extends StatelessWidget {
  final AnalizController controller;
  final AnalizFormModel form;
  final VoidCallback onGonderildi;
  final UserRole? userRole;

  const AnalizAdimOzet({
    super.key,
    required this.controller,
    required this.form,
    required this.onGonderildi,
    this.userRole,
  });

  @override
  Widget build(BuildContext context) {
    final colors = context.spaceColors;
    final textTheme = context.textTheme;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: colors.ascensionLime.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: colors.ascensionLime.withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              children: [
                Icon(
                  Icons.verified_rounded,
                  color: colors.ascensionLime,
                  size: 28,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    'İş planınızın tüm bölümleri hazırlandı. Gönderim sonrası Yörünge uzman ekibi başvurunuzu inceleyecek ve onaylanan fikirler için ücretsiz avukat ataması yapılacaktır.',
                    style: TextStyle(color: colors.textPrimary, fontSize: 13),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          _buildSummaryCard(
            '1. Fikir',
            '${form.fikirAdi.isEmpty ? "(Belirtilmedi)" : form.fikirAdi} • Sektör: ${form.sektor}',
            colors,
            textTheme,
          ),
          _buildSummaryCard(
            '2. Ekip',
            '${form.ekipUyeleri.length} Çekirdek Kadro Üyesi',
            colors,
            textTheme,
          ),
          _buildSummaryCard(
            '3. Traction & Hedef',
            'Hedefe Yakınlık: %${(form.hedefeYakinlikYuzdesi * 100).toInt()} • Ciro: ${form.ciro}',
            colors,
            textTheme,
          ),
          _buildSummaryCard(
            '4. İnovasyon & TRL',
            'TRL Olgunluk: %${(form.yeterlilikOrani * 100).toInt()}',
            colors,
            textTheme,
          ),
          _buildSummaryCard(
            '5. Plan & Zaman',
            '${form.gorevler.length} Gantt Görevi Planlandı',
            colors,
            textTheme,
          ),
          _buildSummaryCard(
            '6. Pazar',
            form.pazarBuyuklugu.isEmpty
                ? 'Pazar analizi girildi'
                : form.pazarBuyuklugu,
            colors,
            textTheme,
          ),
          _buildSummaryCard(
            '7. Marka',
            form.markaIsmi.isEmpty ? 'Marka stratejisi hazır' : form.markaIsmi,
            colors,
            textTheme,
          ),
          const SizedBox(height: 20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: ElevatedButton.icon(
              onPressed: () async {
                if (userRole != null &&
                    !PermissionService.canCreateBusinessPlan(userRole!)) {
                  final colors = context.spaceColors;
                  ScaffoldMessenger.of(context).hideCurrentSnackBar();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Row(
                        children: [
                          const Icon(Icons.lock_outline_rounded,
                              color: Colors.white, size: 20),
                          const SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              PermissionService.getDenialReason(
                                  'create_business_plan'),
                              style:
                                  const TextStyle(fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      backgroundColor: colors.errorRed,
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                      duration: const Duration(seconds: 3),
                    ),
                  );
                  return;
                }

                final success =
                    await controller.basvuruGonder(currentRole: userRole);
                if (success) {
                  onGonderildi();
                }
              },
              icon: const Icon(Icons.rocket_launch_rounded),
              label: const Text(AppStrings.tamamla),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(
    String title,
    String content,
    dynamic colors,
    TextTheme textTheme,
  ) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: colors.surfaceSubtle,
        borderRadius: BorderRadius.circular(10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 12,
              color: colors.nebulaCyan,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            content,
            style: TextStyle(fontSize: 13, color: colors.textPrimary),
          ),
        ],
      ),
    );
  }
}
