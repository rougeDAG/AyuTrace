import 'package:flutter/material.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_typography.dart';

class AiAnalyticsCard extends StatefulWidget {
  final String analyticsText;

  const AiAnalyticsCard({super.key, required this.analyticsText});

  @override
  State<AiAnalyticsCard> createState() => _AiAnalyticsCardState();
}

class _AiAnalyticsCardState extends State<AiAnalyticsCard> {
  bool _isVisible = true;

  @override
  Widget build(BuildContext context) {
    if (!_isVisible) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.06),
            blurRadius: 12,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                'AI Analytics ',
                style: AppTypography.titleSmall.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const Text('✨', style: TextStyle(fontSize: 16)),
              const Text(':', style: TextStyle(fontSize: 14)),
              const Spacer(),
              GestureDetector(
                onTap: () => setState(() => _isVisible = false),
                child: Container(
                  width: 24,
                  height: 24,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: AppColors.textHint),
                  ),
                  child: Icon(Icons.close, size: 14, color: AppColors.textHint),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            widget.analyticsText,
            style: AppTypography.bodyMedium.copyWith(
              color: AppColors.textSecondary,
              height: 1.5,
            ),
          ),
        ],
      ),
    );
  }
}
