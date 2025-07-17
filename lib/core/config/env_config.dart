import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static const String _apiBaseUrlKey = 'API_BASE_URL';
  static const String _apiKeyKey = 'API_KEY';
  static const String _appNameKey = 'APP_NAME';
  static const String _appVersionKey = 'APP_VERSION';
  static const String _enableAnalyticsKey = 'ENABLE_ANALYTICS';
  static const String _enableCrashReportingKey = 'ENABLE_CRASH_REPORTING';
  static const String _enablePushNotificationsKey = 'ENABLE_PUSH_NOTIFICATIONS';

  static String get apiBaseUrl => dotenv.env[_apiBaseUrlKey] ?? 'https://api.example.com';
  static String get apiKey => dotenv.env[_apiKeyKey] ?? '';
  static String get appName => dotenv.env[_appNameKey] ?? 'Video Streaming App';
  static String get appVersion => dotenv.env[_appVersionKey] ?? '1.0.0';
  static bool get enableAnalytics => dotenv.env[_enableAnalyticsKey] == 'true';
  static bool get enableCrashReporting => dotenv.env[_enableCrashReportingKey] == 'true';
  static bool get enablePushNotifications => dotenv.env[_enablePushNotificationsKey] == 'true';

  static Future<void> load() async {
    await dotenv.load(fileName: '.env');
  }
}
