import 'package:firebase_messaging/firebase_messaging.dart';

import '../local/local_notification_service.dart';

/// Static instance for background use - can't use DI in top-level function
final _backgroundNotificationService =
    LocalNotificationService.createBackgroundInstance();

/// Background message handler for FCM.
/// This must be a top-level function (FCM requirement).
/// Delegates notification display to LocalNotificationService.
@pragma('vm:entry-point')
Future<void> backgroundMessageHandler(RemoteMessage message) async {
  try {
    print('📨 Background message received: ${message.data}');
    print('   Message: ${message.toMap()}');

    // Initialize notification service
    await _backgroundNotificationService.initialize();

    // Display notification
    await _backgroundNotificationService.showNotificationFromMessage(message);

    print('✅ Background notification displayed successfully');
  } catch (e, stackTrace) {
    print('💥 Error in background message handler: $e');
    print('Stack trace: $stackTrace');
  }
}
