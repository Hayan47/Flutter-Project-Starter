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
        return 'https://api-goldengroup.dev.itlandfz.com';
      case Environment.prod:
        return 'https://api.goldengroupco.com';
      case Environment.mock:
        return 'https://mock-api.goldengroupco.com'; // Not used but required
    }
  }

  static bool get isProduction => _environment == Environment.prod;
  static bool get isDevelopment => _environment == Environment.dev;
  static bool get isMock => _environment == Environment.mock;
}
