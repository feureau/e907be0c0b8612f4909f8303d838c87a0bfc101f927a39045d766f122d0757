class Vocabulary {
  final String id;
  final String japanese;
  final String reading;
  final String english;
  final String category;
  final int difficulty;
  final String exampleSentence;
  final String exampleReading;
  final String exampleEnglish;

  Vocabulary({
    required this.id,
    required this.japanese,
    required this.reading,
    required this.english,
    required this.category,
    required this.difficulty,
    required this.exampleSentence,
    required this.exampleReading,
    required this.exampleEnglish,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'japanese': japanese,
      'reading': reading,
      'english': english,
      'category': category,
      'difficulty': difficulty,
      'exampleSentence': exampleSentence,
      'exampleReading': exampleReading,
      'exampleEnglish': exampleEnglish,
    };
  }

  factory Vocabulary.fromJson(Map<String, dynamic> json) {
    return Vocabulary(
      id: json['id'] as String,
      japanese: json['japanese'] as String,
      reading: json['reading'] as String,
      english: json['english'] as String,
      category: json['category'] as String,
      difficulty: json['difficulty'] as int,
      exampleSentence: json['exampleSentence'] as String,
      exampleReading: json['exampleReading'] as String,
      exampleEnglish: json['exampleEnglish'] as String,
    );
  }

  // Sample vocabulary data for Japanese
  static List<Vocabulary> getSampleData() {
    return [
      Vocabulary(
        id: '1',
        japanese: 'こんにちは',
        reading: 'Konnichiwa',
        english: 'Hello',
        category: 'Greetings',
        difficulty: 1,
        exampleSentence: 'こんにちは、元気ですか？',
        exampleReading: 'Konnichiwa, genki desu ka?',
        exampleEnglish: 'Hello, how are you?',
      ),
      Vocabulary(
        id: '2',
        japanese: 'ありがとう',
        reading: 'Arigatou',
        english: 'Thank you',
        category: 'Greetings',
        difficulty: 1,
        exampleSentence: 'ありがとうございません。',
        exampleReading: 'Arigatou gozaimasen.',
        exampleEnglish: 'Thank you very much.',
      ),
      Vocabulary(
        id: '3',
        japanese: 'すみません',
        reading: 'Sumimasen',
        english: 'Excuse me / Sorry',
        category: 'Greetings',
        difficulty: 1,
        exampleSentence: 'すみません、トイレはどこですか？',
        exampleReading: 'Sumimasen, toire wa doko desu ka?',
        exampleEnglish: 'Excuse me, where is the toilet?',
      ),
      Vocabulary(
        id: '4',
        japanese: '食べる',
        reading: 'Taberu',
        english: 'To eat',
        category: 'Verbs',
        difficulty: 2,
        exampleSentence: '朝ごはんを食べました。',
        exampleReading: 'Asa gohan wo tabemashita.',
        exampleEnglish: 'I ate breakfast.',
      ),
      Vocabulary(
        id: '5',
        japanese: '見る',
        reading: 'Miru',
        english: 'To see / To watch',
        category: 'Verbs',
        difficulty: 2,
        exampleSentence: '映画を見ます。',
        exampleReading: 'Eiga wo mimasu.',
        exampleEnglish: 'I watch a movie.',
      ),
      Vocabulary(
        id: '6',
        japanese: '大きい',
        reading: 'Ookii',
        english: 'Big',
        category: 'Adjectives',
        difficulty: 2,
        exampleSentence: 'この家は大きいです。',
        exampleReading: 'Kono ie wa ookii desu.',
        exampleEnglish: 'This house is big.',
      ),
      Vocabulary(
        id: '7',
        japanese: '小さい',
        reading: 'Chiisai',
        english: 'Small',
        category: 'Adjectives',
        difficulty: 2,
        exampleSentence: '箱は小さいです。',
        exampleReading: 'Hako wa chiisai desu.',
        exampleEnglish: 'The box is small.',
      ),
    ];
  }
}
