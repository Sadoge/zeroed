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
import 'package:zeroed/features/clients/data/client_repository.dart';
import 'package:zeroed/features/dashboard/presentation/dashboard_view_model.dart';
import 'package:zeroed/features/invoices/data/invoice_repository.dart';
import 'package:zeroed/features/reminders/data/reminder_repository.dart';
import 'package:zeroed/models/client_model.dart';
import 'package:zeroed/models/invoice_model.dart';
import 'package:zeroed/models/invoice_status.dart';
import 'package:zeroed/shared/widgets/app_back_button.dart';
import 'package:zeroed/shared/widgets/app_button.dart';
import 'package:zeroed/shared/widgets/section_header.dart';
import 'package:zeroed/shared/widgets/status_badge.dart';

import 'package:zeroed/core/utils/currency_utils.dart';

final _dateFormat = DateFormat('MMM d, y');
final _shortDate = DateFormat('MMM d');

@RoutePage()
class InvoiceDetailScreen extends ConsumerStatefulWidget {
  const InvoiceDetailScreen({
    super.key,
    @PathParam('id') required this.invoiceId,
  });

  final String invoiceId;

  @override
  ConsumerState<InvoiceDetailScreen> createState() =>
      _InvoiceDetailScreenState();
}

class _InvoiceDetailScreenState extends ConsumerState<InvoiceDetailScreen> {
  Invoice? _invoice;
  Client? _client;
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _loadData();
  }

  Future<void> _loadData() async {
    final invoice = await ref
        .read(invoiceRepositoryProvider)
        .getInvoice(widget.invoiceId);

    Client? client;
    if (invoice?.clientId != null) {
      final clients = await ref.read(clientRepositoryProvider).getClients();
      client = clients.where((c) => c.id == invoice!.clientId).firstOrNull;
    }

    if (mounted) {
      setState(() {
        _invoice = invoice;
        _client = client;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: AppColors.bgPrimary,
        body: Center(
            child: CircularProgressIndicator(color: AppColors.accent)),
      );
    }

    final invoice = _invoice;
    if (invoice == null) {
      return Scaffold(
        backgroundColor: AppColors.bgPrimary,
        body: Center(
          child: Text(
            'Invoice not found',
            style: AppTextStyles.body.copyWith(color: AppColors.textMuted),
          ),
        ),
      );
    }

    final clientName = _client?.name ?? 'Unknown';
    final clientEmail = _client?.email ?? '';

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.lg),
              _Header(invoice: invoice, clientName: clientName),
              const SizedBox(height: AppSpacing.sectionGap),
              _Timeline(invoice: invoice),
              const SizedBox(height: AppSpacing.sectionGap),
              _AmountCard(invoice: invoice),
              const SizedBox(height: AppSpacing.sectionGap),
              _DetailsSection(invoice: invoice, clientName: clientName),
              const SizedBox(height: AppSpacing.sectionGap),
              _ActionsSection(
                invoice: invoice,
                clientName: clientName,
                clientEmail: clientEmail,
                ref: ref,
              ),
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
        horizontal: AppSpacing.md,
        vertical: AppSpacing.lg,
      ),
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
    if (index == 2 &&
        (isCurrent || isComplete) &&
        invoice.status == InvoiceStatus.overdue) {
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
        horizontal: AppSpacing.xl,
        vertical: AppSpacing.xxl,
      ),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: AppRadius.cardBorder,
      ),
      child: Column(
        children: [
          Text('TOTAL AMOUNT', style: AppTextStyles.label),
          const SizedBox(height: AppSpacing.sm),
          Text(
            currencyFormat(invoice.currency).format(invoice.total),
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
        if (invoice.taxRate != null && invoice.taxRate! > 0) ...[
          const SizedBox(height: AppSpacing.md),
          _DetailRow(
            label: 'Tax (${invoice.taxRate!.toStringAsFixed(0)}%)',
            value: currencyFormat(invoice.currency).format(invoice.taxAmount),
            mono: true,
          ),
        ],
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
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
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
  const _ActionsSection({
    required this.invoice,
    required this.clientName,
    required this.clientEmail,
    required this.ref,
  });
  final Invoice invoice;
  final String clientName;
  final String clientEmail;
  final WidgetRef ref;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (invoice.status == InvoiceStatus.overdue) ...[
          AppButton(
            label: 'Send Reminder',
            icon: LucideIcons.send,
            variant: AppButtonVariant.danger,
            onPressed: () => _sendReminder(context),
          ),
          const SizedBox(height: AppSpacing.md),
        ],
        AppButton(
          label: 'Mark as Paid',
          icon: LucideIcons.circleCheck,
          variant: AppButtonVariant.secondary,
          color: null,
          onPressed: () => _markAsPaid(context),
        ),
        const SizedBox(height: AppSpacing.md),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _TextAction(label: 'Duplicate', onTap: () => _duplicate(context)),
            _dot(),
            _TextAction(
              label: 'Download PDF',
              onTap: () => _downloadPdf(context),
            ),
            _dot(),
            _TextAction(
              label: 'Delete',
              color: const Color(0xFFEF4444),
              onTap: () => _delete(context),
            ),
          ],
        ),
      ],
    );
  }

  Future<void> _sendReminder(BuildContext context) async {
    try {
      await ref
          .read(reminderRepositoryProvider)
          .sendReminderEmail(
            invoiceId: invoice.id,
            invoiceNumber: invoice.invoiceNumber,
            clientName: clientName,
            clientEmail: clientEmail,
            amount: invoice.total,
            currency: invoice.currency,
          );
      if (context.mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text('Reminder sent')));
      }
    } catch (_) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Failed to send reminder')),
        );
      }
    }
  }

  Future<void> _markAsPaid(BuildContext context) async {
    final now = DateTime.now();
    final updated = invoice.copyWith(
      status: InvoiceStatus.paid,
      paidAt: now,
      updatedAt: now,
    );

    await ref.read(invoiceRepositoryProvider).updateInvoice(updated);
    ref.invalidate(allInvoicesProvider);

    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invoice marked as paid')));
      context.router.maybePop();
    }
  }

  Future<void> _duplicate(BuildContext context) async {
    final newInvoice = invoice.copyWith(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      status: InvoiceStatus.draft,
      invoiceNumber: '${invoice.invoiceNumber}-COPY',
      sentAt: null,
      paidAt: null,
      stripePaymentLink: null,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );
    await ref.read(invoiceRepositoryProvider).createInvoice(newInvoice);
    ref.invalidate(allInvoicesProvider);
    if (context.mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Invoice duplicated')));
    }
  }

  Future<void> _delete(BuildContext context) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: AppColors.bgCard,
        title: Text('Delete Invoice', style: AppTextStyles.heading3),
        content: Text(
          'Are you sure you want to delete ${invoice.invoiceNumber}?',
          style: GoogleFonts.inter(
            fontSize: 14,
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(false),
            child: Text(
              'Cancel',
              style: GoogleFonts.inter(color: AppColors.textSecondary),
            ),
          ),
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(true),
            child: Text(
              'Delete',
              style: GoogleFonts.inter(color: const Color(0xFFEF4444)),
            ),
          ),
        ],
      ),
    );

    if (confirmed == true) {
      await ref.read(invoiceRepositoryProvider).deleteInvoice(invoice.id);
      ref.invalidate(allInvoicesProvider);
      if (context.mounted) {
        context.router.maybePop();
      }
    }
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
      clientEmail: clientEmail,
    );
    await Printing.sharePdf(
      bytes: pdfBytes,
      filename: '${invoice.invoiceNumber}.pdf',
    );
  }
}

class _TextAction extends StatelessWidget {
  const _TextAction({required this.label, required this.onTap, this.color});
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


