// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$businessProfileHash() => r'e3ac31471ca2c0a7d7e5f4446faaf518a8694fcd';

/// See also [businessProfile].
@ProviderFor(businessProfile)
final businessProfileProvider =
    AutoDisposeFutureProvider<BusinessProfile?>.internal(
      businessProfile,
      name: r'businessProfileProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$businessProfileHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef BusinessProfileRef = AutoDisposeFutureProviderRef<BusinessProfile?>;
String _$profileEditorHash() => r'bfcbda161a76418b8ca2739321156572f3a78373';

/// See also [ProfileEditor].
@ProviderFor(ProfileEditor)
final profileEditorProvider =
    AutoDisposeAsyncNotifierProvider<ProfileEditor, void>.internal(
      ProfileEditor.new,
      name: r'profileEditorProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$profileEditorHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ProfileEditor = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
