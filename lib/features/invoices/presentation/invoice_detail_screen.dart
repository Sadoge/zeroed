import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:printing/printing.dart';

import 'package:zeroed/core/services/pdf_service.dart';
import 'package:zeroed/core/theme/app_colors.dart';
import 'package:zeroed/core/theme/app_spacing.dart';
import 'package:zeroed/core/theme/app_text_styles.dart';
import 'package:zeroed/features/dashboard/presentation/dashboard_view_model.dart';
import 'package:zeroed/models/invoice_model.dart';
import 'package:zeroed/models/invoice_status.dart';
import 'package:zeroed/models/line_item_model.dart';
import 'package:zeroed/shared/widgets/app_back_button.dart';
import 'package:zeroed/shared/widgets/app_button.dart';
import 'package:zeroed/shared/widgets/section_header.dart';
import 'package:zeroed/shared/widgets/status_badge.dart';

final _currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
final _dateFormat = DateFormat('MMM d, y');
final _shortDate = DateFormat('MMM d');

@RoutePage()
class InvoiceDetailScreen extends ConsumerWidget {
  const InvoiceDetailScreen({
    super.key,
    @PathParam('id') required this.invoiceId,
  });

  final String invoiceId;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final invoices = ref.watch(recentInvoicesProvider);
    final invoice = invoices.firstWhere(
      (i) => i.id == invoiceId,
      orElse: () => _fallbackInvoice(),
    );
    final cName = clientNameForId(invoice.clientId);

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.lg),
              _Header(invoice: invoice, clientName: cName),
              const SizedBox(height: AppSpacing.sectionGap),
              _Timeline(invoice: invoice),
              const SizedBox(height: AppSpacing.sectionGap),
              _AmountCard(invoice: invoice),
              const SizedBox(height: AppSpacing.sectionGap),
              _DetailsSection(invoice: invoice, clientName: cName),
              const SizedBox(height: AppSpacing.sectionGap),
              _ActionsSection(invoice: invoice, clientName: cName),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════

class _Header extends StatelessWidget {
  const _Header({required this.invoice, required this.clientName});
  final Invoice invoice;
  final String clientName;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppBackButton(onTap: () => context.router.maybePop()),
        Column(
          children: [
            Text(
              invoice.invoiceNumber,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              clientName,
              style: GoogleFonts.inter(
                fontSize: 13,
                color: AppColors.textSecondary,
              ),
            ),
          ],
        ),
        Container(
          width: AppSizing.iconButtonSize,
          height: AppSizing.iconButtonSize,
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: AppRadius.iconButtonBorder,
          ),
          child: Center(
            child: Icon(
              LucideIcons.ellipsisVertical,
              size: AppSizing.iconMd,
              color: AppColors.textSecondary,
            ),
          ),
        ),
      ],
    );
  }
}

// ─── Status Timeline ──────────────────────────────────────────

class _Timeline extends StatelessWidget {
  const _Timeline({required this.invoice});
  final Invoice invoice;

  static const _steps = ['Created', 'Sent', 'Overdue', 'Paid'];

  int get _activeIndex => switch (invoice.status) {
        InvoiceStatus.draft => 0,
        InvoiceStatus.sent => 1,
        InvoiceStatus.viewed => 1,
        InvoiceStatus.overdue => 2,
        InvoiceStatus.paid => 3,
      };

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md, vertical: AppSpacing.lg),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: AppRadius.cardBorder,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: List.generate(_steps.length * 2 - 1, (i) {
          if (i.isOdd) return _buildLine(i ~/ 2);
          final stepIndex = i ~/ 2;
          return _buildStep(stepIndex);
        }),
      ),
    );
  }

  Widget _buildStep(int index) {
    final isComplete = index <= _activeIndex;
    final isCurrent = index == _activeIndex;
    final color = _stepColor(index, isComplete, isCurrent);

    String dateText = '—';
    if (index == 0) {
      dateText = _shortDate.format(invoice.createdAt);
    } else if (index == 1 && invoice.sentAt != null) {
      dateText = _shortDate.format(invoice.sentAt!);
    } else if (index == 2 && invoice.status == InvoiceStatus.overdue) {
      dateText = _shortDate.format(invoice.dueDate);
    } else if (index == 3 && invoice.paidAt != null) {
      dateText = _shortDate.format(invoice.paidAt!);
    }

    return Column(
      children: [
        Container(
          width: 24,
          height: 24,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: isComplete ? color : AppColors.bgInset,
            border: !isComplete
                ? Border.all(color: AppColors.border, width: 1.5)
                : null,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          _steps[index],
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: isCurrent ? FontWeight.w600 : FontWeight.w500,
            color: isCurrent ? color : AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 2),
        Text(
          dateText,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 9,
            color: isComplete ? AppColors.textTertiary : AppColors.textMuted,
          ),
        ),
      ],
    );
  }

  Widget _buildLine(int afterStep) {
    final isComplete = afterStep < _activeIndex;
    final color = isComplete
        ? _stepColor(afterStep + 1, true, afterStep + 1 == _activeIndex)
        : AppColors.border;

    return Expanded(
      child: Padding(
        padding: const EdgeInsets.only(bottom: 24),
        child: Container(height: 2, color: color),
      ),
    );
  }

  Color _stepColor(int index, bool isComplete, bool isCurrent) {
    if (index == 2 && (isCurrent || isComplete) && invoice.status == InvoiceStatus.overdue) {
      return AppColors.statusOverdue;
    }
    if (isComplete) return AppColors.statusPaid;
    return AppColors.border;
  }
}

