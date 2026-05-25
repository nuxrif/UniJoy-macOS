import SwiftUI

struct SettingsView: View {
    @AppStorage("autoSwitchOnLaunch") private var autoSwitchOnLaunch = false
    @AppStorage("showMenuBarIcon") private var showMenuBarIcon = true
    @AppStorage("showLanguageOverlay") private var showLanguageOverlay = true
    @AppStorage("selectedShortcut") private var selectedShortcut = "globe"
    @State private var shortcutStatus: String = ""
    @State private var showStatus: Bool = false
    
    let shortcuts = [
        ("globe", "🌐 Globe Key", "Globe কী দিয়ে সুইচ"),
        ("ctrl_space", "⌃ Space", "Control + Space"),
        ("cmd_space", "⌘ Space", "Command + Space"),
        ("fn", "Fn Key", "Fn কী দিয়ে সুইচ"),
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 6) {
                    Text("সেটিংস")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    Text("কীবোর্ড শর্টকাট ও অন্যান্য সেটিংস")
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.5))
                }
                .padding(.top, 28)
                
                // Keyboard Shortcut Section
                settingsSection(title: "কীবোর্ড সুইচ শর্টকাট", icon: "keyboard") {
                    VStack(spacing: 2) {
                        ForEach(shortcuts, id: \.0) { shortcut in
                            shortcutRow(id: shortcut.0, label: shortcut.1, description: shortcut.2)
                        }
                    }
                    if showStatus {
                        HStack(spacing: 6) {
                            Image(systemName: shortcutStatus.contains("✅") ? "checkmark.circle.fill" : "info.circle.fill")
                                .font(.system(size: 12))
                                .foregroundColor(shortcutStatus.contains("✅") ? .green : Color(red: 0.5, green: 0.7, blue: 1.0))
                            Text(shortcutStatus)
                                .font(.system(size: 11))
                                .foregroundColor(.white.opacity(0.5))
                        }
                        .padding(10)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(RoundedRectangle(cornerRadius: 8).fill(Color.white.opacity(0.04)))
                        .transition(.opacity.combined(with: .move(edge: .top)))
                    }
                }
                
                // General Settings
                settingsSection(title: "সাধারণ সেটিংস", icon: "gearshape.2") {
                    settingsToggle(
                        title: "মেনু বার আইকন দেখান",
                        description: "মেনু বারে কীবোর্ড ইনডিকেটর দেখাবে",
                        icon: "menubar.rectangle",
                        isOn: $showMenuBarIcon
                    )
                    Divider().opacity(0.1)
                    settingsToggle(
                        title: "চালু হলেই ইউনিজয় সক্রিয়",
                        description: "অ্যাপ চালু হলে স্বয়ংক্রিয়ভাবে ইউনিজয় কীবোর্ড সক্রিয় হবে",
                        icon: "power",
                        isOn: $autoSwitchOnLaunch
                    )
                    Divider().opacity(0.1)
                    settingsToggle(
                        title: "ভাষা সুইচ ওভারলে",
                        description: "ভাষা পরিবর্তনে স্ক্রিনে En → ইউ দেখাবে",
                        icon: "rectangle.center.inset.filled",
                        isOn: $showLanguageOverlay
                    )
                }
                
                // System Settings Link
                settingsSection(title: "সিস্টেম সেটিংস", icon: "laptopcomputer") {
                    systemLink(
                        title: "Keyboard Settings খুলুন",
                        description: "Input Sources পরিচালনা করুন",
                        icon: "keyboard",
                        action: {
                            if let url = URL(string: "x-apple.systempreferences:com.apple.Keyboard-Settings.extension") {
                                NSWorkspace.shared.open(url)
                            }
                        }
                    )
                    Divider().opacity(0.1)
                    systemLink(
                        title: "Language & Region খুলুন",
                        description: "ভাষা ও অঞ্চল সেটিংস",
                        icon: "globe",
                        action: {
                            if let url = URL(string: "x-apple.systempreferences:com.apple.Localization-Settings.extension") {
                                NSWorkspace.shared.open(url)
                            }
                        }
                    )
                }
                
                Spacer(minLength: 28)
            }
            .padding(.horizontal, 32)
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Apply Keyboard Shortcut
    
    private func applyShortcut(_ id: String) {
        withAnimation(.easeInOut(duration: 0.15)) { selectedShortcut = id }
        
        var keyCode: Int
        var modifierFlags: Int
        
        switch id {
        case "ctrl_space":
            keyCode = 49; modifierFlags = 262144
        case "cmd_space":
            keyCode = 49; modifierFlags = 1048576
        case "fn":
            keyCode = 63; modifierFlags = 8388608
        case "globe":
            let script = """
            do shell script "defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 61 '<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>32</integer><integer>49</integer><integer>262144</integer></array><key>type</key><string>standard</string></dict></dict>'"
            """
            var error: NSDictionary?
            if let appleScript = NSAppleScript(source: script) {
                appleScript.executeAndReturnError(&error)
            }
            withAnimation(.easeInOut(duration: 0.3)) {
                shortcutStatus = "✅ Globe Key সেট হয়েছে। কার্যকর হতে লগ-আউট করুন।"
                showStatus = true
            }
            autoHideStatus()
            return
        default:
            return
        }
        
        let script = """
        do shell script "defaults write com.apple.symbolichotkeys AppleSymbolicHotKeys -dict-add 61 '<dict><key>enabled</key><true/><key>value</key><dict><key>parameters</key><array><integer>32</integer><integer>\(keyCode)</integer><integer>\(modifierFlags)</integer></array><key>type</key><string>standard</string></dict></dict>'"
        """
        var error: NSDictionary?
        if let appleScript = NSAppleScript(source: script) {
            appleScript.executeAndReturnError(&error)
            if error == nil {
                if id == "fn" {
                    let fnScript = """
                    do shell script "defaults write com.apple.HIToolbox AppleFnUsageType -int 1"
                    """
                    var fnError: NSDictionary?
                    if let fnApple = NSAppleScript(source: fnScript) { fnApple.executeAndReturnError(&fnError) }
                }
                withAnimation(.easeInOut(duration: 0.3)) {
                    let label = shortcuts.first(where: { $0.0 == id })?.1 ?? id
                    shortcutStatus = "✅ \(label) সেট হয়েছে। কার্যকর হতে লগ-আউট করে লগ-ইন করুন।"
                    showStatus = true
                }
            } else {
                withAnimation(.easeInOut(duration: 0.3)) {
                    shortcutStatus = "⚠️ শর্টকাট সেট করতে সমস্যা হয়েছে।"
                    showStatus = true
                }
            }
            autoHideStatus()
        }
    }
    
    private func autoHideStatus() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 6.0) {
            withAnimation(.easeInOut(duration: 0.3)) { showStatus = false }
        }
    }
    
    // MARK: - UI Components
    
    func settingsSection<Content: View>(title: String, icon: String, @ViewBuilder content: () -> Content) -> some View {
        VStack(alignment: .leading, spacing: 14) {
            HStack(spacing: 8) {
                Image(systemName: icon)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(Color(red: 0.5, green: 0.7, blue: 1.0))
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
            }
            VStack(alignment: .leading, spacing: 10) { content() }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.03))
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(Color.white.opacity(0.06), lineWidth: 1))
                )
        }
        .frame(maxWidth: 560)
    }
    
    func shortcutRow(id: String, label: String, description: String) -> some View {
        Button(action: { applyShortcut(id) }) {
            HStack {
                VStack(alignment: .leading, spacing: 2) {
                    Text(label)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                    Text(description)
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.35))
                }
                Spacer()
                ZStack {
                    Circle()
                        .stroke(selectedShortcut == id ? Color(red: 0.3, green: 0.6, blue: 1.0) : Color.white.opacity(0.15), lineWidth: 2)
                        .frame(width: 20, height: 20)
                    if selectedShortcut == id {
                        Circle()
                            .fill(Color(red: 0.3, green: 0.6, blue: 1.0))
                            .frame(width: 12, height: 12)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(selectedShortcut == id ? Color(red: 0.2, green: 0.5, blue: 1.0).opacity(0.08) : Color.clear)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
    
    func settingsToggle(title: String, description: String, icon: String, isOn: Binding<Bool>) -> some View {
        HStack {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(Color(red: 0.5, green: 0.7, blue: 1.0))
                .frame(width: 24)
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(.white.opacity(0.9))
                Text(description)
                    .font(.system(size: 11))
                    .foregroundColor(.white.opacity(0.35))
            }
            Spacer()
            Toggle("", isOn: isOn)
                .toggleStyle(.switch)
                .tint(Color(red: 0.2, green: 0.5, blue: 1.0))
                .scaleEffect(0.8)
        }
    }
    
    func systemLink(title: String, description: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(Color(red: 0.5, green: 0.7, blue: 1.0))
                    .frame(width: 24)
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.white.opacity(0.9))
                    Text(description)
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.35))
                }
                Spacer()
                Image(systemName: "arrow.up.right")
                    .font(.system(size: 11, weight: .medium))
                    .foregroundColor(.white.opacity(0.25))
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
