class Routes {
  Routes._();

  // Initial route
  static const String splash = '/splash';
  static const String home = '/';
  {{#include_fcm_notifications}}
  static const String notifications = '/notifications';
  {{/include_fcm_notifications}}
  
  // Add your routes here as you build features
  // Example:
  // static const String profile = '/profile';
  // static const String settings = '/settings';
}
