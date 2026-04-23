class Progress {
  final String userId;
  final String language;
  final int streak;
  final int totalXP;
  final Map<String, int> categoryXP;
  final List<Achievement> achievements;
  final DateTime lastActivity;

  Progress({
    required this.userId,
    required this.language,
    required this.streak,
    required this.totalXP,
    required this.categoryXP,
    required this.achievements,
    required this.lastActivity,
  });

  Progress copyWith({
    String? userId,
    String? language,
    int? streak,
    int? totalXP,
    Map<String, int>? categoryXP,
    List<Achievement>? achievements,
    DateTime? lastActivity,
  }) {
    return Progress(
      userId: userId ?? this.userId,
      language: language ?? this.language,
      streak: streak ?? this.streak,
      totalXP: totalXP ?? this.totalXP,
      categoryXP: categoryXP ?? this.categoryXP,
      achievements: achievements ?? this.achievements,
      lastActivity: lastActivity ?? this.lastActivity,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'userId': userId,
      'language': language,
      'streak': streak,
      'totalXP': totalXP,
      'categoryXP': categoryXP,
      'achievements': achievements.map((a) => a.toJson()).toList(),
      'lastActivity': lastActivity.millisecondsSinceEpoch,
    };
  }

  factory Progress.fromJson(Map<String, dynamic> json) {
    return Progress(
      userId: json['userId'] as String,
      language: json['language'] as String,
      streak: json['streak'] as int,
      totalXP: json['totalXP'] as int,
      categoryXP: Map<String, int>.from(json['categoryXP'] as Map),
      achievements: (json['achievements'] as List)
          .map((a) => Achievement.fromJson(a))
          .toList(),
      lastActivity: DateTime.fromMillisecondsSinceEpoch(
        json['lastActivity'] as int,
      ),
    );
  }
}

class Achievement {
  final String id;
  final String title;
  final String description;
  final DateTime earnedAt;

  Achievement({
    required this.id,
    required this.title,
    required this.description,
    required this.earnedAt,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'earnedAt': earnedAt.millisecondsSinceEpoch,
    };
  }

  factory Achievement.fromJson(Map<String, dynamic> json) {
    return Achievement(
      id: json['id'] as String,
      title: json['title'] as String,
      description: json['description'] as String,
      earnedAt: DateTime.fromMillisecondsSinceEpoch(json['earnedAt'] as int),
    );
  }
}
