import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/context_extensions.dart';
import '../models/workout_model.dart';

class AddWorkoutModal extends StatefulWidget {
  final void Function(WorkoutType type, int durationMinutes, [int? calories]) onAdd;

  const AddWorkoutModal({
    super.key,
    required this.onAdd,
  });

  static Future<void> show(
    BuildContext context,
    void Function(WorkoutType type, int durationMinutes, [int? calories]) onAdd,
  ) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => AddWorkoutModal(onAdd: onAdd),
    );
  }

  @override
  State<AddWorkoutModal> createState() => _AddWorkoutModalState();
}

class _AddWorkoutModalState extends State<AddWorkoutModal> {
  WorkoutType _selectedType = WorkoutType.cardio;
  int _duration = 30;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 20 + bottomInset),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 16),
          _buildTypeGrid(),
          const SizedBox(height: 16),
          _buildDurationSelector(context),
          const SizedBox(height: 20),
          _buildSubmitButton(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Antrenman Ekle', style: context.textTheme.headlineMedium?.copyWith(fontSize: 18)),
        IconButton(
          icon: const Icon(Icons.close, color: AppColors.textSecondary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Widget _buildTypeGrid() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: WorkoutType.values.map((type) {
        final isSelected = type == _selectedType;
        return ChoiceChip(
          label: Text(type.label),
          avatar: Icon(
            type.icon,
            size: 18,
            color: isSelected ? AppColors.background : AppColors.neonLime,
          ),
          selected: isSelected,
          selectedColor: AppColors.neonLime,
          backgroundColor: AppColors.card,
          labelStyle: TextStyle(
            color: isSelected ? AppColors.background : AppColors.textPrimary,
            fontWeight: FontWeight.bold,
          ),
          onSelected: (_) => setState(() => _selectedType = type),
        );
      }).toList(),
    );
  }

  Widget _buildDurationSelector(BuildContext context) {
    final estimatedCal = _selectedType.defaultCalPerMin * _duration;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Süre: $_duration dakika', style: context.textTheme.titleLarge?.copyWith(fontSize: 15)),
            Text('~$estimatedCal kcal', style: const TextStyle(color: AppColors.neonOrange, fontWeight: FontWeight.bold)),
          ],
        ),
        Slider(
          value: _duration.toDouble(),
          min: 5,
          max: 120,
          divisions: 23,
          activeColor: AppColors.neonLime,
          inactiveColor: AppColors.surfaceContainer,
          onChanged: (val) => setState(() => _duration = val.round()),
        ),
      ],
    );
  }

  Widget _buildSubmitButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.neonLime,
          foregroundColor: AppColors.background,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
        ),
        onPressed: () {
          widget.onAdd(_selectedType, _duration);
          Navigator.of(context).pop();
        },
        child: const Text('Kaydet', style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
      ),
    );
  }
}
