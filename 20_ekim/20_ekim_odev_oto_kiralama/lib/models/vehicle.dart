import 'unavailable_range.dart';

/// ---------------------------------------------------------------------------
/// 🚘 Vehicle — Araç Veri Modeli
/// ---------------------------------------------------------------------------
/// Uygulamanın merkezindeki en önemli veri sınıfıdır.
/// Bir kiralık aracın tüm teknik, fiyat, görsel ve müsaitlik verilerini saklar.
///
/// Flutter & Dart İyi Pratiği:
/// 'Immutable' (Değiştirilemez) nesneler oluşturmak için tüm alanlar 'final' yapılır.
/// Böylece uygulamanın bir yerinde kazara bir aracın fiyatı değiştirilemez,
/// veri tutarsızlığı önlenir.
class Vehicle {
  final String id;
  final String brand;                 // Örn: 'BMW', 'Renault'
  final String model;                 // Örn: '320i Sedan', 'Clio'
  final int year;                     // Model yılı: 2024
  final String category;              // 'Basic', 'Flex', 'Lux' vb.
  final String transmission;          // 'Otomatik' veya 'Manuel'
  final String fuelType;              // 'Benzin', 'Dizel', 'Elektrik'
  final int mileage;                  // Araç kilometresi: 12500 km
  final double hourlyPrice;           // Saatlik kiralama ücreti
  final double dailyPrice;            // Günlük kiralama ücreti
  final String description;           // Araç tanıtım metni
  final String image;                 // Ana kapak fotoğrafı dosya yolu
  final List<String> images;          // Detay galerisinde kaydırılacak fotoğraflar
  final int fuelLevel;                // Depo / Batarya doluluk oranı (%0 - %100)
  final int estimatedRange;           // Tahmini kalan menzil (örn: 680 km)
  final List<UnavailableRange> unavailableRanges; // Daha önceden kiralanmış dolu tarihler

  const Vehicle({
    required this.id,
    required this.brand,
    required this.model,
    required this.year,
    required this.category,
    required this.transmission,
    required this.fuelType,
    required this.mileage,
    required this.hourlyPrice,
    required this.dailyPrice,
    required this.description,
    required this.image,
    required this.images,
    required this.fuelLevel,
    required this.estimatedRange,
    required this.unavailableRanges,
  });

  /// Marka ve modeli birleştiren pratik getter (Örn: 'BMW 320i Sedan')
  String get fullName => '$brand $model';

  /// 'factory Vehicle.fromJson':
  /// JSON dosyasından gelen ham `Map<String, dynamic>` verisini tip güvenli Dart nesnesine dönüştürür.
  factory Vehicle.fromJson(Map<String, dynamic> json) {
    return Vehicle(
      id: json['id'] as String,
      brand: json['brand'] as String,
      model: json['model'] as String,
      year: json['year'] as int,
      category: json['category'] as String,
      transmission: json['transmission'] as String,
      fuelType: json['fuelType'] as String,
      mileage: json['mileage'] as int,

      /// ⭐ Flutter İpucu:
      /// JSON ayrıştırırken sayılar bazen '1500' (int) bazen '1500.0' (double) olarak gelebilir.
      /// Doğrudan 'as double' dersek tam sayılarda çalışma zamanı hatası (CastError) alırız.
      /// Bu yüzden önce ortak üst sınıf olan 'as num' yapıp ardından '.toDouble()' çağırırız.
      hourlyPrice: (json['hourlyPrice'] as num).toDouble(),
      dailyPrice: (json['dailyPrice'] as num).toDouble(),

      description: json['description'] as String,
      image: json['image'] as String,

      // Fotoğraf galerisi dizisini güvenli biçimde `List<String>`e dönüştürür
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],

      // Varsayılan değer güvenceleri: JSON'da yoksa varsayılan atanır
      fuelLevel: json['fuelLevel'] as int? ?? 100,
      estimatedRange: json['estimatedRange'] as int? ?? 500,

      // İç içe (Nested) model listesi dönüşümü:
      // Her bir JSON objesini UnavailableRange.fromJson ile nesneye çevirir
      unavailableRanges: (json['unavailableRanges'] as List<dynamic>?)
              ?.map((e) => UnavailableRange.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

  /// Dart nesnesini tekrar JSON haritasına dönüştürür
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'brand': brand,
      'model': model,
      'year': year,
      'category': category,
      'transmission': transmission,
      'fuelType': fuelType,
      'mileage': mileage,
      'hourlyPrice': hourlyPrice,
      'dailyPrice': dailyPrice,
      'description': description,
      'image': image,
      'images': images,
      'fuelLevel': fuelLevel,
      'estimatedRange': estimatedRange,
      'unavailableRanges': unavailableRanges.map((e) => e.toJson()).toList(),
    };
  }

  /// 'copyWith' Deseni:
  /// Immutable (değiştirilemez) sınıflarda mevcut bir nesnenin sadece bir veya birkaç
  /// alanını güncelleyerek YENİ bir nesne kopyası üretmek için kullanılır.
  /// Örn: `final guncelArac = arac.copyWith(dailyPrice: 2000.0);`
  Vehicle copyWith({
    String? id,
    String? brand,
    String? model,
    int? year,
    String? category,
    String? transmission,
    String? fuelType,
    int? mileage,
    double? hourlyPrice,
    double? dailyPrice,
    String? description,
    String? image,
    List<String>? images,
    int? fuelLevel,
    int? estimatedRange,
    List<UnavailableRange>? unavailableRanges,
  }) {
    return Vehicle(
      id: id ?? this.id,
      brand: brand ?? this.brand,
      model: model ?? this.model,
      year: year ?? this.year,
      category: category ?? this.category,
      transmission: transmission ?? this.transmission,
      fuelType: fuelType ?? this.fuelType,
      mileage: mileage ?? this.mileage,
      hourlyPrice: hourlyPrice ?? this.hourlyPrice,
      dailyPrice: dailyPrice ?? this.dailyPrice,
      description: description ?? this.description,
      image: image ?? this.image,
      images: images ?? this.images,
      fuelLevel: fuelLevel ?? this.fuelLevel,
      estimatedRange: estimatedRange ?? this.estimatedRange,
      unavailableRanges: unavailableRanges ?? this.unavailableRanges,
    );
  }
}

