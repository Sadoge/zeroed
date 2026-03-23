import 'package:freezed_annotation/freezed_annotation.dart';

import 'invoice_status.dart';
import 'line_item_model.dart';

part 'invoice_model.freezed.dart';
part 'invoice_model.g.dart';

@freezed
class Invoice with _$Invoice {
  const Invoice._();

  const factory Invoice({
    required String id,
    @JsonKey(name: 'user_id') required String userId,
    @JsonKey(name: 'client_id') String? clientId,
    @JsonKey(name: 'invoice_number') required String invoiceNumber,
    @Default(InvoiceStatus.draft) InvoiceStatus status,
    @Default('USD') String currency,
    @Default([]) @JsonKey(name: 'line_items') List<LineItem> lineItems,
    @JsonKey(name: 'tax_rate') double? taxRate,
    @JsonKey(name: 'due_date') required DateTime dueDate,
    @JsonKey(name: 'sent_at') DateTime? sentAt,
    @JsonKey(name: 'paid_at') DateTime? paidAt,
    @JsonKey(name: 'stripe_payment_link') String? stripePaymentLink,
    @JsonKey(name: 'pdf_url') String? pdfUrl,
    String? notes,
    @Default(false) @JsonKey(name: 'is_recurring') bool isRecurring,
    @JsonKey(name: 'recurrence_interval') String? recurrenceInterval,
    @JsonKey(name: 'created_at') required DateTime createdAt,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _Invoice;

  double get subtotal =>
      lineItems.fold(0, (sum, item) => sum + item.amount);

  double get taxAmount =>
      taxRate != null ? subtotal * (taxRate! / 100) : 0;

  double get total => subtotal + taxAmount;

  factory Invoice.fromJson(Map<String, dynamic> json) =>
      _$InvoiceFromJson(json);
}
