# e907 - Japanese Language Learning App

## Overview
e907 is a multi-language learning application with a focus on Japanese. This project implements a comprehensive language learning platform with features including flashcards, grammar exercises, conversation practice, and progress tracking.

## Features Implemented
1. **User Profile Management** - Track user preferences and settings
2. **Progress Tracking** - Monitor learning streaks, experience points, and achievements
3. **Audio Feedback System** - Interactive sound effects using SoundFonts for:
   - Correct/incorrect responses
   - Achievement celebrations
   - Streak maintenance
   - Background ambiance
4. **Data Persistence** - Local database storage using SQLite
5. **State Management** - Using Riverpod for efficient app state handling

## Project Structure
```
lib/
├── models/              # Data models (User, Progress, Vocabulary)
├── providers/           # Riverpod providers for state management
├── services/           # Database and audio services
├── widgets/            # UI components
assets/
├── soundfonts/         # SoundFont files for audio synthesis
```

## Dependencies
- `riverpod` - State management
- `sqflite` - Local database
- `path_provider` - File system access
- `shared_preferences` - Simple data persistence
- `dart_melty_soundfont` - SoundFont-based audio synthesis
- `flutter_pcm_sound` - PCM audio playback
- `fl_chart` - Data visualization

## Setup Instructions
1. Install Flutter SDK from https://flutter.dev/docs/get-started/install
2. Clone this repository
3. Run `flutter pub get` to install dependencies
4. Run `flutter run` to start the application

## Architecture
The app follows a clean architecture pattern with:
- **Models** representing data entities
- **Services** handling business logic and external communication
- **Providers** managing application state with Riverpod
- **Widgets** implementing the user interface

## Audio Features
The audio system uses `dart_melty_soundfont` to synthesize instrument-quality sounds from SoundFont files, providing:
- Immediate feedback for learning activities
- Musical rewards for achievements
- Immersive background ambiance
- Cross-platform compatible audio playback

## Next Steps
- Implement flashcard system with spaced repetition
- Add grammar exercise modules
- Create conversation practice with speech recognition
- Expand vocabulary database with JLPT-level content
- Add social features for community learning