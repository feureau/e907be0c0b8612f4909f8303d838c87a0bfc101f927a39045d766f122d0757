import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/riverpod.dart';
import '../../lib/widgets/flashcard_widget.dart';
import '../../lib/models/vocabulary.dart';

void main() {
  group('FlashcardWidget', () {
    late Vocabulary testVocabulary;
    
    setUp(() {
      testVocabulary = Vocabulary(
        id: '1',
        japanese: 'こんにちは',
        reading: 'Konnichiwa',
        english: 'Hello',
        category: 'Greetings',
        difficulty: 1,
        exampleSentence: 'こんにちは、元気ですか？',
        exampleReading: 'Konnichiwa, genki desu ka?',
        exampleEnglish: 'Hello, how are you?',
      );
    });

    testWidgets('should display Japanese text on front of card', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: FlashcardWidget(
                vocabulary: testVocabulary,
                onCorrect: () {},
                onIncorrect: () {},
              ),
            ),
          ),
        ),
      );

      expect(find.text('こんにちは'), findsOneWidget);
      expect(find.text('Hello'), findsNothing);
    });

    testWidgets('should flip card when tapped', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: FlashcardWidget(
                vocabulary: testVocabulary,
                onCorrect: () {},
                onIncorrect: () {},
              ),
            ),
          ),
        ),
      );

      // Initially shows front of card
      expect(find.text('こんにちは'), findsOneWidget);
      expect(find.text('Hello'), findsNothing);

      // Tap to flip
      await tester.tap(find.byType(GestureDetector));
      await tester.pumpAndSettle();

      // Should now show back of card
      expect(find.text('Hello'), findsOneWidget);
    });

    testWidgets('should trigger callbacks when correct/incorrect buttons pressed', (WidgetTester tester) async {
      bool correctPressed = false;
      bool incorrectPressed = false;

      await tester.pumpWidget(
        ProviderScope(
          child: MaterialApp(
            home: Scaffold(
              body: FlashcardWidget(
                vocabulary: testVocabulary,
                onCorrect: () => correctPressed = true,
                onIncorrect: () => incorrectPressed = true,
              ),
            ),
          ),
        ),
      );

      // Flip the card to see the buttons
      await tester.tap(find.byType(GestureDetector));
      await tester.pumpAndSettle();

      // Test correct button
      await tester.tap(find.text('Correct'));
      expect(correctPressed, isTrue);
      expect(incorrectPressed, isFalse);

      // Reset flags
      correctPressed = false;
      incorrectPressed = false;

      // Test incorrect button
      await tester.tap(find.text('Incorrect'));
      expect(incorrectPressed, isTrue);
      expect(correctPressed, isFalse);
    });
  });
}