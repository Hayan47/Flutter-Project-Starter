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
  {{#include_fcm_notifications}}
  static const String getNotifications = '/notifications/';
  static const String registerToken = '/notifications/register-token/';
  static const String markNotificationAsRead = '/notifications/{notification_id}/mark-read/';
  {{/include_fcm_notifications}}

  // Pagination
  static const int defaultPageSize = 20;

  // Image Constants
  static const double maxImageSizeMB = 5.0;
  static const int imageQuality = 85;
}
