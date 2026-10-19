import 'package:flutter/foundation.dart';
import '../models/beverage_log_model.dart';
import '../models/beverage_type.dart';

class BeverageTrackerController extends ChangeNotifier {
  int _dailyGoalMl = 2500;
  BeverageType _selectedType = BeverageType.water;
  final List<BeverageLogModel> _logs = [];

  // ValueNotifier support as specified in SKILL.md
  final ValueNotifier<int> currentWater = ValueNotifier<int>(800);

  BeverageTrackerController() {
    _initDefaults();
  }

  void _initDefaults() {
    final now = DateTime.now();
    _logs.addAll([
      BeverageLogModel(
        id: '1',
        type: BeverageType.water,
        amountMl: 300,
        timestamp: now.subtract(const Duration(hours: 3)),
        containerType: 'Bardak',
      ),
      BeverageLogModel(
        id: '2',
        type: BeverageType.water,
        amountMl: 500,
        timestamp: now.subtract(const Duration(hours: 1)),
        containerType: 'Matara',
      ),
    ]);
    currentWater.value = effectiveHydrationMl;
  }

  int get dailyGoalMl => _dailyGoalMl;
  BeverageType get selectedType => _selectedType;
  List<BeverageLogModel> get logs => List.unmodifiable(_logs);

  int get consumedMl => _logs.fold<int>(0, (sum, log) => sum + log.amountMl);

  int get effectiveHydrationMl =>
      _logs.fold<int>(0, (sum, log) => sum + log.effectiveHydrationMl);

  double get progressRatio {
    if (_dailyGoalMl <= 0) return 0.0;
    final ratio = effectiveHydrationMl / _dailyGoalMl;
    return ratio.clamp(0.0, 1.0);
  }

  int get remainingMl {
    final remaining = _dailyGoalMl - effectiveHydrationMl;
    return remaining > 0 ? remaining : 0;
  }

  Map<BeverageType, int> get consumptionByType {
    final map = {for (final type in BeverageType.values) type: 0};
    for (final log in _logs) {
      map[log.type] = (map[log.type] ?? 0) + log.amountMl;
    }
    return map;
  }

  void selectType(BeverageType type) {
    if (_selectedType != type) {
      _selectedType = type;
      notifyListeners();
    }
  }

  int _beverageCounter = 0;

  void addBeverage(BeverageType type, int amountMl, [String? containerType]) {
    final newLog = BeverageLogModel(
      id: '${DateTime.now().microsecondsSinceEpoch}_${_beverageCounter++}',
      type: type,
      amountMl: amountMl,
      timestamp: DateTime.now(),
      containerType: containerType,
    );
    _logs.insert(0, newLog);
    currentWater.value = effectiveHydrationMl;
    notifyListeners();
  }

  void addWater(int amountMl, [String? containerType]) {
    addBeverage(BeverageType.water, amountMl, containerType);
  }

  void removeLog(String id) {
    _logs.removeWhere((log) => log.id == id);
    currentWater.value = effectiveHydrationMl;
    notifyListeners();
  }

  void setDailyGoal(int newGoal) {
    if (newGoal > 0) {
      _dailyGoalMl = newGoal;
      notifyListeners();
    }
  }

  void resetToday() {
    _logs.clear();
    currentWater.value = 0;
    notifyListeners();
  }

  @override
  void dispose() {
    currentWater.dispose();
    super.dispose();
  }
}
