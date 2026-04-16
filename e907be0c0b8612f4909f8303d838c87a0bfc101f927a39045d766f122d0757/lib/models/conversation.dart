class Conversation {
  final String id;
  final String title;
  final String scenario;
  final List<ConversationTurn> turns;
  final String category;
  final int difficulty;
  final int xpReward;

  Conversation({
    required this.id,
    required this.title,
    required this.scenario,
    required this.turns,
    required this.category,
    required this.difficulty,
    required this.xpReward,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'scenario': scenario,
      'turns': turns.map((turn) => turn.toJson()).toList(),
      'category': category,
      'difficulty': difficulty,
      'xpReward': xpReward,
    };
  }

  factory Conversation.fromJson(Map<String, dynamic> json) {
    return Conversation(
      id: json['id'] as String,
      title: json['title'] as String,
      scenario: json['scenario'] as String,
      turns: (json['turns'] as List)
          .map((turn) => ConversationTurn.fromJson(turn))
          .toList(),
      category: json['category'] as String,
      difficulty: json['difficulty'] as int,
      xpReward: json['xpReward'] as int,
    );
  }

  // Sample conversation data
  static List<Conversation> getSampleConversations() {
    return [
      Conversation(
        id: '1',
        title: 'Ordering Food',
        scenario: 'You are at a restaurant and want to order food',
        turns: [
          ConversationTurn(
            speaker: 'Waiter',
            text: 'いらっしゃいませ！何になさいますか？',
            reading: 'Irasshaimase! Nani ni narimasu ka?',
            translation: 'Welcome! What would you like to order?',
            audioFile: 'waiter_greeting.mp3',
          ),
          ConversationTurn(
            speaker: 'You',
            text: '',
            reading: '',
            translation: 'I\'ll have the ramen please',
            audioFile: '',
            isUserResponse: true,
          ),
          ConversationTurn(
            speaker: 'Waiter',
            text: 'ラーメンですね。スープはどんなのがお好きですか？',
            reading: 'Ramen desu ne. Suupu wa donna no ga osuki desu ka?',
            translation: 'Ramen it is. What kind of soup do you like?',
            audioFile: 'waiter_question.mp3',
          ),
          ConversationTurn(
            speaker: 'You',
            text: '',
            reading: '',
            translation: 'I like miso soup',
            audioFile: '',
            isUserResponse: true,
          ),
          ConversationTurn(
            speaker: 'Waiter',
            text: '了解です。まことにありがとうございます。',
            reading: 'Ryoukai desu. Maitaku ni arigatou gozaimasu.',
            translation: 'Understood. Thank you very much.',
            audioFile: 'waiter_thanks.mp3',
          ),
        ],
        category: 'Restaurant',
        difficulty: 2,
        xpReward: 50,
      ),
      Conversation(
        id: '2',
        title: 'Asking for Directions',
        scenario: 'You are lost and need to ask for directions',
        turns: [
          ConversationTurn(
            speaker: 'You',
            text: '',
            reading: '',
            translation: 'Excuse me, where is the train station?',
            audioFile: '',
            isUserResponse: true,
          ),
          ConversationTurn(
            speaker: 'Local',
            text: '駅ですか？あの角を左に曲がってください。',
            reading: 'Eki desu ka? Ano kado wo hidari ni magatte kudasai.',
            translation: 'The train station? Please turn left at that corner.',
            audioFile: 'local_directions.mp3',
          ),
          ConversationTurn(
            speaker: 'You',
            text: '',
            reading: '',
            translation: 'Thank you very much',
            audioFile: '',
            isUserResponse: true,
          ),
          ConversationTurn(
            speaker: 'Local',
            text: 'どういたしまして。気をつけて行ってらっしゃい。',
            reading: 'Dou itashimashite. Ki wo tsukete itterasshai.',
            translation: 'You\'re welcome. Please be careful.',
            audioFile: 'local_farewell.mp3',
          ),
        ],
        category: 'Travel',
        difficulty: 1,
        xpReward: 30,
      ),
    ];
  }
}

class ConversationTurn {
  final String speaker;
  final String text;
  final String reading;
  final String translation;
  final String audioFile;
  final bool isUserResponse;

  ConversationTurn({
    required this.speaker,
    required this.text,
    required this.reading,
    required this.translation,
    required this.audioFile,
    this.isUserResponse = false,
  });

  Map<String, dynamic> toJson() {
    return {
      'speaker': speaker,
      'text': text,
      'reading': reading,
      'translation': translation,
      'audioFile': audioFile,
      'isUserResponse': isUserResponse,
    };
  }

  factory ConversationTurn.fromJson(Map<String, dynamic> json) {
    return ConversationTurn(
      speaker: json['speaker'] as String,
      text: json['text'] as String,
      reading: json['reading'] as String,
      translation: json['translation'] as String,
      audioFile: json['audioFile'] as String,
      isUserResponse: json['isUserResponse'] as bool? ?? false,
    );
  }
}