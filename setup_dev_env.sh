#!/bin/bash

echo "Setting up e907 development environment..."
echo

# Check if Flutter is installed
if ! command -v flutter &> /dev/null
then
    echo "ERROR: Flutter is not installed or not in PATH"
    echo "Please install Flutter from https://flutter.dev/docs/get-started/install"
    echo
    read -p "Press enter to continue..."
    exit 1
fi

# Check Flutter version
echo "Checking Flutter version..."
flutter --version
echo

# Navigate to project directory
cd e907be0c0b8612f4909f8303d838c87a0bfc101f927a39045d766f122d0757

# Get dependencies
echo "Getting dependencies..."
flutter pub get
if [ $? -ne 0 ]; then
    echo "ERROR: Failed to get dependencies"
    read -p "Press enter to continue..."
    exit 1
fi

echo
echo "Dependencies installed successfully!"
echo

# Generate mocks for testing
echo "Generating mock files..."
flutter pub run build_runner build --delete-conflicting-outputs
if [ $? -ne 0 ]; then
    echo "WARNING: Failed to generate mock files (optional step)"
    echo "Continuing with setup..."
    echo
fi

echo
echo "Development environment setup complete!"
echo
echo "To run the app, execute: flutter run"
echo "To run tests, execute: flutter test"
echo
read -p "Press enter to continue..."