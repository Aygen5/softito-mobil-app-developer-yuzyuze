---
name: flutter-feature-scaffold
description: Flutter projelerinde feature bazlı kod yazmak için gerekli klasör yapısını oluşturur. ValueNotifier state mimarisini UI ayrımını ve birim test iskeletini standartlara uygun olarak üretir.
---

# Flutter feature scaffold (modüler ekran iskeleti)
Bu yetenek, projede yeni bir ekran ya da işlev modlülü açarken Clean UI ve reaktif State kurallarına tam uyulmasını garanti altına alır.

## Temel Kurallar ve MVC Mimarisi

1. **Katmanların Ayrımı (Asla Tek Dosyada Toplama):**
   - **Model (`_model.dart`):** Yalnızca veri yapısını ve serileştirmeyi barındırır. Kesinlikle UI veya controller koduna bağımlı olamaz.
   - **View (`_view.dart` & `_card.dart`):** Pasif arayüz katmanıdır; yalnızca kullanıcıya veri gösterir ve etkileşimleri controller'a iletir.
   - **Controller (`_controller.dart`):** Durum yönetimi ve iş mantığını yürütür; UI bağımsız çalışır.

2. **Model (M) Kuralları:**
   - Sınıflar mutlaka `immutable` olmalı ve tüm değişkenler `final` tanımlanmalıdır.
   - `const` yapıcı metot, `copyWith`, `fromJson` ve `toJson` metotları eksiksiz uygulanmalıdır.

3. **Controller (C) ve Reaktif State Yönetimi:**
   - Harici ağır state paketleri yerine Flutter'ın yerel çekirdek API'leri (`ChangeNotifier`, `ValueNotifier`) kullanılmalıdır.
   - Doğrudan devasa `StatefulWidget` yazarak iş mantığı UI içine gömülmemelidir.
   - Bellek sızıntılarını önlemek için `dispose()` metodu zorunludur.

4. **View (V) ve UI Standartları:**
   - Sayfa düzeyinde ağır `setState` KULLANILMAZ; `ListenableBuilder` / `ValueListenableBuilder` esastır.
   - Büyük `build` metodları yasaktır. 40 satırı geçen `build` blokları `widget/` altında bağımsız bileşenlere ayrılmalıdır.
   - Değişmeyen tüm widget'larda `const` kullanımı zorunludur.


## Adım Adım Uygulama Akışı
### Adım 1: Klasör Yapısı Oluşturma (Feature-Based MVC)
Hedeflenen modül adını (örn: `beverage_tracker` veya `workout`), `lib/features/<feature_name>` altına MVC yapısına uygun olarak kur:

```text
lib/features/<feature_name>/
    controller/     -> (C) Controller: İş mantığı, reaktif state (ChangeNotifier / ValueNotifier)
    models/         -> (M) Model: Immutable domain entity (copyWith, fromJson, toJson)
    view/           -> (V) View: Ana sayfa düzeni (StatelessWidget + ListenableBuilder)
    widget/         -> (V) Sub-View: 40 satırı geçmeyen modüler bileşenler (const StatelessWidget)
```

### Adım 2: Model (M) Dosyasını Oluşturma
`models/<feature_name>_model.dart` dosyasında veriyi temsil eden `immutable` domain modelini oluştur. Tüm alanlar `final` olmalı; `const` constructor, `copyWith`, `fromJson` ve `toJson` mutlaka bulunmalıdır:

