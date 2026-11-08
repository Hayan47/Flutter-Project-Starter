import 'package:dartz/dartz.dart';
import 'package:{{project_name.snakeCase()}}/features/notifications/domain/repositories/notification_repository.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/utils/usecase.dart';

class MarkNotificationAsReadParams {
  final String notificationId;

  MarkNotificationAsReadParams({required this.notificationId});
}

@injectable
class MarkNotificationAsReadUseCase
    implements UseCase<void, MarkNotificationAsReadParams> {
  final NotificationRepository repository;

  MarkNotificationAsReadUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(
    MarkNotificationAsReadParams params,
  ) async {
    return await repository.markNotificationAsRead(
      notificationId: params.notificationId,
    );
  }
}
