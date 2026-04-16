import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:riverpod/riverpod.dart';
import '../../lib/providers/progress_provider.dart';
import '../../lib/services/database_service.dart';
import '../../lib/models/progress.dart';
import '../../lib/models/user.dart';

// Generate mock classes
@GenerateMocks([DatabaseService])
import 'progress_provider_test.mocks.dart';

void main() {
  group('ProgressProvider', () {
    late ProviderContainer container;
    late MockDatabaseService mockDatabaseService;

    setUp(() {
      mockDatabaseService = MockDatabaseService();
      container = ProviderContainer(
        overrides: [
          databaseServiceProvider.overrideWithValue(mockDatabaseService),
        ],
      );
    });

    tearDown(() {
      container.dispose();
    });

    test('should add XP to progress', () async {
      final user = User(
        id: 'test_user',
        name: 'Test User',
        createdAt: DateTime.now(),
      );
      
      // Set user in provider
      container.read(userProvider.notifier).state = user;
      
      // Mock database service response
      final progress = Progress(
        userId: user.id,
        language: 'Japanese',
        streak: 1,
        totalXP: 0,
        categoryXP: {},
        achievements: [],
        lastActivity: DateTime.now(),
      );
      
      when(mockDatabaseService.getProgress(any, any)).thenAnswer(
        (_) async => progress,
      );
      
      when(mockDatabaseService.updateProgress(any)).thenAnswer(
        (_) async => {},
      );
      
      // Add XP
      await container.read(addXPProvider)(
        'Japanese', 
        10, 
        'Vocabulary'
      );
      
      // Verify database calls
      verify(mockDatabaseService.getProgress(any, any)).called(1);
      verify(mockDatabaseService.updateProgress(any)).called(1);
    });

    test('should update progress provider state', () async {
      final progress = Progress(
        userId: 'test_user',
        language: 'Japanese',
        streak: 5,
        totalXP: 100,
        categoryXP: {'Vocabulary': 50},
        achievements: [],
        lastActivity: DateTime.now(),
      );
      
      final progressMap = {'Japanese': progress};
      
      // Update provider state
      container.read(progressProvider.notifier).state = progressMap;
      
      // Read state
      final state = container.read(progressProvider);
      
      expect(state, isNotNull);
      expect(state!['Japanese'], isNotNull);
      expect(state['Japanese']!.streak, equals(5));
      expect(state['Japanese']!.totalXP, equals(100));
    });
  });
}