// ─── Amount Card ──────────────────────────────────────────────

class _AmountCard extends StatelessWidget {
  const _AmountCard({required this.invoice});
  final Invoice invoice;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.xl, vertical: AppSpacing.xxl),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: AppRadius.cardBorder,
      ),
      child: Column(
        children: [
          Text('TOTAL AMOUNT', style: AppTextStyles.label),
          const SizedBox(height: AppSpacing.sm),
          Text(
            _currencyFormat.format(invoice.total),
            style: AppTextStyles.monoLarge,
          ),
          const SizedBox(height: AppSpacing.sm),
          StatusBadge(status: invoice.status),
        ],
      ),
    );
  }
}

// ─── Details Section ──────────────────────────────────────────

class _DetailsSection extends StatelessWidget {
  const _DetailsSection({required this.invoice, required this.clientName});
  final Invoice invoice;
  final String clientName;

  @override
  Widget build(BuildContext context) {
    final isDue = invoice.status == InvoiceStatus.overdue;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'DETAILS'),
        const SizedBox(height: AppSpacing.md),
        _DetailRow(label: 'Client', value: clientName),
        const SizedBox(height: AppSpacing.md),
        _DetailRow(
          label: 'Due Date',
          value: _dateFormat.format(invoice.dueDate),
          valueColor: isDue ? AppColors.statusOverdue : null,
        ),
        const SizedBox(height: AppSpacing.md),
        _DetailRow(
          label: 'Line Items',
          value:
              '${invoice.lineItems.length} item${invoice.lineItems.length != 1 ? 's' : ''}',
        ),
        const SizedBox(height: AppSpacing.md),
        _DetailRow(
          label: 'Tax',
          value: _currencyFormat.format(invoice.taxAmount),
          mono: true,
        ),
      ],
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.label,
    required this.value,
    this.valueColor,
    this.mono = false,
  });
  final String label;
  final String value;
  final Color? valueColor;
  final bool mono;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          label,
          style: GoogleFonts.inter(fontSize: 14, color: AppColors.textSecondary),
        ),
        Text(
          value,
          style: mono
              ? GoogleFonts.jetBrainsMono(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: valueColor ?? AppColors.textPrimary,
                )
              : GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: valueColor ?? AppColors.textPrimary,
                ),
        ),
      ],
    );
  }
}

// ─── Actions Section ──────────────────────────────────────────

class _ActionsSection extends StatelessWidget {
  const _ActionsSection({required this.invoice, required this.clientName});
  final Invoice invoice;
  final String clientName;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (invoice.status == InvoiceStatus.overdue) ...[
          AppButton(
            label: 'Send Reminder',
            icon: LucideIcons.send,
            variant: AppButtonVariant.danger,
            onPressed: () {
              // TODO: send reminder
            },
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        AppButton(
          label: 'Mark as Paid',
          icon: LucideIcons.circleCheck,
          variant: AppButtonVariant.secondary,
          color: null,
          onPressed: () {
            // TODO: mark as paid
          },
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _TextAction(
              label: 'Duplicate',
              onTap: () {
                // TODO: duplicate invoice
              },
            ),
            _dot(),
            _TextAction(
              label: 'Download PDF',
              onTap: () => _downloadPdf(context),
            ),
            _dot(),
            _TextAction(
              label: 'Delete',
              color: const Color(0xFFEF4444),
              onTap: () {
                // TODO: delete invoice
              },
            ),
          ],
        ),
      ],
    );
  }

  Widget _dot() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 6),
      child: Text(
        '·',
        style: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: AppColors.textTertiary,
        ),
      ),
    );
  }

  Future<void> _downloadPdf(BuildContext context) async {
    final pdfBytes = await PdfService.instance.generateInvoicePdf(
      invoice: invoice,
      clientName: clientName,
      clientEmail:
          '${clientName.toLowerCase().replaceAll(' ', '')}@example.com',
    );
    await Printing.sharePdf(
      bytes: pdfBytes,
      filename: '${invoice.invoiceNumber}.pdf',
    );
  }
}

class _TextAction extends StatelessWidget {
  const _TextAction({
    required this.label,
    required this.onTap,
    this.color,
  });
  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Text(
        label,
        style: GoogleFonts.inter(
          fontSize: 13,
          fontWeight: FontWeight.w500,
          color: color ?? AppColors.textTertiary,
        ),
      ),
    );
  }
}

// ─── Fallback ─────────────────────────────────────────────────

Invoice _fallbackInvoice() => Invoice(
      id: 'unknown',
      userId: 'demo',
      invoiceNumber: 'INV-000',
      lineItems: const [
        LineItem(id: '1', description: 'Service', unitPrice: 0),
      ],
      dueDate: DateTime.now(),
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
