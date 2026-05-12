#!/bin/bash
# DAVClaw APK Build Script (Local)
# This script builds the APK locally without requiring EAS credentials

set -e

echo "=== DAVClaw APK Build Script ==="
echo ""

# Check if Android SDK is installed
if [ -z "$ANDROID_HOME" ]; then
    echo "Error: ANDROID_HOME environment variable not set"
    echo "Please install Android SDK and set ANDROID_HOME"
    exit 1
fi

echo "✓ Android SDK found at: $ANDROID_HOME"

# Check if Node.js is installed
if ! command -v node &> /dev/null; then
    echo "Error: Node.js not found"
    exit 1
fi

echo "✓ Node.js version: $(node --version)"

# Install dependencies
echo ""
echo "Installing dependencies..."
pnpm install --frozen-lockfile

# Build the app
echo ""
echo "Building APK..."
pnpm run build

# Generate APK using Expo
echo ""
echo "Generating APK with Expo..."
npx expo prebuild --clean --platform android

# Build with Gradle
echo ""
echo "Building with Gradle..."
cd android
./gradlew assembleRelease
cd ..

# Move APK to output directory
echo ""
echo "Finalizing APK..."
APK_PATH="android/app/build/outputs/apk/release/app-release.apk"
if [ -f "$APK_PATH" ]; then
    cp "$APK_PATH" "./app.apk"
    echo "✓ APK built successfully: ./app.apk"
    echo ""
    echo "File size: $(du -h ./app.apk | cut -f1)"
else
    echo "Error: APK not found at $APK_PATH"
    exit 1
fi

echo ""
echo "=== Build Complete ==="
echo "You can now install the APK on your Android device:"
echo "  adb install -r ./app.apk"
