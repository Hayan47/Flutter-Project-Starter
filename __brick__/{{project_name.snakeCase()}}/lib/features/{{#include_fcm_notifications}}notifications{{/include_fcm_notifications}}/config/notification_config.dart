import 'dart:io';

import 'package:flutter_local_notifications/flutter_local_notifications.dart';

/// Centralized configuration for local notifications.
/// Provides consistent settings for both foreground and background notification handling.
class NotificationConfig {
  NotificationConfig._();

  // Constants
  static const String channelId = 'general';
  static const String channelName = 'General Notifications';
  static const String channelDescription = 'App updates and alerts';
  static const String androidIcon = '@drawable/ic_launcher_foreground';
  static const String defaultTitle = 'New Notification';
  static const String defaultBody = 'You have a new notification';

  /// Android notification channel configuration
  static const AndroidNotificationChannel androidChannel =
      AndroidNotificationChannel(
        channelId,
        channelName,
        description: channelDescription,
        importance: Importance.high,
      );

  /// Android initialization settings
  static AndroidInitializationSettings getAndroidInitializationSettings() {
    return const AndroidInitializationSettings(androidIcon);
  }

  /// Darwin (iOS/macOS) initialization settings
  static DarwinInitializationSettings getDarwinInitializationSettings() {
    return const DarwinInitializationSettings(
      requestAlertPermission: true,
      requestBadgePermission: true,
      requestSoundPermission: true,
    );
  }

  /// Combined initialization settings for all platforms
  static InitializationSettings getInitializationSettings() {
    return InitializationSettings(
      android: getAndroidInitializationSettings(),
      iOS: getDarwinInitializationSettings(),
      macOS: getDarwinInitializationSettings(),
    );
  }

  /// Android notification details with high priority
  static AndroidNotificationDetails buildAndroidNotificationDetails() {
    return const AndroidNotificationDetails(
      channelId,
      channelName,
      channelDescription: channelDescription,
      importance: Importance.high,
      priority: Priority.high,
      icon: androidIcon,
      showWhen: true,
      enableVibration: true,
      playSound: true,
    );
  }

  /// Darwin (iOS/macOS) notification details
  static DarwinNotificationDetails buildDarwinNotificationDetails() {
    return const DarwinNotificationDetails(
      presentAlert: true,
      presentBadge: true,
      presentSound: true,
    );
  }

  /// Combined notification details for all platforms
  static NotificationDetails buildNotificationDetails() {
    return NotificationDetails(
      android: buildAndroidNotificationDetails(),
      iOS: buildDarwinNotificationDetails(),
      macOS: buildDarwinNotificationDetails(),
    );
  }

  /// Create notification channel for Android
  static Future<void> createAndroidChannel(
    FlutterLocalNotificationsPlugin plugin,
  ) async {
    if (Platform.isAndroid) {
      await plugin
          .resolvePlatformSpecificImplementation<
            AndroidFlutterLocalNotificationsPlugin
          >()
          ?.createNotificationChannel(androidChannel);
    }
  }
}
