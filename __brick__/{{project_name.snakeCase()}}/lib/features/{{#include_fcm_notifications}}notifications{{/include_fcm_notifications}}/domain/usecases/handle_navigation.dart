import 'package:dartz/dartz.dart';
import 'package:{{project_name.snakeCase()}}/core/error/failures.dart';
import 'package:injectable/injectable.dart';

import '../../../../../config/router.dart';
import '../../../../../config/routes.dart';
import '../../../../../core/utils/usecase.dart';
import '../entities/fcm_message.dart';

class HandleNavigationParams {
  final FCMMessageEntity fcmMessageEntity;

  HandleNavigationParams({required this.fcmMessageEntity});
}

@injectable
class HandleNavigationUseCase implements UseCase<void, HandleNavigationParams> {
  HandleNavigationUseCase();

  @override
  Future<Either<Failure, void>> call(HandleNavigationParams params) async {
    // Your navigation logic based on message type
    // print("Action: ${params.fcmMessageEntity.action}");
    switch (params.fcmMessageEntity.action) {
      default:
        AppRouter.router.push(Routes.notifications);
        return Right(null);
    }
  }
}
