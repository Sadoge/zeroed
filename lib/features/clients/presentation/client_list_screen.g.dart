// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_list_screen.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$filteredClientsHash() => r'5efae057210a18333bcaaa91d3b2b3d8f56991c0';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

/// See also [filteredClients].
@ProviderFor(filteredClients)
const filteredClientsProvider = FilteredClientsFamily();

/// See also [filteredClients].
class FilteredClientsFamily extends Family<List<DemoClient>> {
  /// See also [filteredClients].
  const FilteredClientsFamily();

  /// See also [filteredClients].
  FilteredClientsProvider call(String query) {
    return FilteredClientsProvider(query);
  }

  @override
  FilteredClientsProvider getProviderOverride(
    covariant FilteredClientsProvider provider,
  ) {
    return call(provider.query);
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'filteredClientsProvider';
}

/// See also [filteredClients].
class FilteredClientsProvider extends AutoDisposeProvider<List<DemoClient>> {
  /// See also [filteredClients].
  FilteredClientsProvider(String query)
    : this._internal(
        (ref) => filteredClients(ref as FilteredClientsRef, query),
        from: filteredClientsProvider,
        name: r'filteredClientsProvider',
        debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
            ? null
            : _$filteredClientsHash,
        dependencies: FilteredClientsFamily._dependencies,
        allTransitiveDependencies:
            FilteredClientsFamily._allTransitiveDependencies,
        query: query,
      );

  FilteredClientsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.query,
  }) : super.internal();

  final String query;

  @override
  Override overrideWith(
    List<DemoClient> Function(FilteredClientsRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: FilteredClientsProvider._internal(
        (ref) => create(ref as FilteredClientsRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        query: query,
      ),
    );
  }

  @override
  AutoDisposeProviderElement<List<DemoClient>> createElement() {
    return _FilteredClientsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is FilteredClientsProvider && other.query == query;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, query.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin FilteredClientsRef on AutoDisposeProviderRef<List<DemoClient>> {
  /// The parameter `query` of this provider.
  String get query;
}

class _FilteredClientsProviderElement
    extends AutoDisposeProviderElement<List<DemoClient>>
    with FilteredClientsRef {
  _FilteredClientsProviderElement(super.provider);

  @override
  String get query => (origin as FilteredClientsProvider).query;
}

// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
