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
    required String userId,
    String? clientId,
    required String invoiceNumber,
    @Default(InvoiceStatus.draft) InvoiceStatus status,
    @Default('USD') String currency,
    @Default([]) List<LineItem> lineItems,
    double? taxRate,
    required DateTime dueDate,
    DateTime? sentAt,
    DateTime? paidAt,
    String? stripePaymentLink,
    String? pdfUrl,
    String? notes,
    @Default(false) bool isRecurring,
    String? recurrenceInterval,
    required DateTime createdAt,
    required DateTime updatedAt,
  }) = _Invoice;

  double get subtotal =>
      lineItems.fold(0, (sum, item) => sum + item.amount);

  double get taxAmount =>
      taxRate != null ? subtotal * (taxRate! / 100) : 0;

  double get total => subtotal + taxAmount;

  factory Invoice.fromJson(Map<String, dynamic> json) =>
      _$InvoiceFromJson(json);
}
