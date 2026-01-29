import 'package:flutter_dotenv/flutter_dotenv.dart';

class EnvConfig {
  static String get appName => dotenv.env['APP_NAME'] ?? 'Only Law';
  static String get appVersion => dotenv.env['APP_VERSION'] ?? '1.0.0';

  static Future<void> init() async {
    await dotenv.load(fileName: '.env');
  }
}
