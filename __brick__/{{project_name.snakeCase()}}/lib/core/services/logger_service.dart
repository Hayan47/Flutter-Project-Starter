import 'package:logging/logging.dart';

class LoggerService {
  static final LoggerService _instance = LoggerService._internal();
  factory LoggerService() => _instance;

  late Logger _logger;

  LoggerService._internal() {
    _logger = Logger('{{project_name.pascalCase()}}');
    _setupLogging();
  }

  void _setupLogging() {
    Logger.root.level = Level.ALL;
    Logger.root.onRecord.listen((record) {
      final emoji = _getEmoji(record.level);
      print(
        '$emoji [${record.level.name}] ${record.time}: ${record.loggerName}: ${record.message}',
      );
      if (record.error != null) {
        print('Error: ${record.error}');
      }
      if (record.stackTrace != null) {
        print('StackTrace: ${record.stackTrace}');
      }
    });
  }

  String _getEmoji(Level level) {
    if (level == Level.SEVERE || level == Level.SHOUT) {
      return '🔴';
    } else if (level == Level.WARNING) {
      return '🟡';
    } else if (level == Level.INFO) {
      return '🔵';
    } else if (level == Level.CONFIG) {
      return '🟢';
    } else {
      return '⚪';
    }
  }

  void debug(String message) => _logger.fine(message);

  void info(String message) => _logger.info(message);

  void warning(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.warning(message, error, stackTrace);
  }

  void error(String message, [Object? error, StackTrace? stackTrace]) {
    _logger.severe(message, error, stackTrace);
  }

  void logApiRequest(String method, String url, Map<String, dynamic>? data) {
    info('📤 API Request: $method $url ${data != null ? '\nData: $data' : ''}');
  }

  void logApiResponse(String method, String url, int statusCode, dynamic data) {
    info('📥 API Response: $method $url\nStatus: $statusCode\nData: $data');
  }

  void logApiError(String method, String url, Object error) {
    this.error('❌ API Error: $method $url', error);
  }
}
