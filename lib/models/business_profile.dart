import 'package:freezed_annotation/freezed_annotation.dart';

part 'business_profile.freezed.dart';
part 'business_profile.g.dart';

@freezed
class BusinessProfile with _$BusinessProfile {
  const factory BusinessProfile({
    required String id,
    required String email,
    @JsonKey(name: 'business_name') String? businessName,
    @JsonKey(name: 'logo_url') String? logoUrl,
    String? address,
    @JsonKey(name: 'tax_id') String? taxId,
    @Default('USD') @JsonKey(name: 'default_currency') String defaultCurrency,
    @Default(30) @JsonKey(name: 'default_payment_terms_days') int defaultPaymentTermsDays,
    @Default(10.0) @JsonKey(name: 'default_tax_rate') double defaultTaxRate,
    @Default(true) @JsonKey(name: 'reminders_enabled') bool remindersEnabled,
    @JsonKey(name: 'stripe_account_id') String? stripeAccountId,
    @Default(false) @JsonKey(name: 'stripe_connected') bool stripeConnected,
    @JsonKey(name: 'created_at') required DateTime createdAt,
  }) = _BusinessProfile;

  factory BusinessProfile.fromJson(Map<String, dynamic> json) =>
      _$BusinessProfileFromJson(json);
}
