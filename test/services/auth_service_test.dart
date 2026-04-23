import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:e907/services/auth_service.dart';
import 'package:e907/services/database_service.dart';
import 'package:e907/models/user.dart';

@GenerateMocks([DatabaseService])
import 'auth_service_test.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('AuthService', () {
    late MockDatabaseService mockDatabaseService;
    late AuthService authService;

    setUp(() async {
      SharedPreferences.setMockInitialValues({});
      mockDatabaseService = MockDatabaseService();
      authService = AuthService(mockDatabaseService);
    });

    test('should create default user when none exists', () async {
      when(mockDatabaseService.getUser(any)).thenAnswer((_) async => null);
      when(mockDatabaseService.insertUser(any)).thenAnswer((_) async {});

      final user = await authService.createOrGetDefaultUser();

      expect(user, isNotNull);
      expect(user.name, equals('Learner'));
      verify(mockDatabaseService.insertUser(any)).called(1);
    });

    test('should return existing user when already logged in', () async {
      final existingUser = User(
        id: 'existing_user',
        name: 'Existing User',
        createdAt: DateTime.now(),
      );

      when(
        mockDatabaseService.getUser('existing_user'),
      ).thenAnswer((_) async => existingUser);

      SharedPreferences.setMockInitialValues({
        'current_user_id': 'existing_user',
        'is_logged_in': true,
      });

      final user = await authService.createOrGetDefaultUser();

      expect(user.id, equals('existing_user'));
    });

    test('should login with new user name', () async {
      when(mockDatabaseService.insertUser(any)).thenAnswer((_) async {});

      final user = await authService.login('New User');

      expect(user.name, equals('New User'));
      verify(mockDatabaseService.insertUser(any)).called(1);
    });

    test('should logout and clear preferences', () async {
      SharedPreferences.setMockInitialValues({
        'current_user_id': 'test_user',
        'is_logged_in': true,
      });

      await authService.logout();

      final prefs = await SharedPreferences.getInstance();
      expect(prefs.getBool('is_logged_in'), isFalse);
      expect(prefs.getString('current_user_id'), isNull);
    });

    test('should update user in database', () async {
      final user = User(
        id: 'test_user',
        name: 'Test User',
        createdAt: DateTime.now(),
        preferences: {'language': 'Japanese'},
      );

      when(mockDatabaseService.updateUser(any)).thenAnswer((_) async {});

      await authService.updateUser(user);

      verify(mockDatabaseService.updateUser(any)).called(1);
    });
  });
}
