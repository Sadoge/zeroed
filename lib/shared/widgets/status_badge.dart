import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'package:zeroed/core/theme/app_spacing.dart';
import 'package:zeroed/models/invoice_status.dart';

/// Pill-shaped badge displaying an invoice status.
///
/// Matches design component: StatusBadge/* (MecNw, yS76W, R4lKz, 06lI8, ISeep)
class StatusBadge extends StatelessWidget {
  const StatusBadge({super.key, required this.status});

  final InvoiceStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: AppSpacing.xs),
      decoration: BoxDecoration(
        color: status.backgroundColor,
        borderRadius: AppRadius.pillBorder,
      ),
      child: Text(
        status.label,
        style: GoogleFonts.inter(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          letterSpacing: 0.5,
          color: status.color,
        ),
      ),
    );
  }
}
