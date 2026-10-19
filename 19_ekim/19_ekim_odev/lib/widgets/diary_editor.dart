import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Günlük metninin girildiği kağıt zeminli alan ve Günün Hissi seçici bileşeni.
class DiaryEditor extends StatelessWidget {
  final TextEditingController controller;   // Yazı kutusundaki metni kontrol eder ve taşır
  final String selectedMood;
  final ValueChanged<String> onMoodChanged;  // Ruh hali değiştiğinde ana ekrana haber veren fonksiyon
  final VoidCallback onSave;  // Kaydet butonuna basıldığında tetiklenecek fonksiyon
  final bool isSaving;

  const DiaryEditor({
    super.key,
    required this.controller,
    required this.selectedMood,
    required this.onMoodChanged,
    required this.onSave,
    this.isSaving = false,
  });

  static const List<Map<String, dynamic>> _moods = [
    {'name': 'Huzurlu', 'icon': Icons.spa},
    {'name': 'Dalgın', 'icon': Icons.psychology_alt},
    {'name': 'Neşeli', 'icon': Icons.sentiment_satisfied},
    {'name': 'Yorgun', 'icon': Icons.bedtime},
    {'name': 'İlhamlı', 'icon': Icons.auto_awesome},
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Kağıt Hissiyatlı Yazma Kartı
        Container(
          width: double.infinity,
          decoration: BoxDecoration(
            color: AppColors.surfaceContainerLowest,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: AppColors.outlineVariant.withValues(alpha: 0.8)),
            boxShadow: [
              BoxShadow(
                color: AppColors.onSurface.withValues(alpha: 0.04),
                blurRadius: 16,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: const EdgeInsets.all(18),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Metin Girişi
              TextField(
                controller: controller,
                maxLines: null,
                minLines: 8,
                keyboardType: TextInputType.multiline,
                style: const TextStyle(
                  color: AppColors.onSurface,
                  fontSize: 16,
                  height: 1.6,
                ),
                decoration: const InputDecoration(
                  hintText:
                      'Aklından geçenleri, yaşadıklarını veya hatırlamak istediklerini buraya fısılda...',
                  hintStyle: TextStyle(
                    color: AppColors.outline,
                    fontSize: 15,
                    height: 1.5,
                  ),
                  border: InputBorder.none,
                  contentPadding: EdgeInsets.zero,
                ),
              ),

              const SizedBox(height: 12),
              const Divider(color: AppColors.outlineVariant, thickness: 0.8),
              const SizedBox(height: 8),

              // İpucu Bilgisi / Karakter sayısı
              ValueListenableBuilder<TextEditingValue>(
                valueListenable: controller,
                builder: (context, value, _) {
                  final wordCount = value.text.trim().isEmpty
                      ? 0
                      : value.text.trim().split(RegExp(r'\s+')).length;
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.edit_note,
                              size: 16, color: AppColors.outline),
                          SizedBox(width: 4),
                          Text(
                            'Kişisel Defter',
                            style: TextStyle(
                              color: AppColors.outline,
                              fontSize: 12,
                            ),
                          ),
                        ],
                      ),
                      Text(
                        '$wordCount kelime',
                        style: const TextStyle(
                          color: AppColors.outline,
                          fontSize: 12,
                        ),
                      ),
                    ],
                  );
                },
              ),
            ],
          ),
        ),

        const SizedBox(height: 24),

        // Günün Hissi Başlığı
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            const Text(
              'Günün Hissi',
              style: TextStyle(
                color: AppColors.onSurfaceVariant,
                fontSize: 14,
                fontWeight: FontWeight.w600,
              ),
            ),
            Text(
              selectedMood,
              style: const TextStyle(
                color: AppColors.primary,
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),

        const SizedBox(height: 10),

        // Günün Hissi Seçici Butonları
        Row(
          children: _moods.map((mood) {
            final isSelected = mood['name'] == selectedMood;
            return Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 3.0),
                child: InkWell(
                  borderRadius: BorderRadius.circular(12),
                  onTap: () => onMoodChanged(mood['name'] as String),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 180),
                    padding: const EdgeInsets.symmetric(vertical: 10),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.secondaryContainer
                          : AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(12),
                      border: Border.all(
                        color: isSelected
                            ? AppColors.primary.withValues(alpha: 0.5)
                            : Colors.transparent,
                      ),
                    ),
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          mood['icon'] as IconData,
                          size: 20,
                          color: isSelected
                              ? AppColors.onSecondaryContainer
                              : AppColors.onSurfaceVariant,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          mood['name'] as String,
                          style: TextStyle(
                            fontSize: 11,
                            fontWeight: isSelected
                                ? FontWeight.w600
                                : FontWeight.normal,
                            color: isSelected
                                ? AppColors.onSecondaryContainer
                                : AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            );
          }).toList(),
        ),

        const SizedBox(height: 28),

        // Kaydet Butonu
        SizedBox(
          width: double.infinity,
          height: 52,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              foregroundColor: AppColors.onPrimary,
              elevation: 0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(14),
              ),
            ),
            onPressed: isSaving ? null : onSave,
            icon: isSaving
                ? const SizedBox(
                    width: 18,
                    height: 18,
                    child: CircularProgressIndicator(
                      strokeWidth: 2,
                      valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                    ),
                  )
                : const Icon(Icons.check, size: 20),
            label: Text(
              isSaving ? 'Kaydediliyor...' : 'Kaydet ve Mühürle',
              style: const TextStyle(
                fontSize: 15,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
