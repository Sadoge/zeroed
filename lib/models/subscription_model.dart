import 'package:freezed_annotation/freezed_annotation.dart';

part 'subscription_model.freezed.dart';
part 'subscription_model.g.dart';

@freezed
class Subscription with _$Subscription {
  const factory Subscription({
    required String id,
    @Default(false) @JsonKey(name: 'is_pro') bool isPro,
    @JsonKey(name: 'updated_at') required DateTime updatedAt,
  }) = _Subscription;

  factory Subscription.fromJson(Map<String, dynamic> json) =>
      _$SubscriptionFromJson(json);
}
