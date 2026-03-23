import 'package:freezed_annotation/freezed_annotation.dart';

part 'business_profile.freezed.dart';
part 'business_profile.g.dart';

@freezed
class BusinessProfile with _$BusinessProfile {
  const factory BusinessProfile({
    required String id,
    required String email,
    String? businessName,
    String? logoUrl,
    String? address,
    String? taxId,
    @Default('USD') String defaultCurrency,
    @Default(30) int defaultPaymentTermsDays,
    String? stripeAccountId,
    @Default(false) bool stripeConnected,
    required DateTime createdAt,
  }) = _BusinessProfile;

  factory BusinessProfile.fromJson(Map<String, dynamic> json) =>
      _$BusinessProfileFromJson(json);
}
