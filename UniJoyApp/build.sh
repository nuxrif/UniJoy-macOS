#!/bin/bash
set -e

# =============================================================
# UniJoy macOS App Build Script
# =============================================================

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
APP_DIR="$SCRIPT_DIR"
SOURCES_DIR="$APP_DIR/Sources"
RESOURCES_DIR="$APP_DIR/Resources"
BUILD_DIR="$APP_DIR/build"

APP_NAME="UniJoy"
BUNDLE_NAME="$APP_NAME.app"
BUNDLE_PATH="$BUILD_DIR/$BUNDLE_NAME"
EXECUTABLE_PATH="$BUNDLE_PATH/Contents/MacOS/$APP_NAME"

echo "🔨 Building $APP_NAME..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Clean
rm -rf "$BUNDLE_PATH"

# Create app bundle structure
echo "📁 Creating app bundle..."
mkdir -p "$BUNDLE_PATH/Contents/MacOS"
mkdir -p "$BUNDLE_PATH/Contents/Resources"

# Copy Info.plist
cp "$RESOURCES_DIR/Info.plist" "$BUNDLE_PATH/Contents/"

# Copy keyboard layout files into app bundle
echo "📋 Copying keyboard layout files..."
cp "$PROJECT_ROOT/UniJoy.keylayout" "$BUNDLE_PATH/Contents/Resources/"
cp "$PROJECT_ROOT/UniJoy.icns" "$BUNDLE_PATH/Contents/Resources/"

# Also use proper app icon
cp "$RESOURCES_DIR/AppIcon.icns" "$BUNDLE_PATH/Contents/Resources/AppIcon.icns"

# Create PkgInfo
echo "APPL????" > "$BUNDLE_PATH/Contents/PkgInfo"

# Compile Swift sources (Universal Binary: arm64 + x86_64)
echo "⚙️  Compiling Swift sources (Universal Binary)..."
SWIFT_FILES=$(find "$SOURCES_DIR" -name "*.swift" -type f)

# Build for Apple Silicon (arm64)
swiftc \
    -o "${EXECUTABLE_PATH}_arm64" \
    -target arm64-apple-macosx13.0 \
    -sdk $(xcrun --show-sdk-path) \
    -framework SwiftUI \
    -framework AppKit \
    -framework Foundation \
    -parse-as-library \
    $SWIFT_FILES

# Build for Intel (x86_64)
swiftc \
    -o "${EXECUTABLE_PATH}_x86_64" \
    -target x86_64-apple-macosx13.0 \
    -sdk $(xcrun --show-sdk-path) \
    -framework SwiftUI \
    -framework AppKit \
    -framework Foundation \
    -parse-as-library \
    $SWIFT_FILES

# Merge into Universal Binary
lipo -create "${EXECUTABLE_PATH}_arm64" "${EXECUTABLE_PATH}_x86_64" -output "$EXECUTABLE_PATH"
rm -f "${EXECUTABLE_PATH}_arm64" "${EXECUTABLE_PATH}_x86_64"

echo "✅ Compilation successful!"

# Sign the app (ad-hoc)
echo "🔏 Signing app..."
codesign --force --deep --sign - \
    --entitlements "$RESOURCES_DIR/UniJoy.entitlements" \
    "$BUNDLE_PATH"

echo "✅ Build complete: $BUNDLE_PATH"
echo ""

# Quick test
echo "📦 App bundle contents:"
find "$BUNDLE_PATH" -type f | head -15

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "🚀 To run: open '$BUNDLE_PATH'"
echo "📀 To create DMG: ./create_dmg.sh"
