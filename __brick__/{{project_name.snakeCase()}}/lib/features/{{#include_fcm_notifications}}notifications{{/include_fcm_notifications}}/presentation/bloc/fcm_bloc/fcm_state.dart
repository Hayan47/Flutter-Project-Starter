part of 'fcm_bloc.dart';

sealed class FCMState extends Equatable {
  const FCMState();

  @override
  List<Object?> get props => [];
}

class FCMInitial extends FCMState {}

class FCMInitializing extends FCMState {}

class FCMInitialized extends FCMState {
  final String? token;

  const FCMInitialized(this.token);

  @override
  List<Object?> get props => [token];
}

class FCMMessageReceived extends FCMState {
  final FCMMessageEntity message;
  final String? token;

  const FCMMessageReceived({
    required this.message,
    this.token,
  });

  @override
  List<Object?> get props => [message, token];
}

class FCMNavigationRequested extends FCMState {
  final FCMMessageEntity message;
  final String? token;

  const FCMNavigationRequested({
    required this.message,
    this.token,
  });

  @override
  List<Object?> get props => [message, token];
}

class FCMError extends FCMState {
  final String message;

  const FCMError(this.message);

  @override
  List<Object> get props => [message];
}

class FCMTopicSubscribed extends FCMState {
  final String topic;
  final String? token;

  const FCMTopicSubscribed({
    required this.topic,
    this.token,
  });

  @override
  List<Object?> get props => [topic, token];
}
