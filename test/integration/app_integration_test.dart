import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../lib/main.dart';
import '../../lib/models/progress.dart';
import '../../lib/models/user.dart';
import '../../lib/providers/progress_provider.dart';
import '../../lib/providers/user_provider.dart';

void main() {
  group('App Integration Tests', () {
    late User testUser;
    late Progress testProgress;

    setUp(() {
      testUser = User(
        id: 'test-user',
        name: 'Test User',
        createdAt: DateTime.now(),
      );
      testProgress = Progress(
        userId: testUser.id,
        language: 'Japanese',
        streak: 3,
        totalXP: 120,
        categoryXP: {'Vocabulary': 60, 'Grammar': 60},
        achievements: [],
        lastActivity: DateTime.now(),
      );
    });

    Widget buildApp() {
      return ProviderScope(
        overrides: [
          userProvider.overrideWith((ref) => testUser),
          progressProvider.overrideWith((ref) => {'Japanese': testProgress}),
        ],
        child: const MaterialApp(home: MainScreen()),
      );
    }

    testWidgets('should display main screen with navigation', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildApp());
      await tester.pump();

      expect(find.text('e907'), findsOneWidget);
      expect(find.byType(BottomNavigationBar), findsOneWidget);
      expect(find.text('Home'), findsOneWidget);
    });

    testWidgets('should navigate to learn tab', (WidgetTester tester) async {
      await tester.pumpWidget(buildApp());
      await tester.pump();

      await tester.tap(find.text('Learn'));
      await tester.pump();

      expect(find.text('Learning Modules'), findsOneWidget);
      expect(find.text('Vocabulary Practice'), findsOneWidget);
    });

    testWidgets('should display progress dashboard data', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(buildApp());
      await tester.pump();

      expect(find.text('Your Progress'), findsOneWidget);
      expect(find.text('3 days'), findsOneWidget);
      expect(find.text('120 XP'), findsOneWidget);
    });
  });
}
