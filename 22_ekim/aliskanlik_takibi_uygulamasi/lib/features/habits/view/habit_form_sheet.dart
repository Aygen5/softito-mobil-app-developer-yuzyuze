import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_radius.dart';
import '../../../core/theme/app_spacing.dart';
import '../../../core/theme/app_typography.dart';
import '../../../core/widgets/app_button.dart';
import '../../../models/habit.dart';
import '../../../models/habit_category.dart';
import '../cubit/habits_cubit.dart';

class HabitFormSheet extends StatefulWidget {
  final Habit? habitToEdit;

  const HabitFormSheet({super.key, this.habitToEdit});

  @override
  State<HabitFormSheet> createState() => _HabitFormSheetState();
}

class _HabitFormSheetState extends State<HabitFormSheet> {
  late final TextEditingController _titleController;
  late HabitCategory _selectedCategory;
  late int _selectedIconCode;
  late int _selectedColorValue;
  late double _targetValue;
  late String _targetUnit;
  late Set<int> _selectedDays;
  late bool _reminderEnabled;
  late String _reminderTime;

  static const List<IconData> iconPalette = [
    Icons.menu_book,
    Icons.water_drop,
    Icons.directions_walk,
    Icons.fitness_center,
    Icons.eco,
    Icons.bedtime,
    Icons.favorite,
    Icons.self_improvement,
    Icons.restaurant,
    Icons.track_changes,
    Icons.auto_awesome,
    Icons.star,
  ];

  static final List<Color> colorPalette = [
    AppColors.secondaryContainer,
    AppColors.primary,
    AppColors.tertiaryContainer,
    AppColors.primaryFixedDim,
    AppColors.lavenderAccent,
    AppColors.warning,
    AppColors.surfaceBright,
  ];

  static const List<String> units = [
    'Dakika',
    'Sayfa',
    'Adım',
    'ml',
    'Litre',
    'Kez',
    'Gün',
    'Hafta',
  ];

  List<String> get _availableUnits {
    if (!units.contains(_targetUnit)) {
      return [...units, _targetUnit];
    }
    return units;
  }

  @override
  void initState() {
    super.initState();
    final h = widget.habitToEdit;
    _titleController = TextEditingController(text: h?.title ?? 'Kitap Okuma');
    _selectedCategory = h?.category ?? HabitCategory.personalDevelopment;
    _selectedIconCode = h?.iconCodePoint ?? Icons.menu_book.codePoint;
    _selectedColorValue = h?.colorValue ?? AppColors.primary.toARGB32();
    _targetValue = h?.targetValue ?? 20;
    _targetUnit = h?.targetUnit ?? 'Dakika';
    _selectedDays = h != null
        ? Set<int>.from(h.scheduledDays)
        : {1, 2, 3, 4, 5, 6, 7};
    _reminderEnabled = h?.reminderEnabled ?? true;
    _reminderTime = h?.reminderTime ?? '09:00';
  }

  @override
  void dispose() {
    _titleController.dispose();
    super.dispose();
  }

