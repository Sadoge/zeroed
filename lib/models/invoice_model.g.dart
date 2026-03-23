// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'invoice_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$InvoiceImpl _$$InvoiceImplFromJson(Map<String, dynamic> json) =>
    _$InvoiceImpl(
      id: json['id'] as String,
      userId: json['user_id'] as String,
      clientId: json['client_id'] as String?,
      invoiceNumber: json['invoice_number'] as String,
      status:
          $enumDecodeNullable(_$InvoiceStatusEnumMap, json['status']) ??
          InvoiceStatus.draft,
      currency: json['currency'] as String? ?? 'USD',
      lineItems:
          (json['line_items'] as List<dynamic>?)
              ?.map((e) => LineItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      taxRate: (json['tax_rate'] as num?)?.toDouble(),
      dueDate: DateTime.parse(json['due_date'] as String),
      sentAt: json['sent_at'] == null
          ? null
          : DateTime.parse(json['sent_at'] as String),
      paidAt: json['paid_at'] == null
          ? null
          : DateTime.parse(json['paid_at'] as String),
      stripePaymentLink: json['stripe_payment_link'] as String?,
      pdfUrl: json['pdf_url'] as String?,
      notes: json['notes'] as String?,
      isRecurring: json['is_recurring'] as bool? ?? false,
      recurrenceInterval: json['recurrence_interval'] as String?,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );

Map<String, dynamic> _$$InvoiceImplToJson(_$InvoiceImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'client_id': instance.clientId,
      'invoice_number': instance.invoiceNumber,
      'status': _$InvoiceStatusEnumMap[instance.status]!,
      'currency': instance.currency,
      'line_items': instance.lineItems,
      'tax_rate': instance.taxRate,
      'due_date': instance.dueDate.toIso8601String(),
      'sent_at': instance.sentAt?.toIso8601String(),
      'paid_at': instance.paidAt?.toIso8601String(),
      'stripe_payment_link': instance.stripePaymentLink,
      'pdf_url': instance.pdfUrl,
      'notes': instance.notes,
      'is_recurring': instance.isRecurring,
      'recurrence_interval': instance.recurrenceInterval,
      'created_at': instance.createdAt.toIso8601String(),
      'updated_at': instance.updatedAt.toIso8601String(),
    };

const _$InvoiceStatusEnumMap = {
  InvoiceStatus.draft: 'draft',
  InvoiceStatus.sent: 'sent',
  InvoiceStatus.viewed: 'viewed',
  InvoiceStatus.paid: 'paid',
  InvoiceStatus.overdue: 'overdue',
};
