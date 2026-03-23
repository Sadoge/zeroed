import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';

import 'package:zeroed/core/router/app_router.dart';
import 'package:zeroed/shared/widgets/bottom_nav_shell.dart';

/// Shell wrapper that provides bottom navigation for the main tabs.
///
/// Used as the parent route for Dashboard, Clients, Settings.
@RoutePage()
class MainShellScreen extends StatelessWidget {
  const MainShellScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AutoTabsRouter(
      routes: const [
        DashboardRoute(),
        ClientListRoute(),
        SettingsRoute(),
      ],
      builder: (context, child) {
        final tabsRouter = AutoTabsRouter.of(context);
        return BottomNavShell(
          currentIndex: tabsRouter.activeIndex,
          onTap: tabsRouter.setActiveIndex,
          child: child,
        );
      },
    );
  }
}
