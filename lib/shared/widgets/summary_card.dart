import 'package:flutter/material.dart';

import 'package:zeroed/core/theme/app_colors.dart';
import 'package:zeroed/core/theme/app_spacing.dart';
import 'package:zeroed/core/theme/app_text_styles.dart';

/// Summary card for dashboard metrics (outstanding, overdue, paid).
///
/// Matches design component: SummaryCard (ui46f)
class SummaryCard extends StatelessWidget {
  const SummaryCard({
    super.key,
    required this.label,
    required this.amount,
    required this.subtitle,
    this.amountColor,
  });

  final String label;
  final String amount;
  final String subtitle;
  final Color? amountColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: AppRadius.cardBorder,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(label, style: AppTextStyles.label),
          const SizedBox(height: AppSpacing.sm),
          Text(
            amount,
            style: AppTextStyles.monoAmount.copyWith(
              color: amountColor ?? AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(subtitle, style: AppTextStyles.bodySmall),
        ],
      ),
    );
  }
}
