import 'package:flutter/material.dart';

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
    final colorScheme = theme.colorScheme;
    final textTheme = theme.textTheme;
    
    final activeColor = isSelected ? colorScheme.secondary : colorScheme.primary;
    final backgroundColor = activeColor.withValues(alpha: 0.08);
    final borderColor = activeColor.withValues(alpha: 0.24);

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
                                    color: activeColor.withValues(alpha: 0.16),
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: Text(
                                    detectedType!,
                                    style: textTheme.labelSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: activeColor,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 6),
                              ],
                              Text(
                                size!,
                                style: textTheme.labelSmall?.copyWith(
                                  color: colorScheme.onSurfaceVariant,
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
