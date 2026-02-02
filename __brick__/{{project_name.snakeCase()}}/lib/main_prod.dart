import 'package:{{project_name.snakeCase()}}/config/env_config.dart';
import 'package:{{project_name.snakeCase()}}/main.dart' as app;

Future<void> main() async {
  EnvConfig.setEnvironment(Environment.prod);
  await app.main();
}
