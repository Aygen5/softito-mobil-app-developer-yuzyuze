import 'package:flutter/material.dart';
import '../../../models/vehicle.dart';
import '../../../data/reservation_store.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/theme/app_colors.dart';

class AvailabilityCalendar extends StatefulWidget {
  final Vehicle vehicle;
  final DateTime? startDate;
  final DateTime? endDate;
  final Function(DateTime start, DateTime? end) onDateRangeChanged;
  final ValueChanged<String?>? onErrorMessageChanged;

  const AvailabilityCalendar({
    super.key,
    required this.vehicle,
    this.startDate,
    this.endDate,
    required this.onDateRangeChanged,
    this.onErrorMessageChanged,
  });

  @override
  State<AvailabilityCalendar> createState() => _AvailabilityCalendarState();
}

class _AvailabilityCalendarState extends State<AvailabilityCalendar> {
  late DateTime _currentMonth;
  DateTime? _selectedStart;
  DateTime? _selectedEnd;
  String? _validationError;

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _currentMonth = DateTime(now.year, now.month, 1);
    _selectedStart = widget.startDate;
    _selectedEnd = widget.endDate;
  }

  @override
  void didUpdateWidget(covariant AvailabilityCalendar oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.startDate != oldWidget.startDate || widget.endDate != oldWidget.endDate) {
      setState(() {
        _selectedStart = widget.startDate;
        _selectedEnd = widget.endDate;
      });
    }
  }

  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
    });
  }

  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    });
  }

  void _handleDayTap(DateTime day) {
    // 1. Kural: Geçmiş tarihler seçilemez
    if (AppDateUtils.isPastDate(day)) {
      _setError('Geçmiş tarihler için kiralama yapılamaz.');
      return;
    }

    // 2. Kural: Dolu gün seçilemez
    if (reservationStore.isDayUnavailableForVehicle(widget.vehicle, day)) {
      _setError('Bu tarihte araç müsait değildir.');
      return;
    }

    // Seçim mantığı
    if (_selectedStart == null || (_selectedStart != null && _selectedEnd != null)) {
      // Yeni aralık başlangıcı
      setState(() {
        _selectedStart = day;
        _selectedEnd = null;
        _validationError = null;
      });
      widget.onErrorMessageChanged?.call(null);
      widget.onDateRangeChanged(day, null);
    } else {
      // Bitiş tarihi seçiliyor
      if (day.isBefore(_selectedStart!)) {
        // Alış tarihinden önceki bir güne basılırsa yeni alış tarihi yapılır
        setState(() {
          _selectedStart = day;
          _selectedEnd = null;
          _validationError = null;
        });
        widget.onErrorMessageChanged?.call(null);
        widget.onDateRangeChanged(day, null);
      } else if (AppDateUtils.isSameDay(day, _selectedStart!)) {
        // Aynı gün (en az 1 gün kiralama)
        setState(() {
          _selectedEnd = day.add(const Duration(days: 1));
          _validationError = null;
        });
        widget.onErrorMessageChanged?.call(null);
        widget.onDateRangeChanged(_selectedStart!, _selectedEnd);
      } else {
        // Aralık kontrolü: Seçilen aralık içinde dolu gün var mı?
        DateTime current = _selectedStart!.add(const Duration(days: 1));
        bool hasBlockedDay = false;

        while (current.isBefore(day) || AppDateUtils.isSameDay(current, day)) {
          if (reservationStore.isDayUnavailableForVehicle(widget.vehicle, current)) {
            hasBlockedDay = true;
            break;
          }
          current = current.add(const Duration(days: 1));
        }

        if (hasBlockedDay) {
          _setError('Seçtiğiniz tarih aralığında araç müsait değil (Dolu gün içeriyor).');
          return;
        }

        setState(() {
          _selectedEnd = day;
          _validationError = null;
        });
        widget.onErrorMessageChanged?.call(null);
        widget.onDateRangeChanged(_selectedStart!, day);
      }
    }
  }

  void _setError(String message) {
    setState(() {
      _validationError = message;
    });
    widget.onErrorMessageChanged?.call(message);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;
    final isDark = theme.brightness == Brightness.dark;

    final daysInMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
    final firstWeekday = _currentMonth.weekday; // 1: Pzt ... 7: Paz

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: theme.cardTheme.color,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: colorScheme.outline.withOpacity(isDark ? 0.35 : 0.65),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Ay Başlığı & Navigasyon
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${AppDateUtils.formatDayMonth(_currentMonth).split(' ').last} ${_currentMonth.year}',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w800,
                  fontSize: 16,
                ),
              ),
              Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.chevron_left_rounded),
                    visualDensity: VisualDensity.compact,
                    onPressed: _previousMonth,
                  ),
                  IconButton(
                    icon: const Icon(Icons.chevron_right_rounded),
                    visualDensity: VisualDensity.compact,
                    onPressed: _nextMonth,
                  ),
                ],
              ),
            ],
          ),

          const SizedBox(height: 12),

          // Haftanın Günleri Başlıkları
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              _DayHeader('Pzt'),
              _DayHeader('Sal'),
              _DayHeader('Çar'),
              _DayHeader('Per'),
              _DayHeader('Cum'),
              _DayHeader('Cmt'),
              _DayHeader('Paz'),
            ],
          ),

          const SizedBox(height: 8),

          // Takvim Günleri Izgarası
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 42, // 6 hafta x 7 gün
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7,
              crossAxisSpacing: 4,
              mainAxisSpacing: 6,
              childAspectRatio: 1.0,
            ),
            itemBuilder: (context, index) {
              final dayOffset = index - (firstWeekday - 1);
              if (dayOffset < 0 || dayOffset >= daysInMonth) {
                return const SizedBox.shrink();
              }

              final day = DateTime(_currentMonth.year, _currentMonth.month, dayOffset + 1);
              final isPast = AppDateUtils.isPastDate(day);
              final isUnavailable = reservationStore.isDayUnavailableForVehicle(widget.vehicle, day);

              final isStart = _selectedStart != null && AppDateUtils.isSameDay(day, _selectedStart!);
              final isEnd = _selectedEnd != null && AppDateUtils.isSameDay(day, _selectedEnd!);
              final isInRange = _selectedStart != null &&
                  _selectedEnd != null &&
                  day.isAfter(_selectedStart!) &&
                  day.isBefore(_selectedEnd!);

              return GestureDetector(
                onTap: () => _handleDayTap(day),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 150),
                  decoration: BoxDecoration(
                    color: isStart || isEnd
                        ? colorScheme.primary
                        : (isInRange
                            ? colorScheme.primary.withOpacity(isDark ? 0.25 : 0.15)
                            : (isUnavailable
                                ? AppColors.errorRed.withOpacity(isDark ? 0.25 : 0.12)
                                : Colors.transparent)),
                    borderRadius: BorderRadius.circular(isStart || isEnd ? 12 : 8),
                    border: Border.all(
                      color: isStart || isEnd
                          ? colorScheme.primary
                          : (isUnavailable
                              ? AppColors.errorRed.withOpacity(0.6)
                              : Colors.transparent),
                      width: isUnavailable ? 1.5 : 1,
                    ),
                  ),
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${day.day}',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: isStart || isEnd || isUnavailable
                                ? FontWeight.w800
                                : FontWeight.w500,
                            color: isStart || isEnd
                                ? Colors.white
                                : (isUnavailable
                                    ? AppColors.errorRed
                                    : (isPast
                                        ? colorScheme.onSurface.withOpacity(0.3)
                                        : colorScheme.onSurface)),
                          ),
                        ),
                        if (isStart)
                          const Text(
                            'Alış',
                            style: TextStyle(fontSize: 8, color: Colors.white, fontWeight: FontWeight.w700),
                          )
                        else if (isEnd)
                          const Text(
                            'Dönüş',
                            style: TextStyle(fontSize: 8, color: Colors.white, fontWeight: FontWeight.w700),
                          )
                        else if (isUnavailable)
                          const Text(
                            'DOLU',
                            style: TextStyle(fontSize: 7, color: AppColors.errorRed, fontWeight: FontWeight.w800),
                          ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          if (_validationError != null) ...[
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.errorRed.withOpacity(0.12),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: AppColors.errorRed.withOpacity(0.3)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.warning_amber_rounded, size: 16, color: AppColors.errorRed),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      _validationError!,
                      style: const TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.errorRed,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ],

          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 12),

          // Takvim Gösterge Açıklaması (Legend)
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: const [
              _LegendItem(color: Colors.blueAccent, label: 'Seçili'),
              _LegendItem(color: AppColors.errorRed, label: 'Dolu (Rezerve)'),
              _LegendItem(color: Colors.grey, label: 'Geçmiş / Pasif'),
            ],
          ),
        ],
      ),
    );
  }
}

class _DayHeader extends StatelessWidget {
  final String text;
  const _DayHeader(this.text);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      child: Text(
        text,
        textAlign: TextAlign.center,
        style: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w600,
          color: Theme.of(context).colorScheme.onSurfaceVariant,
        ),
      ),
    );
  }
}

class _LegendItem extends StatelessWidget {
  final Color color;
  final String label;

  const _LegendItem({required this.color, required this.label});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 10,
          height: 10,
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        const SizedBox(width: 6),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Theme.of(context).colorScheme.onSurfaceVariant,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
