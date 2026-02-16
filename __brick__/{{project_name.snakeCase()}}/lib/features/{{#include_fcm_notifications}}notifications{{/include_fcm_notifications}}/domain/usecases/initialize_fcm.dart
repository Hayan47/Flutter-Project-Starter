import 'package:dartz/dartz.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/utils/usecase.dart';
import '../../data/data_sources/local/local_notification_service.dart';
import '../../data/data_sources/remote/fcm_service.dart';

@injectable
class InitializeFCMUseCase implements UseCase<String, void> {
  final FCMService fcmService;
  final LocalNotificationService localNotificationService;

  InitializeFCMUseCase(this.fcmService, this.localNotificationService);

  @override
  Future<Either<Failure, String>> call(void params) async {
    try {
      // Initialize local notifications first with notification tap handler
      await localNotificationService.initialize(
        onTap: fcmService.onNotificationTap,
      );

      // Initialize FCM service
      await fcmService.initialize();

      // Get and return FCM token
      return await fcmService.getToken();
    } catch (e) {
      return Left(NetworkFailure('Failed to initialize FCM: $e'));
    }
  }
}
