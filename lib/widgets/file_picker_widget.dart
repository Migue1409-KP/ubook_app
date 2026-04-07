import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// ### Example — profile image (only JPG/PNG)
/// ```dart
/// FilePickerWidget(
///   hint: 'Select your profile photo (JPG / PNG)',
///   fileName: vm.fileName,
///   detectedType: vm.detectedType.isNotEmpty ? vm.detectedType : null,
///   size:        vm.formattedFileSize.isNotEmpty
///                    ? vm.formattedFileSize : null,
///   isLoading:      vm.isSelecting,
///   onSelect: () => vm.selectFile(
///     allowedExtensions: ['jpg', 'jpeg', 'png'],
///   ),
/// )
/// ```
///
/// ### Example — free document (any type)
/// ```dart
/// FilePickerWidget(
///   fileName: vm.fileName,
///   isLoading:      vm.isSelecting,
///   onSelect: () => vm.selectFile(),
/// )
/// ```
class FilePickerWidget extends StatelessWidget {

  final String? fileName;
  final String? detectedType;
  final String? size;
  final bool isLoading;
  final VoidCallback onSelect;
  final String hint;

  const FilePickerWidget({
    super.key,
    required this.fileName,
    required this.isLoading,
    required this.onSelect,
    this.detectedType,
    this.size,
    this.hint = 'Toca para seleccionar archivo',
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = fileName != null;
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    final activeColor = AppColors.primary;
    final backgroundColor = isSelected
      ? AppColors.primary.withValues(alpha: 0.08)
      : AppColors.primary.withValues(alpha: 0.05);
    final borderColor = isSelected
      ? AppColors.primary.withValues(alpha: 0.22)
      : AppColors.divider;

    return GestureDetector(
      onTap: isLoading ? null : onSelect,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.all(20),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(
            color: borderColor,
            width: 1.5,
          ),
        ),
        child: isLoading
            ? Center(
                child: SizedBox(
                  width: 28,
                  height: 28,
                  child: CircularProgressIndicator(
                    strokeWidth: 2.5,
                    valueColor: AlwaysStoppedAnimation<Color>(activeColor),
                  ),
                ),
              )
            : Row(
                children: [
                  Icon(
                    isSelected ? Icons.check_circle : Icons.upload_file,
                    color: activeColor,
                    size: 36,
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          isSelected ? fileName! : hint,
                          style: textTheme.bodyLarge?.copyWith(
                            fontWeight: FontWeight.w600,
                            color: activeColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        if (isSelected && size != null)
                          Row(
                            children: [
                              if (detectedType != null) ...[
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 6, vertical: 2),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.12),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    detectedType!,
                                    style: textTheme.labelSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                              ],
                              Text(
                                size!,
                                style: textTheme.labelSmall?.copyWith(
                                  color: theme.colorScheme.onSurfaceVariant,
                                ),
                              ),
                            ],
                          ),
                      ],
                    ),
                  ),
                  if (isSelected)
                    Icon(
                      Icons.swap_horiz,
                      color: activeColor,
                      size: 20,
                    ),
                ],
              ),
      ),
    );
  }
}
