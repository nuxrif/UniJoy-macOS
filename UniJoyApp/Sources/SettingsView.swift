import SwiftUI

struct SettingsView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @AppStorage("autoSwitchOnLaunch") private var autoSwitchOnLaunch = false
    @AppStorage("showLanguageOverlay") private var showLanguageOverlay = true
    @AppStorage("selectedShortcut") private var selectedShortcut = "globe"
    
    var t: TC { TC(isDark: themeManager.isDark) }
    
    let shortcuts = [
        ("globe", "🌐 Globe Key", "Globe কী দিয়ে সুইচ"),
        ("ctrl_space", "⌃ Space", "Control + Space"),
        ("cmd_space", "⌘ Space", "Command + Space"),
        ("fn", "Fn Key", "Fn কী দিয়ে সুইচ"),
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Keyboard Shortcut Section
            sectionHeader("কীবোর্ড সুইচ শর্টকাট", tag: "SHORTCUT")
            
            VStack(spacing: 0) {
                ForEach(Array(shortcuts.enumerated()), id: \.1.0) { index, shortcut in
                    if index > 0 { Divider().foregroundColor(t.line) }
                    shortcutRow(id: shortcut.0, label: shortcut.1, description: shortcut.2)
                }
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(t.panel)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(t.line, lineWidth: 1))
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            // Info card — how to set shortcut
            HStack(spacing: 10) {
                Image(systemName: "info.circle.fill")
                    .font(.system(size: 14))
                    .foregroundColor(t.accent)
                VStack(alignment: .leading, spacing: 2) {
                    Text("শর্টকাট পরিবর্তন করতে: System Settings → Keyboard → Keyboard Shortcuts → Input Sources")
                        .font(.system(size: 12))
                        .foregroundColor(t.inkSoft)
                }
                Spacer()
                Button(action: {
                    if let url = URL(string: "x-apple.systempreferences:com.apple.Keyboard-Settings.extension") {
                        NSWorkspace.shared.open(url)
                    }
                }) {
                    Text("খুলুন ↗")
                        .font(.system(size: 12, weight: .semibold))
                        .foregroundColor(t.accent)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 6)
                        .background(
                            RoundedRectangle(cornerRadius: 8)
                                .fill(t.accentSoft)
                        )
                }
                .buttonStyle(.plain)
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(t.panel2)
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(t.line, lineWidth: 1))
            )
            .padding(.top, 10)
            
            // General Settings
            sectionHeader("সাধারণ সেটিংস", tag: "GENERAL")
            
            VStack(spacing: 0) {
                settingsToggle(
                    title: "চালু হলেই ইউনিজয় সক্রিয়",
                    description: "অ্যাপ চালু হলে স্বয়ংক্রিয়ভাবে ইউনিজয় কীবোর্ড সক্রিয় হবে",
                    icon: "power",
                    isOn: $autoSwitchOnLaunch
                )
                Divider().foregroundColor(t.line)
                settingsToggle(
                    title: "ভাষা সুইচ ওভারলে",
                    description: "ভাষা পরিবর্তনে স্ক্রিনে En → ইউ দেখাবে",
                    icon: "rectangle.center.inset.filled",
                    isOn: $showLanguageOverlay
                )
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(t.panel)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(t.line, lineWidth: 1))
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            // System Settings
            sectionHeader("সিস্টেম সেটিংস", tag: "SYSTEM")
            
            VStack(spacing: 0) {
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
                Divider().foregroundColor(t.line)
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
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(t.panel)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(t.line, lineWidth: 1))
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Section Header
    func sectionHeader(_ title: String, tag: String) -> some View {
        HStack(spacing: 9) {
            Text(title)
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(t.ink)
            Spacer()
            Text(tag)
                .font(.system(size: 10.5, weight: .medium, design: .monospaced))
                .foregroundColor(t.inkFaint)
                .padding(.horizontal, 8).padding(.vertical, 2)
                .overlay(RoundedRectangle(cornerRadius: 99).stroke(t.line, lineWidth: 1))
        }
        .padding(.top, 26)
        .padding(.bottom, 13)
    }
    
    // MARK: - UI Components
    func shortcutRow(id: String, label: String, description: String) -> some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.15)) { selectedShortcut = id }
            // Open System Settings for the user to set the shortcut
            if let url = URL(string: "x-apple.systempreferences:com.apple.Keyboard-Settings.extension") {
                NSWorkspace.shared.open(url)
            }
        }) {
            HStack(spacing: 16) {
                VStack(alignment: .leading, spacing: 2) {
                    Text(label)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(t.ink)
                    Text(description)
                        .font(.system(size: 13))
                        .foregroundColor(t.inkSoft)
                }
                Spacer()
                ZStack {
                    Circle()
                        .stroke(selectedShortcut == id ? t.accent : t.lineStrong, lineWidth: 2)
                        .frame(width: 20, height: 20)
                    if selectedShortcut == id {
                        Circle()
                            .fill(t.accent)
                            .frame(width: 11, height: 11)
                    }
                }
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 15)
            .background(selectedShortcut == id ? t.accentSoft : Color.clear)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
    
    func settingsToggle(title: String, description: String, icon: String, isOn: Binding<Bool>) -> some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 9)
                    .fill(t.accentSoft)
                    .frame(width: 34, height: 34)
                Image(systemName: icon)
                    .font(.system(size: 14))
                    .foregroundColor(t.accent)
            }
            VStack(alignment: .leading, spacing: 2) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(t.ink)
                Text(description)
                    .font(.system(size: 13))
                    .foregroundColor(t.inkSoft)
            }
            Spacer()
            Toggle("", isOn: isOn)
                .toggleStyle(.switch)
                .tint(t.accent)
                .scaleEffect(0.8)
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 15)
    }
    
    func systemLink(title: String, description: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 16) {
                ZStack {
                    RoundedRectangle(cornerRadius: 9)
                        .fill(t.accentSoft)
                        .frame(width: 34, height: 34)
                    Image(systemName: icon)
                        .font(.system(size: 14))
                        .foregroundColor(t.accent)
                }
                VStack(alignment: .leading, spacing: 2) {
                    Text(title)
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(t.ink)
                    Text(description)
                        .font(.system(size: 13))
                        .foregroundColor(t.inkSoft)
                }
                Spacer()
                Text("↗")
                    .font(.system(size: 14, design: .monospaced))
                    .foregroundColor(t.inkFaint)
            }
            .padding(.horizontal, 18)
            .padding(.vertical, 15)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
