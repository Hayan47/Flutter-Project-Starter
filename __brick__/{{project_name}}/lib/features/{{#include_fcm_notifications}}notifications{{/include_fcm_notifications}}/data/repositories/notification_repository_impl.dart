import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:{{project_name.snakeCase()}}/core/error/failures.dart';
import 'package:{{project_name.snakeCase()}}/core/services/device_info_service.dart';
import 'package:{{project_name.snakeCase()}}/features/notifications/data/data_sources/remote/notification_api_service.dart';
import 'package:{{project_name.snakeCase()}}/features/notifications/domain/entities/paginated_notifications_response.dart';
import 'package:{{project_name.snakeCase()}}/features/notifications/domain/repositories/notification_repository.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/error/exception_mapper.dart';

@Injectable(as: NotificationRepository)
class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationApiService _notificationApiService;
  final DeviceInfoService _deviceInfoService;

  NotificationRepositoryImpl(
    this._notificationApiService,
    this._deviceInfoService,
  );

  @override
  Future<Either<Failure, PaginatedNotificationsResponseEntity>>
  getNotifications(int page, int pageSize) async {
    try {
      final httpResponse = await _notificationApiService.getNotifications(
        page: page,
        pageSize: pageSize,
      );
      return Right(httpResponse.data.toEntity());
    } on DioException catch (e) {
      return Left(mapToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> registerDeviceToken({
    required String token,
  }) async {
    try {
      final deviceId = await _deviceInfoService.getDeviceId();
      final platform = _deviceInfoService.getPlatform();

      await _notificationApiService.registerToken(
        token: token,
        platform: platform,
        deviceId: deviceId,
      );
      return Right(null);
    } on DioException catch (e) {
      return Left(mapToFailure(e));
    }
  }

  @override
  Future<Either<Failure, void>> markNotificationAsRead({
    required String notificationId,
  }) async {
    try {
      await _notificationApiService.markNotificationAsRead(
        notificationId: notificationId,
      );
      return Right(null);
    } on DioException catch (e) {
      return Left(mapToFailure(e));
    }
  }
}
