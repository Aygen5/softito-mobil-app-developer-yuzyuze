import 'package:flutter/material.dart';
import '../../../lib/features/water_tracker/controller/water_tracker_controller.dart';
import '../../../lib/features/water_tracker/widget/water_tracker_card.dart';

class SampleFeatureScreen extends StatelessWidget {
  final WaterTrackerController controller;

  const SampleFeatureScreen({
    super.key,
    required this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sample Feature Screen'),
      ),
      body: ListenableBuilder(
        listenable: controller,
        builder: (context, _) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: WaterTrackerCard(
              title: 'Günlük Su Takibi',
              subtitle: 'Hedefine ulaşmak için su tüketimini kaydet',
              consumedWaterMl: controller.consumedMl,
              dailyGoalWaterMl: controller.dailyGoalMl,
              onAddWater: () => controller.addWater(250, 'Bardak'),
            ),
          );
        },
      ),
    );
  }
}
