import 'package:flutter_test/flutter_test.dart';
import 'package:{{project_name.snakeCase()}}/config/env_config.dart';

void main() {
  group('EnvConfig', () {
    tearDown(() => EnvConfig.setEnvironment(Environment.dev));

    test('uses the dev API by default', () {
      expect(EnvConfig.isDevelopment, isTrue);
      expect(EnvConfig.baseUrl, '{{{dev_api_url}}}');
    });

    test('switches to the prod API', () {
      EnvConfig.setEnvironment(Environment.prod);
      expect(EnvConfig.isProduction, isTrue);
      expect(EnvConfig.baseUrl, '{{{prod_api_url}}}');
    });
  });
}
