import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../models/conversation.dart';
import '../services/conversation_service.dart';
import '../providers/audio_provider.dart';
import '../providers/progress_provider.dart';
import '../utils/constants.dart';

class ConversationScreen extends ConsumerStatefulWidget {
  final Conversation conversation;

  const ConversationScreen({super.key, required this.conversation});

  @override
  ConsumerState<ConversationScreen> createState() => _ConversationScreenState();
}

class _ConversationScreenState extends ConsumerState<ConversationScreen> {
  late ConversationService _conversationService;
  ConversationSession? _session;
  final TextEditingController _responseController = TextEditingController();
  bool _isProcessing = false;
  String _feedbackMessage = '';
  List<String> _responseSuggestions = [];

  @override
  void initState() {
    super.initState();
    _conversationService = ConversationService(ref.read(audioServiceProvider));
    _startConversation();
  }

  Future<void> _startConversation() async {
    setState(() {
      _isProcessing = true;
    });

    final session = await _conversationService.startConversation(
      widget.conversation,
    );
    if (!mounted) {
      return;
    }
    _session = session;
    _updateResponseSuggestions();

    setState(() {
      _isProcessing = false;
    });
  }

  void _updateResponseSuggestions() {
    final session = _session;
    if (session == null) {
      _responseSuggestions = [];
      return;
    }
    final currentTurn = session.currentTurn;
    if (currentTurn != null) {
      _responseSuggestions = _conversationService.generateResponseSuggestions(
        currentTurn,
      );
    } else {
      _responseSuggestions = [];
    }
  }

  Future<void> _submitResponse() async {
    final session = _session;
    if (session == null) return;

    final response = _responseController.text.trim();
    if (response.isEmpty) return;

    setState(() {
      _isProcessing = true;
    });

    // Process the user response
    _session = await _conversationService.processUserResponse(
      session,
      response,
    );

    // Play audio for the next turn if available
    final updatedSession = _session;
    final nextTurn = updatedSession?.currentTurn;
    if (nextTurn != null && !nextTurn.isUserResponse) {
      await _conversationService.playTurnAudio(nextTurn);
    }

    // Update suggestions for next response
    _updateResponseSuggestions();

    // Provide feedback
    setState(() {
      _feedbackMessage = 'Thanks for your response!';
      _responseController.clear();
      _isProcessing = false;
    });

    // Add delay for feedback visibility
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) {
      return;
    }
    setState(() {
      _feedbackMessage = '';
    });

    // Check if conversation is completed
    if (_session?.isCompleted ?? false) {
      await _completeConversation();
    }
  }

  Future<void> _completeConversation() async {
    await ref.read(addXPProvider)(
      AppConstants.defaultLanguage,
      widget.conversation.xpReward,
      'Conversation',
    );

    // Show completion dialog
    if (mounted) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: const Text('Conversation Complete!'),
            content: Text(
              'Great job! You earned ${widget.conversation.xpReward} XP.',
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  // Navigate back to previous screen
                  Navigator.of(context).pop();
                },
                child: const Text('Continue'),
              ),
            ],
          );
        },
      );
    }
  }

  void _useSuggestion(String suggestion) {
    _responseController.text = suggestion;
  }

  @override
  void dispose() {
    _responseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final session = _session;
    if (session == null) {
      return Scaffold(
        appBar: AppBar(
          title: Text(widget.conversation.title),
          backgroundColor: Theme.of(context).primaryColor,
          foregroundColor: Colors.white,
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    final currentTurn = session.currentTurn;

    return Scaffold(
      appBar: AppBar(
        title: Text(widget.conversation.title),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
        actions: [
          IconButton(
            icon: const Icon(Icons.volume_up),
            onPressed: () {
              if (currentTurn != null && !currentTurn.isUserResponse) {
                _conversationService.playTurnAudio(currentTurn);
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // Progress indicator
          LinearProgressIndicator(
            value: session.progress,
            backgroundColor: Colors.grey[300],
            valueColor: const AlwaysStoppedAnimation<Color>(Colors.blue),
          ),

          // Conversation log
          Expanded(
            child: ListView(
              padding: const EdgeInsets.all(16.0),
              children: [
                // Scenario description
                Card(
                  elevation: 2,
                  child: Padding(
                    padding: const EdgeInsets.all(12.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'Scenario: ${widget.conversation.scenario}',
                          style: const TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 10),

                // Conversation turns
                ..._buildConversationLog(),

                // Feedback message
                if (_feedbackMessage.isNotEmpty)
                  Card(
                    color: Colors.green[100],
                    child: Padding(
                      padding: const EdgeInsets.all(12.0),
                      child: Text(
                        _feedbackMessage,
                        style: const TextStyle(color: Colors.green),
                      ),
                    ),
                  ),
              ],
            ),
          ),

          // Response input area
          if (!session.isCompleted) ...[
            // Response suggestions
            if (_responseSuggestions.isNotEmpty)
              Container(
                height: 40,
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: _responseSuggestions.map((suggestion) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8.0),
                      child: ElevatedButton(
                        onPressed: () => _useSuggestion(suggestion),
                        child: Text(
                          suggestion,
                          style: const TextStyle(fontSize: 12),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),

            // Input field
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _responseController,
                      decoration: const InputDecoration(
                        hintText: 'Type your response...',
                        border: OutlineInputBorder(),
                      ),
                      onSubmitted: (_) => _submitResponse(),
                      enabled: !_isProcessing,
                    ),
                  ),
                  const SizedBox(width: 10),
                  IconButton(
                    icon: _isProcessing
                        ? const CircularProgressIndicator()
                        : const Icon(Icons.send),
                    onPressed: _isProcessing ? null : _submitResponse,
                  ),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }

  List<Widget> _buildConversationLog() {
    final session = _session;
    if (session == null) {
      return const <Widget>[];
    }

    final widgets = <Widget>[];

    // Show previous turns
    for (int i = 0; i < session.currentIndex; i++) {
      final turn = session.conversation.turns[i];
      final isUserTurn = turn.isUserResponse;
      final userResponse = i ~/ 2 < session.userResponses.length
          ? session.userResponses[i ~/ 2]
          : '';

      if (isUserTurn) {
        widgets.add(_buildUserMessage(userResponse));
      } else {
        widgets.add(_buildSpeakerMessage(turn));
      }
    }

    // Show current turn if it's the speaker's turn
    final currentTurn = session.currentTurn;
    if (currentTurn != null && !currentTurn.isUserResponse) {
      widgets.add(_buildSpeakerMessage(currentTurn));
    }

    return widgets;
  }

  Widget _buildSpeakerMessage(ConversationTurn turn) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Colors.grey[200],
          borderRadius: BorderRadius.circular(12),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '${turn.speaker}: ${turn.text}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            if (turn.reading.isNotEmpty) ...[
              const SizedBox(height: 4),
              Text(
                '(${turn.reading})',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
            ],
            const SizedBox(height: 4),
            Text(turn.translation, style: const TextStyle(color: Colors.grey)),
          ],
        ),
      ),
    );
  }

  Widget _buildUserMessage(String response) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(vertical: 4.0),
        padding: const EdgeInsets.all(12.0),
        decoration: BoxDecoration(
          color: Theme.of(context).primaryColor,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(response, style: const TextStyle(color: Colors.white)),
      ),
    );
  }
}
