import 'package:test/test.dart';
import '../../lib/services/grammar_exercise_service.dart';
import '../../lib/models/grammar_exercise.dart';

void main() {
  group('GrammarExerciseService', () {
    late GrammarExerciseService service;

    setUp(() {
      service = GrammarExerciseService.instance;
    });

    test('should return all exercises', () {
      final exercises = service.getAllExercises();

      expect(exercises, isNotEmpty);
    });

    test('should get exercise by ID', () {
      final exercises = service.getAllExercises();
      final firstId = exercises.first.id;

      final exercise = service.getExercise(firstId);

      expect(exercise, isNotNull);
      expect(exercise!.id, equals(firstId));
    });

    test('should return null for invalid exercise ID', () {
      final exercise = service.getExercise('nonexistent_id');

      expect(exercise, isNull);
    });

    test('should filter exercises by category', () {
      final exercises = service.getExercisesByCategory('Particles');

      expect(exercises, isNotEmpty);
      expect(exercises.every((e) => e.category == 'Particles'), isTrue);
    });

    test('should filter exercises by difficulty', () {
      final exercises = service.getExercisesByDifficulty(1);

      expect(exercises, isNotEmpty);
      expect(exercises.every((e) => e.difficulty == 1), isTrue);
    });

    test('should check answers case-insensitively', () {
      final exercise = GrammarExercise.getSampleExercises().first;
      final question = exercise.questions.first;

      expect(
        service.checkAnswer(question, question.correctAnswer.toUpperCase()),
        isTrue,
      );
      expect(
        service.checkAnswer(question, question.correctAnswer.toLowerCase()),
        isTrue,
      );
    });

    test('should evaluate exercise and calculate XP correctly', () {
      final exercise = GrammarExercise.getSampleExercises().first;
      final userAnswers = <int, String>{};

      for (int i = 0; i < exercise.questions.length; i++) {
        userAnswers[i] = exercise.questions[i].correctAnswer;
      }

      final result = service.evaluateExercise(exercise, userAnswers);

      expect(result.correctAnswers, equals(exercise.questions.length));
      expect(result.xpEarned, equals(exercise.xpReward));
    });

    test('should calculate partial XP for partial correct answers', () {
      final exercise = GrammarExercise(
        id: 'test',
        title: 'Test',
        explanation: 'Test explanation',
        category: 'Test',
        difficulty: 1,
        xpReward: 100,
        questions: [
          GrammarQuestion(
            type: QuestionType.fillInBlank,
            question: 'Test?',
            correctAnswer: 'Answer',
            options: ['Answer', 'Wrong'],
            explanation: 'Hint',
          ),
          GrammarQuestion(
            type: QuestionType.fillInBlank,
            question: 'Test?',
            correctAnswer: 'Answer',
            options: ['Answer', 'Wrong'],
            explanation: 'Hint',
          ),
        ],
      );

      final userAnswers = <int, String>{0: 'Answer', 1: 'Wrong'};
      final result = service.evaluateExercise(exercise, userAnswers);

      expect(result.correctAnswers, equals(1));
      expect(result.xpEarned, equals(50));
    });

    test('should generate appropriate hints', () {
      final multipleChoiceQuestion = GrammarQuestion(
        type: QuestionType.multipleChoice,
        question: 'Which is correct?',
        correctAnswer: 'A',
        options: ['A', 'B'],
        explanation: 'Test',
      );

      final fillInBlankQuestion = GrammarQuestion(
        type: QuestionType.fillInBlank,
        question: 'Fill in: ___ desu',
        correctAnswer: 'Kore',
        options: [],
        explanation: 'Test',
      );

      final reorderQuestion = GrammarQuestion(
        type: QuestionType.sentenceReorder,
        question: 'Arrange: I eat',
        correctAnswer: 'Watashi wa tabemasu',
        options: [],
        explanation: 'Test',
      );

      expect(
        service.generateHint(multipleChoiceQuestion),
        contains('grammar rule'),
      );
      expect(service.generateHint(fillInBlankQuestion), contains('particle'));
      expect(
        service.generateHint(reorderQuestion),
        contains('Subject-Object-Verb'),
      );
    });

    test('should return unique categories', () {
      final categories = service.getCategories();

      expect(categories, isNotEmpty);
      expect(categories.toSet().length, equals(categories.length));
    });
  });
}
