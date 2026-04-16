import 'package:riverpod/riverpod.dart';
import '../models/user.dart';
import '../services/database_service.dart';

// Provider for DatabaseService
final databaseServiceProvider = Provider((ref) => DatabaseService());

// Provider for current user
final userProvider = StateProvider<User?>((ref) => null);

// Provider for user initialization
final userInitializationProvider = FutureProvider<User?>((ref) async {
  final dbService = ref.read(databaseServiceProvider);
  
  // For demo purposes, we'll create a default user if none exists
  // In a real app, you would implement proper user authentication
  const userId = 'default_user';
  var user = await dbService.getUser(userId);
  
  if (user == null) {
    user = User(
      id: userId,
      name: 'Default User',
      createdAt: DateTime.now(),
      preferences: {
        'language': 'Japanese',
        'notifications': true,
      },
    );
    await dbService.insertUser(user);
  }
  
  return user;
});

// Provider for updating user
final updateUserProvider = Provider((ref) => (User user) async {
  final dbService = ref.read(databaseServiceProvider);
  await dbService.updateUser(user);
  ref.read(userProvider.notifier).state = user;
});