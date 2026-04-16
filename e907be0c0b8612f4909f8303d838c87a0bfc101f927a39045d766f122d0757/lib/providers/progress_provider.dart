import 'package:riverpod/riverpod.dart';
import '../models/progress.dart';
import '../services/database_service.dart';
import 'user_provider.dart';

// Provider for current user's progress
final progressProvider = StateProvider<Map<String, Progress>?>((ref) => null);

// Provider for loading user progress
final userProgressProvider = FutureProvider.autoDispose.family<List<Progress>, String>((ref, userId) async {
  final dbService = ref.read(databaseServiceProvider);
  return await dbService.getAllProgress(userId);
});

// Provider for initializing progress data
final initializeProgressProvider = FutureProvider<Map<String, Progress>?>((ref) async {
  final user = ref.watch(userProvider);
  if (user == null) return null;
  
  final dbService = ref.read(databaseServiceProvider);
  final progressList = await dbService.getAllProgress(user.id);
  
  // Convert list to map for easier access
  final progressMap = <String, Progress>{};
  for (final progress in progressList) {
    progressMap[progress.language] = progress;
  }
  
  // If no progress exists for Japanese, create default
  if (!progressMap.containsKey('Japanese')) {
    final japaneseProgress = Progress(
      userId: user.id,
      language: 'Japanese',
      streak: 0,
      totalXP: 0,
      categoryXP: {},
      achievements: [],
      lastActivity: DateTime.now(),
    );
    
    await dbService.insertProgress(japaneseProgress);
    progressMap['Japanese'] = japaneseProgress;
  }
  
  return progressMap;
});

// Provider for updating progress
final updateProgressProvider = Provider((ref) => (Progress progress) async {
  final dbService = ref.read(databaseServiceProvider);
  await dbService.updateProgress(progress);
  
  // Update the state provider
  final currentProgress = ref.read(progressProvider);
  if (currentProgress != null) {
    currentProgress[progress.language] = progress;
    ref.read(progressProvider.notifier).state = currentProgress;
  }
});

// Provider for adding XP to progress
final addXPProvider = Provider((ref) => (String language, int xp, String category) async {
  final user = ref.read(userProvider);
  if (user == null) return;
  
  final dbService = ref.read(databaseServiceProvider);
  var progress = await dbService.getProgress(user.id, language);
  
  if (progress == null) {
    // Create new progress if it doesn't exist
    progress = Progress(
      userId: user.id,
      language: language,
      streak: 1,
      totalXP: xp,
      categoryXP: {category: xp},
      achievements: [],
      lastActivity: DateTime.now(),
    );
  } else {
    // Update existing progress
    final updatedCategoryXP = Map<String, int>.from(progress.categoryXP);
    updatedCategoryXP[category] = (updatedCategoryXP[category] ?? 0) + xp;
    
    progress = progress.copyWith(
      totalXP: progress.totalXP + xp,
      categoryXP: updatedCategoryXP,
      lastActivity: DateTime.now(),
    );
  }
  
  await dbService.updateProgress(progress);
  
  // Update the state provider
  final currentProgress = ref.read(progressProvider);
  if (currentProgress != null) {
    currentProgress[language] = progress;
    ref.read(progressProvider.notifier).state = currentProgress;
  }
});