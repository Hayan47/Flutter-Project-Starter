part of 'notification_bloc.dart';

sealed class NotificationState extends Equatable {
  const NotificationState();

  @override
  List<Object?> get props => [];
}

class NotificationInitial extends NotificationState {}

class NotificationLoading extends NotificationState {}

class NotificationLoaded extends NotificationState {
  final List<NotificationEntity> notifications;
  final bool hasReachedMax;
  final bool isLoadingMore;
  final int currentPage;
  final String? errorMessage;

  const NotificationLoaded({
    required this.notifications,
    this.hasReachedMax = false,
    this.isLoadingMore = false,
    this.currentPage = 1,
    this.errorMessage,
  });

  NotificationLoaded copyWith({
    List<NotificationEntity>? notifications,
    bool? hasReachedMax,
    bool? isLoadingMore,
    int? currentPage,
    String? errorMessage,
  }) {
    return NotificationLoaded(
      notifications: notifications ?? this.notifications,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      currentPage: currentPage ?? this.currentPage,
      errorMessage: errorMessage,
    );
  }

  @override
  List<Object?> get props => [
        notifications,
        hasReachedMax,
        isLoadingMore,
        currentPage,
        errorMessage,
      ];
}

class NotificationError extends NotificationState {
  final String message;

  const NotificationError({required this.message});

  @override
  List<Object> get props => [message];
}

class DeviceTokenRegistered extends NotificationState {
  final bool success;

  const DeviceTokenRegistered(this.success);

  @override
  List<Object> get props => [success];
}
