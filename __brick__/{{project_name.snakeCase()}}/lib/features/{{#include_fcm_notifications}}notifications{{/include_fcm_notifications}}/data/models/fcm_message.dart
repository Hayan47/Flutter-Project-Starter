import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:{{project_name.snakeCase()}}/features/notifications/domain/entities/fcm_message.dart';

class FCMMessageModel {
  final String? notificationId;
  final String? type;
  final String? title;
  final String? body;
  final Map<String, dynamic> data;

  const FCMMessageModel({
    this.notificationId,
    this.type,
    this.title,
    this.body,
    required this.data,
  });

  factory FCMMessageModel.fromRemoteMessage(RemoteMessage message) {
    return FCMMessageModel(
      notificationId: message.data['notification_id'],
      type: message.data['type'],
      title: message.notification?.title,
      body: message.notification?.body,
      data: message.data,
    );
  }

  FCMMessageEntity toEntity() => FCMMessageEntity(
    notificationId: notificationId,
    title: title,
    body: body,
    type: type,
    data: data,
  );
}
