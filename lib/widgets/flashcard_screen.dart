import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/vocabulary.dart';
import '../providers/progress_provider.dart';
import '../providers/user_provider.dart';
import '../utils/constants.dart';
import 'flashcard_widget.dart';

class FlashcardScreen extends ConsumerStatefulWidget {
  const FlashcardScreen({super.key});

  @override
  ConsumerState<FlashcardScreen> createState() => _FlashcardScreenState();
}

class _FlashcardScreenState extends ConsumerState<FlashcardScreen> {
  late List<Vocabulary> _vocabularyList;
  int _currentIndex = 0;
  int _correctCount = 0;
  int _incorrectCount = 0;

  @override
  void initState() {
    super.initState();
    _vocabularyList = Vocabulary.getSampleData();
  }

  void _handleCorrect() {
    setState(() {
      _correctCount++;
    });

    // Add XP for correct answer
    final user = ref.read(userProvider);
    if (user != null) {
      ref.read(addXPProvider)(AppConstants.defaultLanguage, 10, 'Vocabulary');
    }

    // Move to next card
    _nextCard();
  }

  void _handleIncorrect() {
    setState(() {
      _incorrectCount++;
    });

    // Move to next card
    _nextCard();
  }

  void _nextCard() {
    setState(() {
      _currentIndex = (_currentIndex + 1) % _vocabularyList.length;
    });
  }

  void _previousCard() {
    setState(() {
      _currentIndex =
          (_currentIndex - 1 + _vocabularyList.length) % _vocabularyList.length;
    });
  }

  @override
  Widget build(BuildContext context) {
    final currentVocab = _vocabularyList[_currentIndex];

    return Scaffold(
      appBar: AppBar(
        title: const Text('Flashcards'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          // Progress indicator
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Text(
                  '$_correctCount correct, $_incorrectCount incorrect',
                  style: const TextStyle(fontSize: 16),
                ),
                const SizedBox(height: 10),
                LinearProgressIndicator(
                  value: _currentIndex / _vocabularyList.length,
                  backgroundColor: Colors.grey[300],
                  valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
                ),
                Text(
                  '${_currentIndex + 1} of ${_vocabularyList.length}',
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),
          ),

          // Flashcard
          Expanded(
            child: FlashcardWidget(
              vocabulary: currentVocab,
              onCorrect: _handleCorrect,
              onIncorrect: _handleIncorrect,
            ),
          ),

          // Navigation buttons
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: _previousCard,
                  child: const Text('Previous'),
                ),
                ElevatedButton(onPressed: _nextCard, child: const Text('Next')),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
