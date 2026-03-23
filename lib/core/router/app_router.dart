import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:zeroed/core/router/auth_guard.dart';
import 'package:zeroed/features/auth/presentation/sign_in_screen.dart';
import 'package:zeroed/features/auth/presentation/sign_up_screen.dart';
import 'package:zeroed/features/onboarding/presentation/onboarding_screen.dart';
import 'package:zeroed/features/dashboard/presentation/dashboard_screen.dart';
import 'package:zeroed/features/clients/presentation/client_list_screen.dart';
import 'package:zeroed/features/settings/presentation/settings_screen.dart';
import 'package:zeroed/features/invoices/presentation/create_invoice_screen.dart';
import 'package:zeroed/features/invoices/presentation/invoice_detail_screen.dart';
import 'package:zeroed/features/invoices/presentation/invoice_preview_screen.dart';
import 'package:zeroed/features/paywall/presentation/paywall_screen.dart';
import 'package:zeroed/features/tax_export/presentation/tax_export_screen.dart';
import 'package:zeroed/shared/widgets/main_shell.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes => [
        // Auth
        AutoRoute(page: SignInRoute.page, initial: true),
        AutoRoute(page: SignUpRoute.page),

        // Onboarding
        AutoRoute(page: OnboardingRoute.page),

        // Main shell with bottom nav tabs
        AutoRoute(
          page: MainShellRoute.page,
          guards: [AuthGuard()],
          children: [
            AutoRoute(page: DashboardRoute.page),
            AutoRoute(page: ClientListRoute.page),
            AutoRoute(page: SettingsRoute.page),
          ],
        ),

        // Full-screen routes (all behind auth)
        AutoRoute(
          page: CreateInvoiceRoute.page,
          guards: [AuthGuard()],
        ),
        AutoRoute(
          page: InvoiceDetailRoute.page,
          path: '/invoice/:id',
          guards: [AuthGuard()],
        ),
        AutoRoute(
          page: InvoicePreviewRoute.page,
          path: '/invoice/:id/preview',
          guards: [AuthGuard()],
        ),
        AutoRoute(page: PaywallRoute.page),
        AutoRoute(page: TaxExportRoute.page),
      ];
}
