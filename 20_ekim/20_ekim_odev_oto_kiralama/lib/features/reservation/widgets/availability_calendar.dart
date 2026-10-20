import 'package:flutter/material.dart';
import '../../../models/vehicle.dart';
import '../../../data/reservation_store.dart';
import '../../../core/utils/date_utils.dart';
import '../../../core/theme/app_colors.dart';

/// ============================================================================
/// AVAILABILITY CALENDAR (ARAÇ MÜSAİTLİK VE TARİH SEÇİM TAKVİMİ)
/// ============================================================================
/// 
/// [AvailabilityCalendar], harici ağır bir takvim paketi (table_calendar vb.)
/// kullanmaya gerek kalmadan, tamamen Flutter'ın temel widget'ları (GridView, 
/// AnimatedContainer, GestureDetector) ile sıfırdan inşa edilmiş özel bir takvim bileşenidir.
/// 
/// BU BİLEŞENİN GÖREVLERİ VE ÖĞRENİLECEK KONULAR:
/// 1. TAKVİM MATEMATİĞİ (Calendar Math):
///    - Ayın ilk gününün haftanın hangi gününe denk geldiği (`firstWeekday`).
///    - Ayda kaç gün çektiği (`DateTime(year, month + 1, 0).day`).
///    - Boşluk hücreleri ve gün kaydırma (offset) hesaplamaları.
/// 
/// 2. İŞ MANTIĞI VE REZERVASYON KURALLARI (Business Rules):
///    - Geçmiş günlerin tıklanmasını engelleme ([AppDateUtils.isPastDate]).
///    - Dolu / rezerve günlerin kırmızı boyanması ve tıklanmasının engellenmesi.
///    - Aralık seçerken araya dolu gün girmesini engelleme (HasBlockedDay kontrolü).
/// 
/// 3. İKİ AŞAMALI TARİH SEÇİMİ (Start / End Date Range Picker):
///    - 1. Tıklama: Alış Tarihi (Start Date) belirlenir.
///    - 2. Tıklama: Dönüş Tarihi (End Date) belirlenir.
///    - Kullanıcı başlangıçtan önceki bir güne basarsa akıllıca başlangıcı günceller.
/// 
/// 4. REAKTİF BİLDİRİM (Callbacks):
///    - [onDateRangeChanged] ile üst widget'a seçilen aralık haber verilir.
///    - [onErrorMessageChanged] ile kural ihlali mesajları üst forma iletilir.
class AvailabilityCalendar extends StatefulWidget {
  /// Takvim üzerinde müsaitliği kontrol edilecek araç
  final Vehicle vehicle;
  
  /// Formdan veya üst ekrandan gelen mevcut başlangıç tarihi
  final DateTime? startDate;
  
  /// Formdan veya üst ekrandan gelen mevcut bitiş tarihi
  final DateTime? endDate;
  
  /// Tarih aralığı değiştiğinde tetiklenen geri çağırma (callback) fonksiyonu
  final Function(DateTime start, DateTime? end) onDateRangeChanged;
  
  /// Takvimde bir hata (ör. dolu güne basma) oluştuğunda üst bileşeni uyaran callback
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
  /// Takvimde şu an görüntülenen ay (Yıl ve Ay bilgisi taşır, gün daima 1'dir)
  late DateTime _currentMonth;
  
  /// Kullanıcının seçtiği başlangıç (alış) günü
  DateTime? _selectedStart;
  
  /// Kullanıcının seçtiği bitiş (dönüş) günü
  DateTime? _selectedEnd;
  
  /// Takvim içinde gösterilen anlık hata mesajı (ör: "Bu tarihte araç dolu")
  String? _validationError;

  @override
  void initState() {
    super.initState();
    // Takvim ilk açıldığında içinde bulunduğumuz ayın 1. gününe odaklanırız
    final now = DateTime.now();
    _currentMonth = DateTime(now.year, now.month, 1);
    
    // Eğer üst widget'tan hazır tarihler geldiyse bunları iç duruma kopyalarız
    _selectedStart = widget.startDate;
    _selectedEnd = widget.endDate;
  }

  /// [didUpdateWidget]: Üst widget yeniden build edildiğinde ve bu widget'a
  /// yeni parametreler (props) geçtiğinde çalışır.
  /// Örneğin kullanıcı alttaki form alanından tarihleri değiştirdiğinde,
  /// takvim ızgarasının da o yeni tarihleri anında seçili göstermesini sağlar.
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

