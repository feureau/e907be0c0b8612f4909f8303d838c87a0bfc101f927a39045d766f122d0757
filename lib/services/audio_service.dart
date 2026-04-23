import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:dart_melty_soundfont/dart_melty_soundfont.dart';

class AudioService {
  late Synthesizer _synth;
  bool _isInitialized = false;

  // Sound effect mappings
  static const int CORRECT_SOUND = 60; // Middle C
  static const int INCORRECT_SOUND = 55; // F
  static const int ACHIEVEMENT_SOUND = 72; // High C
  static const int STREAK_SOUND = 67; // G

  Future<void> initialize() async {
    try {
      // Load SoundFont from assets
      final sf2Bytes = await _loadSoundFontAsset(
        'assets/soundfonts/default.sf2',
      );

      // Initialize synthesizer from SoundFont bytes.
      _synth = Synthesizer.loadByteData(
        ByteData.sublistView(sf2Bytes),
        SynthesizerSettings(sampleRate: 44100, blockSize: 64),
      );
      _isInitialized = true;
    } catch (e) {
      print('Failed to initialize audio service: $e');
      _isInitialized = false;
    }
  }

  Future<Uint8List> _loadSoundFontAsset(String assetPath) async {
    final data = await rootBundle.load(assetPath);
    return data.buffer.asUint8List(data.offsetInBytes, data.lengthInBytes);
  }

  Future<void> playCorrectSound() async {
    if (!_isInitialized) return;
    await _playNote(CORRECT_SOUND, 0.5, 100);
  }

  Future<void> playIncorrectSound() async {
    if (!_isInitialized) return;
    await _playNote(INCORRECT_SOUND, 0.5, 80);
  }

  Future<void> playAchievementSound() async {
    if (!_isInitialized) return;

    // Play a short melody for achievements
    await _playNote(ACHIEVEMENT_SOUND, 0.2, 100);
    await Future.delayed(const Duration(milliseconds: 100));
    await _playNote(ACHIEVEMENT_SOUND + 4, 0.2, 100);
    await Future.delayed(const Duration(milliseconds: 100));
    await _playNote(ACHIEVEMENT_SOUND + 7, 0.4, 100);
  }

  Future<void> playStreakSound() async {
    if (!_isInitialized) return;

    // Play a rising sequence for streaks
    await _playNote(STREAK_SOUND, 0.15, 90);
    await Future.delayed(const Duration(milliseconds: 50));
    await _playNote(STREAK_SOUND + 2, 0.15, 95);
    await Future.delayed(const Duration(milliseconds: 50));
    await _playNote(STREAK_SOUND + 4, 0.15, 100);
    await Future.delayed(const Duration(milliseconds: 50));
    await _playNote(STREAK_SOUND + 7, 0.3, 110);
  }

  Future<void> playBackgroundMusic() async {
    if (!_isInitialized) return;

    // Generate a simple looping background ambience
    // This would typically be a longer musical piece
    // For simplicity, we'll just loop a chord progression
    await _playChord([60, 64, 67], 1.0, 60); // C major
    await Future.delayed(const Duration(seconds: 2));
    await _playChord([62, 65, 69], 1.0, 55); // D minor
    await Future.delayed(const Duration(seconds: 2));
    await _playChord([64, 67, 71], 1.0, 50); // E minor
    await Future.delayed(const Duration(seconds: 2));
    await _playChord([65, 69, 72], 1.0, 55); // F major
  }

  Future<void> _playNote(int note, double duration, int velocity) async {
    try {
      // Start playing the note
      _synth.noteOn(channel: 0, key: note, velocity: velocity);

      // Wait for the duration
      await Future.delayed(Duration(milliseconds: (duration * 1000).toInt()));

      // Stop playing the note
      _synth.noteOff(channel: 0, key: note);
    } catch (e) {
      print('Error playing note: $e');
    }
  }

  Future<void> _playChord(
    List<int> notes,
    double duration,
    int velocity,
  ) async {
    try {
      // Start playing all notes in the chord
      for (final note in notes) {
        _synth.noteOn(channel: 0, key: note, velocity: velocity);
      }

      // Wait for the duration
      await Future.delayed(Duration(milliseconds: (duration * 1000).toInt()));

      // Stop playing all notes
      for (final note in notes) {
        _synth.noteOff(channel: 0, key: note);
      }
    } catch (e) {
      print('Error playing chord: $e');
    }
  }

  void dispose() {
    if (_isInitialized) {
      // Clean up resources
      _isInitialized = false;
    }
  }
}
