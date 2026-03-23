import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';

import 'package:zeroed/core/theme/app_colors.dart';
import 'package:zeroed/core/theme/app_spacing.dart';
import 'package:zeroed/core/theme/app_text_styles.dart';
import 'package:zeroed/models/invoice_status.dart';
import 'package:zeroed/shared/widgets/status_badge.dart';

/// Row tile for an invoice in a list.
///
/// Matches design component: InvoiceRow (uuHGP)
class InvoiceRow extends StatelessWidget {
  const InvoiceRow({
    super.key,
    required this.clientName,
    required this.invoiceNumber,
    required this.dateLabel,
    required this.amount,
    required this.status,
    this.onTap,
  });

  final String clientName;
  final String invoiceNumber;
  final String dateLabel;
  final String amount;
  final InvoiceStatus status;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(AppSpacing.lg),
        decoration: BoxDecoration(
          color: AppColors.bgCard,
          borderRadius: AppRadius.cardBorder,
        ),
        child: Row(
          children: [
            // Left side — client name + meta
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    clientName,
                    style: GoogleFonts.inter(
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: AppSpacing.xs),
                  Row(
                    children: [
                      Text(
                        invoiceNumber,
                        style: GoogleFonts.jetBrainsMono(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textTertiary,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 6),
                        child: Icon(
                          LucideIcons.dot,
                          size: 12,
                          color: AppColors.textTertiary,
                        ),
                      ),
                      Text(
                        dateLabel,
                        style: GoogleFonts.inter(
                          fontSize: 12,
                          fontWeight: FontWeight.w400,
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            // Right side — amount + badge
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(amount, style: AppTextStyles.monoBody),
                const SizedBox(height: 6),
                StatusBadge(status: status),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
