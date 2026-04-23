class GrammarExercise {
  final String id;
  final String title;
  final String explanation;
  final List<GrammarQuestion> questions;
  final String category;
  final int difficulty;
  final int xpReward;

  GrammarExercise({
    required this.id,
    required this.title,
    required this.explanation,
    required this.questions,
    required this.category,
    required this.difficulty,
    required this.xpReward,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'explanation': explanation,
      'questions': questions.map((q) => q.toJson()).toList(),
      'category': category,
      'difficulty': difficulty,
      'xpReward': xpReward,
    };
  }

  factory GrammarExercise.fromJson(Map<String, dynamic> json) {
    return GrammarExercise(
      id: json['id'] as String,
      title: json['title'] as String,
      explanation: json['explanation'] as String,
      questions: (json['questions'] as List)
          .map((q) => GrammarQuestion.fromJson(q))
          .toList(),
      category: json['category'] as String,
      difficulty: json['difficulty'] as int,
      xpReward: json['xpReward'] as int,
    );
  }

  static List<GrammarExercise> getSampleExercises() {
    return [
      GrammarExercise(
        id: '1',
        title: 'Japanese Particles - は and が',
        explanation: 'The particle "は" (wa) marks the topic of the sentence, while "が" (ga) marks the grammatical subject. Use "は" when talking about what the topic does or is, and "が" to emphasize the subject itself.',
        questions: [
          GrammarQuestion(
            type: QuestionType.multipleChoice,
            question: '私___学生です。 (watashi ___ gakusei desu)',
            options: ['は', 'が', 'を', 'に'],
            correctAnswer: 'は',
            explanation: '"は" marks the topic of the sentence.',
          ),
          GrammarQuestion(
            type: QuestionType.fillInBlank,
            question: '猫___います。 (neko___imasu)',
            correctAnswer: 'が',
            explanation: '"が" marks the subject doing the action.',
          ),
          GrammarQuestion(
            type: QuestionType.multipleChoice,
            question: ' Which particle marks the topic?',
            options: ['は', 'を', 'で', 'と'],
            correctAnswer: 'は',
            explanation: '"は" is the topic marker particle.',
          ),
        ],
        category: 'Particles',
        difficulty: 1,
        xpReward: 30,
      ),
      GrammarExercise(
        id: '2',
        title: 'Verb Conjugation -masu form',
        explanation: 'The "-masu" form is the polite form of Japanese verbs. To form it: for ichidan verbs, drop "る" and add "ます"; for godan verbs, change the final hiragana to the "-i" row and add "ます".',
        questions: [
          GrammarQuestion(
            type: QuestionType.multipleChoice,
            question: '食べる (taberu) → ___ます',
            options: ['食べ', '食べる', '食べら', '食べた'],
            correctAnswer: '食べ',
            explanation: 'For ichidan verbs, drop "る" and add "ます".',
          ),
          GrammarQuestion(
            type: QuestionType.fillInBlank,
            question: '行く (iku) → 行___ます',
            correctAnswer: 'き',
            explanation: 'Godan verbs change to the -i row.',
          ),
          GrammarQuestion(
            type: QuestionType.multipleChoice,
            question: ' What is the -masu form of 飲む (nomu)?',
            options: ['飲みます', '飲むます', '飲むい', '飲めます'],
            correctAnswer: '飲みます',
            explanation: 'Drop "う" and add "います" for godan verbs.',
          ),
        ],
        category: 'Verbs',
        difficulty: 2,
        xpReward: 40,
      ),
      GrammarExercise(
        id: '3',
        title: 'Describing Adjectives - Na-adjectives',
        explanation: 'Na-adjectives (形容詞 keiyōshi) work like nouns and need "な" (na) before nouns. When connecting to other adjectives, use "ーで" (de).',
        questions: [
          GrammarQuestion(
            type: QuestionType.fillInBlank,
            question: '静かな (shizuka___) 图书馆',
            correctAnswer: 'な',
            explanation: 'Na-adjectives need "な" before nouns.',
          ),
          GrammarQuestion(
            type: QuestionType.multipleChoice,
            question: ' Which is correct for "interesting person"?',
            options: ['面白い人', '面白いな人', '面白いの人', '面白い的人'],
            correctAnswer: '面白い人',
            explanation: 'Na-adjectives use "な" directly before nouns in i-adjective form.',
          ),
          GrammarQuestion(
            type: QuestionType.multipleChoice,
            question: '静的___静かな (seiteki___ shizuka na)',
            options: ['で', 'だ', 'な', 'に'],
            correctAnswer: 'で',
            explanation: 'Use "で" to connect two adjectives.',
          ),
        ],
        category: 'Adjectives',
        difficulty: 2,
        xpReward: 35,
      ),
    ];
  }
}

enum QuestionType {
  multipleChoice,
  fillInBlank,
  sentenceReorder,
}

class GrammarQuestion {
  final QuestionType type;
  final String question;
  final List<String>? options;
  final String correctAnswer;
  final String? reorderOptions;
  final String explanation;

  GrammarQuestion({
    required this.type,
    required this.question,
    this.options,
    required this.correctAnswer,
    this.reorderOptions,
    required this.explanation,
  });

  Map<String, dynamic> toJson() {
    return {
      'type': type.index,
      'question': question,
      'options': options,
      'correctAnswer': correctAnswer,
      'reorderOptions': reorderOptions,
      'explanation': explanation,
    };
  }

  factory GrammarQuestion.fromJson(Map<String, dynamic> json) {
    return GrammarQuestion(
      type: QuestionType.values[json['type'] as int],
      question: json['question'] as String,
      options: json['options'] as List<String>?,
      correctAnswer: json['correctAnswer'] as String,
      reorderOptions: json['reorderOptions'] as String?,
      explanation: json['explanation'] as String,
    );
  }
}

class ExerciseResult {
  final String exerciseId;
  final int totalQuestions;
  final int correctAnswers;
  final int xpEarned;
  final DateTime completedAt;

  ExerciseResult({
    required this.exerciseId,
    required this.totalQuestions,
    required this.correctAnswers,
    required this.xpEarned,
    required this.completedAt,
  });

  double get accuracy => totalQuestions > 0 ? correctAnswers / totalQuestions : 0;
}
