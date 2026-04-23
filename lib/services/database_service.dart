import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:flutter/services.dart';
import 'package:path/path.dart';
import 'package:sqflite/sqflite.dart';
import 'package:path_provider/path_provider.dart';
import '../models/user.dart';
import '../models/progress.dart';
import '../utils/constants.dart';

class DatabaseService {
  static DatabaseService? _instance;
  static Database? _database;
  static const String USER_TABLE = 'users';
  static const String PROGRESS_TABLE = 'progress';

  DatabaseService._();

  static DatabaseService get instance {
    _instance ??= DatabaseService._();
    return _instance!;
  }

  Future<Database> get database async {
    if (_database != null) return _database!;
    _database = await _initDB();
    return _database!;
  }

  Future<Database> _initDB() async {
    String path;
    try {
      final documentsDirectory = await getApplicationDocumentsDirectory();
      path = join(documentsDirectory.path, AppConstants.databaseName);
    } on MissingPluginException {
      // Allows tests to run in environments where path_provider channels are unavailable.
      final fallbackDirectory = await getDatabasesPath();
      path = join(fallbackDirectory, AppConstants.databaseName);
    }
    return await openDatabase(path, version: 1, onCreate: _onCreate);
  }

  Future<void> _onCreate(Database db, int version) async {
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
    await db.insert(
      USER_TABLE,
      _userToDbMap(user),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<User?> getUser(String id) async {
    final db = await database;
    final maps = await db.query(USER_TABLE, where: 'id = ?', whereArgs: [id]);

    if (maps.isNotEmpty) {
      return _userFromDbMap(maps.first);
    }
    return null;
  }

  Future<void> updateUser(User user) async {
    final db = await database;
    await db.insert(
      USER_TABLE,
      _userToDbMap(user),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  // Progress methods
  Future<void> insertProgress(Progress progress) async {
    final db = await database;
    await db.insert(
      PROGRESS_TABLE,
      _progressToDbMap(progress),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<Progress?> getProgress(String userId, String language) async {
    final db = await database;
    final maps = await db.query(
      PROGRESS_TABLE,
      where: 'userId = ? AND language = ?',
      whereArgs: [userId, language],
    );

    if (maps.isNotEmpty) {
      return _progressFromDbMap(maps.first);
    }
    return null;
  }

  Future<void> updateProgress(Progress progress) async {
    final db = await database;
    await db.insert(
      PROGRESS_TABLE,
      _progressToDbMap(progress),
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
  }

  Future<List<Progress>> getAllProgress(String userId) async {
    final db = await database;
    final maps = await db.query(
      PROGRESS_TABLE,
      where: 'userId = ?',
      whereArgs: [userId],
    );

    return maps.map(_progressFromDbMap).toList();
  }

  Map<String, dynamic> _userToDbMap(User user) {
    return {
      'id': user.id,
      'name': user.name,
      'createdAt': user.createdAt.millisecondsSinceEpoch,
      'preferences': jsonEncode(user.preferences),
    };
  }

  User _userFromDbMap(Map<String, dynamic> map) {
    final rawPreferences = map['preferences'];
    final preferences = rawPreferences is String && rawPreferences.isNotEmpty
        ? Map<String, dynamic>.from(jsonDecode(rawPreferences) as Map)
        : <String, dynamic>{};

    return User(
      id: map['id'] as String,
      name: map['name'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      preferences: preferences,
    );
  }

  Map<String, dynamic> _progressToDbMap(Progress progress) {
    return {
      'userId': progress.userId,
      'language': progress.language,
      'streak': progress.streak,
      'totalXP': progress.totalXP,
      'categoryXP': jsonEncode(progress.categoryXP),
      'achievements': jsonEncode(
        progress.achievements.map((a) => a.toJson()).toList(),
      ),
      'lastActivity': progress.lastActivity.millisecondsSinceEpoch,
    };
  }

  Progress _progressFromDbMap(Map<String, dynamic> map) {
    final rawCategoryXp = map['categoryXP'];
    final rawAchievements = map['achievements'];

    final categoryXp = rawCategoryXp is String && rawCategoryXp.isNotEmpty
        ? Map<String, int>.from(jsonDecode(rawCategoryXp) as Map)
        : <String, int>{};
    final achievements = rawAchievements is String && rawAchievements.isNotEmpty
        ? (jsonDecode(rawAchievements) as List)
              .map(
                (entry) => Achievement.fromJson(
                  Map<String, dynamic>.from(entry as Map),
                ),
              )
              .toList()
        : <Achievement>[];

    return Progress(
      userId: map['userId'] as String,
      language: map['language'] as String,
      streak: map['streak'] as int,
      totalXP: map['totalXP'] as int,
      categoryXP: categoryXp,
      achievements: achievements,
      lastActivity: DateTime.fromMillisecondsSinceEpoch(
        map['lastActivity'] as int,
      ),
    );
  }
}
