import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:zeroed/features/clients/data/client_repository.dart';
import 'package:zeroed/features/invoices/data/invoice_repository.dart';
import 'package:zeroed/models/invoice_model.dart';
import 'package:zeroed/models/invoice_status.dart';
import 'package:zeroed/models/invoice_summary.dart';

part 'dashboard_view_model.g.dart';

@riverpod
Future<List<Invoice>> allInvoices(Ref ref) async {
  return ref.watch(invoiceRepositoryProvider).getInvoices();
}

@riverpod
Future<List<Invoice>> recentInvoices(Ref ref) async {
  final all = await ref.watch(allInvoicesProvider.future);
  // Return the 5 most recent invoices
  final sorted = [...all]..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  return sorted.take(5).toList();
}

@riverpod
Future<InvoiceSummary> dashboardSummary(Ref ref) async {
  final invoices = await ref.watch(allInvoicesProvider.future);

  final now = DateTime.now();
  final monthStart = DateTime(now.year, now.month, 1);

  double totalOutstanding = 0;
  double totalOverdue = 0;
  double paidThisMonth = 0;
  int invoiceCount = 0;
  int overdueCount = 0;

  for (final inv in invoices) {
    if (inv.status == InvoiceStatus.sent ||
        inv.status == InvoiceStatus.viewed ||
        inv.status == InvoiceStatus.overdue) {
      totalOutstanding += inv.total;
      invoiceCount++;
    }
    if (inv.status == InvoiceStatus.overdue) {
      totalOverdue += inv.total;
      overdueCount++;
    }
    if (inv.status == InvoiceStatus.paid &&
        inv.paidAt != null &&
        inv.paidAt!.isAfter(monthStart)) {
      paidThisMonth += inv.total;
    }
  }

  return InvoiceSummary(
    totalOutstanding: totalOutstanding,
    totalOverdue: totalOverdue,
    paidThisMonth: paidThisMonth,
    invoiceCount: invoiceCount,
    overdueCount: overdueCount,
  );
}

@riverpod
Future<Map<String, String>> clientNameMap(Ref ref) async {
  final clients = await ref.watch(clientRepositoryProvider).getClients();
  return {for (final c in clients) c.id: c.name};
}

String resolveClientName(
    Map<String, String> nameMap, String? clientId) {
  if (clientId == null) return 'Unknown';
  return nameMap[clientId] ?? 'Unknown';
}

// Keep the old function signature for compatibility with detail/preview screens
// that still use hardcoded data.
String clientNameForId(String? clientId) {
  const fallback = {
    'c1': 'Acme Corp',
    'c2': 'Bright Studio',
    'c3': 'Nova Digital',
    'c4': 'Quantum Labs',
  };
  if (clientId == null) return 'Unknown';
  return fallback[clientId] ?? 'Unknown';
}
