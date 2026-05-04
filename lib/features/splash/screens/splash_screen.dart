import 'package:complaints/common/providers/profile_controller_provider.dart';
import 'package:complaints/common/utils/pref_keys.dart';
import 'package:complaints/common/widgets/max_width_widget.dart';
import 'package:complaints/core/constants/image_constants.dart';
import 'package:complaints/core/routing/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  void _navigate() async {
    final pref = await SharedPreferences.getInstance();
    final isUserLoggedIn = pref.getBool(isLoggedIn);

    if (!mounted) return;

    if (isUserLoggedIn == true) {
      final currentUser = Supabase.instance.client.auth.currentUser;

      ref
          .read(profileControllerProvider.notifier)
          .getProfile(currentUser?.id ?? '');

      await Future.delayed(const Duration(seconds: 3));

      if (!mounted) return;

      context.go(AppRoutes.home.route);
    } else {
      context.go(AppRoutes.login.route);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: MaxWidthWidget(
        child: Center(
          child: Column(
            mainAxisSize: .min,
            children: [
              Image.asset(height: 200, width: 200, ImageConstants.appLogo),
            ],
          ),
        ),
      ),
    );
  }
}
