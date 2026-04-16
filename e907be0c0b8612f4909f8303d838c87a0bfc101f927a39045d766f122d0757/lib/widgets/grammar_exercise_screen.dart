import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import '../models/grammar_exercise.dart';
import '../services/grammar_exercise_service.dart';
import '../providers/audio_provider.dart';
import '../providers/progress_provider.dart';
import '../providers/user_provider.dart';

class GrammarExerciseScreen extends ConsumerStatefulWidget {
  final GrammarExercise exercise;

  const GrammarExerciseScreen({super.key, required this.exercise});

  @override
  ConsumerState<GrammarExerciseScreen> createState() => _GrammarExerciseScreenState();
}

class _GrammarExerciseScreenState extends ConsumerState<GrammarExerciseScreen> {
  late GrammarExerciseService _service;
  int _currentQuestionIndex = 0;
  final Map<int, String> _userAnswers = {};
  bool _showResult = false;
  ExerciseResult? _result;
  String? _feedbackMessage;
  bool _showExplanation = false;

  @override
  void initState() {
    super.initState();
    _service = GrammarExerciseService(ref.read(audioServiceProvider));
  }

  void _submitAnswer(String answer) {
    final currentQuestion = widget.exercise.questions[_currentQuestionIndex];
    final isCorrect = _service.checkAnswer(currentQuestion, answer);

    setState(() {
      _userAnswers[_currentQuestionIndex] = answer;
      _showExplanation = true;
      _feedbackMessage = isCorrect ? 'Correct!' : 'Incorrect. ${currentQuestion.explanation}';
    });

    if (isCorrect) {
      ref.read(playCorrectSoundProvider)();
    } else {
      ref.read(playIncorrectSoundProvider)();
    }

    Future.delayed(const Duration(seconds: 2), () {
      if (mounted) {
        _nextQuestion();
      }
    });
  }

  void _nextQuestion() {
    if (_currentQuestionIndex < widget.exercise.questions.length - 1) {
      setState(() {
        _currentQuestionIndex++;
        _showExplanation = false;
        _feedbackMessage = null;
      });
    } else {
      _finishExercise();
    }
  }

  void _finishExercise() {
    _result = _service.evaluateExercise(widget.exercise, _userAnswers);

    // Award XP
    final user = ref.read(userProvider);
    if (user != null && _result!.xpEarned > 0) {
      ref.read(addXPProvider)(user.id, _result!.xpEarned, 'Grammar');
    }

    setState(() {
      _showResult = true;
    });

    if (_result!.correctAnswers == widget.exercise.questions.length) {
      ref.read(playAchievementSoundProvider)();
    }
  }

  void _retryExercise() {
    setState(() {
      _currentQuestionIndex = 0;
      _userAnswers.clear();
      _showResult = false;
      _result = null;
      _showExplanation = false;
      _feedbackMessage = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_showResult) {
      return _buildResultScreen();
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.exercise.title),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          LinearProgressIndicator(
            value: (_currentQuestionIndex + 1) / widget.exercise.questions.length,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
          ),
          Expanded(
            child: _buildQuestionScreen(widget.exercise.questions[_currentQuestionIndex]),
          ),
          if (_feedbackMessage != null)
            Container(
              padding: const EdgeInsets.all(16),
              color: _feedbackMessage!.startsWith('Correct')
                  ? Colors.green[100]
                  : Colors.red[100],
              child: Text(_feedbackMessage!),
            ),
        ],
      ),
    );
  }

  Widget _buildQuestionScreen(GrammarQuestion question) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Question ${_currentQuestionIndex + 1} of ${widget.exercise.questions.length}',
            style: TextStyle(color: Colors.grey[600], fontSize: 14),
          ),
          const SizedBox(height: 20),
          Text(
            question.question,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 30),
          if (question.type == QuestionType.multipleChoice)
            _buildMultipleChoice(question),
          if (question.type == QuestionType.fillInBlank)
            _buildFillInBlank(question),
          const SizedBox(height: 20),
          Text(
            'Tap an answer to check',
            style: TextStyle(color: Colors.grey[500], fontSize: 12),
          ),
        ],
      ),
    );
  }

  Widget _buildMultipleChoice(GrammarQuestion question) {
    if (question.options == null) return const SizedBox.shrink();

    return Column(
      children: question.options!.map((option) {
        final isSelected = _userAnswers[_currentQuestionIndex] == option;
        final showResult = _showExplanation && isSelected;
        final isCorrect = option == question.correctAnswer;

        Color? backgroundColor;
        if (_showExplanation) {
          if (isCorrect) {
            backgroundColor = Colors.green[100];
          } else if (isSelected) {
            backgroundColor = Colors.red[100];
          }
        }

        return Padding(
          padding: const EdgeInsets.only(bottom: 12),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: _showExplanation ? null : () => _submitAnswer(option),
              style: ElevatedButton.styleFrom(
                backgroundColor: backgroundColor ?? (isSelected ? Colors.blue[50] : Colors.white),
                foregroundColor: Colors.black87,
                padding: const EdgeInsets.symmetric(vertical: 16),
                side: BorderSide(color: isSelected ? Colors.blue : Colors.grey[300]!),
              ),
              child: Text(option, style: const TextStyle(fontSize: 16)),
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildFillInBlank(GrammarQuestion question) {
    final controller = TextEditingController(
      text: _userAnswers[_currentQuestionIndex] ?? '',
    );

    return Column(
      children: [
        TextField(
          controller: controller,
          decoration: InputDecoration(
            hintText: 'Type your answer...',
            border: const OutlineInputBorder(),
            filled: true,
            fillColor: _showExplanation
                ? (question.correctAnswer == _userAnswers[_currentQuestionIndex]
                    ? Colors.green[50]
                    : Colors.red[50])
                : Colors.white,
          ),
          onSubmitted: _showExplanation ? null : (value) => _submitAnswer(value),
          enabled: !_showExplanation,
        ),
        const SizedBox(height: 16),
        ElevatedButton(
          onPressed: _showExplanation
              ? null
              : () {
                  if (controller.text.isNotEmpty) {
                    _submitAnswer(controller.text);
                  }
                },
          style: ElevatedButton.styleFrom(
            backgroundColor: Theme.of(context).primaryColor,
            foregroundColor: Colors.white,
          ),
          child: const Text('Submit'),
        ),
      ],
    );
  }

  Widget _buildResultScreen() {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Results'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: Padding(
          padding: const EdgeInsets.all(32),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(
                _result!.accuracy >= 0.7 ? Icons.celebration : Icons.sentiment_satisfied,
                size: 80,
                color: _result!.accuracy >= 0.7 ? Colors.amber : Colors.blue,
              ),
              const SizedBox(height: 24),
              Text(
                _result!.accuracy >= 0.7 ? 'Great Job!' : 'Keep Practicing!',
                style: const TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              Text(
                '${_result!.correctAnswers} of ${_result!.totalQuestions} correct',
                style: const TextStyle(fontSize: 20),
              ),
              const SizedBox(height: 8),
              Text(
                '${_result!.accuracy.toStringAsFixed(0)}% accuracy',
                style: const TextStyle(fontSize: 16, color: Colors.grey),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.amber[100],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  '+${_result!.xpEarned} XP earned!',
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                style: ElevatedButton.styleFrom(
                  padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                ),
                child: const Text('Continue'),
              ),
              const SizedBox(height: 16),
              TextButton(
                onPressed: _retryExercise,
                child: const Text('Try Again'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}