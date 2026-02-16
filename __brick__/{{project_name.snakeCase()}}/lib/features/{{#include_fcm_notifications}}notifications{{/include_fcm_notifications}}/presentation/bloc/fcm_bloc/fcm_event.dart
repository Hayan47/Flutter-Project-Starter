part of 'fcm_bloc.dart';

sealed class FCMEvent extends Equatable {
  const FCMEvent();

  @override
  List<Object?> get props => [];
}

class InitializeFCM extends FCMEvent {}

class FCMMessageReceivedEvent extends FCMEvent {
  final FCMMessageEntity message;

  const FCMMessageReceivedEvent(this.message);

  @override
  List<Object> get props => [message];
}

class FCMMessageTapped extends FCMEvent {
  final FCMMessageEntity message;

  const FCMMessageTapped(this.message);

  @override
  List<Object> get props => [message];
}

class RefreshFCMToken extends FCMEvent {
  final String token;

  const RefreshFCMToken({required this.token});

  @override
  List<Object> get props => [token];
}

class SubscribeToTopic extends FCMEvent {
  final String topic;

  const SubscribeToTopic(this.topic);

  @override
  List<Object> get props => [topic];
}

class UnsubscribeFromTopic extends FCMEvent {
  final String topic;

  const UnsubscribeFromTopic(this.topic);

  @override
  List<Object> get props => [topic];
}
