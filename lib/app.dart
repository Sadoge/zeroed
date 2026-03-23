import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:zeroed/core/router/app_router.dart';
import 'package:zeroed/core/services/supabase_service.dart';
import 'package:zeroed/core/theme/app_theme.dart';

class ZeroedApp extends ConsumerStatefulWidget {
  const ZeroedApp({super.key});

  @override
  ConsumerState<ZeroedApp> createState() => _ZeroedAppState();
}

class _ZeroedAppState extends ConsumerState<ZeroedApp> {
  final _appRouter = AppRouter();
  bool _didCheckSession = false;

  @override
  Widget build(BuildContext context) {
    ref.listen(authStateChangesProvider, (_, next) {
      next.whenData((authState) {
        final event = authState.event;
        if (event == AuthChangeEvent.signedOut) {
          _appRouter.replaceAll([const SignInRoute()]);
        }
      });
    });

    // On first build, redirect to main shell if user already has a session.
    if (!_didCheckSession) {
      _didCheckSession = true;
      final session = Supabase.instance.client.auth.currentSession;
      if (session != null) {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          _appRouter.replaceAll([const MainShellRoute()]);
        });
      }
    }

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
