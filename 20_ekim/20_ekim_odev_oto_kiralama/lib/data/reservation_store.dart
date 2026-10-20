import 'package:flutter/foundation.dart';
import '../models/reservation.dart';
import '../models/vehicle.dart';
import '../core/utils/date_utils.dart';


/// ReservationStore — Reaktif Rezervasyon Deposu ve Çakışma Motoru

/// Bu sınıf; backend ve veritabanı olmadığı için kullanıcının yaptığı rezervasyonları uygulama belleğinde (In-Memory) saklar.
/// Neden `ValueNotifier<List<Reservation>>`?
/// Bir kullanıcı araç detayında "Rezervasyonu Onayla" butonuna bastığında,"Hesabım & Rezervasyonlarım" ekranının bundan haberdar olup listeyi ANINDA yenilemesi gerekir.
/// 'ValueNotifier' sayesinde rezervasyon listesi değiştiğinde UI otomatik güncellenir.
/// Singleton Deseni:
/// Uygulama boyunca tek bir rezervasyon havuzu olması için Singleton kalıbı kullanıldı.
class ReservationStore extends ValueNotifier<List<Reservation>> {
  static final ReservationStore _instance = ReservationStore._internal();
  factory ReservationStore() => _instance;

  ReservationStore._internal() : super([]) {
    // Uygulama ilk açıldığında boş kalmasın diye 2 adet demo rezervasyon ekliyoruz
    _initSampleReservations();
  }

  /// Demo Rezervasyon Başlatıcı:
  /// Kullanıcı uygulamayı açtığında hem aktif hem geçmiş rezervasyon kartlarını test edebilsin diye oluşturulur.
  void _initSampleReservations() {
    final now = DateTime.now();
    value = [
      Reservation(
        id: 'REZ-2026-9041',
        vehicleId: 'veh-001',
        vehicleName: 'Fiat Egea Sedan',
        vehicleImage: 'https://images.unsplash.com/photo-1549399542-7e3f8b79c341?auto=format&fit=crop&w=800&q=80',
        startDateTime: DateTime(now.year, now.month, now.day + 2, 10, 0),
        endDateTime: DateTime(now.year, now.month, now.day + 5, 18, 0),
        pickupLocation: 'İstanbul - Havalimanı (IST)',
        returnLocation: 'İstanbul - Havalimanı (IST)',
        destinationCity: 'Bursa',
        totalPrice: 3750.0,
        status: 'Onaylandı',
        createdAt: now.subtract(const Duration(days: 1)),
      ),
      Reservation(
        id: 'REZ-2026-8812',
        vehicleId: 'veh-005',
        vehicleName: 'Toyota Corolla Hybrid',
        vehicleImage: 'https://images.unsplash.com/photo-1621007947382-bb3c3994e3fb?auto=format&fit=crop&w=800&q=80',
        startDateTime: DateTime(now.year, now.month, now.day - 7, 09, 0),
        endDateTime: DateTime(now.year, now.month, now.day - 4, 18, 0),
        pickupLocation: 'İstanbul - Sabiha Gökçen Havalimanı (SAW)',
        returnLocation: 'İstanbul - Kadıköy Rıhtım Şube',
        destinationCity: 'Yalova',
        totalPrice: 6300.0,
        status: 'Tamamlandı',
        createdAt: now.subtract(const Duration(days: 8)),
      ),
    ];
  }

  /// Aktif (Onaylı veya Beklemede) olan rezervasyonları filtreler
  List<Reservation> get activeReservations =>
      value.where((r) => r.isActive).toList();

  /// Tamamlanmış veya İptal Edilmiş geçmiş rezervasyonları filtreler
  List<Reservation> get pastReservations =>
      value.where((r) => r.isCompleted).toList();

  // Yeni Rezervasyon Ekleme (Reaktivite Kuralı)
  /// Çok Önemli Flutter Notu:
  /// `value.add(reservation)` yaparsak ValueNotifier listenin referansı değişmediği için ekranları uyarmaz (notifyListeners tetiklenmez)!
  /// Bu yüzden 'Spread Operator' (`...value`) kullanarak YENİ bir liste oluşturup `value = [reservation, ...value]` şeklinde atama yaparız.
  void addReservation(Reservation reservation) {
    value = [reservation, ...value]; // Başa ekler (en güncel en üstte görünür)
  }

