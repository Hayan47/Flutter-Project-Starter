import 'dart:convert';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../core/services/logger_service.dart';
import '../../../config/notification_config.dart';

/// Service responsible for handling local notification display.
/// Provides a centralized way to show notifications for both foreground and background scenarios.
@lazySingleton
class LocalNotificationService {
  final FlutterLocalNotificationsPlugin _plugin;
  final LoggerService? _logger;

  /// Standard constructor for dependency injection
  LocalNotificationService(this._plugin, this._logger);

  /// Factory constructor for background handler (can't use DI)
  factory LocalNotificationService.createBackgroundInstance() {
    return LocalNotificationService._(
      FlutterLocalNotificationsPlugin(),
      null, // No logger available in background
    );
  }

  /// Private constructor for internal use
  LocalNotificationService._(this._plugin, this._logger);

  /// Initialize local notifications with optional tap handler
  Future<void> initialize({Function(NotificationResponse)? onTap}) async {
    _log('Initializing local notification service...');

    try {
      final settings = NotificationConfig.getInitializationSettings();

      await _plugin.initialize(
        settings: settings,
        onDidReceiveNotificationResponse: onTap,
      );

      await createChannels();

      _log('Local notification service initialized successfully');
    } catch (e, stackTrace) {
      _logError('Error initializing local notifications: $e', stackTrace);
      rethrow;
    }
  }

  /// Create notification channels (Android only)
  Future<void> createChannels() async {
    try {
      await NotificationConfig.createAndroidChannel(_plugin);
      _log('Notification channels created');
    } catch (e, stackTrace) {
      _logError('Error creating notification channels: $e', stackTrace);
    }
  }

  /// Show notification from FCM RemoteMessage
  Future<void> showNotificationFromMessage(RemoteMessage message) async {
    try {
      final title =
          message.data['title'] as String? ??
          message.notification?.title ??
          NotificationConfig.defaultTitle;

      final body =
          message.data['body'] as String? ??
          message.notification?.body ??
          NotificationConfig.defaultBody;

      final payload = jsonEncode({
        'notification_id': message.data['notification_id'] ?? message.messageId,
        'type': message.data['type'],
        'title': title,
        'body': body,
        'data': message.data,
      });

      await _plugin.show(
        id: message.hashCode,
        title: title,
        body: body,
        notificationDetails: NotificationConfig.buildNotificationDetails(),
        payload: payload,
      );

      _log('Notification displayed: $title');
    } catch (e, stackTrace) {
      _logError('Error showing notification: $e', stackTrace);
    }
  }

  /// Show custom notification with specific data
  Future<void> showNotification({
    required int id,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    try {
      final payload = data != null ? jsonEncode(data) : null;

      await _plugin.show(
        id: id,
        title: title,
        body: body,
        notificationDetails: NotificationConfig.buildNotificationDetails(),
        payload: payload,
      );

      _log('Custom notification displayed: $title');
    } catch (e, stackTrace) {
      _logError('Error showing custom notification: $e', stackTrace);
    }
  }

  /// Get app launch details to check if app was launched from notification
  Future<NotificationAppLaunchDetails?> getAppLaunchDetails() async {
    try {
      final details = await _plugin.getNotificationAppLaunchDetails();
      _log(
        'App launch details: didLaunchFromNotification=${details?.didNotificationLaunchApp ?? false}',
      );
      return details;
    } catch (e, stackTrace) {
      _logError('Error getting app launch details: $e', stackTrace);
      return null;
    }
  }

  /// Cancel a specific notification by ID
  Future<void> cancelNotification(int id) async {
    try {
      await _plugin.cancel(id: id);
      _log('Notification $id cancelled');
    } catch (e, stackTrace) {
      _logError('Error cancelling notification: $e', stackTrace);
    }
  }

  /// Cancel all notifications
  Future<void> cancelAllNotifications() async {
    try {
      await _plugin.cancelAll();
      _log('All notifications cancelled');
    } catch (e, stackTrace) {
      _logError('Error cancelling all notifications: $e', stackTrace);
    }
  }

  /// Log messages (use logger if available, otherwise print for background)
  void _log(String message) {
    if (_logger != null) {
      _logger.info(message);
    } else {
      print('[LocalNotificationService] $message');
    }
  }

  /// Log errors (use logger if available, otherwise print for background)
  void _logError(String message, StackTrace? stackTrace) {
    if (_logger != null) {
      _logger.severe(message, null, stackTrace);
    } else {
      print('[LocalNotificationService] ERROR: $message');
      if (stackTrace != null) {
        print('Stack trace: $stackTrace');
      }
    }
  }
}
