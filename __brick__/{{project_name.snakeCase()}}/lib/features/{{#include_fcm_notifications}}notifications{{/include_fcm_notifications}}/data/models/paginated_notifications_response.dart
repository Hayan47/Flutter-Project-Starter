import 'package:{{project_name.snakeCase()}}/features/notifications/data/models/notification.dart';
import 'package:{{project_name.snakeCase()}}/features/notifications/domain/entities/paginated_notifications_response.dart';
import 'package:json_annotation/json_annotation.dart';

part 'paginated_notifications_response.g.dart';

@JsonSerializable()
class PaginatedNotificationsResponseModel {
  final int count;
  final String? next;
  final String? previous;
  @JsonKey(name: 'results')
  final List<NotificationModel> notifications;

  const PaginatedNotificationsResponseModel({
    required this.count,
    this.next,
    this.previous,
    required this.notifications,
  });

  factory PaginatedNotificationsResponseModel.fromJson(
    Map<String, dynamic> json,
  ) =>
      _$PaginatedNotificationsResponseModelFromJson(json);

  Map<String, dynamic> toJson() =>
      _$PaginatedNotificationsResponseModelToJson(this);

  PaginatedNotificationsResponseEntity toEntity() =>
      PaginatedNotificationsResponseEntity(
        count: count,
        next: next,
        previous: previous,
        notifications: notifications.map((e) => e.toEntity()).toList(),
      );
}
