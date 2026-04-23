import '../models/conversation.dart';
import 'audio_service.dart';

class ConversationService {
  final AudioService audioService;

  ConversationService(this.audioService);

  /// Starts a conversation session
  Future<ConversationSession> startConversation(
    Conversation conversation,
  ) async {
    return ConversationSession(
      conversation: conversation,
      currentIndex: 0,
      userResponses: [],
      score: 0,
    );
  }

  /// Processes user response in conversation
  Future<ConversationSession> processUserResponse(
    ConversationSession session,
    String userResponse,
  ) async {
    // In a real implementation, you would analyze the user's response
    // For now, we'll just record it and move to the next turn

    final newResponses = List<String>.from(session.userResponses);
    newResponses.add(userResponse);

    // Calculate score based on response (simplified)
    final scoreIncrement = _calculateScoreIncrement(userResponse);

    return session.copyWith(
      userResponses: newResponses,
      currentIndex: session.currentIndex + 1,
      score: session.score + scoreIncrement,
    );
  }

  /// Plays audio for current conversation turn
  Future<void> playTurnAudio(ConversationTurn turn) async {
    if (turn.audioFile.isNotEmpty) {
      // In a real implementation, you would play the actual audio file
      // For now, we'll use the audio service to play a sound
      await audioService.playCorrectSound();
    }
  }

  /// Calculates score increment based on user response
  int _calculateScoreIncrement(String response) {
    // Simplified scoring logic
    // In a real implementation, you would analyze the response quality
    if (response.trim().isNotEmpty) {
      return 10; // Base points for providing any response
    }
    return 0; // No points for empty response
  }

  /// Evaluates pronunciation of user response (placeholder)
  Future<PronunciationFeedback> evaluatePronunciation(String response) async {
    // In a real implementation, you would use speech recognition
    // and compare with expected pronunciation
    return PronunciationFeedback(
      score: 0.8, // Placeholder score
      feedback: 'Good effort!',
      improvements: ['Try pronouncing "desu" more clearly'],
    );
  }

  /// Generates response suggestions for user
  List<String> generateResponseSuggestions(ConversationTurn turn) {
    // Generate common responses based on the conversation context
    if (turn.speaker == 'Waiter') {
      return [
        'ラーメンをお願いします', // Ramen please
        'チャーハンをお願いします', // Fried rice please
        '水をお願いします', // Water please
      ];
    } else if (turn.speaker == 'Local') {
      return [
        'ありがとうございます', // Thank you
        '分かりました', // Understood
        'お願いします', // Please
      ];
    }
    return [];
  }
}

class ConversationSession {
  final Conversation conversation;
  final int currentIndex;
  final List<String> userResponses;
  final int score;

  ConversationSession({
    required this.conversation,
    required this.currentIndex,
    required this.userResponses,
    required this.score,
  });

  ConversationSession copyWith({
    Conversation? conversation,
    int? currentIndex,
    List<String>? userResponses,
    int? score,
  }) {
    return ConversationSession(
      conversation: conversation ?? this.conversation,
      currentIndex: currentIndex ?? this.currentIndex,
      userResponses: userResponses ?? this.userResponses,
      score: score ?? this.score,
    );
  }

  /// Gets current conversation turn
  ConversationTurn? get currentTurn {
    if (currentIndex < conversation.turns.length) {
      return conversation.turns[currentIndex];
    }
    return null;
  }

  /// Checks if conversation is completed
  bool get isCompleted => currentIndex >= conversation.turns.length;

  /// Gets conversation progress percentage
  double get progress {
    if (conversation.turns.isEmpty) return 0.0;
    return currentIndex / conversation.turns.length;
  }
}

class PronunciationFeedback {
  final double score;
  final String feedback;
  final List<String> improvements;

  PronunciationFeedback({
    required this.score,
    required this.feedback,
    required this.improvements,
  });
}
