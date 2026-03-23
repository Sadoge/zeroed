import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:zeroed/models/invoice_model.dart';
import 'package:zeroed/models/invoice_status.dart';
import 'package:zeroed/models/invoice_summary.dart';
import 'package:zeroed/models/line_item_model.dart';

part 'dashboard_view_model.g.dart';

@riverpod
InvoiceSummary dashboardSummary(Ref ref) {
  // Hardcoded for Step 8 — will be wired to real data in Step 13.
  return const InvoiceSummary(
    totalOutstanding: 4250.00,
    totalOverdue: 850.00,
    paidThisMonth: 12400.00,
    invoiceCount: 3,
    overdueCount: 1,
  );
}

@riverpod
List<Invoice> recentInvoices(Ref ref) {
  final now = DateTime.now();
  return [
    Invoice(
      id: '1',
      userId: 'demo',
      clientId: 'c1',
      invoiceNumber: 'INV-024',
      status: InvoiceStatus.sent,
      lineItems: [
        const LineItem(id: 'l1', description: 'Web Design', unitPrice: 2400),
      ],
      dueDate: now.add(const Duration(days: 10)),
      createdAt: now.subtract(const Duration(days: 2)),
      updatedAt: now.subtract(const Duration(days: 2)),
    ),
    Invoice(
      id: '2',
      userId: 'demo',
      clientId: 'c2',
      invoiceNumber: 'INV-023',
      status: InvoiceStatus.overdue,
      lineItems: [
        const LineItem(id: 'l2', description: 'Logo Design', unitPrice: 850),
      ],
      dueDate: now.subtract(const Duration(days: 3)),
      createdAt: now.subtract(const Duration(days: 14)),
      updatedAt: now.subtract(const Duration(days: 14)),
    ),
    Invoice(
      id: '3',
      userId: 'demo',
      clientId: 'c3',
      invoiceNumber: 'INV-022',
      status: InvoiceStatus.paid,
      lineItems: [
        const LineItem(
            id: 'l3', description: 'App Development', unitPrice: 3200),
      ],
      dueDate: now.subtract(const Duration(days: 20)),
      paidAt: now.subtract(const Duration(days: 11)),
      createdAt: now.subtract(const Duration(days: 30)),
      updatedAt: now.subtract(const Duration(days: 11)),
    ),
    Invoice(
      id: '4',
      userId: 'demo',
      clientId: 'c4',
      invoiceNumber: 'INV-021',
      status: InvoiceStatus.viewed,
      lineItems: [
        const LineItem(
            id: 'l4', description: 'Brand Consultation', unitPrice: 1000),
      ],
      dueDate: now.subtract(const Duration(days: 3)),
      createdAt: now.subtract(const Duration(days: 10)),
      updatedAt: now.subtract(const Duration(days: 5)),
    ),
  ];
}

// Hardcoded client names for display (will come from client repo later).
const _clientNames = {
  'c1': 'Acme Corp',
  'c2': 'Bright Studio',
  'c3': 'Nova Digital',
  'c4': 'Quantum Labs',
};

String clientNameForId(String? clientId) {
  if (clientId == null) return 'Unknown';
  return _clientNames[clientId] ?? 'Unknown';
}
