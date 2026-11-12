import '../models/user.dart';
import '../services/api_service.dart';
import 'user_repository.dart';

/// Implementasi [UserRepository] yang mengambil data melalui [ApiService].
class UserRepositoryImpl implements UserRepository {
  final ApiService _apiService;
  final bool _ownsApiService;

  /// Menerima service dari luar agar repository mudah diuji.
  UserRepositoryImpl({ApiService? apiService})
    : _apiService = apiService ?? ApiService(),
      _ownsApiService = apiService == null;

  @override
  Future<List<User>> getUsers() => _apiService.getUsers();

  @override
  Future<User> getUserById(int id) => _apiService.getUserById(id);

  /// Menutup service hanya bila dibuat oleh repository ini.
  void dispose() {
    if (_ownsApiService) _apiService.dispose();
  }
}
