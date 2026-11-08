import 'package:get_it/get_it.dart';
import 'package:{{project_name.snakeCase()}}/config/env_config.dart';
import 'package:injectable/injectable.dart' hide Environment;

import 'injection.config.dart';

final getIt = GetIt.instance;

@InjectableInit(
  initializerName: 'init',
  preferRelativeImports: true,
  asExtension: true,
)
Future<void> configureDependencies() async {
  await getIt.init(environment: EnvConfig.environment.name);
}
