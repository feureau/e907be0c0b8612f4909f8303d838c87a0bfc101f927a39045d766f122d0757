import 'dart:async';
import 'dart:io';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../models/user.dart';
import '../models/progress.dart';

class DatabaseService {
  static Database? _database;
  static const String USER_TABLE = 'users';
  static const String PROGRESS_TABLE = 'progress';

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    Directory documentsDirectory = await getApplicationDocumentsDirectory();
    String path = join(documentsDirectory.path, 'turbolingo.db');
    return await openDatabase(
      path,
      version: 1,
      onCreate: _onCreate,
    );
  }

  void _onCreate(Database db, int version) async {
    // Create users table
    await db.execute('''
      CREATE TABLE $USER_TABLE (
        id TEXT PRIMARY KEY,
        name TEXT,
        createdAt INTEGER,
        preferences TEXT
      )
    ''');

    // Create progress table
    await db.execute('''
      CREATE TABLE $PROGRESS_TABLE (
        userId TEXT,
        language TEXT,
        streak INTEGER,
        totalXP INTEGER,
        categoryXP TEXT,
        achievements TEXT,
        lastActivity INTEGER,
        PRIMARY KEY (userId, language)
      )
    ''');
  }

  // User methods
  Future<void> insertUser(User user) async {
    final db = await database;
    await db.insert(USER_TABLE, user.toJson());
  }

  Future<User?> getUser(String id) async {
    final db = await database;
    final maps = await db.query(
      USER_TABLE,
      where: 'id = ?',
      whereArgs: [id],
    );

    if (maps.isNotEmpty) {
      return User.fromJson(maps.first);
    }
    return null;
  }

  Future<void> updateUser(User user) async {
    final db = await database;
    await db.update(
      USER_TABLE,
      user.toJson(),
      where: 'id = ?',
      whereArgs: [user.id],
    );
  }

  // Progress methods
  Future<void> insertProgress(Progress progress) async {
    final db = await database;
    await db.insert(PROGRESS_TABLE, progress.toJson());
  }

  Future<Progress?> getProgress(String userId, String language) async {
    final db = await database;
    final maps = await db.query(
      PROGRESS_TABLE,
      where: 'userId = ? AND language = ?',
      whereArgs: [userId, language],
    );

    if (maps.isNotEmpty) {
      return Progress.fromJson(maps.first);
    }
    return null;
  }

  Future<void> updateProgress(Progress progress) async {
    final db = await database;
    await db.update(
      PROGRESS_TABLE,
      progress.toJson(),
      where: 'userId = ? AND language = ?',
      whereArgs: [progress.userId, progress.language],
    );
  }

  Future<List<Progress>> getAllProgress(String userId) async {
    final db = await database;
    final maps = await db.query(
      PROGRESS_TABLE,
      where: 'userId = ?',
      whereArgs: [userId],
    );

    return maps.map((map) => Progress.fromJson(map)).toList();
  }
}