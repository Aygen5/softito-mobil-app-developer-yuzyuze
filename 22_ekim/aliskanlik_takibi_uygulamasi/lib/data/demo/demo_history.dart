import '../../core/utils/date_utils.dart';
import '../../models/habit_completion.dart';

abstract class DemoHistory {
  static List<HabitCompletion> generateCompletions(DateTime referenceToday) {
    final normToday = AppDateUtils.normalize(referenceToday);
    final list = <HabitCompletion>[];

    // Son 30 günü geriye doğru oluştur
    for (int i = 0; i < 30; i++) {
      final date = normToday.subtract(Duration(days: i));
      final dateStr = '${date.year}_${date.month}_${date.day}';

      // 1. Günde 10.000 Adım: Son 30 günün tamamı eksiksiz tamamlanmış!
      list.add(
        HabitCompletion(
          id: 'comp_step_$dateStr',
          habitId: 'step_10k',
          date: date,
          value: 10000,
          isCompleted: true,
        ),
      );

      // 2. Sigarasız Yaşam: Son 14 gün tamamlanmış (30 günlük meydan okumanın 14. gününde)
      if (i < 14) {
        list.add(
          HabitCompletion(
            id: 'comp_smoke_$dateStr',
            habitId: 'smoke_free',
            date: date,
            value: 1,
            isCompleted: i != 0, // Bugün henüz devam ediyor
          ),
        );
      }

      // 3. Spor Salonuna Git: Henüz başlanmamış (0 tamamlama) - Hiç kayıt eklenmez

      // 4. Her Gün 100 Sayfa Oku: 2. gününde (Dün tamamlanmış, bugün 45 sayfa)
      if (i == 0) {
        list.add(
          HabitCompletion(
            id: 'comp_read_$dateStr',
            habitId: 'read_100p',
            date: date,
            value: 45,
            isCompleted: false, // 45/100, henüz tamamlanmadı
          ),
        );
      } else if (i == 1) {
        list.add(
          HabitCompletion(
            id: 'comp_read_$dateStr',
            habitId: 'read_100p',
            date: date,
            value: 100,
            isCompleted: true,
          ),
        );
      }

      // 5. Günde 3 Litre Su: Tamamlanan, kısmi ve kaçırılan günler içerir
      if (i == 0) {
        // Bugün: 2.500 ml (%83, tamamlanmadı)
        list.add(
          HabitCompletion(
            id: 'comp_water_$dateStr',
            habitId: 'water_3l',
            date: date,
            value: 2500,
            isCompleted: false,
          ),
        );
      } else if (i % 7 == 3) {
        // Kaçırılan gün
        list.add(
          HabitCompletion(
            id: 'comp_water_$dateStr',
            habitId: 'water_3l',
            date: date,
            value: 1000,
            isCompleted: false,
          ),
        );
      } else if (i % 7 == 5) {
        // Kısmi gün (2200 ml)
        list.add(
          HabitCompletion(
            id: 'comp_water_$dateStr',
            habitId: 'water_3l',
            date: date,
            value: 2200,
            isCompleted: false,
          ),
        );
      } else {
        // Tamamlanan gün (3000 ml)
        list.add(
          HabitCompletion(
            id: 'comp_water_$dateStr',
            habitId: 'water_3l',
            date: date,
            value: 3000,
            isCompleted: true,
          ),
        );
      }
    }

    return list;
  }
}
