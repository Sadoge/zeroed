// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InvoiceImpl _$$InvoiceImplFromJson(Map<String, dynamic> json) =>
    _$InvoiceImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      clientId: json['clientId'] as String?,
      invoiceNumber: json['invoiceNumber'] as String,
      status:
          $enumDecodeNullable(_$InvoiceStatusEnumMap, json['status']) ??
          InvoiceStatus.draft,
      currency: json['currency'] as String? ?? 'USD',
      lineItems:
          (json['lineItems'] as List<dynamic>?)
              ?.map((e) => LineItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      taxRate: (json['taxRate'] as num?)?.toDouble(),
      dueDate: DateTime.parse(json['dueDate'] as String),
      sentAt: json['sentAt'] == null
          ? null
          : DateTime.parse(json['sentAt'] as String),
      paidAt: json['paidAt'] == null
          ? null
          : DateTime.parse(json['paidAt'] as String),
      stripePaymentLink: json['stripePaymentLink'] as String?,
      pdfUrl: json['pdfUrl'] as String?,
      notes: json['notes'] as String?,
      isRecurring: json['isRecurring'] as bool? ?? false,
      recurrenceInterval: json['recurrenceInterval'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$$InvoiceImplToJson(_$InvoiceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'clientId': instance.clientId,
      'invoiceNumber': instance.invoiceNumber,
      'status': _$InvoiceStatusEnumMap[instance.status]!,
      'currency': instance.currency,
      'lineItems': instance.lineItems,
      'taxRate': instance.taxRate,
      'dueDate': instance.dueDate.toIso8601String(),
      'sentAt': instance.sentAt?.toIso8601String(),
      'paidAt': instance.paidAt?.toIso8601String(),
      'stripePaymentLink': instance.stripePaymentLink,
      'pdfUrl': instance.pdfUrl,
      'notes': instance.notes,
      'isRecurring': instance.isRecurring,
      'recurrenceInterval': instance.recurrenceInterval,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };

const _$InvoiceStatusEnumMap = {
  InvoiceStatus.draft: 'draft',
  InvoiceStatus.sent: 'sent',
  InvoiceStatus.viewed: 'viewed',
  InvoiceStatus.paid: 'paid',
  InvoiceStatus.overdue: 'overdue',
};
