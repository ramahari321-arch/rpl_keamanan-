import 'package:flutter_dotenv/flutter_dotenv.dart';

/// Konfigurasi aplikasi yang dimuat dari file `.env`.
class AppConfig {
  /// Base URL untuk API.
  static String get baseUrl => dotenv.env['BASE_URL'] ?? '';

  /// API key untuk autentikasi.
  static String get apiKey => dotenv.env['API_KEY'] ?? '';

  /// Batas waktu request HTTP dalam detik.
  static const int timeoutSeconds = 10;

  /// Memeriksa apakah konfigurasi yang dibutuhkan sudah tersedia.
  static bool isConfigured() => baseUrl.isNotEmpty && apiKey.isNotEmpty;
}
