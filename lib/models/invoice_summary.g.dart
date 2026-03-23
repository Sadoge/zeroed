// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InvoiceSummaryImpl _$$InvoiceSummaryImplFromJson(Map<String, dynamic> json) =>
    _$InvoiceSummaryImpl(
      totalOutstanding: (json['totalOutstanding'] as num?)?.toDouble() ?? 0,
      totalOverdue: (json['totalOverdue'] as num?)?.toDouble() ?? 0,
      paidThisMonth: (json['paidThisMonth'] as num?)?.toDouble() ?? 0,
      invoiceCount: (json['invoiceCount'] as num?)?.toInt() ?? 0,
      overdueCount: (json['overdueCount'] as num?)?.toInt() ?? 0,
    );

Map<String, dynamic> _$$InvoiceSummaryImplToJson(
  _$InvoiceSummaryImpl instance,
) => <String, dynamic>{
  'totalOutstanding': instance.totalOutstanding,
  'totalOverdue': instance.totalOverdue,
  'paidThisMonth': instance.paidThisMonth,
  'invoiceCount': instance.invoiceCount,
  'overdueCount': instance.overdueCount,
};
