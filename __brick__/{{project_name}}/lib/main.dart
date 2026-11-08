{{#include_localization}}import 'package:easy_localization/easy_localization.dart';
{{/include_localization}}import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:{{project_name.snakeCase()}}/app.dart';
import 'package:{{project_name.snakeCase()}}/config/env_config.dart';
import 'package:{{project_name.snakeCase()}}/config/injection.dart';
import 'package:{{project_name.snakeCase()}}/core/services/logger_service.dart';

/// Common entry point for all flavors
/// This ensures consistent initialization across dev and prod environments
Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize logger
  final logger = LoggerService();
  logger.info('🚀 Starting {{project_name.titleCase()}} App');
  logger.info('🌐 Base URL: ${EnvConfig.baseUrl}');

  // Set preferred orientations
  await SystemChrome.setPreferredOrientations([
    DeviceOrientation.portraitUp,
    DeviceOrientation.portraitDown,
  ]);
{{#include_localization}}
  // Initialize Easy Localization
  await EasyLocalization.ensureInitialized();
{{/include_localization}}
  // Configure dependencies
  logger.info('⚙️ Configuring dependencies...');
  await configureDependencies();
  logger.info('✅ Dependencies configured successfully');

  // Run app
  runApp({{#include_localization}}
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      fallbackLocale: const Locale('en'),
      startLocale: const Locale('en'),
      child: const MyApp(),
    ),{{/include_localization}}{{^include_localization}}
    const MyApp(),{{/include_localization}}
  );
}
