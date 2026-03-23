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
  businessName: json['businessName'] as String?,
  logoUrl: json['logoUrl'] as String?,
  address: json['address'] as String?,
  taxId: json['taxId'] as String?,
  defaultCurrency: json['defaultCurrency'] as String? ?? 'USD',
  defaultPaymentTermsDays:
      (json['defaultPaymentTermsDays'] as num?)?.toInt() ?? 30,
  stripeAccountId: json['stripeAccountId'] as String?,
  stripeConnected: json['stripeConnected'] as bool? ?? false,
  createdAt: DateTime.parse(json['createdAt'] as String),
);

Map<String, dynamic> _$$BusinessProfileImplToJson(
  _$BusinessProfileImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'email': instance.email,
  'businessName': instance.businessName,
  'logoUrl': instance.logoUrl,
  'address': instance.address,
  'taxId': instance.taxId,
  'defaultCurrency': instance.defaultCurrency,
  'defaultPaymentTermsDays': instance.defaultPaymentTermsDays,
  'stripeAccountId': instance.stripeAccountId,
  'stripeConnected': instance.stripeConnected,
  'createdAt': instance.createdAt.toIso8601String(),
};
