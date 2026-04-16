import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:riverpod/riverpod.dart';
import '../../lib/main.dart';
import '../../lib/models/user.dart';
import '../../lib/models/progress.dart';

void main() {
  group('App Integration Tests', () {
    testWidgets('should display main screen with navigation', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MainApp(),
        ),
      );

      // Wait for initialization
      await tester.pumpAndSettle();

      // Check that main screen is displayed
      expect(find.text('Turbolingo'), findsOneWidget);
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      
      // Check that home tab is selected by default
      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('should navigate to flashcard screen', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MainApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Tap on the Learn tab
      await tester.tap(find.widgetWithText(BottomNavigationBarItem, 'Learn'));
      await tester.pumpAndSettle();

      // Check that flashcard option is available
      expect(find.text('Vocabulary Practice'), findsOneWidget);
    });

    testWidgets('should display progress dashboard', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MainApp(),
        ),
      );

      await tester.pumpAndSettle();

      // Check that progress information is displayed
      expect(find.text('Your Progress'), findsOneWidget);
      expect(find.byType(LinearProgressIndicator), findsWidgets);
    });

    testWidgets('should handle user initialization', (WidgetTester tester) async {
      await tester.pumpWidget(
        ProviderScope(
          child: MainApp(),
        ),
      );

      // Wait for user initialization
      await tester.pumpAndSettle();

      // Check that default user is created/loaded
      expect(find.text('Turbolingo'), findsOneWidget);
    });
  });
}