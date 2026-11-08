import 'dart:async';
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../core/error/failures.dart';
import '../../../../../../core/services/logger_service.dart';
import '../../../../../../core/storage/local_storage_service.dart';
import '../../../domain/entities/fcm_message.dart';
import '../local/local_notification_service.dart';
import 'background_message_handler.dart';
import 'fcm_service.dart';

/// Real FCM service implementation using Firebase Cloud Messaging.
/// Handles permissions, tokens, topics, and exposes message streams.
/// Delegates notification display to LocalNotificationService.
@LazySingleton(as: FCMService, env: ['dev', 'prod'])
class FCMServiceImpl implements FCMService {
  final FirebaseMessaging _firebaseMessaging;
  final LocalNotificationService _localNotificationService;
  final LocalStorageService _storage;
  final LoggerService _logger;

  // Stream controllers for reactive message handling
  final _messageController = StreamController<FCMMessageEntity>.broadcast();
  final _messageTapController = StreamController<FCMMessageEntity>.broadcast();
  final _tokenRefreshController = StreamController<String>.broadcast();

  FCMServiceImpl(
    this._firebaseMessaging,
    this._localNotificationService,
    this._storage,
    this._logger,
  );

  /// Expose message stream for foreground messages
  @override
  Stream<FCMMessageEntity> get messageStream => _messageController.stream;

  /// Expose message tap stream for notification taps
  @override
  Stream<FCMMessageEntity> get messageTapStream => _messageTapController.stream;

  /// Expose token refresh stream
  @override
  Stream<String> get tokenRefreshStream => _tokenRefreshController.stream;

  /// Initialize FCM service (permissions + message handlers)
  @override
  Future<void> initialize() async {
    await _requestPermission();
    await _setupMessageHandlers();
    await _checkNotificationAppLaunch();
  }

  /// Get FCM token
  @override
  Future<Either<Failure, String>> getToken() async {
    try {
      final token = await _firebaseMessaging.getToken();
      if (token != null) {
        _logger.info('FCM token obtained: ${token.substring(0, 20)}...');
        return Right(token);
      } else {
        _logger.severe('FCM token is null');
        return Left(NetworkFailure('Error getting FCM token'));
      }
    } catch (e) {
      _logger.severe('Error getting FCM token: $e');
      return Left(NetworkFailure('Error getting FCM token'));
    }
  }

  /// Subscribe to FCM topic
  @override
  Future<void> subscribeToTopic(String topic) async {
    try {
      await _firebaseMessaging.subscribeToTopic(topic);
      _logger.info('Subscribed to topic: $topic');
    } catch (e) {
      _logger.severe('Error subscribing to topic $topic: $e');
      rethrow;
    }
  }

  /// Unsubscribe from FCM topic
  @override
  Future<void> unsubscribeFromTopic(String topic) async {
    try {
      await _firebaseMessaging.unsubscribeFromTopic(topic);
      _logger.info('Unsubscribed from topic: $topic');
    } catch (e) {
      _logger.severe('Error unsubscribing from topic $topic: $e');
      rethrow;
    }
  }

  /// Dispose stream controllers to prevent memory leaks
  @override
  void dispose() {
    _messageController.close();
    _messageTapController.close();
    _tokenRefreshController.close();
    _logger.info('FCMService disposed');
  }

  /// Request FCM notification permissions
  Future<void> _requestPermission() async {
    try {
      final settings = await _firebaseMessaging.requestPermission(
        alert: true,
        announcement: false,
        badge: true,
        carPlay: false,
        criticalAlert: false,
        provisional: false,
        sound: true,
      );

      _logger.info('FCM Permission status: ${settings.authorizationStatus}');
    } catch (e) {
      _logger.severe('Error requesting FCM permissions: $e');
    }
  }

