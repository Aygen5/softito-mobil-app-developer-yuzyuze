// Günlük verisini tuttuğumuz model. Alanları final yaptık (immutable).
// Veri güncelleneceği zaman nesneyi doğrudan değiştirmek yerine copyWith ile yenisini üretiyoruz.
class DiaryEntry {
  /// Günlüğün ait olduğu tarih (saat/dakika sıfırlanmış olmalıdır)
  final DateTime date;

  /// Günlük metin içeriği
  final String content;

  /// Seçilen günün hissi / ruh hali (örn: Huzurlu, Dalgın, Neşeli, Yorgun, İlhamlı)
  final String mood;

  /// Güncellenme / kaydedilme zamanı
  final DateTime updatedAt;

  const DiaryEntry({
    required this.date,
    required this.content,
    this.mood = 'Huzurlu',
    required this.updatedAt,
  });

  // copyWith: Bir günlük kaydını kopyalayıp sadece değişen kısımlarını güncellemek için kullanıldı
  DiaryEntry copyWith({
    DateTime? date,
    String? content,
    String? mood,
    DateTime? updatedAt,
  }) {
    return DiaryEntry(
      date: date ?? this.date,
      content: content ?? this.content,
      mood: mood ?? this.mood,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }
}
