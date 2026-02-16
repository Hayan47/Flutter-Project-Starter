import 'package:dartz/dartz.dart';
import 'package:{{project_name.snakeCase()}}/features/notifications/domain/entities/paginated_notifications_response.dart';
import 'package:{{project_name.snakeCase()}}/features/notifications/domain/repositories/notification_repository.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/utils/usecase.dart';

class GetNotificationsParams {
  final int page;
  final int pageSize;

  GetNotificationsParams({required this.page, required this.pageSize});
}

@injectable
class GetNotificationsUseCase
    implements
        UseCase<PaginatedNotificationsResponseEntity, GetNotificationsParams> {
  final NotificationRepository repository;

  GetNotificationsUseCase(this.repository);

  @override
  Future<Either<Failure, PaginatedNotificationsResponseEntity>> call(
    GetNotificationsParams params,
  ) {
    return repository.getNotifications(params.page, params.pageSize);
  }
}
