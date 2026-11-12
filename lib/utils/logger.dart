import 'package:flutter/foundation.dart';

/// Logger terstruktur yang hanya menampilkan pesan saat mode debug.
///
/// Jangan masukkan token, API key, password, header, atau data pribadi ke pesan.
class Logger {
  Logger._();

  /// Mencatat informasi diagnostik saat pengembangan.
  static void debug(String message) => _write('DEBUG', message);

  /// Mencatat aktivitas aplikasi yang tidak bersifat sensitif.
  static void info(String message) => _write('INFO', message);

  /// Mencatat kondisi yang perlu diperhatikan.
  static void warning(String message) => _write('WARNING', message);

  /// Mencatat kategori kegagalan tanpa detail sensitif.
  static void error(String message) => _write('ERROR', message);

  static void _write(String level, String message) {
    if (!kDebugMode) return;
    final timestamp = DateTime.now().toIso8601String();
    debugPrint('[$timestamp] [$level] $message');
  }
}
