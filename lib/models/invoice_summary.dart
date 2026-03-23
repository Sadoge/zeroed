import 'package:freezed_annotation/freezed_annotation.dart';

part 'invoice_summary.freezed.dart';
part 'invoice_summary.g.dart';

@freezed
class InvoiceSummary with _$InvoiceSummary {
  const factory InvoiceSummary({
    @Default(0) double totalOutstanding,
    @Default(0) double totalOverdue,
    @Default(0) double paidThisMonth,
    @Default(0) int invoiceCount,
    @Default(0) int overdueCount,
  }) = _InvoiceSummary;

  factory InvoiceSummary.fromJson(Map<String, dynamic> json) =>
      _$InvoiceSummaryFromJson(json);
}
