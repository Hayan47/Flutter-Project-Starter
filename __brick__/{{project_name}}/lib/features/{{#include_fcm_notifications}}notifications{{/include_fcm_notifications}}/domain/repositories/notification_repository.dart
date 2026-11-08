import 'package:dartz/dartz.dart';
import 'package:{{project_name.snakeCase()}}/features/notifications/domain/entities/paginated_notifications_response.dart';

import '../../../../../core/error/failures.dart';

abstract class NotificationRepository {
  Future<Either<Failure, void>> registerDeviceToken({required String token});

  Future<Either<Failure, PaginatedNotificationsResponseEntity>>
  getNotifications(int page, int pageSize);

  Future<Either<Failure, void>> markNotificationAsRead({
    required String notificationId,
  });
}
