import 'dart:async';
import 'dart:convert';

import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../core/error/failures.dart';
import '../../../../../../core/services/logger_service.dart';
import '../../../../../../core/storage/local_storage_service.dart';
import '../../../domain/entities/fcm_message.dart';
import '../local/local_notification_service.dart';
import '../remote/fcm_service.dart';

/// Mock FCM service for testing without Firebase.
/// Provides the same interface as the real FCMService but doesn't require Firebase initialization.
@LazySingleton(as: FCMService, env: ['mock'])
class FCMMockService implements FCMService {
  final LocalNotificationService _localNotificationService;
  final LocalStorageService _storage;
  final LoggerService _logger;

  // Stream controllers (same as real FCMService)
  final _messageController = StreamController<FCMMessageEntity>.broadcast();
  final _messageTapController = StreamController<FCMMessageEntity>.broadcast();
  final _tokenRefreshController = StreamController<String>.broadcast();

  // Mock token
  static const String _mockToken = 'mock-fcm-token-123456789';

  FCMMockService(this._localNotificationService, this._storage, this._logger);

  @override
  Stream<FCMMessageEntity> get messageStream => _messageController.stream;

  @override
  Stream<FCMMessageEntity> get messageTapStream => _messageTapController.stream;

  @override
  Stream<String> get tokenRefreshStream => _tokenRefreshController.stream;

  @override
  Future<void> initialize() async {
    _logger.info('🎭 Initializing MOCK FCM Service...');
    await _checkNotificationAppLaunch();
    _logger.info('✅ Mock FCM initialized (no Firebase required)');
  }

  @override
  Future<Either<Failure, String>> getToken() async {
    _logger.info('🎭 Returning mock FCM token: $_mockToken');
    return Right(_mockToken);
  }

  @override
  Future<void> subscribeToTopic(String topic) async {
    _logger.info('🎭 Mock subscribed to topic: $topic (no-op)');
  }

  @override
  Future<void> unsubscribeFromTopic(String topic) async {
    _logger.info('🎭 Mock unsubscribed from topic: $topic (no-op)');
  }

  @override
  void dispose() {
    _messageController.close();
    _messageTapController.close();
    _tokenRefreshController.close();
    _logger.info('Mock FCMService disposed');
  }

  /// Public method to simulate receiving a notification (for testing)
  Future<void> simulateNotification({
    required String notificationId,
    required String type,
    required String title,
    required String body,
    Map<String, dynamic>? data,
  }) async {
    _logger.info('🎭 Simulating notification: $title');

    final message = FCMMessageEntity(
      notificationId: notificationId,
      type: type,
      title: title,
      body: body,
      data: data ?? {},
    );

    // Show local notification
    await _localNotificationService.showNotification(
      id: DateTime.now().millisecondsSinceEpoch,
      title: title,
      body: body,
      data: {
        'notification_id': notificationId,
        'type': type,
        'title': title,
        'body': body,
        'data': data ?? {},
      },
    );

    // Emit to message stream
    _messageController.add(message);
  }

  /// Public method to simulate notification tap
  void simulateTap(FCMMessageEntity message) {
    _logger.info('🎭 Simulating notification tap: ${message.title}');
    _messageTapController.add(message);
  }

  @override
  void onNotificationTap(dynamic response) {
    // Handle notification taps same as real service
    _logger.info('Mock notification tapped: ${response.payload}');

    if (response.payload != null) {
      try {
        final payloadData = jsonDecode(response.payload!);
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
        _logger.severe('Error parsing mock notification payload: $e');
      }
    }
  }

  Future<void> _checkNotificationAppLaunch() async {
    _logger.info('🎭 Mock: Checking notification app launch...');

    try {
      final details = await _localNotificationService.getAppLaunchDetails();

      if (details?.didNotificationLaunchApp ?? false) {
        _logger.info('🎭 Mock: App launched from notification');
        final response = details!.notificationResponse;

        if (response != null && response.payload != null) {
          try {
            final payload = jsonDecode(response.payload!);
            final data = payload['data'];

            await _storage.setBool('navigate', true);
            await _storage.setString('notification_data', jsonEncode(data));
          } catch (e) {
            _logger.severe('Mock: Error parsing notification payload: $e');
          }
        }
      }
    } catch (e) {
      _logger.severe('Mock: Error checking notification app launch: $e');
    }
  }
}
