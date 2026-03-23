import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:zeroed/core/services/subscription_service.dart';

part 'paywall_view_model.g.dart';

@riverpod
Future<List<Package>> availablePackages(Ref ref) async {
  return ref.watch(subscriptionServiceProvider).getPackages();
}

@riverpod
class PaywallNotifier extends _$PaywallNotifier {
  @override
  FutureOr<void> build() {}

  Future<bool> purchase(Package package) async {
    state = const AsyncLoading();
    final success =
        await ref.read(subscriptionServiceProvider).purchase(package);
    state = const AsyncData(null);
    if (success) {
      ref.invalidate(isProUserProvider);
    }
    return success;
  }

  Future<bool> restore() async {
    state = const AsyncLoading();
    final success = await ref.read(subscriptionServiceProvider).restore();
    state = const AsyncData(null);
    if (success) {
      ref.invalidate(isProUserProvider);
    }
    return success;
  }
}
