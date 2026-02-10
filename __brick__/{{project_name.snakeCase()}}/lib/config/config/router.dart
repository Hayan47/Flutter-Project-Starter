import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:golden_group/config/injection.dart';
import 'package:golden_group/config/routes.dart';
import 'package:golden_group/features/about/presentation/pages/about_page.dart';
import 'package:golden_group/features/branches/presentation/bloc/branches_event.dart';
import 'package:golden_group/features/branches/presentation/pages/branches_page.dart';
import 'package:golden_group/features/customer_map/presentation/pages/customer_map_page.dart';
import 'package:golden_group/features/devices/presentation/bloc/devices_bloc.dart';
import 'package:golden_group/features/devices/presentation/bloc/devices_event.dart';
import 'package:golden_group/features/devices/presentation/pages/device_detail_page.dart';
import 'package:golden_group/features/devices/presentation/pages/devices_page.dart';
import 'package:golden_group/features/home/presentation/bloc/home_bloc.dart';
import 'package:golden_group/features/home/presentation/bloc/home_event.dart';
import 'package:golden_group/features/home/presentation/pages/home_page.dart';
import 'package:golden_group/features/profile/presentation/pages/profile_page.dart';
import 'package:golden_group/features/requests/presentation/pages/requests_page.dart';
import 'package:golden_group/features/requests/presentation/pages/water_test_for_me_page.dart';
import 'package:golden_group/features/requests/presentation/pages/water_test_for_someone_else_page.dart';
import 'package:golden_group/features/settings/presentation/bloc/settings_bloc.dart';
import 'package:golden_group/features/settings/presentation/bloc/settings_event.dart';
import 'package:golden_group/features/settings/presentation/pages/settings_page.dart';
import 'package:golden_group/features/social/presentation/pages/social_page.dart';
import 'package:golden_group/shared/widgets/app_scaffold.dart';

import '../features/agenting/presentation/pages/agenting_request_page.dart';
import '../features/auth/presentation/bloc/auth_bloc.dart';
import '../features/auth/presentation/bloc/auth_event.dart';
import '../features/branches/presentation/bloc/branches_bloc.dart';
import '../features/contact/presentation/bloc/contact_form_bloc.dart';
import '../features/contact/presentation/pages/contact_us_page.dart';
import '../features/recruitment/presentation/pages/recruitment_request_page.dart';
import '../features/splash/presentation/pages/random_splash.dart';

class AppRouter {
  static final _rootNavigatorKey = GlobalKey<NavigatorState>();
  static final _shellNavigatorKey = GlobalKey<NavigatorState>();

  static GoRouter router = GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: Routes.splash,
    debugLogDiagnostics: true,

    routes: [
      // Splash Screen
      GoRoute(
        path: Routes.splash,
        name: Routes.splash,
        builder: (context, state) => const RandomSplash(),
      ),

      // Bottom Navigation Shell Route
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return AppScaffold(
            currentRoute: state.matchedLocation,
            showNavigation: true,
            child: child,
          );
        },
        routes: [
          // Home Page
          GoRoute(
            path: Routes.home,
            name: Routes.home,
            pageBuilder:
                (context, state) => NoTransitionPage(
                  child: MultiBlocProvider(
                    providers: [
                      BlocProvider(
                        create:
                            (context) =>
                                getIt<HomeBloc>()
                                  ..add(const LoadHomeDataEvent()),
                      ),
                      BlocProvider(
                        create:
                            (context) =>
                                getIt<DevicesBloc>()
                                  ..add(const LoadDevicesEvent()),
                      ),
                      BlocProvider.value(
                        value:
                            getIt<AuthBloc>()..add(const AuthStatusChecked()),
                      ),
                    ],
                    child: const HomePage(),
                  ),
                ),
          ),

          // Devices Page
          GoRoute(
            path: Routes.devices,
            name: Routes.devices,
            pageBuilder:
                (context, state) => NoTransitionPage(
                  child: BlocProvider(
                    create:
                        (context) =>
                            getIt<DevicesBloc>()..add(const LoadDevicesEvent()),
                    child: const DevicesPage(),
                  ),
                ),
            routes: [
              // Device Detail Page
              GoRoute(
                path: ':id',
                name: 'device-detail',
                builder: (context, state) {
                  final deviceId = state.pathParameters['id'] ?? '';
                  return DeviceDetailPage(deviceId: deviceId);
                },
              ),
            ],
          ),

          // Branches Page
          GoRoute(
            path: Routes.branches,
            name: Routes.branches,
            pageBuilder:
                (context, state) =>
                    const NoTransitionPage(child: BranchesPage()),
          ),

          // Requests Page
          GoRoute(
            path: Routes.requests,
            name: Routes.requests,
            pageBuilder:
                (context, state) =>
                    const NoTransitionPage(child: RequestsPage()),
          ),

          // Profile Page
          GoRoute(
            path: Routes.profile,
            name: Routes.profile,
            pageBuilder:
                (context, state) => NoTransitionPage(
                  child: BlocProvider.value(
                    value: getIt<AuthBloc>()..add(const AuthStatusChecked()),
                    child: const ProfilePage(),
                  ),
                ),
          ),

          // Settings Page
          GoRoute(
            path: Routes.settings,
            name: Routes.settings,
            pageBuilder:
                (context, state) => NoTransitionPage(
                  child: BlocProvider(
                    create:
                        (context) =>
                            getIt<SettingsBloc>()
                              ..add(const LoadSettingsEvent()),
                    child: const SettingsPage(),
                  ),
                ),
          ),
        ],
      ),

      // Drawer Routes (outside bottom navigation)
      GoRoute(
        path: Routes.customerMap,
        name: Routes.customerMap,
        builder: (context, state) => const CustomerMapPage(),
      ),
      GoRoute(
        path: Routes.about,
        name: Routes.about,
        builder: (context, state) => const AboutPage(),
      ),
      GoRoute(
        path: Routes.social,
        name: Routes.social,
        builder: (context, state) => const SocialPage(),
      ),
      GoRoute(
        path: Routes.contactUs,
        name: Routes.contactUs,
        builder:
            (context, state) => MultiBlocProvider(
              providers: [
                BlocProvider(create: (context) => getIt<ContactFormBloc>()),
                BlocProvider(
                  create:
                      (context) =>
                          getIt<BranchesBloc>()..add(const LoadBranchesEvent()),
                ),
              ],
              child: const ContactUsPage(),
            ),
      ),
      // Water Test Routes
      GoRoute(
        path: Routes.waterTestForMe,
        name: 'water-test-for-me',
        builder: (context, state) => const WaterTestForMePage(),
      ),
      GoRoute(
        path: Routes.waterTestForSomeoneElse,
        name: 'water-test-for-someone-else',
        builder: (context, state) => const WaterTestForSomeoneElsePage(),
      ),

      // Recruitment Routes
      GoRoute(
        path: Routes.recruitmentRequest,
        name: 'recruitment-request',
        builder: (context, state) => const RecruitmentRequestPage(),
      ),

      // Agenting Routes
      GoRoute(
        path: Routes.agentingRequest,
        name: 'agenting-request',
        builder: (context, state) => const AgentingRequestPage(),
      ),
    ],
    errorBuilder: (context, state) {
      return Scaffold(
        body: Center(child: Text('Page not found: ${state.uri}')),
      );
    },
  );
}
