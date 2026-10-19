import 'package:flutter/material.dart';
import '../models/diary_entry.dart';
import '../theme/app_colors.dart';
import '../widgets/calendar_grid.dart';
import 'diary_screen.dart';

/// Aylık takvim görünümünü ve seçilen güne göre günlük geçişini sağlayan ana ekran.
class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  late DateTime _currentMonth; // Şu an ekranda gösterilen ay
  late DateTime _selectedDate; // Kullanıcının takvimde tıkladığı gün

  // Tarih anahtarı ('YYYY-MM-DD') -> Günlük kaydı eşleştirmesi
  final Map<String, DiaryEntry> _entries = {};

  static const List<String> _months = [
    'Ocak',
    'Şubat',
    'Mart',
    'Nisan',
    'Mayıs',
    'Haziran',
    'Temmuz',
    'Ağustos',
    'Eylül',
    'Ekim',
    'Kasım',
    'Aralık'
  ];

  @override
  void initState() {
    super.initState();
    final now = DateTime.now();
    _currentMonth = DateTime(now.year, now.month, 1);
    _selectedDate = DateTime(now.year, now.month, now.day);

    // Başlangıçta örnek/sahte veri konulmaz; kullanıcının kaydettiği gerçek kayıtlar tutulur.
  }

  String _dateKey(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

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

  Future<void> _openDiaryScreen(DateTime date) async {
    setState(() {
      _selectedDate = date;
    });

    final key = _dateKey(date);
    final existingEntry = _entries[key];

    // Günlük ekranına geçiş ve dönen kaydı bekleme
    final result = await Navigator.push<DiaryEntry>(
      context,
      MaterialPageRoute(
        builder: (context) => DiaryScreen(
          date: date,
          initialEntry: existingEntry,
        ),
      ),
    );

    // Eğer bir kayıt döndüyse map'e kaydet ve arayüzü güncelle
    if (result != null) {
      setState(() {
        _entries[key] = result;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final monthName = _months[_currentMonth.month - 1];
    final year = _currentMonth.year;
    final selectedKey = _dateKey(_selectedDate);
    final selectedEntry = _entries[selectedKey];

    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        backgroundColor: AppColors.background,
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primaryContainer,
                borderRadius: BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.auto_stories,
                size: 20,
                color: AppColors.onPrimary,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              'Günlüğüm',
              style: TextStyle(
                color: AppColors.onSurface,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Üst Açıklama
              const Text(
                'Sessiz Defter',
                style: TextStyle(
                  color: AppColors.tertiary,
                  fontSize: 15,
                  fontStyle: FontStyle.italic,
                ),
              ),
              const SizedBox(height: 16),

              // Ay Değiştirme ve Başlık Kartı
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                      color: AppColors.outlineVariant.withValues(alpha: 0.8)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.onSurface.withValues(alpha: 0.03),
                      blurRadius: 12,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '$monthName $year',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                        color: AppColors.onSurface,
                      ),
                    ),
                    Row(
                      children: [
                        IconButton(
                          icon: const Icon(Icons.chevron_left),
                          color: AppColors.onSurfaceVariant,
                          tooltip: 'Önceki Ay',
                          onPressed: _previousMonth,
                        ),
                        IconButton(
                          icon: const Icon(Icons.chevron_right),
                          color: AppColors.onSurfaceVariant,
                          tooltip: 'Sonraki Ay',
                          onPressed: _nextMonth,
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 16),

              // Takvim Izgarası
              Container(
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLowest,
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(
                      color: AppColors.outlineVariant.withValues(alpha: 0.8)),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.onSurface.withValues(alpha: 0.04),
                      blurRadius: 16,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                padding: const EdgeInsets.all(16),
                child: CalendarGrid(
                  currentMonth: _currentMonth,
                  selectedDate: _selectedDate,
                  entryDates: _entries.keys.toSet(),
                  onDateSelected: (date) {
                    _openDiaryScreen(date);
                  },
                ),
              ),

              const SizedBox(height: 20),

              // Seçili Güne Ait Bilgi ve Hızlı Giriş Kartı
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: AppColors.surfaceContainerLow,
                  borderRadius: BorderRadius.circular(18),
                  border: Border.all(
                      color: AppColors.outlineVariant.withValues(alpha: 0.7)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          '${_selectedDate.day} ${_months[_selectedDate.month - 1]} ${_selectedDate.year}',
                          style: const TextStyle(
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSurface,
                          ),
                        ),
                        if (selectedEntry != null)
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: AppColors.secondaryContainer,
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                const Icon(Icons.spa,
                                    size: 13,
                                    color: AppColors.onSecondaryContainer),
                                const SizedBox(width: 4),
                                Text(
                                  selectedEntry.mood,
                                  style: const TextStyle(
                                    fontSize: 11,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.onSecondaryContainer,
                                  ),
                                ),
                              ],
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    if (selectedEntry != null) ...[
                      Text(
                        selectedEntry.content,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.onSurfaceVariant,
                          height: 1.5,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ] else ...[
                      const Text(
                        'Bu tarihte henüz bir günlük yazılmamış. Düşüncelerini kaydetmek için tıkla.',
                        style: TextStyle(
                          fontSize: 13,
                          color: AppColors.outline,
                          fontStyle: FontStyle.italic,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    SizedBox(
                      width: double.infinity,
                      child: OutlinedButton.icon(
                        style: OutlinedButton.styleFrom(
                          foregroundColor: AppColors.primary,
                          side: const BorderSide(color: AppColors.primary),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        onPressed: () => _openDiaryScreen(_selectedDate),
                        icon: Icon(
                          selectedEntry != null ? Icons.edit : Icons.create,
                          size: 18,
                        ),
                        label: Text(
                          selectedEntry != null
                              ? 'Günlüğü Düzenle'
                              : 'Bugün İçin Günlük Yaz',
                          style: const TextStyle(fontWeight: FontWeight.w600),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 24),
            ],
          ),
        ),
      ),
    );
  }
}
