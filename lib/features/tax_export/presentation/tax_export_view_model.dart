import 'dart:typed_data';

import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:zeroed/features/dashboard/presentation/dashboard_view_model.dart';
import 'package:zeroed/models/invoice_model.dart';
import 'package:zeroed/models/invoice_status.dart';

part 'tax_export_view_model.g.dart';

// ─── Period Types ──────────────────────────────────────────────

enum PeriodPreset { thisMonth, lastMonth, thisQuarter, thisYear, custom }

class ExportPeriod {
  const ExportPeriod({
    required this.start,
    required this.end,
    required this.preset,
  });

  final DateTime start;
  final DateTime end;
  final PeriodPreset preset;
}

class ExportSummary {
  const ExportSummary({
    required this.totalInvoices,
    required this.totalBilled,
    required this.totalCollected,
    required this.outstanding,
    required this.taxCollected,
  });

  final int totalInvoices;
  final double totalBilled;
  final double totalCollected;
  final double outstanding;
  final double taxCollected;
}

// ─── Period Provider ───────────────────────────────────────────

@riverpod
class ExportPeriodNotifier extends _$ExportPeriodNotifier {
  @override
  ExportPeriod build() {
    return _periodFor(PeriodPreset.thisQuarter);
  }

  void setPreset(PeriodPreset preset) {
    state = _periodFor(preset);
  }

  void setCustomRange(DateTime start, DateTime end) {
    state = ExportPeriod(
        start: start, end: end, preset: PeriodPreset.custom);
  }

  ExportPeriod _periodFor(PeriodPreset preset) {
    final now = DateTime.now();
    switch (preset) {
      case PeriodPreset.thisMonth:
        return ExportPeriod(
          start: DateTime(now.year, now.month, 1),
          end: now,
          preset: preset,
        );
      case PeriodPreset.lastMonth:
        final lastMonth = DateTime(now.year, now.month - 1, 1);
        final lastDay = DateTime(now.year, now.month, 0);
        return ExportPeriod(
          start: lastMonth,
          end: lastDay,
          preset: preset,
        );
      case PeriodPreset.thisQuarter:
        final qStart = DateTime(now.year, ((now.month - 1) ~/ 3) * 3 + 1, 1);
        return ExportPeriod(start: qStart, end: now, preset: preset);
      case PeriodPreset.thisYear:
        return ExportPeriod(
          start: DateTime(now.year, 1, 1),
          end: now,
          preset: preset,
        );
      case PeriodPreset.custom:
        return ExportPeriod(
          start: DateTime(now.year, 1, 1),
          end: now,
          preset: preset,
        );
    }
  }
}

// ─── Filtered Invoices ─────────────────────────────────────────

@riverpod
Future<List<Invoice>> exportInvoices(Ref ref) async {
  final period = ref.watch(exportPeriodNotifierProvider);
  final all = await ref.watch(allInvoicesProvider.future);
  return all
      .where((inv) =>
          inv.createdAt.isAfter(period.start.subtract(const Duration(days: 1))) &&
          inv.createdAt.isBefore(period.end.add(const Duration(days: 1))))
      .toList();
}

// ─── Summary Provider ──────────────────────────────────────────

@riverpod
Future<ExportSummary> exportSummary(Ref ref) async {
  final invoices = await ref.watch(exportInvoicesProvider.future);

  double totalBilled = 0;
  double totalCollected = 0;
  double outstanding = 0;
  double taxCollected = 0;

  for (final inv in invoices) {
    totalBilled += inv.total;
    if (inv.status == InvoiceStatus.paid) {
      totalCollected += inv.total;
      taxCollected += inv.taxAmount;
    } else if (inv.status != InvoiceStatus.draft) {
      outstanding += inv.total;
    }
  }

  return ExportSummary(
    totalInvoices: invoices.length,
    totalBilled: totalBilled,
    totalCollected: totalCollected,
    outstanding: outstanding,
    taxCollected: taxCollected,
  );
}

// ─── PDF Builder ───────────────────────────────────────────────

final _currencyFormat = NumberFormat.currency(symbol: '\$', decimalDigits: 2);
final _dateFormat = DateFormat('MMM d, y');

class TaxExportPdfBuilder {
  static Future<Uint8List> build({
    required ExportSummary summary,
    required ExportPeriod period,
  }) async {
    final pdf = pw.Document();

    final dark = PdfColor.fromHex('#0A0F1C');
    final muted = PdfColor.fromHex('#64748B');
    final label = PdfColor.fromHex('#94A3B8');
    final border = PdfColor.fromHex('#E2E8F0');
    final accent = PdfColor.fromHex('#22D3EE');
    final green = PdfColor.fromHex('#34D399');
    final orange = PdfColor.fromHex('#FB923C');

    final periodStr =
        '${_dateFormat.format(period.start)} – ${_dateFormat.format(period.end)}';

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text('ZEROED',
                    style: pw.TextStyle(
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                        color: dark)),
                pw.Text('TAX EXPORT',
                    style: pw.TextStyle(
                        fontSize: 11,
                        fontWeight: pw.FontWeight.bold,
                        letterSpacing: 2,
                        color: label)),
              ],
            ),
            pw.SizedBox(height: 4),
            pw.Text('Period: $periodStr',
                style: pw.TextStyle(fontSize: 11, color: muted)),
            pw.SizedBox(height: 24),
            pw.Divider(color: border, thickness: 1),
            pw.SizedBox(height: 16),
            _pdfRow('Total Invoices', '${summary.totalInvoices}', dark, dark),
            pw.SizedBox(height: 10),
            _pdfRow('Total Billed',
                _currencyFormat.format(summary.totalBilled), dark, dark),
            pw.SizedBox(height: 10),
            _pdfRow('Total Collected',
                _currencyFormat.format(summary.totalCollected), dark, green),
            pw.SizedBox(height: 10),
            _pdfRow('Outstanding',
                _currencyFormat.format(summary.outstanding), dark, orange),
            pw.SizedBox(height: 16),
            pw.Divider(color: border, thickness: 1),
            pw.SizedBox(height: 16),
            _pdfRow('Tax Collected',
                _currencyFormat.format(summary.taxCollected), dark, accent,
                bold: true),
            pw.Spacer(),
            pw.Center(
              child: pw.Text(
                'Generated by Zeroed',
                style: pw.TextStyle(fontSize: 9, color: label),
              ),
            ),
          ],
        ),
      ),
    );

    return pdf.save();
  }

  static pw.Widget _pdfRow(
    String label,
    String value,
    PdfColor labelColor,
    PdfColor valueColor, {
    bool bold = false,
  }) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(label,
            style: pw.TextStyle(
              fontSize: bold ? 14 : 12,
              fontWeight: bold ? pw.FontWeight.bold : pw.FontWeight.normal,
              color: labelColor,
            )),
        pw.Text(value,
            style: pw.TextStyle(
              fontSize: bold ? 16 : 12,
              fontWeight: pw.FontWeight.bold,
              color: valueColor,
            )),
      ],
    );
  }
}
