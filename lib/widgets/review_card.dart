import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

/// Widget reutilizable para mostrar una tarjeta de reseña con rating y contenido
class ReviewCard extends StatelessWidget {
  final int rating;
  final String title;
  final String? content;
  final String? authorName;
  final DateTime? createdAt;
  final VoidCallback? onDelete;

  const ReviewCard({
    super.key,
    required this.rating,
    required this.title,
    this.content,
    this.authorName,
    this.createdAt,
    this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.inputFill,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.divider),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  ...List.generate(
                    5,
                    (index) => Icon(
                      index < rating ? Icons.star_rounded : Icons.star_outline,
                      color: Colors.amber,
                      size: 16,
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    '$rating/5',
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      color: AppColors.textPrimary,
                      fontSize: 13,
                    ),
                  ),
                ],
              ),
              if (onDelete != null)
                IconButton(
                  icon: const Icon(Icons.delete_outline, size: 18),
                  onPressed: onDelete,
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(minWidth: 24, minHeight: 24),
                ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.textPrimary,
              fontSize: 14,
            ),
          ),
          if (content != null && content!.isNotEmpty) ...[
            const SizedBox(height: 6),
            Text(
              content!,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontSize: 13,
              ),
              maxLines: 3,
              overflow: TextOverflow.ellipsis,
            ),
          ],
          if (authorName != null || createdAt != null) ...[
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if (authorName != null)
                  Text(
                    authorName!,
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                      fontStyle: FontStyle.italic,
                    ),
                  ),
                if (createdAt != null)
                  Text(
                    _formatDate(createdAt!),
                    style: const TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 11,
                    ),
                  ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date);

    if (difference.inDays == 0) {
      return 'Hoy';
    } else if (difference.inDays == 1) {
      return 'Ayer';
    } else if (difference.inDays < 7) {
      return 'Hace ${difference.inDays} días';
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}
