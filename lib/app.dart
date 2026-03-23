import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:zeroed/core/router/app_router.dart';
import 'package:zeroed/core/services/hive_service.dart';
import 'package:zeroed/core/services/supabase_service.dart';
import 'package:zeroed/core/theme/app_theme.dart';
import 'package:zeroed/features/onboarding/presentation/onboarding_screen.dart';

class ZeroedApp extends ConsumerStatefulWidget {
  const ZeroedApp({super.key});

  @override
  ConsumerState<ZeroedApp> createState() => _ZeroedAppState();
}

class _ZeroedAppState extends ConsumerState<ZeroedApp> {
  final _appRouter = AppRouter();

  @override
  void initState() {
    super.initState();
    // Defer auth listener to after the first frame so the router is ready.
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _listenToAuthState();
    });
  }

  void _listenToAuthState() {
    ref.listen(authStateChangesProvider, (_, next) {
      next.whenData((authState) {
        final event = authState.event;
        if (event == AuthChangeEvent.signedIn ||
            event == AuthChangeEvent.tokenRefreshed) {
          final hasOnboarded = HiveService.instance.settingsBox
              .get(kOnboardingComplete);
          if (hasOnboarded == 'true') {
            _appRouter.replaceAll([const MainShellRoute()]);
          } else {
            _appRouter.replaceAll([const OnboardingRoute()]);
          }
        } else if (event == AuthChangeEvent.signedOut) {
          _appRouter.replaceAll([const SignInRoute()]);
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Zeroed',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.darkTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.dark,
      routerConfig: _appRouter.config(),
    );
  }
}
