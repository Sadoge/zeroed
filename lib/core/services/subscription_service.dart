import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:purchases_flutter/purchases_flutter.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'subscription_service.g.dart';

/// RevenueCat entitlement identifier for Pro features.
const kProEntitlement = 'pro';

/// RevenueCat API keys — replace with real values.
const _rcAppleKey = 'appl_YOUR_REVENUECAT_KEY';
const _rcGoogleKey = 'goog_YOUR_REVENUECAT_KEY';

class SubscriptionService {
  SubscriptionService._();
  static final instance = SubscriptionService._();

  bool _initialized = false;

  Future<void> init({required bool isApple}) async {
    if (_initialized) return;

    await Purchases.configure(
      PurchasesConfiguration(isApple ? _rcAppleKey : _rcGoogleKey),
    );
    _initialized = true;
  }

  /// Check if the user has an active Pro subscription.
  Future<bool> isProUser() async {
    try {
      final info = await Purchases.getCustomerInfo();
      return info.entitlements.active.containsKey(kProEntitlement);
    } catch (_) {
      return false;
    }
  }

  /// Get available packages (monthly, annual).
  Future<List<Package>> getPackages() async {
    try {
      final offerings = await Purchases.getOfferings();
      return offerings.current?.availablePackages ?? [];
    } catch (_) {
      return [];
    }
  }

  /// Purchase a package. Returns true on success.
  Future<bool> purchase(Package package) async {
    try {
      final result = await Purchases.purchasePackage(package);
      return result.entitlements.active.containsKey(kProEntitlement);
    } catch (_) {
      return false;
    }
  }

  /// Restore previous purchases. Returns true if Pro is active.
  Future<bool> restore() async {
    try {
      final info = await Purchases.restorePurchases();
      return info.entitlements.active.containsKey(kProEntitlement);
    } catch (_) {
      return false;
    }
  }

  /// Log in user to RevenueCat (call after Supabase auth).
  Future<void> login(String userId) async {
    try {
      await Purchases.logIn(userId);
    } catch (_) {
      // Non-critical
    }
  }

  /// Log out user from RevenueCat.
  Future<void> logout() async {
    try {
      await Purchases.logOut();
    } catch (_) {
      // Non-critical
    }
  }
}

@Riverpod(keepAlive: true)
SubscriptionService subscriptionService(Ref ref) {
  return SubscriptionService.instance;
}

/// Whether the current user has Pro access.
@riverpod
Future<bool> isProUser(Ref ref) async {
  return ref.watch(subscriptionServiceProvider).isProUser();
}
