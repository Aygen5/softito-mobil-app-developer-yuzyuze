import 'package:flutter/material.dart';
import '../../../models/vehicle.dart';
import 'vehicle_card.dart';

class VehicleGrid extends StatelessWidget {
  final List<Vehicle> vehicles;
  final int columnCount;
  final ValueChanged<Vehicle> onVehicleTap;

  const VehicleGrid({
    super.key,
    required this.vehicles,
    required this.columnCount,
    required this.onVehicleTap,
  });

  @override
  Widget build(BuildContext context) {
    if (columnCount == 1) {
      return ListView.separated(
        padding: const EdgeInsets.fromLTRB(20, 12, 20, 32),
        itemCount: vehicles.length,
        separatorBuilder: (_, __) => const SizedBox(height: 16),
        itemBuilder: (context, index) {
          final vehicle = vehicles[index];
          return VehicleCard(
            vehicle: vehicle,
            columnCount: 1,
            onTap: () => onVehicleTap(vehicle),
          );
        },
      );
    } else if (columnCount == 2) {
      return GridView.builder(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 32),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          childAspectRatio: 0.72,
        ),
        itemCount: vehicles.length,
        itemBuilder: (context, index) {
          final vehicle = vehicles[index];
          return VehicleCard(
            vehicle: vehicle,
            columnCount: 2,
            onTap: () => onVehicleTap(vehicle),
          );
        },
      );
    } else {
      return GridView.builder(
        padding: const EdgeInsets.fromLTRB(12, 12, 12, 32),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 0.68,
        ),
        itemCount: vehicles.length,
        itemBuilder: (context, index) {
          final vehicle = vehicles[index];
          return VehicleCard(
            vehicle: vehicle,
            columnCount: 3,
            onTap: () => onVehicleTap(vehicle),
          );
        },
      );
    }
  }
}
