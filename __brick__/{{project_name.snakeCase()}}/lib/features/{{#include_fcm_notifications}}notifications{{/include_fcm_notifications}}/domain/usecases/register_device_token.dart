import 'package:dartz/dartz.dart';
import 'package:{{project_name.snakeCase()}}/features/notifications/domain/repositories/notification_repository.dart';
import 'package:injectable/injectable.dart';

import '../../../../../core/error/failures.dart';
import '../../../../../core/utils/usecase.dart';

class RegisterDeviceTokenParams {
  final String token;

  RegisterDeviceTokenParams({required this.token});
}

@injectable
class RegisterDeviceTokenUseCase
    implements UseCase<void, RegisterDeviceTokenParams> {
  final NotificationRepository repository;

  RegisterDeviceTokenUseCase(this.repository);

  @override
  Future<Either<Failure, void>> call(RegisterDeviceTokenParams params) {
    return repository.registerDeviceToken(token: params.token);
  }
}