```dart
class BeverageLogModel {
  final String id;
  final String type; // water, tea, coffee, mineral
  final int amountMl;
  final DateTime timestamp;
  final String? containerType;
  final double hydrationFactor;

  const BeverageLogModel({
    required this.id,
    required this.type,
    required this.amountMl,
    required this.timestamp,
    this.containerType,
    this.hydrationFactor = 1.0,
  });

  /// Efektif hidrasyon miktarı (Katsayı ile çarpılmış net su kazanımı)
  int get effectiveHydrationMl => (amountMl * hydrationFactor).round();

  BeverageLogModel copyWith({
    String? id,
    String? type,
    int? amountMl,
    DateTime? timestamp,
    String? containerType,
    double? hydrationFactor,
  }) {
    return BeverageLogModel(
      id: id ?? this.id,
      type: type ?? this.type,
      amountMl: amountMl ?? this.amountMl,
      timestamp: timestamp ?? this.timestamp,
      containerType: containerType ?? this.containerType,
      hydrationFactor: hydrationFactor ?? this.hydrationFactor,
    );
  }

  factory BeverageLogModel.fromJson(Map<String, dynamic> json) {
    return BeverageLogModel(
      id: json['id'] as String,
      type: json['type'] as String,
      amountMl: json['amountMl'] as int,
      timestamp: DateTime.parse(json['timestamp'] as String),
      containerType: json['containerType'] as String?,
      hydrationFactor: (json['hydrationFactor'] as num?)?.toDouble() ?? 1.0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'type': type,
      'amountMl': amountMl,
      'timestamp': timestamp.toIso8601String(),
      'containerType': containerType,
      'hydrationFactor': hydrationFactor,
    };
  }
}
```

### Adım 3: Controller (C) Dosyasını Yazma
`controller/<feature_name>_controller.dart` içinde Model'i yöneten, iş mantığını yürüten ve reaktif durumu sağlayan Controller sınıfını oluştur. Flutter'ın çekirdek `ChangeNotifier` ve `ValueNotifier` sınıflarını kullan; bellek sızıntısını önlemek için `dispose()` metodunu mutlaka yaz:

```dart
import 'package:flutter/foundation.dart';
import '../models/beverage_log_model.dart';

class BeverageTrackerController extends ChangeNotifier {
  int _dailyGoalMl = 2500;
  final List<BeverageLogModel> _logs = [];

  // SKILL yönergesine uygun ValueNotifier köprüsü
  final ValueNotifier<int> currentWater = ValueNotifier<int>(0);

  int get dailyGoalMl => _dailyGoalMl;
  List<BeverageLogModel> get logs => List.unmodifiable(_logs);

  int get consumedMl => _logs.fold<int>(0, (sum, item) => sum + item.amountMl);

  int get effectiveHydrationMl =>
      _logs.fold<int>(0, (sum, item) => sum + item.effectiveHydrationMl);

  double get progressRatio {
    if (_dailyGoalMl <= 0) return 0.0;
    return (effectiveHydrationMl / _dailyGoalMl).clamp(0.0, 1.0);
  }

  void addBeverage(String type, int amountMl, {double factor = 1.0, String? container}) {
    final log = BeverageLogModel(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      type: type,
      amountMl: amountMl,
      timestamp: DateTime.now(),
      containerType: container,
      hydrationFactor: factor,
    );
    _logs.insert(0, log);
    currentWater.value = effectiveHydrationMl;
    notifyListeners();
  }

  void removeLog(String id) {
    _logs.removeWhere((log) => log.id == id);
    currentWater.value = effectiveHydrationMl;
    notifyListeners();
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
```

### Adım 4: View (V) Dosyasını Oluşturma
`view/<feature_name>_view.dart` dosyasında `StatelessWidget` kullanarak ana ekran iskeletini oluştur. Sayfa düzeyinde ağır `setState` KULLANILMAZ; `ListenableBuilder` ile controller dinlenir ve `build` metodu 40 satırı geçmeyecek şekilde alt widget'lara delege edilir:

```dart
import 'package:flutter/material.dart';
import '../controller/beverage_tracker_controller.dart';
import '../widget/beverage_card.dart';

class BeverageTrackerView extends StatelessWidget {
  final BeverageTrackerController controller;

  const BeverageTrackerView({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Susadım - İçecek Takibi'),
        centerTitle: true,
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: controller,
          builder: (context, _) {
            return SingleChildScrollView(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  BeverageProgressCard(
                    consumedMl: controller.consumedMl,
                    effectiveMl: controller.effectiveHydrationMl,
                    dailyGoalMl: controller.dailyGoalMl,
                    progressRatio: controller.progressRatio,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton.icon(
                    onPressed: () => controller.addBeverage('water', 250),
                    icon: const Icon(Icons.water_drop),
                    label: const Text('250 ml Su Ekle'),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
```

