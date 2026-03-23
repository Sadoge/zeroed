import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:uuid/uuid.dart';

import 'package:zeroed/core/constants/app_constants.dart';
import 'package:zeroed/features/invoices/data/invoice_repository.dart';
import 'package:zeroed/features/settings/presentation/settings_view_model.dart';
import 'package:zeroed/models/client_model.dart';
import 'package:zeroed/models/invoice_model.dart';
import 'package:zeroed/models/line_item_model.dart';

part 'create_invoice_view_model.g.dart';

const _uuid = Uuid();

@riverpod
class CreateInvoiceViewModel extends _$CreateInvoiceViewModel {
  @override
  CreateInvoiceState build() {
    final profile = ref.watch(businessProfileProvider).valueOrNull;
    final dueDays =
        profile?.defaultPaymentTermsDays ?? AppConstants.defaultPaymentTermsDays;
    final taxRate = profile?.defaultTaxRate ?? 10.0;
    final currency = profile?.defaultCurrency ?? AppConstants.defaultCurrency;

    return CreateInvoiceState(
      dueDate: DateTime.now().add(Duration(days: dueDays)),
      taxRate: taxRate,
      currency: currency,
    );
  }

  void selectClient(Client client) {
    state = state.copyWith(selectedClient: client);
  }

  void clearClient() {
    state = state.copyWith(selectedClient: null);
  }

  void addLineItem({
    required String description,
    required double quantity,
    required double unitPrice,
  }) {
    final item = LineItem(
      id: _uuid.v4(),
      description: description,
      quantity: quantity,
      unitPrice: unitPrice,
      sortOrder: state.lineItems.length,
    );
    state = state.copyWith(lineItems: [...state.lineItems, item]);
  }

  void updateLineItem(int index, LineItem item) {
    final items = [...state.lineItems];
    items[index] = item;
    state = state.copyWith(lineItems: items);
  }

  void removeLineItem(int index) {
    final items = [...state.lineItems];
    items.removeAt(index);
    state = state.copyWith(lineItems: items);
  }

  void setTaxRate(double? rate) {
    state = state.copyWith(taxRate: rate);
  }

  void setDueDate(DateTime date) {
    state = state.copyWith(dueDate: date);
  }

  void setNotes(String notes) {
    state = state.copyWith(notes: notes);
  }

  double get subtotal =>
      state.lineItems.fold(0, (sum, item) => sum + item.amount);

  double get taxAmount =>
      state.taxRate != null ? subtotal * (state.taxRate! / 100) : 0;

  double get total => subtotal + taxAmount;

  Future<Invoice?> saveInvoice() async {
    if (state.lineItems.isEmpty) return null;

    final now = DateTime.now();
    final invoice = Invoice(
      id: _uuid.v4(),
      userId: '', // Will be filled by repository / Supabase RLS
      clientId: state.selectedClient?.id,
      invoiceNumber: 'INV-${now.millisecondsSinceEpoch.toString().substring(7)}',
      currency: state.currency,
      lineItems: state.lineItems,
      taxRate: state.taxRate,
      dueDate: state.dueDate,
      notes: state.notes,
      createdAt: now,
      updatedAt: now,
    );

    state = state.copyWith(isSaving: true);
    try {
      final saved =
          await ref.read(invoiceRepositoryProvider).createInvoice(invoice);
      state = state.copyWith(isSaving: false);
      return saved;
    } catch (e) {
      state = state.copyWith(isSaving: false);
      return null;
    }
  }
}

class CreateInvoiceState {
  const CreateInvoiceState({
    this.selectedClient,
    this.lineItems = const [],
    this.taxRate = 10,
    required this.dueDate,
    this.currency = 'USD',
    this.notes,
    this.isSaving = false,
  });

  final Client? selectedClient;
  final List<LineItem> lineItems;
  final double? taxRate;
  final DateTime dueDate;
  final String currency;
  final String? notes;
  final bool isSaving;

  CreateInvoiceState copyWith({
    Client? selectedClient,
    List<LineItem>? lineItems,
    double? taxRate,
    DateTime? dueDate,
    String? currency,
    String? notes,
    bool? isSaving,
  }) {
    return CreateInvoiceState(
      selectedClient: selectedClient ?? this.selectedClient,
      lineItems: lineItems ?? this.lineItems,
      taxRate: taxRate ?? this.taxRate,
      dueDate: dueDate ?? this.dueDate,
      currency: currency ?? this.currency,
      notes: notes ?? this.notes,
      isSaving: isSaving ?? this.isSaving,
    );
  }
}
