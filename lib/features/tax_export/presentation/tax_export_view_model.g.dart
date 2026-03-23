// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'tax_export_view_model.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$exportInvoicesHash() => r'06deb46047399c2e930e8204f214381568052a58';

/// See also [exportInvoices].
@ProviderFor(exportInvoices)
final exportInvoicesProvider =
    AutoDisposeFutureProvider<List<Invoice>>.internal(
      exportInvoices,
      name: r'exportInvoicesProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$exportInvoicesHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ExportInvoicesRef = AutoDisposeFutureProviderRef<List<Invoice>>;
String _$exportSummaryHash() => r'b4ead610263a06889d6c30f4e127c0a2f21017ad';

/// See also [exportSummary].
@ProviderFor(exportSummary)
final exportSummaryProvider = AutoDisposeFutureProvider<ExportSummary>.internal(
  exportSummary,
  name: r'exportSummaryProvider',
  debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
      ? null
      : _$exportSummaryHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
typedef ExportSummaryRef = AutoDisposeFutureProviderRef<ExportSummary>;
String _$exportPeriodNotifierHash() =>
    r'b65038d22b8d5677b589f4d7e938b5364f501a5c';

/// See also [ExportPeriodNotifier].
@ProviderFor(ExportPeriodNotifier)
final exportPeriodNotifierProvider =
    AutoDisposeNotifierProvider<ExportPeriodNotifier, ExportPeriod>.internal(
      ExportPeriodNotifier.new,
      name: r'exportPeriodNotifierProvider',
      debugGetCreateSourceHash: const bool.fromEnvironment('dart.vm.product')
          ? null
          : _$exportPeriodNotifierHash,
      dependencies: null,
      allTransitiveDependencies: null,
    );

typedef _$ExportPeriodNotifier = AutoDisposeNotifier<ExportPeriod>;
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
