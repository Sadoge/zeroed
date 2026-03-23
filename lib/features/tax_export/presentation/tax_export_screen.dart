import 'dart:convert';

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:lucide_icons_flutter/lucide_icons.dart';
import 'package:printing/printing.dart';
import 'package:share_plus/share_plus.dart';

import 'package:zeroed/core/theme/app_colors.dart';
import 'package:zeroed/core/theme/app_spacing.dart';
import 'package:zeroed/core/theme/app_text_styles.dart';
import 'package:zeroed/features/dashboard/presentation/dashboard_view_model.dart';
import 'package:zeroed/features/tax_export/presentation/tax_export_view_model.dart';
import 'package:zeroed/shared/widgets/app_back_button.dart';
import 'package:zeroed/shared/widgets/app_button.dart';
import 'package:zeroed/shared/widgets/section_header.dart';

import 'package:zeroed/core/utils/currency_utils.dart';
final _dateFormat = DateFormat('MMM d');

@RoutePage()
class TaxExportScreen extends ConsumerWidget {
  const TaxExportScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final period = ref.watch(exportPeriodNotifierProvider);
    final summaryAsync = ref.watch(exportSummaryProvider);

    final year = DateTime.now().year;
    final dateLabel = '${_dateFormat.format(period.start)} '
        '– ${_dateFormat.format(period.end)}, $year';

    return Scaffold(
      backgroundColor: AppColors.bgPrimary,
      body: SafeArea(
        child: SingleChildScrollView(
          padding: AppSpacing.screenPadding,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: AppSpacing.lg),
              _buildHeader(context),
              const SizedBox(height: AppSpacing.sectionGap),
              _buildPeriodSection(ref, period, dateLabel),
              const SizedBox(height: AppSpacing.sectionGap),
              _buildSummarySection(summaryAsync),
              const SizedBox(height: AppSpacing.sectionGap),
              _buildDownloadSection(context, ref),
              const SizedBox(height: AppSpacing.xxl),
            ],
          ),
        ),
      ),
    );
  }

  // ─── Header ──────────────────────────────────────────────────

  Widget _buildHeader(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        AppBackButton(onTap: () => context.router.maybePop()),
        Text('Tax Export', style: AppTextStyles.heading2),
        const SizedBox(width: AppSizing.iconButtonSize),
      ],
    );
  }

  // ─── Period Section ──────────────────────────────────────────

  Widget _buildPeriodSection(
      WidgetRef ref, ExportPeriod period, String dateLabel) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'PERIOD'),
        const SizedBox(height: AppSpacing.md),

        // Row 1
        Row(
          children: [
            Expanded(
                child: _PeriodChip(
              label: 'This Month',
              selected: period.preset == PeriodPreset.thisMonth,
              onTap: () => ref
                  .read(exportPeriodNotifierProvider.notifier)
                  .setPreset(PeriodPreset.thisMonth),
            )),
            const SizedBox(width: 8),
            Expanded(
                child: _PeriodChip(
              label: 'Last Month',
              selected: period.preset == PeriodPreset.lastMonth,
              onTap: () => ref
                  .read(exportPeriodNotifierProvider.notifier)
                  .setPreset(PeriodPreset.lastMonth),
            )),
          ],
        ),
        const SizedBox(height: 8),

        // Row 2
        Row(
          children: [
            Expanded(
                child: _PeriodChip(
              label: 'This Quarter',
              selected: period.preset == PeriodPreset.thisQuarter,
              onTap: () => ref
                  .read(exportPeriodNotifierProvider.notifier)
                  .setPreset(PeriodPreset.thisQuarter),
            )),
            const SizedBox(width: 8),
            Expanded(
                child: _PeriodChip(
              label: 'This Year',
              selected: period.preset == PeriodPreset.thisYear,
              onTap: () => ref
                  .read(exportPeriodNotifierProvider.notifier)
                  .setPreset(PeriodPreset.thisYear),
            )),
            const SizedBox(width: 8),
            Expanded(
                child: _PeriodChip(
              label: 'Custom',
              selected: period.preset == PeriodPreset.custom,
              onTap: () => _pickDateRange(ref),
            )),
          ],
        ),
        const SizedBox(height: 12),

        // Date range display
        Container(
          height: AppSizing.inputHeight,
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg),
          decoration: BoxDecoration(
            color: AppColors.bgCard,
            borderRadius: AppRadius.inputBorder,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(LucideIcons.calendar,
                  size: 16, color: AppColors.textSecondary),
              Text(
                dateLabel,
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  void _pickDateRange(WidgetRef ref) {
    // Preset to custom — in production a date picker would open here
    ref.read(exportPeriodNotifierProvider.notifier).setPreset(PeriodPreset.custom);
  }

  // ─── Summary Section ─────────────────────────────────────────

  Widget _buildSummarySection(AsyncValue<ExportSummary> summaryAsync) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'SUMMARY'),
        const SizedBox(height: AppSpacing.md),
        summaryAsync.when(
          loading: () => Container(
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: AppRadius.cardBorder,
            ),
            child: const Center(
                child:
                    CircularProgressIndicator(color: AppColors.accent)),
          ),
          error: (_, __) => Container(
            height: 200,
            decoration: BoxDecoration(
              color: AppColors.bgCard,
              borderRadius: AppRadius.cardBorder,
            ),
            child: Center(
              child: Text('Error loading data',
                  style: GoogleFonts.inter(
                      fontSize: 14, color: AppColors.textMuted)),
            ),
          ),
          data: (summary) => _SummaryCard(summary: summary),
        ),
      ],
    );
  }

  // ─── Download Section ─────────────────────────────────────────

  Widget _buildDownloadSection(BuildContext context, WidgetRef ref) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SectionHeader(title: 'DOWNLOAD'),
        const SizedBox(height: AppSpacing.md),
        AppButton(
          label: 'Download CSV',
          icon: LucideIcons.download,
          onPressed: () => _exportCsv(context, ref),
        ),
        const SizedBox(height: AppSpacing.md),
        AppButton(
          label: 'Download PDF',
          icon: LucideIcons.fileText,
          variant: AppButtonVariant.secondary,
          onPressed: () => _exportPdf(context, ref),
        ),
      ],
    );
  }

  Future<void> _exportCsv(BuildContext context, WidgetRef ref) async {
    final summary = ref.read(exportSummaryProvider).valueOrNull;
    final invoices = ref.read(exportInvoicesProvider).valueOrNull;
    if (summary == null || invoices == null) return;

    final csv = StringBuffer();
    csv.writeln('Invoice Number,Client,Status,Subtotal,Tax,Total,Date');
    for (final inv in invoices) {
      final clientName =
          ref.read(clientNameMapProvider).valueOrNull?[inv.clientId] ??
              'Unknown';
      csv.writeln(
        '${inv.invoiceNumber},$clientName,${inv.status.name},'
        '${inv.subtotal.toStringAsFixed(2)},'
        '${inv.taxAmount.toStringAsFixed(2)},'
        '${inv.total.toStringAsFixed(2)},'
        '${DateFormat('yyyy-MM-dd').format(inv.createdAt)}',
      );
    }

    final bytes = utf8.encode(csv.toString());
    await Share.shareXFiles(
      [XFile.fromData(bytes, mimeType: 'text/csv', name: 'tax-export.csv')],
    );
  }

  Future<void> _exportPdf(BuildContext context, WidgetRef ref) async {
    final summary = ref.read(exportSummaryProvider).valueOrNull;
    if (summary == null) return;

    final period = ref.read(exportPeriodNotifierProvider);
    final bytes =
        await TaxExportPdfBuilder.build(summary: summary, period: period);
    await Printing.sharePdf(bytes: bytes, filename: 'tax-export.pdf');
  }
}

