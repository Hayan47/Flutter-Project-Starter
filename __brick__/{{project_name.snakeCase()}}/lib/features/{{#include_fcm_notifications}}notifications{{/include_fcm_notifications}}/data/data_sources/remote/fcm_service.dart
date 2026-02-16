import 'package:dartz/dartz.dart';

import '../../../../../../core/error/failures.dart';
import '../../../domain/entities/fcm_message.dart';

/// Abstract interface for FCM services.
/// Implemented by FCMServiceImpl (real) and FCMMockService (mock).
abstract class FCMService {
  /// Expose message stream for foreground messages
  Stream<FCMMessageEntity> get messageStream;

  /// Expose message tap stream for notification taps
  Stream<FCMMessageEntity> get messageTapStream;

  /// Expose token refresh stream
  Stream<String> get tokenRefreshStream;

  /// Initialize FCM service (permissions + message handlers)
  Future<void> initialize();

  /// Get FCM token
  Future<Either<Failure, String>> getToken();

  /// Subscribe to FCM topic
  Future<void> subscribeToTopic(String topic);

  /// Unsubscribe from FCM topic
  Future<void> unsubscribeFromTopic(String topic);

  /// Dispose stream controllers to prevent memory leaks
  void dispose();

  /// Handle local notification taps
  void onNotificationTap(dynamic response);
}
