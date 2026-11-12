import 'package:flutter/widgets.dart';

import '../repositories/post_repository.dart';
import '../repositories/post_repository_impl.dart';
import '../repositories/user_repository.dart';
import '../repositories/user_repository_impl.dart';
import '../services/api_service.dart';

/// Menyediakan satu [ApiService] untuk semua repository selama aplikasi hidup.
class DependencyInjectorHost extends StatefulWidget {
  final Widget child;

  const DependencyInjectorHost({super.key, required this.child});

  @override
  State<DependencyInjectorHost> createState() => _DependencyInjectorHostState();
}

class _DependencyInjectorHostState extends State<DependencyInjectorHost> {
  late final ApiService _apiService;
  late final UserRepository _userRepository;
  late final PostRepository _postRepository;

  @override
  void initState() {
    super.initState();
    _apiService = ApiService();
    _userRepository = UserRepositoryImpl(apiService: _apiService);
    _postRepository = PostRepositoryImpl(apiService: _apiService);
  }

  @override
  void dispose() {
    _apiService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return DependencyInjector(
      apiService: _apiService,
      userRepository: _userRepository,
      postRepository: _postRepository,
      child: widget.child,
    );
  }
}

/// Membagikan service dan repository lewat widget tree.
class DependencyInjector extends InheritedWidget {
  final ApiService apiService;
  final UserRepository userRepository;
  final PostRepository postRepository;

  const DependencyInjector({
    super.key,
    required this.apiService,
    required this.userRepository,
    required this.postRepository,
    required super.child,
  });

  /// Mengambil dependency yang disediakan di atas [context].
  static DependencyInjector of(BuildContext context) {
    final injector = context
        .dependOnInheritedWidgetOfExactType<DependencyInjector>();
    if (injector == null) {
      throw StateError('DependencyInjectorHost belum dipasang di widget tree.');
    }
    return injector;
  }

  @override
  bool updateShouldNotify(DependencyInjector oldWidget) =>
      !identical(apiService, oldWidget.apiService) ||
      !identical(userRepository, oldWidget.userRepository) ||
      !identical(postRepository, oldWidget.postRepository);
}
