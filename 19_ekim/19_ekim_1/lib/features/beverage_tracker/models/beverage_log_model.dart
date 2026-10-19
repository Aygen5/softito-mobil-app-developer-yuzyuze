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
}
