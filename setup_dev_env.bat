@echo off
echo Setting up Turbolingo development environment...
echo.

REM Check if Flutter is installed
where flutter >nul 2>&1
if %errorlevel% neq 0 (
    echo ERROR: Flutter is not installed or not in PATH
    echo Please install Flutter from https://flutter.dev/docs/get-started/install
    echo.
    pause
    exit /b 1
)

REM Check Flutter version
echo Checking Flutter version...
flutter --version
echo.

REM Navigate to project directory
cd e907be0c0b8612f4909f8303d838c87a0bfc101f927a39045d766f122d0757

REM Get dependencies
echo Getting dependencies...
flutter pub get
if %errorlevel% neq 0 (
    echo ERROR: Failed to get dependencies
    pause
    exit /b 1
)

echo.
echo Dependencies installed successfully!
echo.

REM Generate mocks for testing
echo Generating mock files...
flutter pub run build_runner build --delete-conflicting-outputs
if %errorlevel% neq 0 (
    echo WARNING: Failed to generate mock files (optional step)
    echo Continuing with setup...
    echo.
)

echo.
echo Development environment setup complete!
echo.
echo To run the app, execute: flutter run
echo To run tests, execute: flutter test
echo.
pause