import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../core/error/failures.dart';
import '../../../../../../shared/constants/app_constants.dart';
import '../../../domain/entities/notification.dart';
import '../../../domain/usecases/get_notifications.dart';
import '../../../domain/usecases/mark_notification_as_read.dart';
import '../../../domain/usecases/register_device_token.dart';

part 'notification_event.dart';
part 'notification_state.dart';

@injectable
class NotificationBloc extends Bloc<NotificationEvent, NotificationState> {
  final int pageSize = AppConstants.defaultPageSize;

  final GetNotificationsUseCase getNotificationsUseCase;
  final RegisterDeviceTokenUseCase registerDeviceTokenUseCase;
  final MarkNotificationAsReadUseCase markAsReadUseCase;

  NotificationBloc({
    required this.getNotificationsUseCase,
    required this.registerDeviceTokenUseCase,
    required this.markAsReadUseCase,
  }) : super(NotificationInitial()) {
    on<LoadNotifications>(_onLoadNotifications);
    on<LoadMoreNotificationsEvent>(_handleLoadMoreNotificationsEvent);
    on<RefreshNotifications>(_onRefreshNotifications);
    on<MarkNotificationAsRead>(_onMarkNotificationAsRead);
  }

  Future<void> _onLoadNotifications(
    LoadNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    emit(NotificationLoading());

    try {
      final result = await getNotificationsUseCase(
        GetNotificationsParams(page: 1, pageSize: pageSize),
      );

      result.fold(
        // Left - Failure case
        (failure) {
          emit(
            NotificationError(
              message: failure.message ?? 'Getting Notifications failed',
            ),
          );
        },
        // Right - Success case
        (data) {
          emit(
            NotificationLoaded(
              notifications: data.notifications,
              hasReachedMax: data.next == null,
              currentPage: 1,
            ),
          );
        },
      );
    } catch (e) {
      emit(NotificationError(message: e.toString()));
    }
  }

  Future<void> _handleLoadMoreNotificationsEvent(
    LoadMoreNotificationsEvent event,
    Emitter<NotificationState> emit,
  ) async {
    final currentState = state;
    if (currentState is! NotificationLoaded ||
        currentState.hasReachedMax ||
        currentState.isLoadingMore) {
      return;
    }

    emit(currentState.copyWith(isLoadingMore: true));

    final nextPage = currentState.currentPage + 1;
    final result = await getNotificationsUseCase(
      GetNotificationsParams(page: nextPage, pageSize: pageSize),
    );

    result.fold(
      // Left - Failure case
      (failure) {
        emit(
          currentState.copyWith(
            isLoadingMore: false,
            errorMessage: failure.message ?? 'Error loading more notifications',
          ),
        );
      },
      // Right - Success case
      (data) {
        final newNotifications = data.notifications;

        emit(
          currentState.copyWith(
            notifications: [...currentState.notifications, ...newNotifications],
            isLoadingMore: false,
            hasReachedMax: data.next == null,
            currentPage: nextPage,
            errorMessage: null,
          ),
        );
      },
    );
  }

  Future<void> _onRefreshNotifications(
    RefreshNotifications event,
    Emitter<NotificationState> emit,
  ) async {
    final currentState = state;
    if (currentState is NotificationLoaded) {
      // Keep current data visible during refresh
      emit(currentState.copyWith(errorMessage: null));
    }

    final result = await getNotificationsUseCase(
      GetNotificationsParams(page: 1, pageSize: pageSize),
    );

    result.fold(
      // Left - Failure case
      (failure) {
        emit(
          NotificationError(
            message: failure.message ?? 'Error Getting notification',
          ),
        );
      },
      // Right - Success case
      (data) {
        emit(
          NotificationLoaded(
            notifications: data.notifications,
            hasReachedMax: data.next == null,
            currentPage: 1,
          ),
        );
      },
    );
  }

  Future<void> _onMarkNotificationAsRead(
    MarkNotificationAsRead event,
    Emitter<NotificationState> emit,
  ) async {
    try {
      final result = await markAsReadUseCase(
        MarkNotificationAsReadParams(notificationId: event.notificationId),
      );
      result.fold(
        // Left - Failure case
        (failure) {
          emit(
            NotificationError(message: 'Failed to mark notification as read'),
          );
        },
        // Right - Success case
        (_) {
          if (state is NotificationLoaded) {
            emit(state);
          }
        },
      );
      // Reload notifications to reflect the change
      add(RefreshNotifications());
    } catch (e) {
      emit(NotificationError(message: e.toString()));
    }
  }
}
