// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'paywall_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$availablePackagesHash() => r'57ea22468fbf03047247d6dc4c2c830e00d7fa21';

/// See also [availablePackages].
@ProviderFor(availablePackages)
final availablePackagesProvider =
    AutoDisposeFutureProvider<List<Package>>.internal(
      availablePackages,
      name: r'availablePackagesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$availablePackagesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef AvailablePackagesRef = AutoDisposeFutureProviderRef<List<Package>>;
String _$paywallNotifierHash() => r'08651e8db6b7e80ecf69ae64cea5e69a9b455a00';

/// See also [PaywallNotifier].
@ProviderFor(PaywallNotifier)
final paywallNotifierProvider =
    AutoDisposeAsyncNotifierProvider<PaywallNotifier, void>.internal(
      PaywallNotifier.new,
      name: r'paywallNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$paywallNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$PaywallNotifier = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
