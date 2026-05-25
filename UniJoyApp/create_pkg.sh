#!/bin/bash
set -e

# =============================================================
# UniJoy PKG Installer Creator
# =============================================================

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
BUILD_DIR="$SCRIPT_DIR/build"
APP_NAME="UniJoy"
BUNDLE_PATH="$BUILD_DIR/$APP_NAME.app"
PKG_PATH="$BUILD_DIR/UniJoy-Installer.pkg"
PKG_TEMP="$BUILD_DIR/pkg_temp"
SCRIPTS_DIR="$BUILD_DIR/pkg_scripts"
IDENTIFIER="com.sharifdev.unijoy"
VERSION="1.0.0"

echo "📦 Creating PKG installer..."
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"

# Check if app exists
if [ ! -d "$BUNDLE_PATH" ]; then
    echo "❌ App not found! Run build.sh first."
    exit 1
fi

# Clean previous
rm -rf "$PKG_TEMP" "$SCRIPTS_DIR"
rm -f "$PKG_PATH"
rm -f "$BUILD_DIR/${APP_NAME}-component.pkg"

# Create payload directory
echo "📁 Preparing payload..."
mkdir -p "$PKG_TEMP"
cp -R "$BUNDLE_PATH" "$PKG_TEMP/"

# Create postinstall script (removes quarantine + sets permissions)
echo "📝 Creating install scripts..."
mkdir -p "$SCRIPTS_DIR"
cat > "$SCRIPTS_DIR/postinstall" << 'SCRIPT'
#!/bin/bash
# Remove quarantine flag so Gatekeeper won't block
xattr -cr /Applications/UniJoy.app 2>/dev/null || true

# Ensure proper permissions
chmod -R 755 /Applications/UniJoy.app
chown -R root:wheel /Applications/UniJoy.app

exit 0
SCRIPT
chmod +x "$SCRIPTS_DIR/postinstall"

# Create component plist to prevent relocation
echo "📋 Creating component plist..."
pkgbuild --analyze --root "$PKG_TEMP" "$BUILD_DIR/component.plist"
# Set BundleIsRelocatable to false
/usr/libexec/PlistBuddy -c "Set :0:BundleIsRelocatable false" "$BUILD_DIR/component.plist"

# Build component pkg
echo "🔨 Building component package..."
pkgbuild \
    --root "$PKG_TEMP" \
    --component-plist "$BUILD_DIR/component.plist" \
    --scripts "$SCRIPTS_DIR" \
    --identifier "$IDENTIFIER" \
    --version "$VERSION" \
    --install-location "/Applications" \
    "$BUILD_DIR/${APP_NAME}-component.pkg"

# Create distribution XML for a nicer installer UI
echo "🎨 Creating distribution..."
cat > "$BUILD_DIR/distribution.xml" << DIST
<?xml version="1.0" encoding="utf-8"?>
<installer-gui-script minSpecVersion="2">
    <title>UniJoy — বাংলা কীবোর্ড</title>
    <welcome file="welcome.html" mime-type="text/html"/>
    <conclusion file="conclusion.html" mime-type="text/html"/>
    <options customize="never" require-scripts="false" hostArchitectures="x86_64,arm64"/>
    <domains enable_localSystem="true"/>
    <choices-outline>
        <line choice="default">
            <line choice="$IDENTIFIER"/>
        </line>
    </choices-outline>
    <choice id="default"/>
    <choice id="$IDENTIFIER" visible="false">
        <pkg-ref id="$IDENTIFIER"/>
    </choice>
    <pkg-ref id="$IDENTIFIER" version="$VERSION" onConclusion="none">${APP_NAME}-component.pkg</pkg-ref>
</installer-gui-script>
DIST

# Create welcome HTML
mkdir -p "$BUILD_DIR/pkg_resources"
cat > "$BUILD_DIR/pkg_resources/welcome.html" << 'HTML'
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<style>
    body { font-family: -apple-system, sans-serif; padding: 20px; }
    h1 { font-size: 22px; }
    .bengali { font-size: 16px; margin-top: 6px; }
    .features { margin-top: 18px; padding-left: 20px; }
    .features li { margin: 8px 0; font-size: 14px; }
    .note { margin-top: 22px; font-size: 13px; }
</style>
</head>
<body>
    <h1>UniJoy — বাংলা কীবোর্ড for macOS</h1>
    <p class="bengali">macOS-এ সবচেয়ে সহজ বাংলা লেখার উপায়!</p>
    
    <ul class="features">
        <li>✅ ইউনিজয় লেআউট — ফিক্সড পজিশন বাংলা টাইপিং</li>
        <li>⌨️ ইন্টারেক্টিভ কীবোর্ড ভিউ</li>
        <li>📋 যুক্তবর্ণ চার্ট সহ</li>
        <li>🔍 অক্ষর সার্চ ও লাইভ টাইপিং টেস্ট</li>
    </ul>
    
    <p class="note">ইনস্টলের পর Applications থেকে UniJoy ওপেন করুন এবং "ইনস্টল" বাটনে ক্লিক করুন।</p>
</body>
</html>
HTML

cat > "$BUILD_DIR/pkg_resources/conclusion.html" << 'HTML'
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<style>
    body { font-family: -apple-system, sans-serif; padding: 20px; }
    h1 { font-size: 22px; }
    .steps { margin-top: 16px; }
    .steps li { margin: 8px 0; font-size: 14px; }
</style>
</head>
<body>
    <h1>✅ ইনস্টল সম্পন্ন!</h1>
    
    <ol class="steps">
        <li>Applications থেকে UniJoy ওপেন করুন</li>
        <li>"ইনস্টল ও শুরু করুন" বাটনে ক্লিক করুন</li>
        <li>Globe (🌐) কী চেপে বাংলা ↔ ইংরেজি সুইচ করুন</li>
    </ol>
    
    <p>🎉 এখন থেকে আপনি macOS-এ বাংলা টাইপ করতে পারবেন!</p>
</body>
</html>
HTML

# Build final product pkg
echo "📦 Building final installer..."
productbuild \
    --distribution "$BUILD_DIR/distribution.xml" \
    --resources "$BUILD_DIR/pkg_resources" \
    --package-path "$BUILD_DIR" \
    "$PKG_PATH"

# Clean up temp files
rm -rf "$PKG_TEMP" "$SCRIPTS_DIR"
rm -f "$BUILD_DIR/${APP_NAME}-component.pkg"
rm -f "$BUILD_DIR/distribution.xml"
rm -f "$BUILD_DIR/component.plist"
rm -rf "$BUILD_DIR/pkg_resources"

echo ""
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "✅ PKG installer created successfully!"
echo "📦 Location: $PKG_PATH"
echo ""
PKG_SIZE=$(du -h "$PKG_PATH" | cut -f1)
echo "📦 Size: $PKG_SIZE"
echo ""
echo "🚀 Double-click the PKG to install UniJoy!"
echo "   No Terminal command needed! 🎉"
