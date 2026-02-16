import 'package:{{project_name.snakeCase()}}/features/notifications/domain/entities/notification.dart';
import 'package:json_annotation/json_annotation.dart';

part 'notification.g.dart';

@JsonSerializable()
class NotificationModel {
  final String id;
  final String message;
  @JsonKey(name: 'is_read')
  final bool isRead;
  final Map<String, dynamic> data;
  @JsonKey(name: 'created_at')
  final DateTime createdAt;
  @JsonKey(name: 'sent_at')
  final DateTime? sentAt;
  @JsonKey(name: 'read_at')
  final DateTime? readAt;

  const NotificationModel({
    required this.id,
    required this.message,
    required this.isRead,
    required this.data,
    required this.createdAt,
    this.sentAt,
    this.readAt,
  });

  factory NotificationModel.fromJson(Map<String, dynamic> json) =>
      _$NotificationModelFromJson(json);

  Map<String, dynamic> toJson() => _$NotificationModelToJson(this);

  NotificationEntity toEntity() => NotificationEntity(
    id: id,
    message: message,
    isRead: isRead,
    data: data,
    createdAt: createdAt,
    readAt: readAt,
  );
}
