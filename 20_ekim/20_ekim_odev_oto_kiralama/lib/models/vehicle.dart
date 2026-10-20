import 'unavailable_range.dart';

class Vehicle {
  final String id;
  final String brand;
  final String model;
  final int year;
  final String category;
  final String transmission;
  final String fuelType;
  final int mileage;
  final double hourlyPrice;
  final double dailyPrice;
  final String description;
  final String image;
  final List<String> images;
  final int fuelLevel; // Yüzde (%)
  final int estimatedRange; // KM
  final List<UnavailableRange> unavailableRanges;

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

  String get fullName => '$brand $model';

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
      hourlyPrice: (json['hourlyPrice'] as num).toDouble(),
      dailyPrice: (json['dailyPrice'] as num).toDouble(),
      description: json['description'] as String,
      image: json['image'] as String,
      images: (json['images'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          [],
      fuelLevel: json['fuelLevel'] as int? ?? 100,
      estimatedRange: json['estimatedRange'] as int? ?? 500,
      unavailableRanges: (json['unavailableRanges'] as List<dynamic>?)
              ?.map((e) => UnavailableRange.fromJson(e as Map<String, dynamic>))
              .toList() ??
          [],
    );
  }

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
