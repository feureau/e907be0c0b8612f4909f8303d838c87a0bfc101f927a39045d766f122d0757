/// App-wide constants
class AppConstants {
  // App information
  static const String appName = 'e907';
  static const String appVersion = '0.1.0';
  
  // Database constants
  static const String databaseName = 'e907.db';
  
  // Language constants
  static const String defaultLanguage = 'Japanese';
  static const List<String> supportedLanguages = ['Japanese', 'Spanish', 'French', 'German'];
  
  // XP constants
  static const int xpPerCorrectAnswer = 10;
  static const int xpPerLessonCompleted = 50;
  static const int xpPerStreakDay = 5;
  
  // Streak constants
  static const int streakFreezeCost = 100; // XP cost to freeze a streak
  
  // Audio constants
  static const String defaultSoundFont = 'assets/soundfonts/default.sf2';
  
  // UI constants
  static const double defaultBorderRadius = 16.0;
  static const double defaultPadding = 16.0;
  static const double defaultCardElevation = 4.0;
  
  // Colors
  static const int primaryColor = 0xFF2196F3; // Blue
  static const int secondaryColor = 0xFFFF9800; // Orange
  static const int accentColor = 0xFF4CAF50; // Green
  static const int errorColor = 0xFFF44336; // Red
  
  // Category colors
  static const Map<String, int> categoryColors = {
    'Vocabulary': 0xFF2196F3,
    'Grammar': 0xFF9C27B0,
    'Conversation': 0xFF4CAF50,
    'Listening': 0xFFFF9800,
    'Reading': 0xFF607D8B,
  };
  
  // Achievement constants
  static const List<Map<String, dynamic>> achievements = [
    {
      'id': 'first_lesson',
      'title': 'First Lesson',
      'description': 'Complete your first lesson',
      'xpReward': 100,
    },
    {
      'id': 'streak_7',
      'title': 'Week Warrior',
      'description': 'Maintain a 7-day streak',
      'xpReward': 200,
    },
    {
      'id': 'streak_30',
      'title': 'Month Master',
      'description': 'Maintain a 30-day streak',
      'xpReward': 500,
    },
    {
      'id': 'xp_1000',
      'title': 'Knowledge Seeker',
      'description': 'Earn 1000 XP',
      'xpReward': 300,
    },
  ];
}
