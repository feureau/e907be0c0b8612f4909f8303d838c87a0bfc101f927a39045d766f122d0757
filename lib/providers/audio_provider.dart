import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../services/audio_service.dart';

// Provider for AudioService
final audioServiceProvider = Provider<AudioService>((ref) {
  final audioService = AudioService();
  // Initialize the audio service
  audioService.initialize();
  return audioService;
});

// Provider for playing correct sound
final playCorrectSoundProvider = Provider(
  (ref) => () async {
    final audioService = ref.read(audioServiceProvider);
    await audioService.playCorrectSound();
  },
);

// Provider for playing incorrect sound
final playIncorrectSoundProvider = Provider(
  (ref) => () async {
    final audioService = ref.read(audioServiceProvider);
    await audioService.playIncorrectSound();
  },
);

// Provider for playing achievement sound
final playAchievementSoundProvider = Provider(
  (ref) => () async {
    final audioService = ref.read(audioServiceProvider);
    await audioService.playAchievementSound();
  },
);

// Provider for playing streak sound
final playStreakSoundProvider = Provider(
  (ref) => () async {
    final audioService = ref.read(audioServiceProvider);
    await audioService.playStreakSound();
  },
);

// Provider for playing background music
final playBackgroundMusicProvider = Provider(
  (ref) => () async {
    final audioService = ref.read(audioServiceProvider);
    await audioService.playBackgroundMusic();
  },
);
