import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/product_summary.dart';
import 'package:intl/intl.dart';

class ProductGridItem extends StatelessWidget {
  final ProductSummary product;
  final VoidCallback? onTap;

  const ProductGridItem({super.key, required this.product, this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: SizedBox(
        width: double.infinity, // ✅ Forces proper width constraint
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Container(
              width: double.infinity,
              height: 90,
              decoration: BoxDecoration(
                color: AppColors.cardBackgroundLight,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.06),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: Image.asset(
                  product.imageUrl,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Container(
                    color: AppColors.cardBackground,
                    child: Icon(
                      Icons.local_florist,
                      size: 36,
                      color: AppColors.primary.withValues(alpha: 0.3),
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
            Text(
              product.name,
              textAlign: TextAlign.center,
              style: AppTypography.bodySmall.copyWith(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            Text(
              _formatDate(product.lastUpdated),
              textAlign: TextAlign.center,
              maxLines: 1, // ✅ Prevents horizontal overflow
              overflow: TextOverflow.ellipsis,
              style: AppTypography.labelSmall.copyWith(
                color: const Color.fromARGB(255, 255, 248, 231),
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final diff = now.difference(date);

    if (diff.inDays == 0) return 'Updated today';
    if (diff.inDays == 1) return 'Updated yesterday';
    if (diff.inDays < 7) return 'Updated ${diff.inDays} days ago';
    return 'Updated ${DateFormat('MMM d').format(date)}';
  }
}
