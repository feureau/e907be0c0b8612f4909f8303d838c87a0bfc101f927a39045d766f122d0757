import 'package:flutter_test/flutter_test.dart';
import 'package:sqflite/sqflite.dart';
import 'package:sqflite_common_ffi/sqflite_ffi.dart';
import '../../lib/services/database_service.dart';
import '../../lib/models/user.dart';
import '../../lib/models/progress.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  sqfliteFfiInit();
  databaseFactory = databaseFactoryFfi;

  group('DatabaseService', () {
    late DatabaseService instance1;
    late DatabaseService instance2;

    setUpAll(() async {
      instance1 = DatabaseService.instance;
    });

    test('should be a singleton', () {
      instance2 = DatabaseService.instance;

      expect(identical(instance1, instance2), isTrue);
    });

    test('should share database instance', () async {
      final db1 = await instance1.database;
      final db2 = await instance2.database;

      expect(identical(db1, db2), isTrue);
    });
  });

  group('User CRUD', () {
    late DatabaseService db;

    setUp(() async {
      db = DatabaseService.instance;
      final database = await db.database;
      await database.delete('users');
    });

    test('should insert and retrieve user', () async {
      final user = User(
        id: 'test_user',
        name: 'Test User',
        createdAt: DateTime.now(),
        preferences: {'key': 'value'},
      );

      await db.insertUser(user);
      final retrieved = await db.getUser('test_user');

      expect(retrieved, isNotNull);
      expect(retrieved!.id, equals('test_user'));
      expect(retrieved.name, equals('Test User'));
    });

    test('should update user', () async {
      final user = User(
        id: 'test_user',
        name: 'Original',
        createdAt: DateTime.now(),
      );

      await db.insertUser(user);

      final updatedUser = user.copyWith(name: 'Updated');
      await db.updateUser(updatedUser);

      final retrieved = await db.getUser('test_user');
      expect(retrieved!.name, equals('Updated'));
    });

    test('should return null for non-existent user', () async {
      final user = await db.getUser('nonexistent');
      expect(user, isNull);
    });
  });

  group('Progress CRUD', () {
    late DatabaseService db;

    setUp(() async {
      db = DatabaseService.instance;
      final database = await db.database;
      await database.delete('progress');
    });

    test('should insert and retrieve progress', () async {
      final progress = Progress(
        userId: 'user1',
        language: 'Japanese',
        streak: 5,
        totalXP: 100,
        categoryXP: {'Vocabulary': 50},
        achievements: [],
        lastActivity: DateTime.now(),
      );

      await db.insertProgress(progress);
      final retrieved = await db.getProgress('user1', 'Japanese');

      expect(retrieved, isNotNull);
      expect(retrieved!.streak, equals(5));
      expect(retrieved.totalXP, equals(100));
    });

    test('should update progress', () async {
      final progress = Progress(
        userId: 'user1',
        language: 'Japanese',
        streak: 1,
        totalXP: 0,
        categoryXP: {},
        achievements: [],
        lastActivity: DateTime.now(),
      );

      await db.insertProgress(progress);

      final updated = progress.copyWith(streak: 10, totalXP: 200);
      await db.updateProgress(updated);

      final retrieved = await db.getProgress('user1', 'Japanese');
      expect(retrieved!.streak, equals(10));
      expect(retrieved.totalXP, equals(200));
    });

    test('should get all progress for user', () async {
      final progress1 = Progress(
        userId: 'user1',
        language: 'Japanese',
        streak: 1,
        totalXP: 10,
        categoryXP: {},
        achievements: [],
        lastActivity: DateTime.now(),
      );

      final progress2 = Progress(
        userId: 'user1',
        language: 'English',
        streak: 2,
        totalXP: 20,
        categoryXP: {},
        achievements: [],
        lastActivity: DateTime.now(),
      );

      await db.insertProgress(progress1);
      await db.insertProgress(progress2);

      final all = await db.getAllProgress('user1');

      expect(all.length, equals(2));
    });
  });
}
