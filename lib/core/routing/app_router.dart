import 'package:complaints/common/screens/page_not_found_screen.dart';
import 'package:complaints/common/utils/enum_utils.dart';
import 'package:complaints/features/auth/login_screen.dart';
import 'package:complaints/features/home/screens/home_screen.dart';
import 'package:complaints/features/splash/screens/splash_screen.dart';
import 'package:complaints/features/student_list/screens/student_list_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'app_routes.dart';

// Global navigator key for accessing the router
final GlobalKey<NavigatorState> _rootNavigatorKey = GlobalKey<NavigatorState>();

// Router provider that always starts with welcome screen
final routerProvider = Provider<GoRouter>((ref) {
  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: AppRoutes.splash.route,
    routes: [
      // Splash route
      GoRoute(
        path: AppRoutes.splash.route,
        name: AppRoutes.splash.name,
        builder: (context, state) => const SplashScreen(),
      ),

      // Login route
      GoRoute(
        path: AppRoutes.login.route,
        name: AppRoutes.login.name,
        builder: (context, state) => LoginScreen(),
      ),

      // Home route
      GoRoute(
        path: AppRoutes.home.route,
        name: AppRoutes.home.name,
        builder: (context, state) => HomeScreen(),
      ),

      // Student List route
      GoRoute(
        path: AppRoutes.studentList.route,
        name: AppRoutes.studentList.name,
        builder: (context, state) =>
            StudentListScreen(streamType: state.extra as StreamType),
      ),
    ],
    errorBuilder: (context, state) => const PageNotFoundScreen(),
  );
});
