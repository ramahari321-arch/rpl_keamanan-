import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:http/http.dart' as http;

import '../config/app_config.dart';
import '../models/post.dart';
import '../models/user.dart';
import '../utils/logger.dart';

/// Mengelola request HTTP dan pengubahan respons menjadi model aplikasi.
class ApiService {
  final http.Client _client;
  final String _baseUrl;

  /// Membuat service dengan client dan URL yang dapat diganti saat pengujian.
  ApiService({http.Client? client, String? baseUrl})
    : _client = client ?? http.Client(),
      _baseUrl = baseUrl ?? AppConfig.baseUrl;

  /// Mengambil daftar pengguna dari API.
  Future<List<User>> getUsers() async {
    try {
      _logRequest('GET', '/users');
      final response = await _client
          .get(Uri.parse('$_baseUrl/users'), headers: _buildHeaders())
          .timeout(const Duration(seconds: AppConfig.timeoutSeconds));
      _logResponse(response.statusCode);

      if (response.statusCode != 200) {
        throw Exception('Gagal memuat data. Status: ${response.statusCode}');
      }

      final data = jsonDecode(response.body) as List<dynamic>;
      return data
          .map((item) => User.fromJson(item as Map<String, dynamic>))
          .toList();
    } on TimeoutException {
      throw Exception('Request timeout. Periksa koneksi internet Anda.');
    } on SocketException {
      throw Exception('Tidak ada koneksi internet. Periksa jaringan Anda.');
    } on FormatException {
      throw Exception('Format data tidak valid.');
    } on http.ClientException {
      throw Exception('Gagal menghubungi server.');
    }
  }

  /// Mengambil pengguna berdasarkan [id] positif.
  Future<User> getUserById(int id) async {
    if (id <= 0) {
      throw ArgumentError.value(id, 'id', 'ID harus positif');
    }

    try {
      _logRequest('GET', '/users/$id');
      final response = await _client
          .get(Uri.parse('$_baseUrl/users/$id'), headers: _buildHeaders())
          .timeout(const Duration(seconds: AppConfig.timeoutSeconds));
      _logResponse(response.statusCode);

      if (response.statusCode != 200) {
        throw Exception('Gagal memuat data. Status: ${response.statusCode}');
      }

      return User.fromJson(jsonDecode(response.body) as Map<String, dynamic>);
    } on TimeoutException {
      throw Exception('Request timeout. Periksa koneksi internet Anda.');
    } on SocketException {
      throw Exception('Tidak ada koneksi internet. Periksa jaringan Anda.');
    } on FormatException {
      throw Exception('Format data tidak valid.');
    } on http.ClientException {
      throw Exception('Gagal menghubungi server.');
    }
  }

  /// Mengambil daftar postingan dari endpoint `/posts`.
  Future<List<Post>> getPosts() async {
    try {
      _logRequest('GET', '/posts');
      final response = await _client
          .get(Uri.parse('$_baseUrl/posts'), headers: _buildHeaders())
          .timeout(const Duration(seconds: AppConfig.timeoutSeconds));
      _logResponse(response.statusCode);

      if (response.statusCode != 200) {
        throw Exception(
          'Gagal memuat postingan. Status: ${response.statusCode}',
        );
      }

      final data = jsonDecode(response.body) as List<dynamic>;
      return data
          .map((item) => Post.fromJson(item as Map<String, dynamic>))
          .toList();
    } on TimeoutException {
      throw Exception('Request timeout. Periksa koneksi internet Anda.');
    } on SocketException {
      throw Exception('Tidak ada koneksi internet. Periksa jaringan Anda.');
    } on FormatException {
      throw Exception('Format data tidak valid.');
    } on http.ClientException {
      throw Exception('Gagal menghubungi server.');
    }
  }

  /// Menyiapkan header tanpa menulis API key langsung di kode.
  Map<String, String> _buildHeaders() => {
    'Content-Type': 'application/json',
    'X-API-Key': AppConfig.apiKey,
  };

  /// Mencatat method dan endpoint saja, bukan header atau credential.
  void _logRequest(String method, String endpoint) {
    Logger.info('Request $method $endpoint');
  }

  /// Mencatat status respons tanpa data sensitif.
  void _logResponse(int statusCode) {
    if (statusCode >= 400) {
      Logger.warning('Response HTTP status: $statusCode');
    } else {
      Logger.info('Response HTTP status: $statusCode');
    }
  }

  /// Menutup HTTP client saat service tidak digunakan lagi.
  void dispose() => _client.close();
}
