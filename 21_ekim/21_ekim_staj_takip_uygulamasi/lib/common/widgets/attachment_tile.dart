import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/app_text_styles.dart';

/// Rapor ekindeki belgeleri listeleyen ve yükleme durumunu gösteren satır bileşeni.
class AttachmentTile extends StatelessWidget {
  final String fileName;
  final int? fileSizeBytes;
  final VoidCallback? onTap;
  final VoidCallback? onDelete;
  final bool isUploading;
  final double? uploadProgress;

  const AttachmentTile({
    super.key,
    required this.fileName,
    this.fileSizeBytes,
    this.onTap,
    VoidCallback? onDelete,
    VoidCallback? onRemove,
    this.isUploading = false,
    this.uploadProgress,
  }) : onDelete = onRemove ?? onDelete;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.border, width: 1),
      ),
      child: Column(
        children: [
          Row(
            children: [
              _buildFileIcon(fileName),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      fileName,
                      style: AppTextStyles.bodyMedium.copyWith(fontSize: 14),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (fileSizeBytes != null)
                      Text(
                        _formatFileSize(fileSizeBytes!),
                        style: AppTextStyles.caption,
                      ),
                  ],
                ),
              ),
              if (isUploading)
                const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else if (onDelete != null)
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    size: 18,
                    color: AppColors.error,
                  ),
                  onPressed: onDelete,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  tooltip: 'Dosyayı Kaldır',
                )
              else if (onTap != null)
                IconButton(
                  icon: const Icon(
                    Icons.open_in_new,
                    size: 18,
                    color: AppColors.primaryBlue,
                  ),
                  onPressed: onTap,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  tooltip: 'Dosyayı Aç',
                ),
            ],
          ),
          if (isUploading && uploadProgress != null) ...[
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: uploadProgress,
              minHeight: 4,
              backgroundColor: AppColors.borderLight,
              valueColor: const AlwaysStoppedAnimation<Color>(
                AppColors.primaryBlue,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildFileIcon(String name) {
    final extension = name.split('.').last.toLowerCase();
    IconData iconData = Icons.insert_drive_file_outlined;
    Color iconColor = AppColors.textSecondary;

    if (extension == 'pdf') {
      iconData = Icons.picture_as_pdf_outlined;
      iconColor = AppColors.error;
    } else if (['jpg', 'jpeg', 'png'].contains(extension)) {
      iconData = Icons.image_outlined;
      iconColor = AppColors.accentTeal;
    } else if (['doc', 'docx'].contains(extension)) {
      iconData = Icons.description_outlined;
      iconColor = AppColors.primaryBlue;
    }

    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
        color: iconColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Icon(iconData, size: 20, color: iconColor),
    );
  }

  String _formatFileSize(int bytes) {
    if (bytes < 1024) return '$bytes B';
    if (bytes < 1024 * 1024) return '${(bytes / 1024).toStringAsFixed(1)} KB';
    return '${(bytes / (1024 * 1024)).toStringAsFixed(1)} MB';
  }
}