  /// Bir önceki aya geçiş fonksiyonu (Örnek: Kasım -> Ekim)
  void _previousMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month - 1, 1);
    });
  }

  /// Bir sonraki aya geçiş fonksiyonu (Örnek: Ekim -> Kasım)
  void _nextMonth() {
    setState(() {
      _currentMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 1);
    });
  }

  /// Bir takvim gününe tıklandığında çalışan merkezi karar mekanizması
  void _handleDayTap(DateTime day) {
    // -------------------------------------------------------------
    // KURAL 1: Geçmiş tarihler seçilemez!
    // -------------------------------------------------------------
    if (AppDateUtils.isPastDate(day)) {
      _setError('Geçmiş tarihler için kiralama yapılamaz.');
      return;
    }

    // -------------------------------------------------------------
    // KURAL 2: Dolu (rezerve edilmiş) gün seçilemez!
    // -------------------------------------------------------------
    if (reservationStore.isDayUnavailableForVehicle(widget.vehicle, day)) {
      _setError('Bu tarihte araç müsait değildir.');
      return;
    }

    // -------------------------------------------------------------
    // ADIM 3: Tarih Seçim Mantığı (Start / End Range Selection)
    // -------------------------------------------------------------
    // Durum A: Henüz hiçbir tarih seçilmemişse VEYA hem start hem end zaten seçiliyse ->
    // Kullanıcı yeni bir seçim başlatmak istiyordur. Tıklanan gün yeni "Start" olur.
    if (_selectedStart == null || (_selectedStart != null && _selectedEnd != null)) {
      setState(() {
        _selectedStart = day;
        _selectedEnd = null; // Bitişi sıfırlayıp 2. tıklamayı bekliyoruz
        _validationError = null;
      });
      widget.onErrorMessageChanged?.call(null);
      widget.onDateRangeChanged(day, null);
    } else {
      // Durum B: Başlangıç (Start) zaten seçili, kullanıcı 2. tıklamayı yapıyor (End arıyor)
      if (day.isBefore(_selectedStart!)) {
        // Eğer kullanıcı başlangıçtan daha önceki bir güne tıklarsa,
        // hata vermek yerine akıllıca yeni başlangıcı bu gün yaparız (UX kolaylığı)
        setState(() {
          _selectedStart = day;
          _selectedEnd = null;
          _validationError = null;
        });
        widget.onErrorMessageChanged?.call(null);
        widget.onDateRangeChanged(day, null);
      } else if (AppDateUtils.isSameDay(day, _selectedStart!)) {
        // Eğer aynı güne tekrar tıklarsa: En az 1 günlük kiralama olarak kabul edip
        // bitişi ertesi gün yaparız.
        setState(() {
          _selectedEnd = day.add(const Duration(days: 1));
          _validationError = null;
        });
        widget.onErrorMessageChanged?.call(null);
        widget.onDateRangeChanged(_selectedStart!, _selectedEnd);
      } else {
        // ---------------------------------------------------------
        // KURAL 4: Aralık Kontrolü (Critical Range Gap Checking)
        // Kullanıcı 1 Ekim ile 10 Ekim'i seçti diyelim. 5 Ekim doluysa,
        // aracı 1-10 arası kiralayamaz! Aradaki tüm günleri tek tek tarıyoruz.
        // ---------------------------------------------------------
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

        // Tüm kurallar sağlandı, aralık başarıyla belirlendi
        setState(() {
          _selectedEnd = day;
          _validationError = null;
        });
        widget.onErrorMessageChanged?.call(null);
        widget.onDateRangeChanged(_selectedStart!, day);
      }
    }
  }

  /// Hata durumunda hem yerel state'i hem de üst formu bilgilendirme
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

    // MATEMATİKSEL HESAPLAMALAR:
    // 1. Ayın kaç gün çektiğini bulma:
    // Gelecek ayın 0. günü demek, bu ayın son günü demektir!
    // Örneğin DateTime(2026, 11, 0).day -> Ekim'in 31 gün olduğunu döndürür.
    final daysInMonth = DateTime(_currentMonth.year, _currentMonth.month + 1, 0).day;
    
    // 2. Ayın ilk gününün haftanın hangi günü olduğunu bulma (1 = Pazartesi, 7 = Pazar)
    final firstWeekday = _currentMonth.weekday;

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
          // -------------------------------------------------------------
          // 1. AY BAŞLIĞI VE ÖNCEKİ/SONRAKİ AY BUTONLARI
          // -------------------------------------------------------------
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

          // -------------------------------------------------------------
          // 2. HAFTANIN GÜNLERİ SÜTUN BAŞLIKLARI (Pzt, Sal, Çar ...)
          // -------------------------------------------------------------
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

          // -------------------------------------------------------------
          // 3. TAKVİM GÜNLERİ IZGARASI (GRID VIEW)
          // -------------------------------------------------------------
          // Bir ay en fazla 6 haftaya yayılabilir (6 x 7 = 42 hücre)
          GridView.builder(
            shrinkWrap: true, // Ebeveyn scroll'u içinde boyutu kadar yer kaplaması için
            physics: const NeverScrollableScrollPhysics(), // Kendi başına kaymasın
            itemCount: 42,
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 7, // Haftanın 7 günü için 7 sütun
              crossAxisSpacing: 4,
              mainAxisSpacing: 6,
              childAspectRatio: 1.0, // Kare hücreler
            ),
            itemBuilder: (context, index) {
              // Ofset hesabı: Ayın 1'i Pazartesi (1) değilse önceki günleri boş bırakırız
              final dayOffset = index - (firstWeekday - 1);
              if (dayOffset < 0 || dayOffset >= daysInMonth) {
                // Ayın kapsamadığı boş günler için görünmez widget
                return const SizedBox.shrink();
              }

              // Hücrenin temsil ettiği gerçek gün objesi
              final day = DateTime(_currentMonth.year, _currentMonth.month, dayOffset + 1);
              final isPast = AppDateUtils.isPastDate(day);
              final isUnavailable = reservationStore.isDayUnavailableForVehicle(widget.vehicle, day);

              // Seçim durumları belirleme:
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
                    // Seçili başlangıç/bitiş günleri ana renk, aradaki günler yarı saydam,
                    // dolu günler ise hafif kırmızı arka plan alır
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
                        // Gün numarası (ör: "15")
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
                        // Alt etiket (Alış, Dönüş, DOLU)
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

          // -------------------------------------------------------------
          // 4. KURAL İHLALİ HATA KUTUSU (Validation Error Banner)
          // -------------------------------------------------------------
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

          // -------------------------------------------------------------
          // 5. TAKVİM RENK GÖSTERGESİ (LEGEND / AÇIKLAMA)
          // -------------------------------------------------------------
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

/// Gün başlıkları (Pzt, Sal, vb.) için yardımcı özel widget
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

/// Takvim altındaki renk açıklamaları (Legend) için minik renk kutucuğu ve yazı
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

