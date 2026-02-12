class AppConstants {
  static const String appName = '{{project_name.titleCase()}}';

  // Storage Keys
  {{#use_jwt_auth}}
  static const String tokenKey = 'auth_token';
  static const String refreshTokenKey = 'refresh_token';{{/use_jwt_auth}}
  static const String languageKey = 'language';
  static const String themeKey = 'theme_mode';

  // API Constants
  static const int apiTimeoutSeconds = 10;{{#use_jwt_auth}}
  static const String tokenRefreshEndpoint = '/auth/token/refresh';{{/use_jwt_auth}}

  // Pagination
  static const int defaultPageSize = 20;

  // Image Constants
  static const double maxImageSizeMB = 5.0;
  static const int imageQuality = 85;
}
