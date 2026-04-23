import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/user.dart';
import '../services/database_service.dart';
import '../services/auth_service.dart';

final databaseServiceProvider = Provider<DatabaseService>(
  (ref) => DatabaseService.instance,
);

final authServiceProvider = Provider<AuthService>((ref) {
  final dbService = ref.read(databaseServiceProvider);
  return AuthService(dbService);
});

final userProvider = StateProvider<User?>((ref) => null);

final userInitializationProvider = FutureProvider<User?>((ref) async {
  final authService = ref.read(authServiceProvider);

  final user = await authService.createOrGetDefaultUser();
  ref.read(userProvider.notifier).state = user;

  return user;
});

final updateUserProvider = Provider(
  (ref) => (User user) async {
    final authService = ref.read(authServiceProvider);
    await authService.updateUser(user);
    ref.read(userProvider.notifier).state = user;
  },
);

final logoutProvider = Provider(
  (ref) => () async {
    final authService = ref.read(authServiceProvider);
    await authService.logout();
    ref.read(userProvider.notifier).state = null;
  },
);
