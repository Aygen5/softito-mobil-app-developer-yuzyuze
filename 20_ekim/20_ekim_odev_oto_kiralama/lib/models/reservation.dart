class Reservation {
  final String id;
  final String vehicleId;
  final String vehicleName;
  final String vehicleImage;
  final DateTime startDateTime;
  final DateTime endDateTime;
  final String pickupLocation;
  final String returnLocation;
  final String? destinationCity;
  final double totalPrice;
  final String status; // Onaylandı, Bekliyor, Tamamlandı, İptal Edildi
  final DateTime createdAt;

  const Reservation({
    required this.id,
    required this.vehicleId,
    required this.vehicleName,
    required this.vehicleImage,
    required this.startDateTime,
    required this.endDateTime,
    required this.pickupLocation,
    required this.returnLocation,
    this.destinationCity,
    required this.totalPrice,
    required this.status,
    required this.createdAt,
  });

  bool get isActive => status == 'Onaylandı' || status == 'Bekliyor';
  bool get isCompleted => status == 'Tamamlandı' || status == 'İptal Edildi';

  factory Reservation.fromJson(Map<String, dynamic> json) {
    return Reservation(
      id: json['id'] as String,
      vehicleId: json['vehicleId'] as String,
      vehicleName: json['vehicleName'] as String,
      vehicleImage: json['vehicleImage'] as String? ?? '',
      startDateTime: DateTime.parse(json['startDateTime'] as String),
      endDateTime: DateTime.parse(json['endDateTime'] as String),
      pickupLocation: json['pickupLocation'] as String,
      returnLocation: json['returnLocation'] as String,
      destinationCity: json['destinationCity'] as String?,
      totalPrice: (json['totalPrice'] as num).toDouble(),
      status: json['status'] as String,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'vehicleId': vehicleId,
      'vehicleName': vehicleName,
      'vehicleImage': vehicleImage,
      'startDateTime': startDateTime.toIso8601String(),
      'endDateTime': endDateTime.toIso8601String(),
      'pickupLocation': pickupLocation,
      'returnLocation': returnLocation,
      'destinationCity': destinationCity,
      'totalPrice': totalPrice,
      'status': status,
      'createdAt': createdAt.toIso8601String(),
    };
  }

  Reservation copyWith({
    String? id,
    String? vehicleId,
    String? vehicleName,
    String? vehicleImage,
    DateTime? startDateTime,
    DateTime? endDateTime,
    String? pickupLocation,
    String? returnLocation,
    String? destinationCity,
    double? totalPrice,
    String? status,
    DateTime? createdAt,
  }) {
    return Reservation(
      id: id ?? this.id,
      vehicleId: vehicleId ?? this.vehicleId,
      vehicleName: vehicleName ?? this.vehicleName,
      vehicleImage: vehicleImage ?? this.vehicleImage,
      startDateTime: startDateTime ?? this.startDateTime,
      endDateTime: endDateTime ?? this.endDateTime,
      pickupLocation: pickupLocation ?? this.pickupLocation,
      returnLocation: returnLocation ?? this.returnLocation,
      destinationCity: destinationCity ?? this.destinationCity,
      totalPrice: totalPrice ?? this.totalPrice,
      status: status ?? this.status,
      createdAt: createdAt ?? this.createdAt,
    );
  }
}
