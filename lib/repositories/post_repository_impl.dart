import '../models/post.dart';
import '../services/api_service.dart';
import 'post_repository.dart';

/// Implementasi [PostRepository] menggunakan [ApiService].
class PostRepositoryImpl implements PostRepository {
  final ApiService _apiService;
  final bool _ownsApiService;

  /// Service boleh disuntikkan agar repository mudah diuji.
  PostRepositoryImpl({ApiService? apiService})
    : _apiService = apiService ?? ApiService(),
      _ownsApiService = apiService == null;

  @override
  Future<List<Post>> getPosts() => _apiService.getPosts();

  /// Menutup service hanya jika dibuat oleh repository ini.
  void dispose() {
    if (_ownsApiService) _apiService.dispose();
  }
}
