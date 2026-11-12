import '../models/post.dart';

/// Kontrak akses data postingan tanpa mengikat UI ke API.
abstract class PostRepository {
  /// Mengambil daftar postingan.
  Future<List<Post>> getPosts();
}