### Adım 5: Widget (Sub-View) Dosyasını Oluşturma
`widget/<feature_name>_card.dart` dosyasında `StatelessWidget` kullanılarak modüler UI bileşenini oluştur. Bileşenin `build` metodu 40 satırın altında olmalı ve değişmeyen tüm özellikler `const` olmalıdır:

```dart
import 'package:flutter/material.dart';

class BeverageProgressCard extends StatelessWidget {
  final int consumedMl;
  final int effectiveMl;
  final int dailyGoalMl;
  final double progressRatio;

  const BeverageProgressCard({
    super.key,
    required this.consumedMl,
    required this.effectiveMl,
    required this.dailyGoalMl,
    required this.progressRatio,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final percent = (progressRatio * 100).toInt();

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Günlük Hidrasyon', style: theme.textTheme.titleMedium),
            const SizedBox(height: 12),
            LinearProgressIndicator(value: progressRatio, minHeight: 8),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Efektif: $effectiveMl / $dailyGoalMl ml ($percent%)'),
                Text('Toplam Sıvı: $consumedMl ml', style: theme.textTheme.bodySmall),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

### Adım 6: Clean Architecture ve MVC Standartlarına Uyum
- **Separation of Concerns:** Model veriyi, Controller iş mantığını ve durumu, View görsel sunumu yönetir.
- **Unidirectional Data Flow:** View $\rightarrow$ Controller $\rightarrow$ Model $\rightarrow$ Controller (`notifyListeners`) $\rightarrow$ View.
- **Reusability:** Widget'lar ve Controller bağımsız ekran ve modüllerde tekrar kullanılabilir olmalıdır.
- **Testability:** Controller ve Model katmanları UI bağımsızlığı sayesinde %100 birim testleri ile test edilebilir olmalıdır.
- **Memory Management:** Controller'ın `dispose()` metodu çağrılarak tüm notifier ve stream kaynakları serbest bırakılmalıdır.

## Kullanım Örnekleri

### Örnek 1: Basit bir ekran oluşturma
```dart
import 'package:flutter/material.dart';
import 'package:susadim/features/beverage_tracker/view/beverage_tracker_view.dart';
import 'package:susadim/features/beverage_tracker/controller/beverage_tracker_controller.dart';

class HomePage extends StatelessWidget {
  final BeverageTrackerController controller;

  const HomePage({super.key, required this.controller});

  @override
  Widget build(BuildContext context) {
    return BeverageTrackerView(controller: controller);
  }
}
```

### Örnek 2: Modüler widget kullanımı
```dart
import 'package:flutter/material.dart';
import 'package:susadim/features/water_tracker/widget/water_tracker_card.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return WaterTrackerCard(
      title: 'Water Tracker',
      subtitle: 'Track your water intake',
      image: 'https://example.com/water_tracker.jpg',
      level: 1,
      coins: 0,
    );
  }
}
```

## Ekstra İpuçları
- **Dependency Injection:** Controller'ları widgetlara inject etmek veya constructor üzerinden iletmek esastır.
- **Navigation:** Navigasyonu sağlamak için Navigator 2.0 veya go_router kullanabilirsin.
- **Testing:** Her katman için ayrı testler yazarak uygulamanın stabilitesini sağlayabilirsin.

## SSS

### Soru: Hangi durumlarda bu yeteneği kullanmalıyım?
**Cevap:** Yeni bir ekran veya işlev modülü oluştururken bu yeteneği kullanmalısın.

### Soru: Bu yetenek hangi durumlarda kullanmamalıyım?
**Cevap:** Mevcut bir ekranı güncellerken veya küçük bir hata düzeltmesi yaparken bu yeteneği kullanmamalısın.
