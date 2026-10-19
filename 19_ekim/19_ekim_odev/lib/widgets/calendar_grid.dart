import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Takvimin günlerini ve haftanın gün başlıklarını gösteren ızgara bileşeni.
class CalendarGrid extends StatelessWidget {
  final DateTime currentMonth;
  final DateTime selectedDate;
  final Set<String> entryDates; // 'YYYY-MM-DD' formatında günlük yazılmış tarihler
  final ValueChanged<DateTime> onDateSelected;

  const CalendarGrid({
    super.key,
    required this.currentMonth,
    required this.selectedDate,
    required this.entryDates,
    required this.onDateSelected,
  });

  static const List<String> _weekdays = [
    'Pzt',
    'Sal',
    'Çar',
    'Per',
    'Cum',
    'Cmt',
    'Paz',
  ];

  String _dateKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context) {
    // Ayın ilk gününün haftanın hangi gününe denk geldiği (1 = Pazartesi ... 7 = Pazar)
    final firstDayOfMonth = DateTime(currentMonth.year, currentMonth.month, 1);
    final daysInMonth =
        DateTime(currentMonth.year, currentMonth.month + 1, 0).day;

    // Pazartesi = 1, bu yüzden ilk günden önceki boşluk sayısı = weekday - 1
    final leadingEmptyCount = firstDayOfMonth.weekday - 1;
    final totalCells = leadingEmptyCount + daysInMonth;

    return Column(
      children: [
        // Hafta başlıkları (Pzt, Sal, Çar...)
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 8.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: _weekdays.map((day) {
              return Expanded(
                child: Center(
                  child: Text(
                    day,
                    style: const TextStyle(
                      color: AppColors.outline,
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),

        // Gün hücreleri
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: totalCells,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 7,
            mainAxisSpacing: 6,
            crossAxisSpacing: 6,
            childAspectRatio: 1.0,
          ),
          itemBuilder: (context, index) {
            if (index < leadingEmptyCount) {
              return const SizedBox.shrink();
            }

            final dayNumber = index - leadingEmptyCount + 1;
            final cellDate =
                DateTime(currentMonth.year, currentMonth.month, dayNumber);
            final isSelected = _isSameDay(cellDate, selectedDate);
            final hasEntry = entryDates.contains(_dateKey(cellDate));
            final isToday = _isSameDay(cellDate, DateTime.now());

            return InkWell(
              borderRadius: BorderRadius.circular(12),
              onTap: () => onDateSelected(cellDate),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 200),
                decoration: BoxDecoration(
                  color: isSelected
                      ? AppColors.primary
                      : (isToday
                          ? AppColors.secondaryContainer.withValues(alpha: 0.5)
                          : AppColors.surfaceContainerLowest),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: isSelected
                        ? AppColors.primary
                        : (isToday
                            ? AppColors.primary.withValues(alpha: 0.4)
                            : AppColors.outlineVariant.withValues(alpha: 0.6)),
                    width: isSelected || isToday ? 1.5 : 1,
                  ),
                  boxShadow: isSelected
                      ? [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.2),
                            blurRadius: 8,
                            offset: const Offset(0, 3),
                          )
                        ]
                      : null,
                ),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      '$dayNumber',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: isSelected || isToday
                            ? FontWeight.bold
                            : FontWeight.w500,
                        color: isSelected
                            ? AppColors.onPrimary
                            : AppColors.onSurface,
                      ),
                    ),
                    const SizedBox(height: 3),
                    // Günlük yazılmışsa gösterilen minik belirteç noktası
                    Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: hasEntry
                            ? (isSelected
                                ? AppColors.onPrimary
                                : AppColors.primary)
                            : Colors.transparent,
                      ),
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ],
    );
  }
}
