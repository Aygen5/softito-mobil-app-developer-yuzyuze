import 'package:flutter/material.dart';

/// [SampleFeatureScreen]
///
/// `project.md` ve `SKILLS.md` standartlarına tam uyumlu örnek ekran şablonu:
/// 1. Sayfa düzeyinde ağır `setState` KULLANILMAZ; [StatelessWidget] + [ListenableBuilder] kullanılır.
/// 2. Tüm `build` metodları 40 satır sınırına uyar; alt bileşenler modüler widget'lara ayrılmıştır.
/// 3. Değişmeyen tüm widget'lar `const` anahtar kelimesi ile işaretlenmiştir.
/// 4. Controller bağımlılığı doğrudan constructor üzerinden (Dependency Injection) enjekte edilir.
class SampleFeatureScreen extends StatelessWidget {
  final SampleTrackerController controller;

  const SampleFeatureScreen({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Susadım - İçecek & Hidrasyon'),
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
                  SampleHydrationSummaryCard(
                    consumedMl: controller.consumedMl,
                    effectiveMl: controller.effectiveHydrationMl,
                    dailyGoalMl: controller.dailyGoalMl,
                    progressRatio: controller.progressRatio,
                  ),
                  const SizedBox(height: 16),
                  SampleQuickActionButtons(
                    onAddWater: () => controller.addBeverage('water', 250),
                    onAddTea: () => controller.addBeverage('tea', 150),
                    onAddCoffee: () => controller.addBeverage('coffee', 150),
                    onAddMineral: () => controller.addBeverage('mineral', 200),
                  ),
                  const SizedBox(height: 16),
                  SampleResetButton(onReset: controller.resetToday),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

/// Hidrasyon özet kartı (Modüler Widget - 40 satır altı)
class SampleHydrationSummaryCard extends StatelessWidget {
  final int consumedMl;
  final int effectiveMl;
  final int dailyGoalMl;
  final double progressRatio;

  const SampleHydrationSummaryCard({
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
            Text(
              'Günlük Hidrasyon Durumu',
              style: theme.textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 12),
            LinearProgressIndicator(
              value: progressRatio,
              minHeight: 10,
              borderRadius: BorderRadius.circular(8),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('Efektif: $effectiveMl / $dailyGoalMl ml ($percent%)'),
                Text(
                  'Toplam Sıvı: $consumedMl ml',
                  style: theme.textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// Hızlı içecek ekleme butonları (Modüler Widget - 40 satır altı)
class SampleQuickActionButtons extends StatelessWidget {
  final VoidCallback onAddWater;
  final VoidCallback onAddTea;
  final VoidCallback onAddCoffee;
  final VoidCallback onAddMineral;

  const SampleQuickActionButtons({
    super.key,
    required this.onAddWater,
    required this.onAddTea,
    required this.onAddCoffee,
    required this.onAddMineral,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Hızlı İçecek Ekle',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
        ),
        const SizedBox(height: 10),
        Wrap(
          spacing: 8.0,
          runSpacing: 8.0,
          children: [
            ElevatedButton.icon(
              onPressed: onAddWater,
              icon: const Icon(Icons.water_drop),
              label: const Text('Su (+250ml)'),
            ),
            ElevatedButton.icon(
              onPressed: onAddMineral,
              icon: const Icon(Icons.bubble_chart),
              label: const Text('Maden Suyu (+200ml)'),
            ),
            ElevatedButton.icon(
              onPressed: onAddTea,
              icon: const Icon(Icons.emoji_food_beverage),
              label: const Text('Çay (+150ml)'),
            ),
            ElevatedButton.icon(
              onPressed: onAddCoffee,
              icon: const Icon(Icons.coffee),
              label: const Text('Kahve (+150ml)'),
            ),
          ],
        ),
      ],
    );
  }
}

/// Sıfırlama butonu (Modüler Widget - 40 satır altı)
class SampleResetButton extends StatelessWidget {
  final VoidCallback onReset;

  const SampleResetButton({
    super.key,
    required this.onReset,
  });

  @override
  Widget build(BuildContext context) {
    return OutlinedButton.icon(
      onPressed: onReset,
      icon: const Icon(Icons.refresh),
      label: const Text('Günü Sıfırla'),
    );
  }
}

/// Örnek Controller Arayüzü (SKILL & project.md gereksinimleri için)
abstract class SampleTrackerController extends ChangeNotifier {
  int get dailyGoalMl;
  int get consumedMl;
  int get effectiveHydrationMl;
  double get progressRatio;

  void addBeverage(String type, int amountMl);
  void resetToday();
}
