import 'dart:async';

import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';

import '../../../../../../core/services/logger_service.dart';
import '../../../domain/entities/fcm_message.dart';
import '../../../domain/usecases/handle_fcm_message.dart';
import '../../../domain/usecases/handle_navigation.dart';
import '../../../domain/usecases/initialize_fcm.dart';
import '../../../domain/usecases/mark_notification_as_read.dart';
import '../../../domain/usecases/register_device_token.dart';

part 'fcm_event.dart';
part 'fcm_state.dart';

@lazySingleton
class FCMBloc extends Bloc<FCMEvent, FCMState> {
  final LoggerService _logger;

  final InitializeFCMUseCase initializeFCMUseCase;
  final HandleFCMMessageUseCase handleFCMMessageUseCase;
  final RegisterDeviceTokenUseCase registerDeviceTokenUseCase;
  final HandleNavigationUseCase handleNavigationUseCase;
  final MarkNotificationAsReadUseCase markNotificationAsReadUseCase;

  String? _currentToken;

  // Stream subscriptions for cleanup
  StreamSubscription<FCMMessageEntity>? _messageSubscription;
  StreamSubscription<FCMMessageEntity>? _tapSubscription;
  StreamSubscription<String>? _tokenSubscription;

  FCMBloc({
    required this.initializeFCMUseCase,
    required this.handleFCMMessageUseCase,
    required this.registerDeviceTokenUseCase,
    required this.handleNavigationUseCase,
    required this.markNotificationAsReadUseCase,
    required LoggerService logger,
  }) : _logger = logger,
       super(FCMInitial()) {
    on<FCMEvent>((event, emit) => _logger.info("$event called"));

    on<InitializeFCM>(_onInitializeFCM);
    on<FCMMessageReceivedEvent>(_onFCMMessageReceived);
    on<FCMMessageTapped>(_onFCMMessageTapped);
    on<RefreshFCMToken>(_onRefreshFCMToken);
    on<SubscribeToTopic>(_onSubscribeToTopic);
    on<UnsubscribeFromTopic>(_onUnsubscribeFromTopic);

    // Initialize FCM immediately on app start
    add(InitializeFCM());
  }

  Future<void> _onInitializeFCM(
    InitializeFCM event,
    Emitter<FCMState> emit,
  ) async {
    emit(FCMInitializing());
    _logger.info(state.toString());

    try {
      // Setup stream subscriptions instead of callbacks
      _messageSubscription = handleFCMMessageUseCase.messageStream.listen(
        (message) {
          _logger.info('Message received from stream: ${message.data}');
          add(FCMMessageReceivedEvent(message));
        },
        onError: (error) {
          _logger.severe('Error in message stream: $error');
        },
      );

      _tapSubscription = handleFCMMessageUseCase.messageTapStream.listen(
        (message) {
          _logger.info('Message tapped from stream: ${message.data}');
          add(FCMMessageTapped(message));
        },
        onError: (error) {
          _logger.severe('Error in tap stream: $error');
        },
      );

      _tokenSubscription = handleFCMMessageUseCase.tokenRefreshStream.listen(
        (token) {
          _logger.info(
            'Token refreshed from stream: ${token.substring(0, 20)}...',
          );
          add(RefreshFCMToken(token: token));
        },
        onError: (error) {
          _logger.severe('Error in token stream: $error');
        },
      );

      final result = await initializeFCMUseCase(null);
      _logger.info(result.toString());

      result.fold(
        (failure) {
          _logger.severe('FCM initialization failed: $failure');
          emit(FCMError(failure.toString()));
        },
        (token) async {
          _currentToken = token;
          _logger.info('FCM initialized with token: $token');

          await registerDeviceTokenUseCase(
            RegisterDeviceTokenParams(token: token),
          );
        },
      );

      emit(FCMInitialized(_currentToken));
    } catch (e, stackTrace) {
      _logger.severe('FCM initialization error: $e', null, stackTrace);
      emit(FCMError(e.toString()));
    }
  }

  void _onFCMMessageReceived(
    FCMMessageReceivedEvent event,
    Emitter<FCMState> emit,
  ) {
    emit(FCMMessageReceived(message: event.message, token: _currentToken));
  }

  void _onFCMMessageTapped(
    FCMMessageTapped event,
    Emitter<FCMState> emit,
  ) async {
    try {
      await handleNavigationUseCase(
        HandleNavigationParams(fcmMessageEntity: event.message),
      );

      if (event.message.notificationId != null) {
        await markNotificationAsReadUseCase(
          MarkNotificationAsReadParams(
            notificationId: event.message.notificationId!,
          ),
        );
      }
      emit(
        FCMNavigationRequested(message: event.message, token: _currentToken),
      );
    } catch (e) {
      _logger.severe('Error handling message tap: $e');
      emit(FCMError(e.toString()));
    }
  }

  Future<void> _onRefreshFCMToken(
    RefreshFCMToken event,
    Emitter<FCMState> emit,
  ) async {
    try {
      _currentToken = event.token;

      await registerDeviceTokenUseCase(
        RegisterDeviceTokenParams(token: event.token),
      );

      emit(FCMInitialized(_currentToken));
    } catch (e) {
      _logger.severe('Error refreshing FCM token: $e');
      emit(FCMError(e.toString()));
    }
  }

  Future<void> _onSubscribeToTopic(
    SubscribeToTopic event,
    Emitter<FCMState> emit,
  ) async {
    try {
      await handleFCMMessageUseCase.subscribeToTopic(event.topic);
      _logger.info('Subscribed to topic: ${event.topic}');
      emit(FCMTopicSubscribed(topic: event.topic, token: _currentToken));
    } catch (e) {
      _logger.severe('Error subscribing to topic ${event.topic}: $e');
      emit(FCMError(e.toString()));
    }
  }

  Future<void> _onUnsubscribeFromTopic(
    UnsubscribeFromTopic event,
    Emitter<FCMState> emit,
  ) async {
    try {
      await handleFCMMessageUseCase.unsubscribeFromTopic(event.topic);
      _logger.info('Unsubscribed from topic: ${event.topic}');
      emit(FCMInitialized(_currentToken));
    } catch (e) {
      _logger.severe('Error unsubscribing from topic ${event.topic}: $e');
      emit(FCMError(e.toString()));
    }
  }

  @override
  Future<void> close() {
    // Cancel all stream subscriptions to prevent memory leaks
    _messageSubscription?.cancel();
    _tapSubscription?.cancel();
    _tokenSubscription?.cancel();
    _logger.info('FCMBloc closed, stream subscriptions cancelled');
    return super.close();
  }
}
