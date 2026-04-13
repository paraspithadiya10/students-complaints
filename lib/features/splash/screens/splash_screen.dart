import 'package:complaints/common/widgets/max_width_widget.dart';
import 'package:complaints/core/constants/image_constants.dart';
import 'package:complaints/core/routing/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    _navigate();
  }

  void _navigate() async {
    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    context.go(AppRoutes.login.route);
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
