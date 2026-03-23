import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:printing/printing.dart';

import 'package:zeroed/core/services/pdf_service.dart';
import 'package:zeroed/core/services/stripe_service.dart';
import 'package:zeroed/core/theme/app_colors.dart';
import 'package:zeroed/core/theme/app_spacing.dart';
import 'package:zeroed/core/theme/app_text_styles.dart';
import 'package:zeroed/features/clients/data/client_repository.dart';
import 'package:zeroed/features/dashboard/presentation/dashboard_view_model.dart';
import 'package:zeroed/features/invoices/data/invoice_repository.dart';
import 'package:zeroed/features/reminders/data/reminder_repository.dart';
import 'package:zeroed/features/settings/presentation/settings_view_model.dart';
import 'package:zeroed/models/client_model.dart';
import 'package:zeroed/models/invoice_model.dart';
import 'package:zeroed/models/invoice_status.dart';
import 'package:zeroed/models/line_item_model.dart';
import 'package:zeroed/shared/widgets/app_back_button.dart';
import 'package:zeroed/shared/widgets/app_button.dart';

import 'package:zeroed/core/utils/currency_utils.dart';

final _dateFormat = DateFormat('MMM d, y');

@RoutePage()
class InvoicePreviewScreen extends ConsumerStatefulWidget {
  const InvoicePreviewScreen({
    super.key,
    @PathParam('id') required this.invoiceId,
  });

  final String invoiceId;

  @override
  ConsumerState<InvoicePreviewScreen> createState() =>
      _InvoicePreviewScreenState();
}

class _InvoicePreviewScreenState extends ConsumerState<InvoicePreviewScreen> {
  Invoice? _invoice;
  Client? _client;
  String? _businessName;
  bool _loading = true;
  bool _isSending = false;

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

    final profile = await ref.read(businessProfileProvider.future);

    if (mounted) {
      setState(() {
        _invoice = invoice;
        _client = client;
        _businessName = profile?.businessName;
        _loading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        backgroundColor: AppColors.bgPrimary,
        body: Center(child: CircularProgressIndicator(color: AppColors.accent)),
      );
    }

    final invoice = _invoice;
    if (invoice == null) {
      return Scaffold(
        backgroundColor: AppColors.bgPrimary,
        body: Center(
          child: Text('Invoice not found', style: AppTextStyles.body),
        ),
      );
    }

    final clientName = _client?.name ?? 'Unknown';
    final clientEmail = _client?.email ?? '';

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: Column(
          children: [
            // Header
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.lg,
                AppSpacing.xl,
                0,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  AppBackButton(onTap: () => context.router.maybePop()),
                  Text('Preview', style: AppTextStyles.heading2),
                  const SizedBox(width: AppSizing.iconButtonSize),
                ],
              ),
            ),

