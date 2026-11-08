import 'package:equatable/equatable.dart';
import 'package:{{project_name.snakeCase()}}/features/notifications/domain/entities/notification.dart';

class PaginatedNotificationsResponseEntity extends Equatable {
  final int count;
  final String? next;
  final String? previous;
  final List<NotificationEntity> notifications;

  const PaginatedNotificationsResponseEntity({
    required this.count,
    this.next,
    this.previous,
    required this.notifications,
  });

  @override
  List<Object?> get props => [count, next, previous, notifications];
}
