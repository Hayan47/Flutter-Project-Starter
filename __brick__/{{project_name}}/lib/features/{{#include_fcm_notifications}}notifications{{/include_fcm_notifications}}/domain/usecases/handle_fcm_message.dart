import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/utils/usecase.dart';
import '../../data/data_sources/remote/fcm_service.dart';
import '../entities/fcm_message.dart';

@injectable
class HandleFCMMessageUseCase implements UseCase<FCMMessageEntity, void> {
  final FCMService fcmService;

  HandleFCMMessageUseCase(this.fcmService);

  /// Expose message stream for foreground messages
  Stream<FCMMessageEntity> get messageStream => fcmService.messageStream;

  /// Expose message tap stream for notification taps
  Stream<FCMMessageEntity> get messageTapStream => fcmService.messageTapStream;

  /// Expose token refresh stream
  Stream<String> get tokenRefreshStream => fcmService.tokenRefreshStream;

  /// Subscribe to FCM topic
  Future<void> subscribeToTopic(String topic) {
    return fcmService.subscribeToTopic(topic);
  }

  /// Unsubscribe from FCM topic
  Future<void> unsubscribeFromTopic(String topic) {
    return fcmService.unsubscribeFromTopic(topic);
  }

  @override
  Future<Either<Failure, FCMMessageEntity>> call(void params) {
    // Not used - streams are the primary interface
    throw UnimplementedError(
      'Use messageStream, messageTapStream, or tokenRefreshStream instead',
    );
  }
}