// ═══════════════════════════════════════════════════════════════
// Period Chip
// ═══════════════════════════════════════════════════════════════

class _PeriodChip extends StatelessWidget {
  const _PeriodChip({
    required this.label,
    required this.selected,
    required this.onTap,
  });
  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 36,
        decoration: BoxDecoration(
          color: selected ? AppColors.accent : AppColors.bgCard,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.inter(
              fontSize: 12,
              fontWeight: selected ? FontWeight.w600 : FontWeight.w500,
              color: selected ? AppColors.textInverted : AppColors.textSecondary,
            ),
          ),
        ),
      ),
    );
  }
}

// ═══════════════════════════════════════════════════════════════
// Summary Card
// ═══════════════════════════════════════════════════════════════

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({required this.summary});
  final ExportSummary summary;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: AppColors.bgCard,
        borderRadius: AppRadius.cardBorder,
      ),
      child: Column(
        children: [
          _row('Total Invoices', summary.totalInvoices.toString()),
          const SizedBox(height: AppSpacing.lg),
          _row('Total Billed', currencyFormat().format(summary.totalBilled)),
          const SizedBox(height: AppSpacing.lg),
          _row('Total Collected',
              currencyFormat().format(summary.totalCollected),
              valueColor: AppColors.statusPaid),
          const SizedBox(height: AppSpacing.lg),
          _row('Outstanding', currencyFormat().format(summary.outstanding),
              valueColor: AppColors.statusOverdue),
          const SizedBox(height: AppSpacing.lg),
          Container(height: 1, color: AppColors.bgInset),
          const SizedBox(height: AppSpacing.lg),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Tax Collected',
                style: GoogleFonts.inter(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: AppColors.textPrimary,
                ),
              ),
              Text(
                currencyFormat().format(summary.taxCollected),
                style: GoogleFonts.jetBrainsMono(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.accent,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _row(String label, String value, {Color? valueColor}) {
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
          style: GoogleFonts.jetBrainsMono(
            fontSize: 14,
            fontWeight: FontWeight.w600,
            color: valueColor ?? AppColors.textPrimary,
          ),
        ),
      ],
    );
  }
}
