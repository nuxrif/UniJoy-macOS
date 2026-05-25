#!/bin/bash
set -e

# =============================================================
# UniJoy DMG Creator
# =============================================================

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PROJECT_ROOT="$(cd "$SCRIPT_DIR/.." && pwd)"
BUILD_DIR="$SCRIPT_DIR/build"
APP_NAME="UniJoy"
BUNDLE_PATH="$BUILD_DIR/$APP_NAME.app"
DMG_NAME="UniJoy-Installer"
DMG_PATH="$BUILD_DIR/$DMG_NAME.dmg"
DMG_TEMP="$BUILD_DIR/dmg_temp"
VOLUME_NAME="UniJoy বাংলা কীবোর্ড"

echo "📀 Creating DMG installer..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Check if app exists
if [ ! -d "$BUNDLE_PATH" ]; then
    echo "❌ App not found! Run build.sh first."
    exit 1
fi

# Clean previous
rm -rf "$DMG_TEMP"
rm -f "$DMG_PATH"
rm -f "$BUILD_DIR/${DMG_NAME}-temp.dmg"

# Create temp directory
echo "📁 Preparing DMG contents..."
mkdir -p "$DMG_TEMP"

# Copy app
cp -R "$BUNDLE_PATH" "$DMG_TEMP/"

# Create Applications symlink
ln -s /Applications "$DMG_TEMP/Applications"

# Create a README
cat > "$DMG_TEMP/README.txt" << 'EOF'
╔═══════════════════════════════════════════════════╗
║          UniJoy — বাংলা কীবোর্ড for macOS         ║
╠═══════════════════════════════════════════════════╣
║                                                   ║
║  ইনস্টল করতে:                                    ║
║  UniJoy.app কে Applications ফোল্ডারে ড্র্যাগ করুন  ║
║                                                   ║
║  ⚠️  যদি "can't be opened" দেখায়:                 ║
║  Terminal ওপেন করে এই কমান্ড রান করুন:            ║
║  xattr -cr /Applications/UniJoy.app               ║
║                                                   ║
║  অথবা: Right-click > Open > Open ক্লিক করুন       ║
║                                                   ║
║  তারপর অ্যাপ ওপেন করে "ইনস্টল" বাটনে ক্লিক করুন ║
║                                                   ║
║  © 2026 Sharif Ahammad                            ║
╚═══════════════════════════════════════════════════╝
EOF

# Calculate size (in MB, add some padding)
SIZE_KB=$(du -sk "$DMG_TEMP" | cut -f1)
SIZE_MB=$(( (SIZE_KB / 1024) + 10 ))

echo "💿 Creating DMG image (${SIZE_MB}MB)..."

# Create a temporary DMG
hdiutil create \
    -srcfolder "$DMG_TEMP" \
    -volname "$VOLUME_NAME" \
    -fs HFS+ \
    -fsargs "-c c=64,a=16,e=16" \
    -format UDRW \
    -size "${SIZE_MB}m" \
    "$BUILD_DIR/${DMG_NAME}-temp.dmg"

# Mount the temp DMG
echo "🎨 Configuring DMG appearance..."
MOUNT_POINT=$(hdiutil attach -readwrite -noverify -noautoopen "$BUILD_DIR/${DMG_NAME}-temp.dmg" | grep "/Volumes/" | sed 's/.*\/Volumes/\/Volumes/')

# Wait for mount
sleep 2

# Set DMG window appearance via AppleScript
osascript << APPLESCRIPT
tell application "Finder"
    tell disk "$VOLUME_NAME"
        open
        set current view of container window to icon view
        set toolbar visible of container window to false
        set statusbar visible of container window to false
        set the bounds of container window to {200, 120, 780, 480}
        set viewOptions to the icon view options of container window
        set arrangement of viewOptions to not arranged
        set icon size of viewOptions to 96
        set position of item "$APP_NAME.app" of container window to {150, 180}
        set position of item "Applications" of container window to {420, 180}
        set position of item "README.txt" of container window to {290, 320}
        close
        open
        update without registering applications
    end tell
end tell
APPLESCRIPT

# Set background color via .DS_Store settings
sync

# Unmount
echo "📦 Finalizing..."
hdiutil detach "$MOUNT_POINT" -quiet 2>/dev/null || true
sleep 2

# Convert to compressed read-only DMG
hdiutil convert \
    "$BUILD_DIR/${DMG_NAME}-temp.dmg" \
    -format UDZO \
    -imagekey zlib-level=9 \
    -o "$DMG_PATH"

# Clean up
rm -f "$BUILD_DIR/${DMG_NAME}-temp.dmg"
rm -rf "$DMG_TEMP"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ DMG created successfully!"
echo "📀 Location: $DMG_PATH"
echo ""
DMG_SIZE=$(du -h "$DMG_PATH" | cut -f1)
echo "📦 Size: $DMG_SIZE"
echo ""
echo "🚀 Double-click the DMG to install UniJoy!"
