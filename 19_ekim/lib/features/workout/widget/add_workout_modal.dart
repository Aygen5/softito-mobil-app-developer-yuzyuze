import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/context_extensions.dart';
import '../models/workout_model.dart';

class AddWorkoutModal extends StatefulWidget {
  final void Function(WorkoutType type, int duration, int? calories) onSave;

  const AddWorkoutModal({super.key, required this.onSave});

  static Future<void> show(
    BuildContext context,
    void Function(WorkoutType type, int duration, int? calories) onSave,
  ) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: AppColors.surface,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => AddWorkoutModal(onSave: onSave),
    );
  }

  @override
  State<AddWorkoutModal> createState() => _AddWorkoutModalState();
}

class _AddWorkoutModalState extends State<AddWorkoutModal> {
  WorkoutType _selectedType = WorkoutType.strength;
  final TextEditingController _durationController = TextEditingController(text: '30');

  @override
  void dispose() {
    _durationController.dispose();
    super.dispose();
  }

  void _submit() {
    final duration = int.tryParse(_durationController.text) ?? 30;
    widget.onSave(_selectedType, duration, null);
    Navigator.of(context).pop();
  }

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.of(context).viewInsets.bottom;
    return Padding(
      padding: EdgeInsets.fromLTRB(20, 20, 20, bottomInset + 20),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(context),
          const SizedBox(height: 16),
          _buildTypeSelector(),
          const SizedBox(height: 16),
          _buildDurationField(context),
          const SizedBox(height: 20),
          _buildSaveButton(context),
        ],
      ),
    );
  }

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text('Egzersiz Ekle', style: context.textTheme.headlineMedium?.copyWith(fontSize: 18)),
        IconButton(
          icon: const Icon(Icons.close, color: AppColors.textSecondary),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ],
    );
  }

  Widget _buildTypeSelector() {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: WorkoutType.values.map((type) {
        final isSelected = type == _selectedType;
        return ChoiceChip(
          avatar: Icon(
            type.icon,
            size: 16,
            color: isSelected ? AppColors.background : AppColors.neonLime,
          ),
          label: Text(type.label),
          selected: isSelected,
          selectedColor: AppColors.neonLime,
          backgroundColor: AppColors.surfaceContainer,
          labelStyle: TextStyle(
            color: isSelected ? AppColors.background : AppColors.textPrimary,
            fontWeight: FontWeight.w600,
            fontSize: 12,
          ),
          onSelected: (_) => setState(() => _selectedType = type),
        );
      }).toList(),
    );
  }

  Widget _buildDurationField(BuildContext context) {
    return TextField(
      controller: _durationController,
      keyboardType: TextInputType.number,
      style: const TextStyle(color: AppColors.textPrimary),
      decoration: InputDecoration(
        labelText: 'Süre (Dakika)',
        labelStyle: const TextStyle(color: AppColors.textSecondary),
        suffixText: 'dk',
        filled: true,
        fillColor: AppColors.surfaceContainer,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
          borderSide: const BorderSide(color: AppColors.outline),
        ),
      ),
    );
  }

  Widget _buildSaveButton(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: AppColors.neonLime,
          foregroundColor: AppColors.background,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
        onPressed: _submit,
        child: const Text('Kaydet ve Kalori Hesapla', style: TextStyle(fontWeight: FontWeight.bold)),
      ),
    );
  }
}
