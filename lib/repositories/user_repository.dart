import '../models/user.dart';

/// Kontrak untuk mengambil data pengguna tanpa mengikat UI ke sumber data.
abstract class UserRepository {
  /// Mengambil daftar semua pengguna.
  Future<List<User>> getUsers();

  /// Mengambil pengguna berdasarkan [id].
  Future<User> getUserById(int id);
}
