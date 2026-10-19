import 'beverage_type.dart';

class BeverageLogModel {
  final String id;
  final BeverageType type;
  final int amountMl;
  final DateTime timestamp;
  final String? containerType;

  const BeverageLogModel({
    required this.id,
    this.type = BeverageType.water,
    required this.amountMl,
    required this.timestamp,
    this.containerType,
  });

  int get effectiveHydrationMl => (amountMl * type.hydrationFactor).round();

  BeverageLogModel copyWith({
    String? id,
    BeverageType? type,
    int? amountMl,
    DateTime? timestamp,
    String? containerType,
  }) {
    return BeverageLogModel(
      id: id ?? this.id,
      type: type ?? this.type,
      amountMl: amountMl ?? this.amountMl,
      timestamp: timestamp ?? this.timestamp,
      containerType: containerType ?? this.containerType,
    );
  }

  factory BeverageLogModel.fromJson(Map<String, dynamic> json) {
    return BeverageLogModel(
      id: json['id'] as String,
      type: BeverageType.values.firstWhere(
        (t) => t.name == json['type'],
        orElse: () => BeverageType.water,
      ),
      amountMl: json['amountMl'] as int,
      timestamp: DateTime.parse(json['timestamp'] as String),
      containerType: json['containerType'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type.name,
      'amountMl': amountMl,
      'timestamp': timestamp.toIso8601String(),
      'containerType': containerType,
    };
  }
}