  /// Setup FCM message handlers and listeners
  Future<void> _setupMessageHandlers() async {
    // Handle foreground messages
    FirebaseMessaging.onMessage.listen(_handleForegroundMessage);

    // Handle background message taps
    FirebaseMessaging.onMessageOpenedApp.listen(_handleBackgroundMessageTap);

    // Handle token refresh
    _firebaseMessaging.onTokenRefresh.listen(_handleOnTokenRefresh);

    // Handle app launch from notification (terminated state)
    _logger.info('Checking for initial message...');
    final message = await _firebaseMessaging.getInitialMessage();
    if (message != null) {
      _logger.info('App launched from notification: ${message.data}');
      _handleBackgroundMessageTap(message);
    } else {
      _logger.info('App launched normally');
    }

    // Register background message handler
    FirebaseMessaging.onBackgroundMessage(backgroundMessageHandler);
  }

  /// Handle foreground messages (app is open)
  void _handleForegroundMessage(RemoteMessage message) {
    _logger.info('Received foreground message: ${message.toMap()}');

    // Delegate notification display to LocalNotificationService
    _localNotificationService.showNotificationFromMessage(message);

    // Emit message to stream
    _messageController.add(
      FCMMessageEntity(
        notificationId: message.data['notification_id'] ?? message.messageId,
        type: message.data['type'],
        title: message.notification?.title,
        body: message.notification?.body,
        data: message.data,
      ),
    );
  }

  /// Handle background message taps (notification was tapped)
  void _handleBackgroundMessageTap(RemoteMessage message) {
    _logger.info('_handleBackgroundMessageTap fired');
    _logger.info('Message tapped: ${message.notification?.title}');
    _logger.info('Message data: ${message.data}');

    // Emit tap event to stream
    _messageTapController.add(
      FCMMessageEntity(
        notificationId: message.data['notification_id'] ?? message.messageId,
        type: message.data['type'],
        title: message.notification?.title,
        body: message.notification?.body,
        data: message.data,
      ),
    );
  }

  /// Handle local notification taps
  @override
  void onNotificationTap(response) {
    _logger.info('Local notification tapped: ${response.payload}');
    _logger.info('Local notification tapped: ID ${response.id}');
    _logger.info('Local notification tapped: ActionID ${response.actionId}');
    _logger.info('Local notification tapped: input ${response.input}');

    if (response.payload != null) {
      try {
        final payloadData = jsonDecode(response.payload!);

        // Emit tap event to stream
        _messageTapController.add(
          FCMMessageEntity(
            notificationId: payloadData['notification_id'],
            type: payloadData['type'],
            title: payloadData['title'],
            body: payloadData['body'],
            data: Map<String, dynamic>.from(payloadData['data'] ?? {}),
          ),
        );
      } catch (e) {
        _logger.severe('Error parsing local notification payload: $e');
        _logger.severe('Payload was: ${response.payload}');
      }
    }
  }

  /// Handle token refresh events
  void _handleOnTokenRefresh(String token) {
    _logger.info('FCM token refreshed: ${token.substring(0, 20)}...');
    _tokenRefreshController.add(token);
  }

  /// Check if app was launched from a notification
  Future<void> _checkNotificationAppLaunch() async {
    _logger.info('Checking if app was launched from notification...');

    try {
      final notificationAppLaunchDetails =
          await _localNotificationService.getAppLaunchDetails();

      if (notificationAppLaunchDetails?.didNotificationLaunchApp ?? false) {
        _logger.info('App WAS launched from notification!');

        final response = notificationAppLaunchDetails!.notificationResponse;
        _logger.info('Notification response: ${response?.payload}');

        if (response != null && response.payload != null) {
          try {
            final payload = jsonDecode(response.payload!);
            final data = payload['data'];
            _logger.info('Parsed notification data: $data');

            // Store navigation data for handling after app initialization
            await _storage.setBool('navigate', true);
            await _storage.setString('notification_data', jsonEncode(data));
          } catch (e) {
            _logger.severe('Error parsing notification payload: $e');
          }
        }
      } else {
        _logger.info('App launched normally (not from notification)');
      }
    } catch (e) {
      _logger.severe('Error checking notification app launch: $e');
    }
  }
}
