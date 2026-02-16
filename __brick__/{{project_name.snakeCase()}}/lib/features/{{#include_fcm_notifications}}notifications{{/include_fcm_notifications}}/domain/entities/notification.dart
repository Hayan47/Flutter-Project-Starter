import 'package:equatable/equatable.dart';

class NotificationEntity extends Equatable {
  final String id;
  final String message;
  final bool isRead;
  final Map<String, dynamic> data;
  final DateTime createdAt;
  final DateTime? sentAt;
  final DateTime? readAt;

  const NotificationEntity({
    required this.id,
    required this.message,
    required this.isRead,
    required this.data,
    required this.createdAt,
    this.sentAt,
    this.readAt,
  });

  // Helper methods for common data access
  String? get action => data['action'];

  @override
  List<Object?> get props => [
    id,
    message,
    isRead,
    data,
    createdAt,
    sentAt,
    readAt,
  ];
}
