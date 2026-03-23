import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'package:zeroed/app.dart';
import 'package:zeroed/core/env/env.dart';
import 'package:zeroed/core/services/hive_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: Env.supabaseUrl,
    anonKey: Env.supabaseAnonKey,
  );

  await Hive.initFlutter();
  await HiveService.instance.init();

  runApp(
    const ProviderScope(
      child: ZeroedApp(),
    ),
  );
}
