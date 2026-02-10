class AppConstants {
  static const String appName = 'Golden Group';

  // Storage Keys
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';
  static const String userKey = 'user_data';
  static const String languageKey = 'language';
  static const String themeKey = 'theme_mode';

  // API Constants
  static const int apiTimeoutSeconds = 10;
  static const String tokenRefreshEndpoint = '/auth/token/refresh';

  // Pagination
  static const int defaultPageSize = 20;

  // Image Constants
  static const double maxImageSizeMB = 5.0;
  static const int imageQuality = 85;
}
