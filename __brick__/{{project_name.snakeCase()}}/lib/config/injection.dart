import 'package:get_it/get_it.dart';
import 'package:{{project_name.snakeCase()}}/config/env_config.dart';
import 'package:{{project_name.snakeCase()}}/core/network/api_client.dart';
import 'package:{{project_name.snakeCase()}}/core/services/connectivity_service.dart';
import 'package:{{project_name.snakeCase()}}/core/services/logger_service.dart';
import 'package:{{project_name.snakeCase()}}/core/storage/hive_service.dart';
import 'package:{{project_name.snakeCase()}}/core/storage/local_storage_service.dart';
import 'package:injectable/injectable.dart' hide Environment;

import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies() async {
  getIt.init(environment: EnvConfig.environment.name);

  // Register core services
  getIt.registerLazySingleton<LoggerService>(() => LoggerService());

  getIt.registerLazySingleton<ApiClient>(
    () => ApiClient(baseUrl: EnvConfig.baseUrl, logger: getIt<LoggerService>()),
  );

  // Initialize and register storage services
  final localStorage = LocalStorageService();
  await localStorage.init();
  getIt.registerLazySingleton<LocalStorageService>(() => localStorage);

  final hiveService = HiveService();
  await hiveService.init();
  getIt.registerLazySingleton<HiveService>(() => hiveService);

  // Register connectivity service
  getIt.registerLazySingleton<ConnectivityService>(() => ConnectivityService());
}