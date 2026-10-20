/// ---------------------------------------------------------------------------
/// 📝 Reservation — Kullanıcı Rezervasyon Veri Modeli
/// ---------------------------------------------------------------------------
/// Kullanıcının bir aracı belirli tarihler arasında kiralama talebini temsil eder.
/// Bu model; aracın özet bilgilerini (ad, resim), teslim alma ve bırakma lokasyonlarını,
/// toplam tutarı ve kiralama durumunu bir arada saklar.
class Reservation {
  final String id;                  // Benzersiz rezervasyon takip numarası (örn: 'RES-1729432000')
  final String vehicleId;           // Kiralanan aracın benzersiz ID'si
  final String vehicleName;         // Araç adı (örn: 'BMW 320i Sedan')
  final String vehicleImage;        // Rezervasyon kartında hızlıca göstermek için küçük resim yolu
  final DateTime startDateTime;     // Alış tarihi ve saati
  final DateTime endDateTime;       // Teslim ediliş tarihi ve saati
  final String pickupLocation;      // Aracın teslim alınacağı şube/havalimanı
  final String returnLocation;      // Aracın iade edileceği şube/havalimanı
  final String? destinationCity;    // Seyahat edilecek opsiyonel varış şehri
  final double totalPrice;          // İndirimler düşüldükten sonraki net rezervasyon bedeli
  final String status;              // 'Onaylandı', 'Bekliyor', 'Tamamlandı', 'İptal Edildi'
  final DateTime createdAt;         // Rezervasyonun sisteme girildiği an

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

  /// 🎯 UI Kolaylaştırıcı Getter'lar:
  /// Hesabım ekranında 'Aktif Rezervasyonlar' ve 'Geçmiş Rezervasyonlar' şeklinde
  /// iki sekme (tab) bulunmaktadır. Bu filtrelemeyi temiz tutmak için iki pratik getter:

  /// Rezervasyon hala geçerli veya onay sürecinde mi?
  bool get isActive => status == 'Onaylandı' || status == 'Bekliyor';

  /// Rezervasyon geçmişte mi kaldı (tamamlandı ya da iptal mi oldu)?
  bool get isCompleted => status == 'Tamamlandı' || status == 'İptal Edildi';

  /// JSON verisinden Dart Reservation nesnesi oluşturur
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

  /// Modeli JSON haritasına dönüştürür
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

  /// Mevcut rezervasyonun belirli alanlarını güncelleyip yeni bir kopya oluşturur
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

