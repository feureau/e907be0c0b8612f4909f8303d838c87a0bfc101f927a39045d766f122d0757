import '../models/grammar_exercise.dart';
import 'audio_service.dart';

class GrammarExerciseService {
  final AudioService? audioService;

  GrammarExerciseService(this.audioService);

  List<GrammarExercise> getAllExercises() {
    return GrammarExercise.getSampleExercises();
  }

  GrammarExercise? getExercise(String id) {
    final exercises = GrammarExercise.getSampleExercises();
    try {
      return exercises.firstWhere((e) => e.id == id);
    } catch (e) {
      return null;
    }
  }

  List<GrammarExercise> getExercisesByCategory(String category) {
    return GrammarExercise.getSampleExercises()
        .where((e) => e.category.toLowerCase() == category.toLowerCase())
        .toList();
  }

  List<GrammarExercise> getExercisesByDifficulty(int difficulty) {
    return GrammarExercise.getSampleExercises()
        .where((e) => e.difficulty == difficulty)
        .toList();
  }

  bool checkAnswer(GrammarQuestion question, String answer) {
    return question.correctAnswer.toLowerCase() == answer.toLowerCase();
  }

  ExerciseResult evaluateExercise(
    GrammarExercise exercise,
    Map<int, String> userAnswers,
  ) {
    int correctCount = 0;

    for (int i = 0; i < exercise.questions.length; i++) {
      final question = exercise.questions[i];
      final userAnswer = userAnswers[i] ?? '';

      if (checkAnswer(question, userAnswer)) {
        correctCount++;
      }
    }

    // Calculate XP based on accuracy
    final accuracy = exercise.questions.length > 0
        ? correctCount / exercise.questions.length
        : 0.0;
    final xpEarned = (exercise.xpReward * accuracy).round();

    return ExerciseResult(
      exerciseId: exercise.id,
      totalQuestions: exercise.questions.length,
      correctAnswers: correctCount,
      xpEarned: xpEarned,
      completedAt: DateTime.now(),
    );
  }

  String generateHint(GrammarQuestion question) {
    switch (question.type) {
      case QuestionType.multipleChoice:
        return 'Think about the grammar rule discussed in the lesson.';
      case QuestionType.fillInBlank:
        return 'Consider what particle or conjugation is needed here.';
      case QuestionType.sentenceReorder:
        return 'Remember the basic Japanese word order: Subject-Object-Verb.';
    }
  }

  List<String> getCategories() {
    final exercises = GrammarExercise.getSampleExercises();
    return exercises.map((e) => e.category).toSet().toList();
  }
}