            // Invoice document
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(AppSpacing.xl),
                child: _InvoiceDocument(
                  invoice: invoice,
                  clientName: clientName,
                  clientEmail: clientEmail,
                  businessName: _businessName,
                ),
              ),
            ),

            // Action buttons
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.md,
                AppSpacing.xl,
                AppSpacing.xxl,
              ),
              child: Column(
                children: [
                  AppButton(
                    label: 'Edit',
                    icon: LucideIcons.pencil,
                    variant: AppButtonVariant.secondary,
                    onPressed: () => context.router.maybePop(),
                  ),
                  const SizedBox(height: AppSpacing.md),
                  AppButton(
                    label: 'Send Invoice',
                    icon: LucideIcons.send,
                    isLoading: _isSending,
                    onPressed: () =>
                        _handleSend(invoice, clientName, clientEmail),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _handleSend(
    Invoice invoice,
    String clientName,
    String clientEmail,
  ) async {
    setState(() => _isSending = true);
    try {
      // Try to generate a Stripe payment link
      String? paymentLink;
      try {
        paymentLink = await ref
            .read(stripeServiceProvider)
            .createPaymentLink(
              invoice: invoice,
              clientName: clientName,
              clientEmail: clientEmail,
            );
      } catch (_) {
        // Stripe not connected or failed — continue without payment link
      }

      // Update invoice status to sent
      final now = DateTime.now();
      final sentInvoice = invoice.copyWith(
        status: InvoiceStatus.sent,
        sentAt: now,
        stripePaymentLink: paymentLink,
        updatedAt: now,
      );
      await ref.read(invoiceRepositoryProvider).updateInvoice(sentInvoice);

      // Schedule reminders (3, 7, 14 days)
      try {
        await ref
            .read(reminderRepositoryProvider)
            .scheduleReminders(invoiceId: invoice.id, sentAt: now);
      } catch (_) {
        // Non-critical — reminders can be retried
      }

      // Send invoice email
      if (clientEmail.isNotEmpty) {
        try {
          await ref
              .read(reminderRepositoryProvider)
              .sendInvoiceEmail(
                invoiceId: invoice.id,
                invoiceNumber: invoice.invoiceNumber,
                clientName: clientName,
                clientEmail: clientEmail,
                amount: invoice.total,
                currency: invoice.currency,
                paymentLink: paymentLink,
              );
        } catch (_) {
          // Email send failed — still share PDF as fallback
        }
      }

      // Refresh invoice list
      ref.invalidate(allInvoicesProvider);

      // Share PDF
      final pdfBytes = await PdfService.instance.generateInvoicePdf(
        invoice: invoice,
        clientName: clientName,
        clientEmail: clientEmail,
        businessName: _businessName,
        paymentLink: paymentLink,
      );

      await Printing.sharePdf(
        bytes: pdfBytes,
        filename: '${invoice.invoiceNumber}.pdf',
      );
    } finally {
      if (mounted) setState(() => _isSending = false);
    }
  }
}

// ═══════════════════════════════════════════════════════════════
// White invoice document card (matches design exactly)
// ═══════════════════════════════════════════════════════════════

class _InvoiceDocument extends StatelessWidget {
  const _InvoiceDocument({
    required this.invoice,
    required this.clientName,
    required this.clientEmail,
    this.businessName,
  });

  final Invoice invoice;
  final String clientName;
  final String clientEmail;
  final String? businessName;

  static const _dark = Color(0xFF0A0F1C);
  static const _body = Color(0xFF0F172A);
  static const _muted = Color(0xFF64748B);
  static const _label = Color(0xFF94A3B8);
  static const _border = Color(0xFFE2E8F0);
  static const _accent = Color(0xFF22D3EE);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 28),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: AppRadius.cardBorder,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 24),
          _buildBillTo(),
          const SizedBox(height: 24),
          const Divider(color: _border, height: 1),
          const SizedBox(height: 12),
          _buildTableHeader(),
          const SizedBox(height: 8),
          ...invoice.lineItems.map(_buildLineRow),
          const SizedBox(height: 12),
          const Divider(color: _border, height: 1),
          const SizedBox(height: 12),
          _buildTotals(),
          const SizedBox(height: 24),
          _buildPayButton(),
          const SizedBox(height: 16),
          _buildTerms(),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ZEROED',
              style: GoogleFonts.jetBrainsMono(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: _dark,
              ),
            ),
            if (businessName != null && businessName!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                businessName!,
                style: GoogleFonts.inter(fontSize: 11, color: _muted),
              ),
            ],
          ],
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              'INVOICE',
              style: GoogleFonts.inter(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 2,
                color: _label,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              invoice.invoiceNumber,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: _dark,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              _dateFormat.format(invoice.createdAt),
              style: GoogleFonts.inter(fontSize: 11, color: _muted),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildBillTo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'BILL TO',
          style: GoogleFonts.inter(
            fontSize: 10,
            fontWeight: FontWeight.w600,
            letterSpacing: 2,
            color: _label,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          clientName,
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: _dark,
          ),
        ),
        if (clientEmail.isNotEmpty) ...[
          const SizedBox(height: 2),
          Text(
            clientEmail,
            style: GoogleFonts.inter(fontSize: 11, color: _muted),
          ),
        ],
      ],
    );
  }

  Widget _buildTableHeader() {
    return Row(
      children: [
        Expanded(
          child: Text(
            'Description',
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
              color: _label,
            ),
          ),
        ),
        SizedBox(
          width: 36,
          child: Text(
            'QTY',
            textAlign: TextAlign.center,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
              color: _label,
            ),
          ),
        ),
        SizedBox(
          width: 60,
          child: Text(
            'RATE',
            textAlign: TextAlign.right,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
              color: _label,
            ),
          ),
        ),
        SizedBox(
          width: 72,
          child: Text(
            'AMOUNT',
            textAlign: TextAlign.right,
            style: GoogleFonts.inter(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              letterSpacing: 1,
              color: _label,
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildLineRow(LineItem item) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Expanded(
            child: Text(
              item.description,
              style: GoogleFonts.inter(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: _body,
              ),
            ),
          ),
          SizedBox(
            width: 36,
            child: Text(
              item.quantity.toStringAsFixed(0),
              textAlign: TextAlign.center,
              style: GoogleFonts.jetBrainsMono(fontSize: 12, color: _muted),
            ),
          ),
          SizedBox(
            width: 60,
            child: Text(
              formatCurrency(item.unitPrice, invoice.currency),
              textAlign: TextAlign.right,
              style: GoogleFonts.jetBrainsMono(fontSize: 12, color: _muted),
            ),
          ),
          SizedBox(
            width: 72,
            child: Text(
              formatCurrency(item.amount, invoice.currency),
              textAlign: TextAlign.right,
              style: GoogleFonts.jetBrainsMono(
                fontSize: 12,
                fontWeight: FontWeight.w500,
                color: _body,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTotals() {
    return Align(
      alignment: Alignment.centerRight,
      child: SizedBox(
        width: 180,
        child: Column(
          children: [
            _buildTotalRow(
              'Subtotal',
              formatCurrency(invoice.subtotal, invoice.currency),
            ),
            if (invoice.taxRate != null && invoice.taxRate! > 0) ...[
              const SizedBox(height: 6),
              _buildTotalRow(
                'Tax (${invoice.taxRate!.toStringAsFixed(0)}%)',
                formatCurrency(invoice.taxAmount, invoice.currency),
              ),
            ],
            const SizedBox(height: 8),
            const Divider(color: _border, height: 1),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Total',
                  style: GoogleFonts.inter(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: _dark,
                  ),
                ),
                Text(
                  formatCurrency(invoice.total, invoice.currency),
                  style: GoogleFonts.jetBrainsMono(
                    fontSize: 18,
                    fontWeight: FontWeight.w700,
                    color: _dark,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTotalRow(String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: GoogleFonts.inter(fontSize: 12, color: _muted)),
        Text(
          value,
          style: GoogleFonts.jetBrainsMono(
            fontSize: 12,
            fontWeight: FontWeight.w500,
            color: _body,
          ),
        ),
      ],
    );
  }

  Widget _buildPayButton() {
    return Container(
      width: double.infinity,
      height: 44,
      decoration: BoxDecoration(
        color: _accent,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Center(
        child: Text(
          'Pay Now — ${formatCurrency(invoice.total, invoice.currency)}',
          style: GoogleFonts.inter(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: _dark,
          ),
        ),
      ),
    );
  }

  Widget _buildTerms() {
    return Center(
      child: Text(
        'Payment due within 30 days. Late payments subject to 1.5% monthly interest.',
        textAlign: TextAlign.center,
        style: GoogleFonts.inter(fontSize: 9, color: _label),
      ),
    );
  }
}
