import 'package:flutter_secure_storage/flutter_secure_storage.dart';

/// Mengelola token dan PIN dengan penyimpanan aman perangkat.
class SecureStorageService {
  static const _storage = FlutterSecureStorage(
    aOptions: AndroidOptions(encryptedSharedPreferences: true),
    iOptions: IOSOptions(accessibility: KeychainAccessibility.first_unlock),
  );

  static const String _tokenKey = 'auth_token';
  static const String _pinKey = 'user_pin';

  /// Menyimpan [token] tanpa mencetak nilainya ke log.
  Future<void> saveToken(String token) =>
      _storage.write(key: _tokenKey, value: token);

  /// Membaca token yang tersimpan.
  Future<String?> getToken() => _storage.read(key: _tokenKey);

  /// Menghapus token yang tersimpan.
  Future<void> deleteToken() => _storage.delete(key: _tokenKey);

  /// Menyimpan [pin] secara aman.
  Future<void> savePin(String pin) => _storage.write(key: _pinKey, value: pin);

  /// Membaca PIN yang tersimpan.
  Future<String?> getPin() => _storage.read(key: _pinKey);

  /// Menghapus seluruh data yang tersimpan oleh aplikasi.
  Future<void> deleteAll() => _storage.deleteAll();

  /// Memeriksa keberadaan token tanpa mengambil nilainya.
  Future<bool> hasToken() => _storage.containsKey(key: _tokenKey);
}
