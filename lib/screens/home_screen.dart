import 'package:flutter/material.dart';

import '../config/dependency_injector.dart';
import '../services/secure_storage_service.dart';
import 'post_list_screen.dart';
import 'user_list_screen.dart';

/// Halaman utama untuk secure storage dan akses daftar pengguna.
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final SecureStorageService _storageService = SecureStorageService();
  final TextEditingController _tokenController = TextEditingController();
  bool _hasToken = false;

  @override
  void initState() {
    super.initState();
    _checkToken();
  }

  @override
  void dispose() {
    _tokenController.dispose();
    super.dispose();
  }

  Future<void> _checkToken() async {
    try {
      final hasToken = await _storageService.hasToken();
      if (mounted) setState(() => _hasToken = hasToken);
    } catch (_) {
      if (mounted) _showMessage('Gagal memeriksa token', Colors.red);
    }
  }

  Future<void> _saveToken() async {
    final token = _tokenController.text.trim();
    if (token.isEmpty) {
      _showMessage('Token tidak boleh kosong', Colors.red);
      return;
    }

    try {
      await _storageService.saveToken(token);
      _tokenController.clear();
      await _checkToken();
      if (mounted) {
        _showMessage('Token berhasil disimpan di secure storage', Colors.green);
      }
    } catch (_) {
      if (mounted) _showMessage('Gagal menyimpan token', Colors.red);
    }
  }

  Future<void> _deleteToken() async {
    try {
      await _storageService.deleteToken();
      await _checkToken();
      if (mounted) _showMessage('Token berhasil dihapus', Colors.orange);
    } catch (_) {
      if (mounted) _showMessage('Gagal menghapus token', Colors.red);
    }
  }

  void _showMessage(String message, Color color) {
    ScaffoldMessenger.of(context)
        .showSnackBar(SnackBar(content: Text(message), backgroundColor: color));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('RPL & Keamanan'),
        backgroundColor: Colors.deepPurple,
        foregroundColor: Colors.white,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.lock, color: Colors.deepPurple),
                        SizedBox(width: 8),
                        Text(
                          'Secure Storage',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text('Simpan token secara aman di perangkat.'),
                    const SizedBox(height: 16),
                    TextField(
                      controller: _tokenController,
                      obscureText: true,
                      decoration: const InputDecoration(
                        labelText: 'Token',
                        hintText: 'Masukkan token dummy',
                        prefixIcon: Icon(Icons.vpn_key),
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 12),
                    Row(
                      children: [
                        Expanded(
                          child: ElevatedButton.icon(
                            onPressed: _saveToken,
                            icon: const Icon(Icons.save),
                            label: const Text('Simpan'),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Expanded(
                          child: OutlinedButton.icon(
                            onPressed: _hasToken ? _deleteToken : null,
                            icon: const Icon(Icons.delete),
                            label: const Text('Hapus'),
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 12),
                    Text(
                      _hasToken
                          ? 'Token tersimpan'
                          : 'Belum ada token tersimpan',
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: 16),
            Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Row(
                      children: [
                        Icon(Icons.cloud, color: Colors.blue),
                        SizedBox(width: 8),
                        Text(
                          'HTTP Request',
                          style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    const Text(
                      'Ambil data pengguna dan postingan dari JSONPlaceholder.',
                    ),
                    const SizedBox(height: 16),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (context) => UserListScreen(
                              repository: DependencyInjector.of(context)
                                  .userRepository,
                            ),
                          ),
                        ),
                        icon: const Icon(Icons.list),
                        label: const Text('Lihat Daftar Pengguna'),
                      ),
                    ),
                    const SizedBox(height: 10),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton.icon(
                        onPressed: () => Navigator.push(
                          context,
                          MaterialPageRoute<void>(
                            builder: (context) => PostListScreen(
                              repository: DependencyInjector.of(context)
                                  .postRepository,
                            ),
                          ),
                        ),
                        icon: const Icon(Icons.article),
                        label: const Text('Lihat Daftar Postingan'),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
