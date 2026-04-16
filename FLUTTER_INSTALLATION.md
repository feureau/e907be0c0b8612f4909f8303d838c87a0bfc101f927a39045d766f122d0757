# Flutter Installation Guide for Windows

## Quick Download Links

### Latest Stable Version (Flutter 3.41 - February 2026)
- **Windows x64**: https://storage.googleapis.com/flutter_infra_release/releases/stable/windows/flutter_windows_3.41.5-stable.zip

### Alternative: Get from VS Code (Easiest Option)
1. Download VS Code from: https://code.visualstudio.com
2. Install VS Code
3. Open VS Code → Extensions (Ctrl+Shift+X)
4. Search "Flutter" → Click "Install"
5. VS Code will prompt you to download Flutter SDK automatically

---

## Step-by-Step Installation

### Step 1: Download Flutter SDK
1. Click the download link above
2. Or go to: https://docs.flutter.dev/get-started/install/windows
3. Download the Windows ZIP file

### Step 2: Extract the ZIP
1. Create a folder: `C:\flutter` (or `C:\dev\flutter`)
2. Right-click the downloaded ZIP → "Extract All"
3. Select your new folder as destination

### Step 3: Add to Windows PATH
1. Press **Windows key** → type "env" → Press Enter
2. Click "Edit the system environment variables"
3. Click "Environment Variables" button
4. Under "User variables" (top section), find "Path" → Double-click
5. Click "New" → Add: `C:\flutter\bin` (or your custom path)
6. Click OK on all dialogs

### Step 4: Verify Installation
Open a **new** PowerShell or Command Prompt and run:
```powershell
flutter --version
```

You should see:
```
Flutter 3.41.x • channel stable • https://github.com/flutter/flutter.git
Dart 3.x.x
```

### Step 5: Run Setup
```powershell
flutter doctor
flutter pub get
```

---

## Optional: Install Android Studio (for Android apps)

1. Download: https://developer.android.com/studio
2. Install with default settings
3. Run: `flutter doctor --android-licenses`
4. Accept all licenses

---

## Quick Start Commands

In your project folder (`e907be0c0b8612f4909f8303d838c87a0bfc101f927a39045d766f122d0757`):

```powershell
# Install dependencies
flutter pub get

# Run app
flutter run

# Run tests
flutter test

# Build debug APK
flutter build apk --debug
```