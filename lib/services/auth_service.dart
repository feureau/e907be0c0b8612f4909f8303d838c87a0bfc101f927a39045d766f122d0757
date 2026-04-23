import 'package:shared_preferences/shared_preferences.dart';
import '../models/user.dart';
import 'database_service.dart';

class AuthService {
  static const String _userIdKey = 'current_user_id';
  static const String _isLoggedInKey = 'is_logged_in';

  final DatabaseService _db;

  AuthService(this._db);

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_isLoggedInKey) ?? false;
  }

  Future<String?> getCurrentUserId() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(_userIdKey);
  }

  Future<User?> getCurrentUser() async {
    final userId = await getCurrentUserId();
    if (userId == null) return null;
    return _db.getUser(userId);
  }

  Future<User> login(String name) async {
    final userId = 'user_${DateTime.now().millisecondsSinceEpoch}';
    final user = User(
      id: userId,
      name: name,
      createdAt: DateTime.now(),
      preferences: {
        'language': 'Japanese',
        'notifications': true,
      },
    );
    await _db.insertUser(user);

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_userIdKey, userId);
    await prefs.setBool(_isLoggedInKey, true);

    return user;
  }

  Future<User> createOrGetDefaultUser() async {
    final prefs = await SharedPreferences.getInstance();
    var userId = prefs.getString(_userIdKey);

    if (userId != null) {
      final existingUser = await _db.getUser(userId);
      if (existingUser != null) {
        return existingUser;
      }
    }

    userId = 'default_user_${DateTime.now().millisecondsSinceEpoch}';
    final user = User(
      id: userId,
      name: 'Learner',
      createdAt: DateTime.now(),
      preferences: {
        'language': 'Japanese',
        'notifications': true,
      },
    );
    await _db.insertUser(user);

    await prefs.setString(_userIdKey, userId);
    await prefs.setBool(_isLoggedInKey, true);

    return user;
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_userIdKey);
    await prefs.setBool(_isLoggedInKey, false);
  }

  Future<void> updateUser(User user) async {
    await _db.updateUser(user);
  }
}
