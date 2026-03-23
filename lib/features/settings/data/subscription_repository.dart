import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:zeroed/core/services/hive_service.dart';
import 'package:zeroed/core/services/supabase_service.dart';
import 'package:zeroed/models/subscription_model.dart';

part 'subscription_repository.g.dart';

class SubscriptionRepository {
  SubscriptionRepository(this._hive, this._supabase);

  final HiveService _hive;
  final SupabaseClient _supabase;

  static const _subscriptionKey = 'current_subscription';

  /// Fetch the current user's subscription status.
  /// Tries Supabase first, falls back to Hive cache.
  Future<Subscription?> getSubscription() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return _cachedSubscription();

      final response = await _supabase
          .from('subscriptions')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (response == null) return _cachedSubscription();

      final subscription = Subscription.fromJson(response);
      await _hive.put(
          _hive.settingsBox, _subscriptionKey, subscription.toJson());
      return subscription;
    } catch (_) {
      return _cachedSubscription();
    }
  }

  Subscription? _cachedSubscription() {
    final json = _hive.get(_hive.settingsBox, _subscriptionKey);
    if (json == null) return null;
    return Subscription.fromJson(json);
  }
}

@Riverpod(keepAlive: true)
SubscriptionRepository subscriptionRepository(Ref ref) {
  return SubscriptionRepository(
    ref.watch(hiveServiceProvider),
    ref.watch(supabaseClientProvider),
  );
}
