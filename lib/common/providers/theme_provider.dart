import 'package:complaints/common/models/theme.dart';
import 'package:complaints/common/providers/service_providers.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// Provider for the theme
final themeProvider = StateNotifierProvider<ThemeNotifier, AppThemeMode>((ref) {
  return ThemeNotifier(ref);
});

/// Notifier for the theme provider
class ThemeNotifier extends StateNotifier<AppThemeMode> {
  final Ref ref;

  ThemeNotifier(this.ref) : super(AppThemeMode.system) {
    _loadTheme();
  }

  Future<void> _loadTheme() async {
    final themeMode = await ref.read(preferencesServiceProvider).getThemeMode();
    state = themeMode;
  }

  Future<void> setTheme(AppThemeMode themeMode) async {
    await ref.read(preferencesServiceProvider).setThemeMode(themeMode);
    state = themeMode;
  }
}
