enum Environment { dev, prod, mock }

class EnvConfig {
  static Environment _environment = Environment.dev;

  static Environment get environment => _environment;

  static void setEnvironment(Environment env) {
    _environment = env;
  }

  static String get baseUrl {
    switch (_environment) {
      case Environment.dev:
        return '{{dev_api_url}}';
      case Environment.prod:
        return '{{prod_api_url}}';
      case Environment.mock:
        return 'https://mock-api.{{project_name.snakeCase()}}.com'; // Not used but required
    }
  }

  static bool get isProduction => _environment == Environment.prod;
  static bool get isDevelopment => _environment == Environment.dev;
  static bool get isMock => _environment == Environment.mock;
}
