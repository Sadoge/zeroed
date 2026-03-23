import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:zeroed/core/services/hive_service.dart';
import 'package:zeroed/core/services/supabase_service.dart';
import 'package:zeroed/models/invoice_model.dart';

part 'invoice_repository.g.dart';

class InvoiceRepository {
  InvoiceRepository(this._hive, this._supabase);

  final HiveService _hive;
  final dynamic _supabase;

  /// Fetch all invoices for the current user.
  Future<List<Invoice>> getInvoices() async {
    try {
      final response = await _supabase
          .from('invoices')
          .select('*, line_items(*)')
          .order('created_at', ascending: false);
      final invoices = (response as List)
          .map((json) => Invoice.fromJson(json as Map<String, dynamic>))
          .toList();

      for (final invoice in invoices) {
        await _hive.put(_hive.invoicesBox, invoice.id, invoice.toJson());
      }
      return invoices;
    } catch (_) {
      return _hive
          .getAll(_hive.invoicesBox)
          .map((json) => Invoice.fromJson(json))
          .toList();
    }
  }

  /// Get a single invoice by ID.
  Future<Invoice?> getInvoice(String id) async {
    try {
      final response = await _supabase
          .from('invoices')
          .select('*, line_items(*)')
          .eq('id', id)
          .single();
      final invoice = Invoice.fromJson(response as Map<String, dynamic>);
      await _hive.put(_hive.invoicesBox, id, invoice.toJson());
      return invoice;
    } catch (_) {
      final json = _hive.get(_hive.invoicesBox, id);
      return json != null ? Invoice.fromJson(json) : null;
    }
  }

  /// Create a new invoice with line items.
  Future<Invoice> createInvoice(Invoice invoice) async {
    await _hive.put(_hive.invoicesBox, invoice.id, invoice.toJson());

    try {
      // Insert invoice (without line items field)
      final invoiceJson = invoice.toJson()..remove('lineItems');
      await _supabase.from('invoices').insert(invoiceJson);

      // Insert line items
      if (invoice.lineItems.isNotEmpty) {
        final lineItemsJson = invoice.lineItems
            .map((li) => li.toJson()..['invoice_id'] = invoice.id)
            .toList();
        await _supabase.from('line_items').insert(lineItemsJson);
      }
    } catch (_) {
      await _hive
          .put(_hive.syncQueueBox, 'invoice_create_${invoice.id}', {
        'table': 'invoices',
        'operation': 'insert',
        'data': invoice.toJson(),
      });
    }
    return invoice;
  }

  /// Update an existing invoice.
  Future<void> updateInvoice(Invoice invoice) async {
    await _hive.put(_hive.invoicesBox, invoice.id, invoice.toJson());
    try {
      final invoiceJson = invoice.toJson()..remove('lineItems');
      await _supabase
          .from('invoices')
          .update(invoiceJson)
          .eq('id', invoice.id);

      // Replace line items
      await _supabase
          .from('line_items')
          .delete()
          .eq('invoice_id', invoice.id);
      if (invoice.lineItems.isNotEmpty) {
        final lineItemsJson = invoice.lineItems
            .map((li) => li.toJson()..['invoice_id'] = invoice.id)
            .toList();
        await _supabase.from('line_items').insert(lineItemsJson);
      }
    } catch (_) {
      await _hive
          .put(_hive.syncQueueBox, 'invoice_update_${invoice.id}', {
        'table': 'invoices',
        'operation': 'update',
        'data': invoice.toJson(),
      });
    }
  }

  /// Delete an invoice.
  Future<void> deleteInvoice(String id) async {
    await _hive.delete(_hive.invoicesBox, id);
    try {
      await _supabase.from('invoices').delete().eq('id', id);
    } catch (_) {
      await _hive.put(_hive.syncQueueBox, 'invoice_delete_$id', {
        'table': 'invoices',
        'operation': 'delete',
        'data': {'id': id},
      });
    }
  }
}

@Riverpod(keepAlive: true)
InvoiceRepository invoiceRepository(Ref ref) {
  return InvoiceRepository(
    ref.watch(hiveServiceProvider),
    ref.watch(supabaseClientProvider),
  );
}
