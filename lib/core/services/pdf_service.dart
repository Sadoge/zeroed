import 'dart:typed_data';

import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

import 'package:zeroed/models/invoice_model.dart';
import 'package:zeroed/models/line_item_model.dart';

import 'package:zeroed/core/utils/currency_utils.dart';
final _dateFormat = DateFormat('MMM d, y');

class PdfService {
  PdfService._();
  static final instance = PdfService._();

  Future<Uint8List> generateInvoicePdf({
    required Invoice invoice,
    required String clientName,
    required String clientEmail,
    String? businessName,
    String? paymentLink,
  }) async {
    final pdf = pw.Document();

    final darkColor = PdfColor.fromHex('#0A0F1C');
    final bodyColor = PdfColor.fromHex('#0F172A');
    final mutedColor = PdfColor.fromHex('#64748B');
    final labelColor = PdfColor.fromHex('#94A3B8');
    final borderColor = PdfColor.fromHex('#E2E8F0');

    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(40),
        build: (context) {
          return pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              // Header: logo + invoice info
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(
                        'ZEROED',
                        style: pw.TextStyle(
                          fontSize: 20,
                          fontWeight: pw.FontWeight.bold,
                          color: darkColor,
                        ),
                      ),
                      if (businessName != null && businessName.isNotEmpty) ...[
                        pw.SizedBox(height: 4),
                        pw.Text(
                          businessName,
                          style: pw.TextStyle(
                              fontSize: 11, color: mutedColor),
                        ),
                      ],
                    ],
                  ),
                  pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.end,
                    children: [
                      pw.Text(
                        'INVOICE',
                        style: pw.TextStyle(
                          fontSize: 11,
                          fontWeight: pw.FontWeight.bold,
                          color: labelColor,
                          letterSpacing: 2,
                        ),
                      ),
                      pw.SizedBox(height: 2),
                      pw.Text(
                        invoice.invoiceNumber,
                        style: pw.TextStyle(
                          fontSize: 14,
                          fontWeight: pw.FontWeight.bold,
                          color: darkColor,
                        ),
                      ),
                      pw.SizedBox(height: 2),
                      pw.Text(
                        _dateFormat.format(invoice.createdAt),
                        style: pw.TextStyle(
                            fontSize: 11, color: mutedColor),
                      ),
                    ],
                  ),
                ],
              ),

              pw.SizedBox(height: 24),

              // Bill To
              pw.Text(
                'BILL TO',
                style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                  color: labelColor,
                  letterSpacing: 2,
                ),
              ),
              pw.SizedBox(height: 4),
              pw.Text(
                clientName,
                style: pw.TextStyle(
                  fontSize: 14,
                  fontWeight: pw.FontWeight.bold,
                  color: darkColor,
                ),
              ),
              pw.SizedBox(height: 2),
              pw.Text(
                clientEmail,
                style: pw.TextStyle(fontSize: 11, color: mutedColor),
              ),

              pw.SizedBox(height: 24),
              pw.Divider(color: borderColor, thickness: 1),
              pw.SizedBox(height: 12),

              // Table header
              _buildTableHeader(labelColor),
              pw.SizedBox(height: 8),

              // Line items
              ...invoice.lineItems.map(
                (item) => _buildLineRow(item, bodyColor, mutedColor, invoice.currency),
              ),

              pw.SizedBox(height: 12),
              pw.Divider(color: borderColor, thickness: 1),
              pw.SizedBox(height: 12),

              // Totals
              pw.Align(
                alignment: pw.Alignment.centerRight,
                child: pw.SizedBox(
                  width: 200,
                  child: pw.Column(
                    children: [
                      _buildTotalRow('Subtotal',
                          formatCurrency(invoice.subtotal, invoice.currency),
                          mutedColor, bodyColor),
                      if (invoice.taxRate != null && invoice.taxRate! > 0) ...[
                        pw.SizedBox(height: 6),
                        _buildTotalRow(
                            'Tax (${invoice.taxRate!.toStringAsFixed(0)}%)',
                            formatCurrency(invoice.taxAmount, invoice.currency),
                            mutedColor, bodyColor),
                      ],
                      pw.SizedBox(height: 8),
                      pw.Divider(color: borderColor, thickness: 1),
                      pw.SizedBox(height: 8),
                      pw.Row(
                        mainAxisAlignment:
                            pw.MainAxisAlignment.spaceBetween,
                        children: [
                          pw.Text(
                            'Total',
                            style: pw.TextStyle(
                              fontSize: 14,
                              fontWeight: pw.FontWeight.bold,
                              color: darkColor,
                            ),
                          ),
                          pw.Text(
                            formatCurrency(invoice.total, invoice.currency),
                            style: pw.TextStyle(
                              fontSize: 18,
                              fontWeight: pw.FontWeight.bold,
                              color: darkColor,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),

              pw.Spacer(),

              // Footer
              pw.Center(
                child: pw.Text(
                  'Payment due within 30 days. Late payments subject to 1.5% monthly interest.',
                  style: pw.TextStyle(fontSize: 9, color: labelColor),
                  textAlign: pw.TextAlign.center,
                ),
              ),
            ],
          );
        },
      ),
    );

    return pdf.save();
  }

  pw.Widget _buildTableHeader(PdfColor labelColor) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Expanded(
          child: pw.Text(
            'Description',
            style: pw.TextStyle(
              fontSize: 10,
              fontWeight: pw.FontWeight.bold,
              color: labelColor,
              letterSpacing: 1,
            ),
          ),
        ),
        pw.SizedBox(
          width: 40,
          child: pw.Text('QTY',
              style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                  color: labelColor,
                  letterSpacing: 1),
              textAlign: pw.TextAlign.center),
        ),
        pw.SizedBox(
          width: 70,
          child: pw.Text('RATE',
              style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                  color: labelColor,
                  letterSpacing: 1),
              textAlign: pw.TextAlign.right),
        ),
        pw.SizedBox(
          width: 80,
          child: pw.Text('AMOUNT',
              style: pw.TextStyle(
                  fontSize: 10,
                  fontWeight: pw.FontWeight.bold,
                  color: labelColor,
                  letterSpacing: 1),
              textAlign: pw.TextAlign.right),
        ),
      ],
    );
  }

  pw.Widget _buildLineRow(
      LineItem item, PdfColor bodyColor, PdfColor mutedColor, String currency) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 4),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Expanded(
            child: pw.Text(
              item.description,
              style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.normal,
                  color: bodyColor),
            ),
          ),
          pw.SizedBox(
            width: 40,
            child: pw.Text(
              item.quantity.toStringAsFixed(0),
              style: pw.TextStyle(fontSize: 12, color: mutedColor),
              textAlign: pw.TextAlign.center,
            ),
          ),
          pw.SizedBox(
            width: 70,
            child: pw.Text(
              formatCurrency(item.unitPrice, currency),
              style: pw.TextStyle(fontSize: 12, color: mutedColor),
              textAlign: pw.TextAlign.right,
            ),
          ),
          pw.SizedBox(
            width: 80,
            child: pw.Text(
              formatCurrency(item.amount, currency),
              style: pw.TextStyle(
                  fontSize: 12,
                  fontWeight: pw.FontWeight.normal,
                  color: bodyColor),
              textAlign: pw.TextAlign.right,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget _buildTotalRow(
      String label, String value, PdfColor labelColor, PdfColor valueColor) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Text(label,
            style: pw.TextStyle(fontSize: 12, color: labelColor)),
        pw.Text(value,
            style: pw.TextStyle(
                fontSize: 12,
                fontWeight: pw.FontWeight.normal,
                color: valueColor)),
      ],
    );
  }
}
