import 'package:flutter/material.dart';
import 'package:riverpod/riverpod.dart';
import 'models/conversation.dart';
import 'models/grammar_exercise.dart';
import 'services/grammar_exercise_service.dart';
import 'providers/user_provider.dart';
import 'providers/progress_provider.dart';
import 'widgets/progress_dashboard.dart';
import 'widgets/flashcard_screen.dart';
import 'widgets/conversation_screen.dart';
import 'widgets/grammar_exercise_screen.dart';

void main() {
  runApp(
    ProviderScope(
      child: MainApp(),
    ),
  );
}

class MainApp extends ConsumerWidget {
  MainApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Initialize user and progress data
    final userAsync = ref.watch(userInitializationProvider);
    final progressAsync = ref.watch(initializeProgressProvider);

    return MaterialApp(
      title: 'e907',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: userAsync.when(
        data: (user) {
          if (user == null) {
            return const Scaffold(
              body: Center(
                child: Text('Error loading user data'),
              ),
            );
          }

          // Update user provider with loaded user
          ref.read(userProvider.notifier).state = user;

          return progressAsync.when(
            data: (progressMap) {
              if (progressMap == null) {
                return const Scaffold(
                  body: Center(
                    child: Text('Error loading progress data'),
                  ),
                );
              }

              // Update progress provider with loaded progress
              ref.read(progressProvider.notifier).state = progressMap;

              return const MainScreen();
            },
            loading: () => const Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            ),
            error: (error, stack) => Scaffold(
              body: Center(
                child: Text('Error loading progress: $error'),
              ),
            ),
          );
        },
        loading: () => const Scaffold(
          body: Center(
            child: CircularProgressIndicator(),
          ),
        ),
        error: (error, stack) => Scaffold(
          body: Center(
            child: Text('Error loading user: $error'),
          ),
        ),
      ),
      routes: {
        '/flashcards': (context) => const FlashcardScreen(),
      },
    );
  }
}

class MainScreen extends ConsumerStatefulWidget {
  const MainScreen({super.key});

  @override
  ConsumerState<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends ConsumerState<MainScreen> {
  int _currentIndex = 0;
  Conversation? _selectedConversation;
  GrammarExercise? _selectedExercise;

  final GrammarExerciseService _grammarService = GrammarExerciseService(null);

  void _onNavigationTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _openConversation(Conversation conversation) {
    setState(() {
      _selectedConversation = conversation;
      _selectedExercise = null;
      _currentIndex = 1;
    });
  }

  void _openExercise(GrammarExercise exercise) {
    setState(() {
      _selectedExercise = exercise;
      _selectedConversation = null;
      _currentIndex = 1;
    });
  }

  Widget _getCurrentPage() {
    switch (_currentIndex) {
      case 0:
        return const ProgressDashboard();
      case 1:
        if (_selectedConversation != null) {
          return ConversationScreen(conversation: _selectedConversation!);
        }
        if (_selectedExercise != null) {
          return GrammarExerciseScreen(exercise: _selectedExercise!);
        }
        return _buildLearnScreen();
      case 2:
        return const ProgressDashboard();
      case 3:
        return const Center(child: Text('Settings Screen'));
      default:
        return const ProgressDashboard();
    }
  }

  Widget _buildLearnScreen() {
    final sampleConversations = Conversation.getSampleConversations();
    final grammarExercises = _grammarService.getAllExercises();

    return Scaffold(
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Learning Modules',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Flashcards',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Card(
              elevation: 4,
              child: ListTile(
                leading: const Icon(Icons.style, color: Colors.blue),
                title: const Text('Vocabulary Practice'),
                subtitle: const Text('Practice common Japanese words'),
                trailing: const Icon(Icons.arrow_forward_ios),
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const FlashcardScreen(),
                    ),
                  );
                },
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Grammar Exercises',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            ...grammarExercises.map((exercise) {
              return Card(
                elevation: 4,
                child: ListTile(
                  leading: const Icon(Icons.edit, color: Colors.purple),
                  title: Text(exercise.title),
                  subtitle: Text('${exercise.questions.length} questions • ${exercise.difficulty} stars'),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => _openExercise(exercise),
                ),
              );
            }).toList(),
            const SizedBox(height: 20),
            const Text(
              'Conversations',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            ...sampleConversations.map((conversation) {
              return Card(
                elevation: 4,
                child: ListTile(
                  leading: const Icon(Icons.chat, color: Colors.green),
                  title: Text(conversation.title),
                  subtitle: Text(conversation.scenario),
                  trailing: const Icon(Icons.arrow_forward_ios),
                  onTap: () => _openConversation(conversation),
                ),
              );
            }).toList(),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('e907'),
        backgroundColor: Theme.of(context).primaryColor,
        foregroundColor: Colors.white,
      ),
      body: _getCurrentPage(),
      bottomNavigationBar: BottomNavigationBar(
        items: const [
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.school),
            label: 'Learn',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.leaderboard),
            label: 'Progress',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.settings),
            label: 'Settings',
          ),
        ],
        currentIndex: _currentIndex,
        onTap: _onNavigationTapped,
      ),
    );
  }
}