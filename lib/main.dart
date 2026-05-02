import 'package:complaints/common/providers/theme_provider.dart';
import 'package:complaints/core/constants/app_constants.dart';
import 'package:complaints/core/preference_service/preferences_service.dart';
import 'package:complaints/core/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'core/routing/app_router.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await PreferencesService().init();

  await Supabase.initialize(
    url: 'https://jjqxeeiyoudbstaflhvf.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImpqcXhlZWl5b3VkYnN0YWZsaHZmIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NzU5MDE0NDQsImV4cCI6MjA5MTQ3NzQ0NH0.roGJB1PDCOElNakVP5revQkXbmMARyr7rzzLOSmByYk',
  );

  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = ref.watch(themeProvider);
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: theme.themeMode,
      routerConfig: router,
    );
  }
}
