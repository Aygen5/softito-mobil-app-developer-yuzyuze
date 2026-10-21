import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';

import '../../data/models/daily_report_model.dart';

/// Rozet boyutu seçenekleri.
enum StatusBadgeSize { small, medium, large }

/// Rapor ve staj durumlarını renkli etiket ve ikonla gösteren ortak rozet.
class StatusBadge extends StatelessWidget {
  final Object status;
  final String? labelOverride;
  final bool showIcon;
  final StatusBadgeSize size;

  const StatusBadge({
    super.key,
    required this.status,
    this.labelOverride,
    this.showIcon = true,
    this.size = StatusBadgeSize.medium,
  });

  @override
  Widget build(BuildContext context) {
    final config = _getStatusConfig(status);
    final horizontalPadding = size == StatusBadgeSize.small ? 7.0 : 10.0;
    final verticalPadding = size == StatusBadgeSize.small ? 3.0 : 5.0;
    final fontSize = size == StatusBadgeSize.small ? 11.0 : 12.0;
    final iconSize = size == StatusBadgeSize.small ? 12.0 : 14.0;

    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: horizontalPadding,
        vertical: verticalPadding,
      ),
      decoration: BoxDecoration(
        color: config.backgroundColor,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: config.borderColor, width: 1),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (showIcon) ...[
            Icon(config.icon, size: iconSize, color: config.textColor),
            const SizedBox(width: 5),
          ],
          Text(
            labelOverride ?? config.label,
            style: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.w600,
              color: config.textColor,
            ),
          ),
        ],
      ),
    );
  }

  _StatusConfig _getStatusConfig(Object status) {
    final statusStr =
        status is ReportStatus ? status.value : status.toString();
    switch (statusStr.toLowerCase()) {
      case 'approved':
      case 'onaylandi':
        return const _StatusConfig(
          label: 'Onaylandı',
          backgroundColor: AppColors.successLight,
          textColor: AppColors.success,
          borderColor: Color(0xFFC7EBD7),
          icon: Icons.check_circle_outline,
        );
      case 'submitted':
      case 'incelemede':
      case 'beklemede':
        return const _StatusConfig(
          label: 'Onay Bekliyor',
          backgroundColor: AppColors.infoLight,
          textColor: AppColors.info,
          borderColor: Color(0xFFBBDEFB),
          icon: Icons.access_time,
        );
      case 'revisionrequested':
      case 'duzeltme':
      case 'duzeltmeistendi':
        return const _StatusConfig(
          label: 'Düzeltme İstendi',
          backgroundColor: AppColors.errorLight,
          textColor: AppColors.error,
          borderColor: Color(0xFFF9D6D6),
          icon: Icons.error_outline,
        );
      case 'draft':
      case 'taslak':
      default:
        return const _StatusConfig(
          label: 'Taslak',
          backgroundColor: Color(0xFFF1F5F9),
          textColor: AppColors.textSecondary,
          borderColor: AppColors.border,
          icon: Icons.edit_note,
        );
    }
  }
}

class _StatusConfig {
  final String label;
  final Color backgroundColor;
  final Color textColor;
  final Color borderColor;
  final IconData icon;

  const _StatusConfig({
    required this.label,
    required this.backgroundColor,
    required this.textColor,
    required this.borderColor,
    required this.icon,
  });
}
