import 'package:dio/dio.dart';
import 'package:{{project_name.snakeCase()}}/features/notifications/data/data_sources/remote/notification_api_service.dart';
import 'package:{{project_name.snakeCase()}}/features/notifications/data/models/notification.dart';
import 'package:{{project_name.snakeCase()}}/features/notifications/data/models/paginated_notifications_response.dart';
import 'package:{{project_name.snakeCase()}}/shared/models/message_response.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';

/// Mock implementation of NotificationApiService for testing without backend.
/// Simulates notification operations with realistic delays and data.
@Injectable(as: NotificationApiService, env: ['mock'])
class NotificationMockDataSource implements NotificationApiService {
  static const Duration _networkDelay = Duration(milliseconds: 500);

  // Mock notification data
  static final List<NotificationModel> _mockNotifications = [
    NotificationModel(
      id: 'notif-1',
      message: 'You received \$500.00 from John Doe',
      isRead: false,
      data: {
        'transaction_id': 'txn-123',
        'amount': '500.00',
        'sender': 'John Doe',
        'action': 'view_transaction',
      },
      createdAt: DateTime.now().subtract(const Duration(hours: 2)),
      sentAt: DateTime.now().subtract(const Duration(hours: 2)),
    ),
    NotificationModel(
      id: 'notif-2',
      message: 'New payment request from Sarah Smith for \$250.00',
      isRead: false,
      data: {
        'request_id': 'req-456',
        'amount': '250.00',
        'requester': 'Sarah Smith',
        'action': 'view_payment_request',
      },
      createdAt: DateTime.now().subtract(const Duration(hours: 5)),
      sentAt: DateTime.now().subtract(const Duration(hours: 5)),
    ),
    NotificationModel(
      id: 'notif-3',
      message: 'Transfer of \$1,200.00 from Michael Johnson completed',
      isRead: true,
      data: {
        'transaction_id': 'txn-789',
        'amount': '1200.00',
        'sender': 'Michael Johnson',
        'action': 'view_transaction',
      },
      createdAt: DateTime.now().subtract(const Duration(days: 1)),
      sentAt: DateTime.now().subtract(const Duration(days: 1)),
      readAt: DateTime.now().subtract(const Duration(hours: 20)),
    ),
    NotificationModel(
      id: 'notif-4',
      message: 'Transfer failed: Insufficient funds',
      isRead: true,
      data: {
        'transaction_id': 'txn-999',
        'error': 'insufficient_funds',
        'action': 'view_transaction',
      },
      createdAt: DateTime.now().subtract(const Duration(days: 2)),
      sentAt: DateTime.now().subtract(const Duration(days: 2)),
      readAt: DateTime.now().subtract(const Duration(days: 1, hours: 23)),
    ),
    NotificationModel(
      id: 'notif-5',
      message: 'Payment request expired',
      isRead: true,
      data: {
        'request_id': 'req-789',
        'error': 'expired',
        'action': 'view_payment_request',
      },
      createdAt: DateTime.now().subtract(const Duration(days: 3)),
      sentAt: DateTime.now().subtract(const Duration(days: 3)),
      readAt: DateTime.now().subtract(const Duration(days: 2)),
    ),
    NotificationModel(
      id: 'notif-6',
      message: 'Received \$75.00 from Emma Wilson',
      isRead: true,
      data: {
        'transaction_id': 'txn-456',
        'amount': '75.00',
        'sender': 'Emma Wilson',
        'action': 'view_transaction',
      },
      createdAt: DateTime.now().subtract(const Duration(days: 4)),
      sentAt: DateTime.now().subtract(const Duration(days: 4)),
      readAt: DateTime.now().subtract(const Duration(days: 3)),
    ),
  ];

  @override
  Future<HttpResponse<PaginatedNotificationsResponseModel>> getNotifications({
    required int page,
    required int pageSize,
  }) async {
    await Future.delayed(_networkDelay);

    // Calculate pagination
    final startIndex = (page - 1) * pageSize;
    final endIndex = startIndex + pageSize;

    final paginatedNotifications = _mockNotifications.sublist(
      startIndex.clamp(0, _mockNotifications.length),
      endIndex.clamp(0, _mockNotifications.length),
    );

    final hasNext = endIndex < _mockNotifications.length;
    final hasPrevious = page > 1;

    final response = PaginatedNotificationsResponseModel(
      count: _mockNotifications.length,
      next: hasNext ? 'http://mock-api/notifications?page=${page + 1}' : null,
      previous:
          hasPrevious ? 'http://mock-api/notifications?page=${page - 1}' : null,
      notifications: paginatedNotifications,
    );

    return HttpResponse(
      response,
      Response(
        requestOptions: RequestOptions(path: '/notifications'),
        statusCode: 200,
      ),
    );
  }

  @override
  Future<HttpResponse<MessageResponseModel>> registerToken({
    required String token,
    required String platform,
    required String deviceId,
  }) async {
    await Future.delayed(_networkDelay);

    print('🎭 Mock: Registering device token');
    print('   Token: ${token.substring(0, 20)}...');
    print('   Platform: $platform');
    print('   Device ID: $deviceId');

    final response = MessageResponseModel(
      message: 'Mock: Device token registered successfully',
    );

    return HttpResponse(
      response,
      Response(
        requestOptions: RequestOptions(path: '/tokens/register'),
        statusCode: 200,
      ),
    );
  }

  @override
  Future<HttpResponse<MessageResponseModel>> markNotificationAsRead({
    required String notificationId,
  }) async {
    await Future.delayed(_networkDelay);

    print('🎭 Mock: Marking notification as read: $notificationId');

    // Update the mock data
    final index = _mockNotifications.indexWhere((n) => n.id == notificationId);
    if (index != -1) {
      _mockNotifications[index] = NotificationModel(
        id: _mockNotifications[index].id,
        message: _mockNotifications[index].message,
        isRead: true,
        data: _mockNotifications[index].data,
        createdAt: _mockNotifications[index].createdAt,
        sentAt: _mockNotifications[index].sentAt,
        readAt: DateTime.now(),
      );
    }

    final response = MessageResponseModel(
      message: 'Mock: Notification marked as read',
    );

    return HttpResponse(
      response,
      Response(
        requestOptions: RequestOptions(
          path: '/notifications/$notificationId/read',
        ),
        statusCode: 200,
      ),
    );
  }
}
