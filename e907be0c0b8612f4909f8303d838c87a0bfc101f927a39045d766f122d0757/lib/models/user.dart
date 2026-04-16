class User {
  final String id;
  final String name;
  final DateTime createdAt;
  final Map<String, dynamic> preferences;

  User({
    required this.id,
    required this.name,
    required this.createdAt,
    this.preferences = const {},
  });

  User copyWith({
    String? id,
    String? name,
    DateTime? createdAt,
    Map<String, dynamic>? preferences,
  }) {
    return User(
      id: id ?? this.id,
      name: name ?? this.name,
      createdAt: createdAt ?? this.createdAt,
      preferences: preferences ?? this.preferences,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'preferences': preferences,
    };
  }

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      name: json['name'] as String,
      createdAt: DateTime.fromMillisecondsSinceEpoch(json['createdAt'] as int),
      preferences: json['preferences'] as Map<String, dynamic>? ?? {},
    );
  }
}