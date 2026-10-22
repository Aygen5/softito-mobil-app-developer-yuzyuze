import 'package:flutter/material.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';

class HydrationCard extends StatelessWidget {
  final double currentMl;
  final double targetMl;
  final Function(double amount) onAddWater;

  const HydrationCard({
    super.key,
    required this.currentMl,
    required this.targetMl,
    required this.onAddWater,
  });

  void _openHydrationModal(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (ctx) => _HydrationModal(
        currentMl: currentMl,
        targetMl: targetMl,
        onAddWater: onAddWater,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentLitre = (currentMl / 1000)
        .toStringAsFixed(1)
        .replaceAll('.', ',');
    final targetLitre = (targetMl / 1000)
        .toStringAsFixed(1)
        .replaceAll('.', ',');

    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: () => _openHydrationModal(context),
        child: Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer,
            borderRadius: AppRadius.xlRadius,
            border: Border.all(
              color: AppColors.outlineVariant.withValues(alpha: 0.4),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.25),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            children: [
              // Su Damlası İkon Kutusu
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: AppColors.tertiaryContainer.withValues(alpha: 0.3),
                  borderRadius: AppRadius.mdRadius,
                ),
                child: const Icon(
                  Icons.water_drop,
                  color: AppColors.tertiary,
                  size: 24,
                ),
              ),
              const SizedBox(width: 14),

              // Bilgi Metinleri
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Text(
                          'Hidrasyon Günlüğü',
                          style: AppTypography.labelCaps.copyWith(
                            color: AppColors.tertiary,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        const SizedBox(width: 6),
                        const Text(
                          '•',
                          style: TextStyle(
                            color: AppColors.outline,
                            fontSize: 10,
                          ),
                        ),
                        const SizedBox(width: 6),
                        Text(
                          '$currentLitre / $targetLitre Litre',
                          style: AppTypography.caption.copyWith(
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      currentMl >= targetMl
                          ? 'Harika! Günlük su hedefine ulaştın.'
                          : 'Hedefine çok yaklaştın!',
                      style: AppTypography.bodySmall.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                    ),
                    Text(
                      currentMl >= targetMl
                          ? 'Bedenin sana teşekkür ediyor.'
                          : 'Dokun ve su ekleyerek ritmini koru.',
                      style: AppTypography.caption.copyWith(
                        color: AppColors.secondary,
                      ),
                    ),
                  ],
                ),
              ),

              // Su Ekle Butonu
              IconButton(
                onPressed: () => _openHydrationModal(context),
                icon: const Icon(
                  Icons.add_circle,
                  color: AppColors.tertiary,
                  size: 30,
                ),
                tooltip: 'Su Ekle',
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _HydrationModal extends StatefulWidget {
  final double currentMl;
  final double targetMl;
  final Function(double amount) onAddWater;

  const _HydrationModal({
    required this.currentMl,
    required this.targetMl,
    required this.onAddWater,
  });

  @override
  State<_HydrationModal> createState() => _HydrationModalState();
}

class _HydrationModalState extends State<_HydrationModal> {
  double _selectedAmount = 250;

  @override
  Widget build(BuildContext context) {
    final currentLitre = (widget.currentMl / 1000).toStringAsFixed(1);
    final targetLitre = (widget.targetMl / 1000).toStringAsFixed(1);
    final ratio = (widget.currentMl / widget.targetMl).clamp(0.0, 1.0);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: AppRadius.sheetRadius,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.6),
            blurRadius: 24,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Tutamaç
            Center(
              child: Container(
                width: 40,
                height: 4,
                margin: const EdgeInsets.only(bottom: 16),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerHighest,
                  borderRadius: AppRadius.fullRadius,
                ),
              ),
            ),

            // Başlık
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Container(
                      width: 36,
                      height: 36,
                      decoration: BoxDecoration(
                        color: AppColors.tertiaryContainer.withValues(alpha: 0.3),
                        borderRadius: AppRadius.mdRadius,
                      ),
                      child: const Icon(
                        Icons.water_drop,
                        color: AppColors.tertiary,
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Su Tüketimi Ekle', style: AppTypography.headlineSmall),
                        Text(
                          '$currentLitre L / $targetLitre L (%${(ratio * 100).round()})',
                          style: AppTypography.caption,
                        ),
                      ],
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, size: 20),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.surfaceContainerHigh,
                  ),
                ),
              ],
            ),

            const SizedBox(height: 18),

            // İlerleme Çubuğu
            ClipRRect(
              borderRadius: AppRadius.fullRadius,
              child: Container(
                height: 8,
                color: AppColors.surfaceContainerLowest,
                child: FractionallySizedBox(
                  alignment: Alignment.centerLeft,
                  widthFactor: ratio,
                  child: Container(color: AppColors.tertiary),
                ),
              ),
            ),

            const SizedBox(height: 20),

            Text('HIZLI SEÇENEKLER', style: AppTypography.labelCaps),
            const SizedBox(height: 10),

            // 4 Hızlı Ekleme Butonu
            Row(
              children: [
                _buildQuickBtn(200, '200 ml', 'Küçük', Icons.local_cafe),
                const SizedBox(width: 8),
                _buildQuickBtn(250, '250 ml', 'Bardak', Icons.local_drink),
                const SizedBox(width: 8),
                _buildQuickBtn(500, '500 ml', 'Şişe', Icons.sports_bar),
                const SizedBox(width: 8),
                _buildQuickBtn(1000, '1000 ml', 'Matara', Icons.water),
              ],
            ),

            const SizedBox(height: 20),

            // Seçilen Miktar Özeti
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: AppRadius.lgRadius,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.opacity, color: AppColors.tertiary, size: 20),
                      const SizedBox(width: 8),
                      Text('Eklenecek Miktar:', style: AppTypography.bodyMedium),
                    ],
                  ),
                  Text(
                    '+${_selectedAmount.toInt()} ml',
                    style: AppTypography.labelNumeric.copyWith(
                      color: AppColors.tertiary,
                      fontSize: 18,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 20),

            // Onay Butonu
            AppButton(
              label: '+${_selectedAmount.toInt()} ml Kaydet',
              icon: Icons.check,
              type: AppButtonType.primary,
              onPressed: () {
                widget.onAddWater(_selectedAmount);
                Navigator.of(context).pop();
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('+${_selectedAmount.toInt()} ml su başarıyla eklendi!'),
                    backgroundColor: AppColors.tertiaryContainer,
                    duration: const Duration(seconds: 2),
                  ),
                );
              },
            ),
            const SizedBox(height: 8),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickBtn(double amount, String title, String subtitle, IconData icon) {
    final isSelected = _selectedAmount == amount;

    return Expanded(
      child: GestureDetector(
        onTap: () => setState(() => _selectedAmount = amount),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(vertical: 12),
          decoration: BoxDecoration(
            color: isSelected ? AppColors.primaryContainer : AppColors.surfaceContainer,
            borderRadius: AppRadius.lgRadius,
            border: Border.all(
              color: isSelected
                  ? AppColors.tertiary
                  : AppColors.outlineVariant.withValues(alpha: 0.3),
              width: isSelected ? 1.5 : 1,
            ),
          ),
          child: Column(
            children: [
              Icon(
                icon,
                color: isSelected ? AppColors.onPrimaryContainer : AppColors.outline,
                size: 20,
              ),
              const SizedBox(height: 4),
              Text(
                title,
                style: AppTypography.caption.copyWith(
                  fontWeight: FontWeight.bold,
                  color: isSelected ? AppColors.onPrimaryContainer : AppColors.onSurface,
                ),
              ),
              Text(
                subtitle,
                style: AppTypography.caption.copyWith(
                  fontSize: 9,
                  color: isSelected ? AppColors.onPrimaryContainer : AppColors.outline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