  /// Rezervasyonu İptal Et
  /// Listeyi kopyalar, ilgili rezervasyonun durumunu 'İptal Edildi' yapar ve yeni listeyi atar.
  bool cancelReservation(String reservationId) {
    final index = value.indexWhere((r) => r.id == reservationId);
    if (index != -1) {
      final updatedList = List<Reservation>.from(value);
      updatedList[index] = updatedList[index].copyWith(status: 'İptal Edildi');
      value = updatedList; // UI anında güncellenir
      return true;
    }
    return false;
  }

  // Araç Müsaitlik ve Çakışma Denetleyicisi (Availability Validator)
  /// Bir araç için seçilen tarihlerin geçerli olup olmadığını 4 adımda test eder:
  ({bool isAvailable, String? errorMessage}) checkVehicleAvailability({
    required Vehicle vehicle,
    required DateTime startDateTime,
    required DateTime endDateTime,
  }) {
    // 1. Kural: Geçmiş tarihler için rezervasyon oluşturulamaz
    if (AppDateUtils.isPastDate(startDateTime)) {
      return (
        isAvailable: false,
        errorMessage: 'Geçmiş tarihler için kiralama oluşturulamaz.',
      );
    }

    // 2. Kural: Dönüş tarihi alış tarihinden önce veya eşit olamaz
    if (!endDateTime.isAfter(startDateTime)) {
      return (
        isAvailable: false,
        errorMessage: 'Dönüş tarihi ve saati, alış tarihinden sonra olmalıdır.',
      );
    }

    // 3. Kural: JSON'dan gelen statik dolu tarihlerle (unavailableRanges) çakışma var mı?
    for (final range in vehicle.unavailableRanges) {
      if (AppDateUtils.hasDateOverlap(
        start1: startDateTime,
        end1: endDateTime,
        start2: range.startDate,
        end2: range.endDate,
      )) {
        return (
          isAvailable: false,
          errorMessage: 'Seçtiğiniz tarih aralığında araç müsait değil (Önceden Rezerve Edilmiş).',
        );
      }
    }

    // 4. Kural: Bellekte kullanıcının daha önce oluşturduğu aktif rezervasyonlarla çakışma var mı?
    final vehicleActiveReservations = value.where(
      (r) => r.vehicleId == vehicle.id && r.isActive,
    );

    for (final reservation in vehicleActiveReservations) {
      if (AppDateUtils.hasDateOverlap(
        start1: startDateTime,
        end1: endDateTime,
        start2: reservation.startDateTime,
        end2: reservation.endDateTime,
      )) {
        return (
          isAvailable: false,
          errorMessage: 'Seçtiğiniz tarih aralığında bu araca ait onaylı bir rezervasyon bulunmaktadır.',
        );
      }
    }

    // Hiçbir engele takılmadıysa araç tamamen müsaittir!
    return (isAvailable: true, errorMessage: null);
  }

  //  Takvimde Günün Dolu Olup Olmadığını Sorgulama
  /// Müsaitlik takviminde (AvailabilityCalendar) her bir gün kutusu çizilirken çağrılır.
  /// Eğer gün bu araç için doluysa takvimde kırmızı renk ve kilit simgesi basılır.
  bool isDayUnavailableForVehicle(Vehicle vehicle, DateTime day) {
    // Geçmiş günler zaten kiralanamaz (gri pasif gösterilir)
    if (AppDateUtils.isPastDate(day)) {
      return false;
    }

    // JSON'daki dolu gün aralıkları kontrolü
    for (final range in vehicle.unavailableRanges) {
      if (AppDateUtils.isDayWithinRange(day, range.startDate, range.endDate)) {
        return true;
      }
    }

    // Kullanıcının bellekteki aktif rezervasyonlarının gün kontrolü
    final vehicleActiveReservations = value.where(
      (r) => r.vehicleId == vehicle.id && r.isActive,
    );

    for (final res in vehicleActiveReservations) {
      if (AppDateUtils.isDayWithinRange(day, res.startDateTime, res.endDateTime)) {
        return true;
      }
    }

    return false;
  }
}

/// Uygulama genelinden erişilebilen global rezervasyon deposu örneği
final ReservationStore reservationStore = ReservationStore();

