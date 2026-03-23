// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'business_profile.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$BusinessProfileImpl _$$BusinessProfileImplFromJson(
  Map<String, dynamic> json,
) => _$BusinessProfileImpl(
  id: json['id'] as String,
  email: json['email'] as String,
  businessName: json['business_name'] as String?,
  logoUrl: json['logo_url'] as String?,
  address: json['address'] as String?,
  taxId: json['tax_id'] as String?,
  defaultCurrency: json['default_currency'] as String? ?? 'USD',
  defaultPaymentTermsDays:
      (json['default_payment_terms_days'] as num?)?.toInt() ?? 30,
  defaultTaxRate: (json['default_tax_rate'] as num?)?.toDouble() ?? 10.0,
  remindersEnabled: json['reminders_enabled'] as bool? ?? true,
  stripeAccountId: json['stripe_account_id'] as String?,
  stripeConnected: json['stripe_connected'] as bool? ?? false,
  createdAt: DateTime.parse(json['created_at'] as String),
);

Map<String, dynamic> _$$BusinessProfileImplToJson(
  _$BusinessProfileImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'business_name': instance.businessName,
  'logo_url': instance.logoUrl,
  'address': instance.address,
  'tax_id': instance.taxId,
  'default_currency': instance.defaultCurrency,
  'default_payment_terms_days': instance.defaultPaymentTermsDays,
  'default_tax_rate': instance.defaultTaxRate,
  'reminders_enabled': instance.remindersEnabled,
  'stripe_account_id': instance.stripeAccountId,
  'stripe_connected': instance.stripeConnected,
  'created_at': instance.createdAt.toIso8601String(),
};
