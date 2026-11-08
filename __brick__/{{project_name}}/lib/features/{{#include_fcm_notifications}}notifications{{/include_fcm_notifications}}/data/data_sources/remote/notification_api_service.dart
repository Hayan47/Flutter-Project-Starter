import 'package:dio/dio.dart';
import 'package:{{project_name.snakeCase()}}/features/notifications/data/models/paginated_notifications_response.dart';
import 'package:{{project_name.snakeCase()}}/shared/constants/app_constants.dart';
import 'package:{{project_name.snakeCase()}}/shared/models/message_response.dart';
import 'package:retrofit/dio.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';

part 'notification_api_service.g.dart';

@RestApi()
abstract class NotificationApiService {
  factory NotificationApiService(Dio dio) = _NotificationApiService;

  @GET(AppConstants.getNotifications)
  Future<HttpResponse<PaginatedNotificationsResponseModel>> getNotifications({
    @Query("page") required int page,
    @Query("page_size") required int pageSize,
  });

  @POST(AppConstants.registerToken)
  Future<HttpResponse<MessageResponseModel>> registerToken({
    @Field("token") required String token,
    @Field("platform") required String platform,
    @Field("device_id") required String deviceId,
  });

  @PATCH(AppConstants.markNotificationAsRead)
  Future<HttpResponse<MessageResponseModel>> markNotificationAsRead({
    @Path("notification_id") required String notificationId,
  });
}
