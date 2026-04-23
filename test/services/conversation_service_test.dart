import 'package:test/test.dart';
import 'package:mockito/mockito.dart';
import '../../lib/services/conversation_service.dart';
import '../../lib/models/conversation.dart';
import '../../lib/services/audio_service.dart';

class MockAudioService extends Mock implements AudioService {}

void main() {
  group('ConversationService', () {
    late ConversationService conversationService;
    late MockAudioService mockAudioService;
    late Conversation testConversation;

    setUp(() {
      mockAudioService = MockAudioService();
      conversationService = ConversationService(mockAudioService);

      testConversation = Conversation(
        id: '1',
        title: 'Test Conversation',
        scenario: 'Test scenario',
        turns: [
          ConversationTurn(
            speaker: 'Speaker1',
            text: 'Hello',
            reading: 'こんにちは',
            translation: 'Hello',
            audioFile: 'hello.mp3',
          ),
          ConversationTurn(
            speaker: 'You',
            text: '',
            reading: '',
            translation: 'Response placeholder',
            audioFile: '',
            isUserResponse: true,
          ),
        ],
        category: 'Test',
        difficulty: 1,
        xpReward: 10,
      );
    });

    test('should start a conversation session', () async {
      final session = await conversationService.startConversation(
        testConversation,
      );

      expect(session.conversation, equals(testConversation));
      expect(session.currentIndex, equals(0));
      expect(session.userResponses, isEmpty);
      expect(session.score, equals(0));
    });

    test('should process user response and update session', () async {
      final session = await conversationService.startConversation(
        testConversation,
      );
      final updatedSession = await conversationService.processUserResponse(
        session,
        'Test response',
      );

      expect(updatedSession.userResponses, hasLength(1));
      expect(updatedSession.userResponses.first, equals('Test response'));
      expect(updatedSession.currentIndex, equals(1));
      expect(updatedSession.score, greaterThan(0));
    });

    test('should generate response suggestions', () {
      final turn = ConversationTurn(
        speaker: 'Waiter',
        text: 'What would you like to order?',
        reading: 'Nani ni narimasu ka?',
        translation: 'What would you like to order?',
        audioFile: '',
      );

      final suggestions = conversationService.generateResponseSuggestions(turn);

      expect(suggestions, isNotEmpty);
      expect(suggestions.first, contains('お願'));
    });

    test('should return current turn from session', () async {
      final session = await conversationService.startConversation(
        testConversation,
      );
      final currentTurn = session.currentTurn;

      expect(currentTurn, isNotNull);
      expect(currentTurn!.speaker, equals('Speaker1'));
    });

    test('should detect when conversation is completed', () async {
      // Create a session with no turns remaining
      final completedSession = ConversationSession(
        conversation: testConversation,
        currentIndex: testConversation.turns.length,
        userResponses: [],
        score: 0,
      );

      expect(completedSession.isCompleted, isTrue);
    });
  });

  group('ConversationSession', () {
    late ConversationSession session;
    late Conversation conversation;

    setUp(() {
      conversation = Conversation(
        id: '1',
        title: 'Test',
        scenario: 'Test',
        turns: [
          ConversationTurn(
            speaker: 'Speaker',
            text: 'Hello',
            reading: 'こんにちは',
            translation: 'Hello',
            audioFile: '',
          ),
        ],
        category: 'Test',
        difficulty: 1,
        xpReward: 10,
      );

      session = ConversationSession(
        conversation: conversation,
        currentIndex: 0,
        userResponses: [],
        score: 0,
      );
    });

    test('should calculate progress correctly', () {
      expect(session.progress, equals(0.0));

      final halfCompletedSession = session.copyWith(currentIndex: 1);
      expect(halfCompletedSession.progress, equals(1.0));
    });

    test('should copy with updated values', () {
      final updatedSession = session.copyWith(score: 100);

      expect(updatedSession.score, equals(100));
      expect(updatedSession.conversation, equals(session.conversation));
    });
  });
}
