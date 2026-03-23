import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:zeroed/core/services/hive_service.dart';
import 'package:zeroed/core/services/supabase_service.dart';
import 'package:zeroed/models/business_profile.dart';

part 'settings_repository.g.dart';

class SettingsRepository {
  SettingsRepository(this._hive, this._supabase);

  final HiveService _hive;
  final SupabaseClient _supabase;

  static const _profileKey = 'current_profile';

  /// Fetch the current user's business profile.
  /// Tries Supabase first, falls back to Hive cache.
  Future<BusinessProfile?> getProfile() async {
    try {
      final userId = _supabase.auth.currentUser?.id;
      if (userId == null) return _cachedProfile();

      final response = await _supabase
          .from('profiles')
          .select()
          .eq('id', userId)
          .maybeSingle();

      if (response == null) return _cachedProfile();

      final profile =
          BusinessProfile.fromJson(response);
      await _hive.put(_hive.profileBox, _profileKey, profile.toJson());
      return profile;
    } catch (_) {
      return _cachedProfile();
    }
  }

  BusinessProfile? _cachedProfile() {
    final json = _hive.get(_hive.profileBox, _profileKey);
    if (json == null) return null;
    return BusinessProfile.fromJson(json);
  }

  /// Update the business profile.
  Future<void> updateProfile(BusinessProfile profile) async {
    await _hive.put(_hive.profileBox, _profileKey, profile.toJson());

    try {
      await _supabase
          .from('profiles')
          .update(profile.toJson())
          .eq('id', profile.id);
    } catch (_) {
      await _hive.put(_hive.syncQueueBox, 'profile_update', {
        'table': 'profiles',
        'operation': 'update',
        'data': profile.toJson(),
      });
    }
  }
}

@Riverpod(keepAlive: true)
SettingsRepository settingsRepository(Ref ref) {
  return SettingsRepository(
    ref.watch(hiveServiceProvider),
    ref.watch(supabaseClientProvider),
  );
}
