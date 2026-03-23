// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'client_list_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$clientListHash() => r'd7ca6da37916fff548a02b51eff6fdd68efa079e';

/// See also [clientList].
@ProviderFor(clientList)
final clientListProvider = AutoDisposeFutureProvider<List<Client>>.internal(
  clientList,
  name: r'clientListProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$clientListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ClientListRef = AutoDisposeFutureProviderRef<List<Client>>;
String _$clientListViewModelHash() =>
    r'a2a94fc08f3fca61013629168c1961918ed34528';

/// See also [ClientListViewModel].
@ProviderFor(ClientListViewModel)
final clientListViewModelProvider =
    AutoDisposeAsyncNotifierProvider<ClientListViewModel, void>.internal(
      ClientListViewModel.new,
      name: r'clientListViewModelProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$clientListViewModelHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ClientListViewModel = AutoDisposeAsyncNotifier<void>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
