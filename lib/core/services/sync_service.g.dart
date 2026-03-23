// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'sync_service.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$syncServiceHash() => r'79eb4c3cfc5537bf13ec44ad9ad1d3b042482efc';

/// Offline-first sync engine.
///
/// When the app comes back online, queued mutations are replayed
/// against Supabase in order. For now this is a placeholder that
/// will be fleshed out once repositories exist.
///
/// Copied from [SyncService].
@ProviderFor(SyncService)
final syncServiceProvider = NotifierProvider<SyncService, void>.internal(
  SyncService.new,
  name: r'syncServiceProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$syncServiceHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$SyncService = Notifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
