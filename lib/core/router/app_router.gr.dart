// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'app_router.dart';

/// generated route for
/// [ClientListScreen]
class ClientListRoute extends PageRouteInfo<void> {
  const ClientListRoute({List<PageRouteInfo>? children})
    : super(ClientListRoute.name, initialChildren: children);

  static const String name = 'ClientListRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const ClientListScreen();
    },
  );
}

/// generated route for
/// [CreateInvoiceScreen]
class CreateInvoiceRoute extends PageRouteInfo<void> {
  const CreateInvoiceRoute({List<PageRouteInfo>? children})
    : super(CreateInvoiceRoute.name, initialChildren: children);

  static const String name = 'CreateInvoiceRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const CreateInvoiceScreen();
    },
  );
}

/// generated route for
/// [DashboardScreen]
class DashboardRoute extends PageRouteInfo<void> {
  const DashboardRoute({List<PageRouteInfo>? children})
    : super(DashboardRoute.name, initialChildren: children);

  static const String name = 'DashboardRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const DashboardScreen();
    },
  );
}

/// generated route for
/// [InvoiceDetailScreen]
class InvoiceDetailRoute extends PageRouteInfo<InvoiceDetailRouteArgs> {
  InvoiceDetailRoute({
    Key? key,
    required String invoiceId,
    List<PageRouteInfo>? children,
  }) : super(
         InvoiceDetailRoute.name,
         args: InvoiceDetailRouteArgs(key: key, invoiceId: invoiceId),
         rawPathParams: {'id': invoiceId},
         initialChildren: children,
       );

  static const String name = 'InvoiceDetailRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<InvoiceDetailRouteArgs>(
        orElse: () =>
            InvoiceDetailRouteArgs(invoiceId: pathParams.getString('id')),
      );
      return InvoiceDetailScreen(key: args.key, invoiceId: args.invoiceId);
    },
  );
}

class InvoiceDetailRouteArgs {
  const InvoiceDetailRouteArgs({this.key, required this.invoiceId});

  final Key? key;

  final String invoiceId;

  @override
  String toString() {
    return 'InvoiceDetailRouteArgs{key: $key, invoiceId: $invoiceId}';
  }
}

/// generated route for
/// [InvoicePreviewScreen]
class InvoicePreviewRoute extends PageRouteInfo<InvoicePreviewRouteArgs> {
  InvoicePreviewRoute({
    Key? key,
    required String invoiceId,
    List<PageRouteInfo>? children,
  }) : super(
         InvoicePreviewRoute.name,
         args: InvoicePreviewRouteArgs(key: key, invoiceId: invoiceId),
         rawPathParams: {'id': invoiceId},
         initialChildren: children,
       );

  static const String name = 'InvoicePreviewRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      final pathParams = data.inheritedPathParams;
      final args = data.argsAs<InvoicePreviewRouteArgs>(
        orElse: () =>
            InvoicePreviewRouteArgs(invoiceId: pathParams.getString('id')),
      );
      return InvoicePreviewScreen(key: args.key, invoiceId: args.invoiceId);
    },
  );
}

class InvoicePreviewRouteArgs {
  const InvoicePreviewRouteArgs({this.key, required this.invoiceId});

  final Key? key;

  final String invoiceId;

  @override
  String toString() {
    return 'InvoicePreviewRouteArgs{key: $key, invoiceId: $invoiceId}';
  }
}

/// generated route for
/// [MainShellScreen]
class MainShellRoute extends PageRouteInfo<void> {
  const MainShellRoute({List<PageRouteInfo>? children})
    : super(MainShellRoute.name, initialChildren: children);

  static const String name = 'MainShellRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const MainShellScreen();
    },
  );
}

/// generated route for
/// [OnboardingScreen]
class OnboardingRoute extends PageRouteInfo<void> {
  const OnboardingRoute({List<PageRouteInfo>? children})
    : super(OnboardingRoute.name, initialChildren: children);

  static const String name = 'OnboardingRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const OnboardingScreen();
    },
  );
}

/// generated route for
/// [PaywallScreen]
class PaywallRoute extends PageRouteInfo<void> {
  const PaywallRoute({List<PageRouteInfo>? children})
    : super(PaywallRoute.name, initialChildren: children);

  static const String name = 'PaywallRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const PaywallScreen();
    },
  );
}

/// generated route for
/// [SettingsScreen]
class SettingsRoute extends PageRouteInfo<void> {
  const SettingsRoute({List<PageRouteInfo>? children})
    : super(SettingsRoute.name, initialChildren: children);

  static const String name = 'SettingsRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SettingsScreen();
    },
  );
}

/// generated route for
/// [SignInScreen]
class SignInRoute extends PageRouteInfo<void> {
  const SignInRoute({List<PageRouteInfo>? children})
    : super(SignInRoute.name, initialChildren: children);

  static const String name = 'SignInRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SignInScreen();
    },
  );
}

/// generated route for
/// [SignUpScreen]
class SignUpRoute extends PageRouteInfo<void> {
  const SignUpRoute({List<PageRouteInfo>? children})
    : super(SignUpRoute.name, initialChildren: children);

  static const String name = 'SignUpRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const SignUpScreen();
    },
  );
}

/// generated route for
/// [TaxExportScreen]
class TaxExportRoute extends PageRouteInfo<void> {
  const TaxExportRoute({List<PageRouteInfo>? children})
    : super(TaxExportRoute.name, initialChildren: children);

  static const String name = 'TaxExportRoute';

  static PageInfo page = PageInfo(
    name,
    builder: (data) {
      return const TaxExportScreen();
    },
  );
}
