import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/context_extensions.dart';
import '../models/beverage_log_model.dart';

class BeverageLogHistoryListWidget extends StatelessWidget {
  final List<BeverageLogModel> logs;
  final void Function(String id) onDelete;

  const BeverageLogHistoryListWidget({
    super.key,
    required this.logs,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (logs.isEmpty) {
      return _buildEmptyState(context);
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: logs.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) => _buildItem(context, logs[index]),
    );
  }

  Widget _buildEmptyState(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 24),
        child: Text(
          'Bugün henüz sıvı kaydı eklenmedi.',
          style: context.textTheme.bodyMedium,
        ),
      ),
    );
  }

  Widget _buildItem(BuildContext context, BeverageLogModel log) {
    final hour = log.timestamp.hour.toString().padLeft(2, '0');
    final minute = log.timestamp.minute.toString().padLeft(2, '0');
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.outline),
      ),
      child: Row(
        children: [
          Icon(log.type.icon, color: log.type.color, size: 20),
          const SizedBox(width: 12),
          Text(
            '${log.amountMl} ml',
            style: context.textTheme.titleLarge?.copyWith(fontSize: 16),
          ),
          const SizedBox(width: 8),
          Text(
            '${log.type.label} (${log.containerType ?? "Manuel"})',
            style: context.textTheme.bodyMedium,
          ),
          const Spacer(),
          Text('$hour:$minute', style: context.textTheme.labelSmall),
          IconButton(
            icon: const Icon(Icons.delete_outline, size: 18, color: AppColors.textMuted),
            onPressed: () => onDelete(log.id),
          ),
        ],
      ),
    );
  }
}
