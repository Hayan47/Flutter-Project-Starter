import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:{{project_name.snakeCase()}}/config/routes.dart';
import 'package:{{project_name.snakeCase()}}/features/splash/presentation/pages/splash_page.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: Routes.splash,
    debugLogDiagnostics: true,

    routes: [
      // Splash Screen
      GoRoute(
        path: Routes.splash,
        name: Routes.splash,
        builder: (context, state) => const SplashPage(),
      ),

      // Add your routes here as you build features
    ],
    errorBuilder: (context, state) {
      return Scaffold(
        body: Center(child: Text('Page not found: ${state.uri}')),
      );
    },
  );
}
