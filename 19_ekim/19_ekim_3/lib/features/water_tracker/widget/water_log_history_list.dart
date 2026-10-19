import 'package:flutter/material.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/extensions/context_extensions.dart';
import '../models/water_log_model.dart';

class WaterLogHistoryListWidget extends StatelessWidget {
  final List<WaterLogModel> logs;
  final void Function(String id) onDelete;

  const WaterLogHistoryListWidget({
    super.key,
    required this.logs,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    if (logs.isEmpty) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 24),
          child: Text(
            'Henüz su tüketim kaydı yok.',
            style: context.textTheme.bodyMedium,
          ),
        ),
      );
    }
    return ListView.separated(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: logs.length,
      separatorBuilder: (_, _) => const SizedBox(height: 8),
      itemBuilder: (context, index) {
        final log = logs[index];
        return _buildItem(context, log);
      },
    );
  }

  Widget _buildItem(BuildContext context, WaterLogModel log) {
    final timeStr =
        '${log.timestamp.hour.toString().padLeft(2, '0')}:${log.timestamp.minute.toString().padLeft(2, '0')}';
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: AppColors.card,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: AppColors.outline),
      ),
      child: Row(
        children: [
          const Icon(Icons.water_drop, color: AppColors.neonCyan, size: 24),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${log.amountMl} ml',
                  style: context.textTheme.titleLarge?.copyWith(fontSize: 16),
                ),
                Text(
                  '${log.containerType ?? "Manuel"} • $timeStr',
                  style: context.textTheme.labelSmall,
                ),
              ],
            ),
          ),
          IconButton(
            icon: const Icon(Icons.delete_outline, color: AppColors.error, size: 20),
            onPressed: () => onDelete(log.id),
          ),
        ],
      ),
    );
  }
}
