import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:zeroed/features/settings/data/settings_repository.dart';
import 'package:zeroed/features/settings/data/subscription_repository.dart';
import 'package:zeroed/models/business_profile.dart';
import 'package:zeroed/models/subscription_model.dart';

part 'settings_view_model.g.dart';

@riverpod
Future<BusinessProfile?> businessProfile(Ref ref) async {
  return ref.watch(settingsRepositoryProvider).getProfile();
}

@riverpod
Future<Subscription?> subscription(Ref ref) async {
  return ref.watch(subscriptionRepositoryProvider).getSubscription();
}

@riverpod
class ProfileEditor extends _$ProfileEditor {
  @override
  FutureOr<void> build() {}

  Future<void> updateProfile(BusinessProfile profile) async {
    state = const AsyncLoading();
    state = await AsyncValue.guard(() async {
      await ref.read(settingsRepositoryProvider).updateProfile(profile);
      ref.invalidate(businessProfileProvider);
    });
  }
}