  void _save() {
    final title = _titleController.text.trim();
    if (title.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen alışkanlık adı girin.'),
          backgroundColor: AppColors.errorContainer,
        ),
      );
      return;
    }

    if (_selectedDays.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Lütfen en az bir tekrarlama günü seçin.'),
          backgroundColor: AppColors.errorContainer,
        ),
      );
      return;
    }

    final cubit = context.read<HabitsCubit>();

    if (widget.habitToEdit != null) {
      final updated = widget.habitToEdit!.copyWith(
        title: title,
        category: _selectedCategory,
        iconCodePoint: _selectedIconCode,
        colorValue: _selectedColorValue,
        targetValue: _targetValue,
        targetUnit: _targetUnit,
        scheduledDays: _selectedDays,
        reminderEnabled: _reminderEnabled,
        reminderTime: _reminderTime,
      );
      cubit.updateHabit(updated);
    } else {
      final newHabit = Habit(
        id: 'habit_${DateTime.now().millisecondsSinceEpoch}',
        title: title,
        category: _selectedCategory,
        iconCodePoint: _selectedIconCode,
        colorValue: _selectedColorValue,
        targetValue: _targetValue,
        targetUnit: _targetUnit,
        scheduledDays: _selectedDays,
        reminderEnabled: _reminderEnabled,
        reminderTime: _reminderTime,
        createdAt: DateTime.now(),
      );
      cubit.addHabit(newHabit);
    }

    Navigator.of(context).pop();
  }

  void _confirmDelete() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.surfaceContainer,
        title: Text('Alışkanlığı Sil', style: AppTypography.headlineSmall),
        content: Text(
          'Bu alışkanlığı silmek istediğinize emin misiniz? Bu işlem geri alınamaz.',
          style: AppTypography.bodyMedium,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(
              'Vazgeç',
              style: AppTypography.bodyMedium.copyWith(
                color: AppColors.outline,
              ),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.errorContainer,
            ),
            onPressed: () {
              Navigator.of(ctx).pop();
              context.read<HabitsCubit>().deleteHabit(widget.habitToEdit!.id);
              Navigator.of(context).pop();
            },
            child: const Text('Sil', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height * 0.9,
      decoration: BoxDecoration(
        color: AppColors.surfaceContainerLow,
        borderRadius: AppRadius.sheetRadius,
        boxShadow: [
          BoxShadow(color: Colors.black.withValues(alpha: 0.5), blurRadius: 24),
        ],
      ),
      child: Column(
        children: [
          // Tutamaç (Drag Handle)
          Container(
            margin: const EdgeInsets.only(top: 10, bottom: 6),
            width: 44,
            height: 5,
            decoration: BoxDecoration(
              color: AppColors.surfaceContainerHighest,
              borderRadius: AppRadius.fullRadius,
            ),
          ),

          // Başlık Satırı
          Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.margin,
              vertical: 8,
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      widget.habitToEdit != null
                          ? 'Alışkanlığı Düzenle'
                          : 'Yeni Alışkanlık Oluştur',
                      style: AppTypography.headlineMedium.copyWith(
                        fontSize: 20,
                      ),
                    ),
                    Text(
                      'Küçük bir adımla başla, kök salarak büyü.',
                      style: AppTypography.bodySmall,
                    ),
                  ],
                ),
                IconButton(
                  onPressed: () => Navigator.of(context).pop(),
                  icon: const Icon(Icons.close, size: 22),
                  style: IconButton.styleFrom(
                    backgroundColor: AppColors.surfaceContainer,
                  ),
                ),
              ],
            ),
          ),

          const Divider(color: AppColors.outlineVariant, height: 1),

          // Kaydırılabilir Form Alanı
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(AppSpacing.margin),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 1. Alışkanlığın Adı
                  Text('ALIŞKANLIĞIN ADI', style: AppTypography.labelCaps),
                  const SizedBox(height: 6),
                  Container(
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainer,
                      borderRadius: AppRadius.lgRadius,
                    ),
                    child: TextField(
                      controller: _titleController,
                      style: AppTypography.bodyMedium,
                      decoration: InputDecoration(
                        hintText: 'Örn: Kitap okuma, Meditasyon, Yürüyüş...',
                        hintStyle: AppTypography.bodyMedium.copyWith(
                          color: AppColors.outlineVariant,
                        ),
                        suffixIcon: const Icon(
                          Icons.spa,
                          color: AppColors.tertiary,
                          size: 20,
                        ),
                        border: InputBorder.none,
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 16,
                          vertical: 14,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 2. Kategori Seçimi
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('KATEGORİ SEÇİMİ', style: AppTypography.labelCaps),
                      Text(
                        'Özenle seçilmiş alanlar',
                        style: AppTypography.caption,
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: Row(
                      children: HabitCategory.values.map((cat) {
                        final isSel = cat == _selectedCategory;
                        return Padding(
                          padding: const EdgeInsets.only(right: 8),
                          child: ChoiceChip(
                            label: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  cat.icon,
                                  size: 16,
                                  color: isSel
                                      ? AppColors.onPrimaryContainer
                                      : AppColors.onSurfaceVariant,
                                ),
                                const SizedBox(width: 6),
                                Text(cat.displayName),
                              ],
                            ),
                            selected: isSel,
                            selectedColor: AppColors.primaryContainer,
                            backgroundColor: AppColors.surfaceContainer,
                            labelStyle: AppTypography.caption.copyWith(
                              color: isSel
                                  ? AppColors.onPrimaryContainer
                                  : AppColors.onSurfaceVariant,
                              fontWeight: isSel
                                  ? FontWeight.bold
                                  : FontWeight.normal,
                            ),
                            shape: RoundedRectangleBorder(
                              borderRadius: AppRadius.fullRadius,
                            ),
                            onSelected: (val) {
                              if (val) setState(() => _selectedCategory = cat);
                            },
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 3. İkon Seçimi
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('İKON SEÇİMİ', style: AppTypography.labelCaps),
                      Text('Görsel sembol', style: AppTypography.caption),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainer,
                      borderRadius: AppRadius.xlRadius,
                    ),
                    child: GridView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 6,
                            crossAxisSpacing: 10,
                            mainAxisSpacing: 10,
                          ),
                      itemCount: iconPalette.length,
                      itemBuilder: (context, index) {
                        final icon = iconPalette[index];
                        final isSel = icon.codePoint == _selectedIconCode;

                        return GestureDetector(
                          onTap: () => setState(
                            () => _selectedIconCode = icon.codePoint,
                          ),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            decoration: BoxDecoration(
                              color: isSel
                                  ? AppColors.primary
                                  : AppColors.surfaceContainerHigh,
                              borderRadius: AppRadius.mdRadius,
                              boxShadow: isSel
                                  ? [
                                      BoxShadow(
                                        color: AppColors.primary.withValues(
                                          alpha: 0.4,
                                        ),
                                        blurRadius: 8,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: Icon(
                              icon,
                              color: isSel
                                  ? AppColors.onPrimary
                                  : AppColors.onSurfaceVariant,
                              size: 22,
                            ),
                          ),
                        );
                      },
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 4. Renk Paleti
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('RENK PALETİ', style: AppTypography.labelCaps),
                      Text('Aura tonu', style: AppTypography.caption),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 12,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainer,
                      borderRadius: AppRadius.xlRadius,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: colorPalette.map((col) {
                        final isSel = col.toARGB32() == _selectedColorValue;
                        return GestureDetector(
                          onTap: () => setState(
                            () => _selectedColorValue = col.toARGB32(),
                          ),
                          child: AnimatedContainer(
                            duration: const Duration(milliseconds: 150),
                            width: isSel ? 36 : 30,
                            height: isSel ? 36 : 30,
                            decoration: BoxDecoration(
                              color: col,
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: isSel
                                    ? Colors.white
                                    : Colors.transparent,
                                width: 2,
                              ),
                              boxShadow: isSel
                                  ? [
                                      BoxShadow(
                                        color: col.withValues(alpha: 0.5),
                                        blurRadius: 10,
                                      ),
                                    ]
                                  : null,
                            ),
                            child: isSel
                                ? const Icon(
                                    Icons.check,
                                    size: 18,
                                    color: Colors.white,
                                  )
                                : null,
                          ),
                        );
                      }).toList(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // 5. Günlük Hedef & Birim
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text('GÜNLÜK HEDEF', style: AppTypography.labelCaps),
                      Text('Miktar ve birim', style: AppTypography.caption),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      // Sayısal Sayaç (- / +)
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainer,
                            borderRadius: AppRadius.lgRadius,
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              IconButton(
                                onPressed: _targetValue > 1
                                    ? () => setState(() => _targetValue -= 1)
                                    : null,
                                icon: const Icon(Icons.remove, size: 20),
                                style: IconButton.styleFrom(
                                  backgroundColor:
                                      AppColors.surfaceContainerHigh,
                                ),
                              ),
                              Text(
                                '${_targetValue.toInt()}',
                                style: AppTypography.labelNumeric.copyWith(
                                  fontSize: 18,
                                ),
                              ),
                              IconButton(
                                onPressed: () =>
                                    setState(() => _targetValue += 1),
                                icon: const Icon(Icons.add, size: 20),
                                style: IconButton.styleFrom(
                                  backgroundColor:
                                      AppColors.surfaceContainerHigh,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      // Birim Dropdown
                      Expanded(
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 14,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainer,
                            borderRadius: AppRadius.lgRadius,
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              value: _availableUnits.contains(_targetUnit)
                                  ? _targetUnit
                                  : _availableUnits.first,
                              dropdownColor: AppColors.surfaceContainerHigh,
                              icon: const Icon(
                                Icons.keyboard_arrow_down,
                                color: AppColors.outline,
                              ),
                              items: _availableUnits.map((u) {
                                return DropdownMenuItem<String>(
                                  value: u,
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.schedule,
                                        size: 18,
                                        color: AppColors.primary,
                                      ),
                                      const SizedBox(width: 8),
                                      Text(u, style: AppTypography.bodyMedium),
                                    ],
                                  ),
                                );
                              }).toList(),
                              onChanged: (val) {
                                if (val != null) {
                                  setState(() => _targetUnit = val);
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 20),

                  // 6. Tekrarlanacak Günler
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'TEKRARLANACAK GÜNLER',
                        style: AppTypography.labelCaps,
                      ),
                      GestureDetector(
                        onTap: () {
                          setState(() {
                            if (_selectedDays.length == 7) {
                              _selectedDays.clear();
                            } else {
                              _selectedDays = {1, 2, 3, 4, 5, 6, 7};
                            }
                          });
                        },
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.secondaryContainer,
                            borderRadius: AppRadius.fullRadius,
                          ),
                          child: Row(
                            children: [
                              const Icon(
                                Icons.done_all,
                                size: 14,
                                color: AppColors.onSecondaryContainer,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                'Her gün',
                                style: AppTypography.caption.copyWith(
                                  color: AppColors.onSecondaryContainer,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: List.generate(7, (idx) {
                      final dayNum = idx + 1;
                      final isSel = _selectedDays.contains(dayNum);
                      const dayLabels = [
                        'Pzt',
                        'Sal',
                        'Çar',
                        'Per',
                        'Cum',
                        'Cmt',
                        'Paz',
                      ];

                      return GestureDetector(
                        onTap: () {
                          setState(() {
                            if (isSel) {
                              _selectedDays.remove(dayNum);
                            } else {
                              _selectedDays.add(dayNum);
                            }
                          });
                        },
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 150),
                          width:
                              (MediaQuery.of(context).size.width - 40 - 36) / 7,
                          height: 50,
                          decoration: BoxDecoration(
                            color: isSel
                                ? AppColors.primary
                                : AppColors.surfaceContainer,
                            borderRadius: AppRadius.mdRadius,
                            boxShadow: isSel
                                ? [
                                    BoxShadow(
                                      color: AppColors.primary.withValues(
                                        alpha: 0.3,
                                      ),
                                      blurRadius: 6,
                                    ),
                                  ]
                                : null,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                dayLabels[idx],
                                style: AppTypography.labelCaps.copyWith(
                                  fontSize: 10,
                                  color: isSel
                                      ? AppColors.onPrimary
                                      : AppColors.outline,
                                ),
                              ),
                              Text(
                                '$dayNum',
                                style: AppTypography.caption.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: isSel
                                      ? AppColors.onPrimary
                                      : AppColors.onSurface,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }),
                  ),

                  const SizedBox(height: 20),

                  // 7. Hatırlatıcı Bildirim
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainer,
                      borderRadius: AppRadius.xlRadius,
                    ),
                    child: Column(
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 36,
                              height: 36,
                              decoration: BoxDecoration(
                                color: AppColors.surfaceContainerHigh,
                                borderRadius: AppRadius.mdRadius,
                              ),
                              child: const Icon(
                                Icons.notifications_active,
                                color: AppColors.primary,
                                size: 20,
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Hatırlatıcı Bildirim',
                                    style: AppTypography.bodyMedium.copyWith(
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                  Text(
                                    'Günün ritmine göre nazik bir uyarı',
                                    style: AppTypography.caption,
                                  ),
                                ],
                              ),
                            ),
                            Switch(
                              value: _reminderEnabled,
                              activeThumbColor: AppColors.tertiary,
                              onChanged: (val) =>
                                  setState(() => _reminderEnabled = val),
                            ),
                          ],
                        ),
                        if (_reminderEnabled) ...[
                          const SizedBox(height: 12),
                          const Divider(
                            color: AppColors.outlineVariant,
                            height: 1,
                          ),
                          const SizedBox(height: 12),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Text(
                                'Bildirim Saati',
                                style: AppTypography.bodySmall,
                              ),
                              GestureDetector(
                                onTap: () async {
                                  final parts = _reminderTime.split(':');
                                  final initialTime = TimeOfDay(
                                    hour: int.tryParse(parts[0]) ?? 9,
                                    minute: int.tryParse(parts[1]) ?? 0,
                                  );
                                  final picked = await showTimePicker(
                                    context: context,
                                    initialTime: initialTime,
                                  );
                                  if (picked != null) {
                                    final h = picked.hour.toString().padLeft(
                                      2,
                                      '0',
                                    );
                                    final m = picked.minute.toString().padLeft(
                                      2,
                                      '0',
                                    );
                                    setState(() => _reminderTime = '$h:$m');
                                  }
                                },
                                child: Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 14,
                                    vertical: 6,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.surfaceContainerHigh,
                                    borderRadius: AppRadius.mdRadius,
                                  ),
                                  child: Row(
                                    children: [
                                      const Icon(
                                        Icons.access_time,
                                        size: 16,
                                        color: AppColors.primary,
                                      ),
                                      const SizedBox(width: 6),
                                      Text(
                                        _reminderTime,
                                        style: AppTypography.labelNumeric
                                            .copyWith(fontSize: 14),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ],
                      ],
                    ),
                  ),

                  const SizedBox(height: 32),

                  // Kaydet / Başlat Butonu
                  AppButton(
                    label: widget.habitToEdit != null
                        ? 'Değişiklikleri Kaydet'
                        : 'Alışkanlığı Başlat',
                    icon: Icons.eco,
                    type: AppButtonType.primary,
                    onPressed: _save,
                  ),

                  if (widget.habitToEdit != null) ...[
                    const SizedBox(height: 12),
                    AppButton(
                      label: 'Alışkanlığı Sil',
                      icon: Icons.delete_outline,
                      type: AppButtonType.outline,
                      onPressed: _confirmDelete,
                    ),
                  ],

                  const SizedBox(height: 24),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
