import SwiftUI

struct InstallView: View {
    @ObservedObject var manager: KeyboardLayoutManager
    @EnvironmentObject var themeManager: ThemeManager
    var reopenWelcome: () -> Void = {}
    
    var t: TC { TC(isDark: themeManager.isDark) }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Status Card
            HStack(spacing: 18) {
                ZStack {
                    RoundedRectangle(cornerRadius: 14)
                        .fill(t.accent)
                        .frame(width: 52, height: 52)
                    Image(systemName: "keyboard")
                        .font(.system(size: 22, weight: .medium))
                        .foregroundColor(t.accentInk)
                }
                VStack(alignment: .leading, spacing: 3) {
                    Text(manager.isInstalled ? "ইনস্টল করা আছে" : "ইনস্টল করা হয়নি")
                        .font(.system(size: 18, weight: .bold))
                        .foregroundColor(t.ink)
                    Text("UniJoy v1.0.0 · ইউনিজয় কীবোর্ড সক্রিয় ও ব্যবহারের জন্য প্রস্তুত")
                        .font(.system(size: 13))
                        .foregroundColor(t.inkSoft)
                }
                Spacer()
                HStack(spacing: 7) {
                    Circle()
                        .fill(manager.isInstalled ? t.good : t.warn)
                        .frame(width: 7, height: 7)
                    Text(manager.isInstalled ? "সক্রিয়" : "নিষ্ক্রিয়")
                        .font(.system(size: 13, weight: .semibold))
                        .foregroundColor(manager.isInstalled ? t.good : t.warn)
                }
            }
            .padding(20)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(t.panel)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(t.line, lineWidth: 1))
            )
            
            // Section: System Status
            sectionHeader("সিস্টেম স্ট্যাটাস", tag: "STATUS")
            
            VStack(spacing: 0) {
                healthRow(icon: "doc.fill", title: "লেআউট ফাইল", status: "ইনস্টল আছে", ok: true)
                Divider().foregroundColor(t.line)
                healthRow(icon: "square.and.pencil", title: "সিস্টেম রেজিস্ট্রেশন", status: "রেজিস্টার্ড", ok: true)
                Divider().foregroundColor(t.line)
                healthRow(icon: "bolt.fill", title: "ইনপুট সোর্স", status: manager.isInputSourceEnabled ? "সক্রিয়" : "নিষ্ক্রিয়", ok: manager.isInputSourceEnabled)
                Divider().foregroundColor(t.line)
                healthRow(icon: "person.crop.circle", title: "Login Items", status: manager.isLoginItemEnabled ? "যোগ আছে" : "যোগ নেই", ok: manager.isLoginItemEnabled)
            }
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(t.panel)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(t.line, lineWidth: 1))
            )
            .clipShape(RoundedRectangle(cornerRadius: 12))
            
            // Action Buttons
            HStack(spacing: 10) {
                if !manager.isInstalled {
                    actionBtn(title: "⚡ ওয়ান-ক্লিক ইনস্টল", style: .accent) { manager.install() }
                } else {
                    actionBtn(title: "ক সুইচ করুন", style: .accent) { manager.switchToBangla() }
                    actionBtn(title: "পুনরায় ইনস্টল", style: .neutral) {
                        manager.uninstall()
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) { manager.install() }
                    }
                    actionBtn(title: "আনইনস্টল", style: .danger) { manager.uninstall() }
                    actionBtn(title: "Settings", style: .ghost) { manager.openKeyboardPreferences() }
                }
            }
            .padding(.top, 18)
            
            // Status Message
            if !manager.statusMessage.isEmpty {
                HStack(alignment: .top, spacing: 10) {
                    if manager.isProcessing {
                        ProgressView()
                            .progressViewStyle(.circular)
                            .scaleEffect(0.6)
                    }
                    Text(manager.statusMessage)
                        .font(.system(size: 13))
                        .foregroundColor(t.inkSoft)
                        .lineSpacing(3)
                }
                .padding(16)
                .frame(maxWidth: .infinity, alignment: .leading)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(t.panel)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(t.line, lineWidth: 1))
                )
                .padding(.top, 14)
                .transition(.opacity.combined(with: .move(edge: .bottom)))
                .animation(.easeInOut, value: manager.statusMessage)
            }
            
            // Section: Auto Steps
            sectionHeader("অটো ইনস্টলে কী হয়?", tag: "AUTO SETUP")
            
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ], spacing: 12) {
                stepItem(number: "১", text: "কীবোর্ড লেআউট ফাইল সিস্টেমে কপি হয়", icon: "doc.fill", done: manager.isInstalled)
                stepItem(number: "২", text: "macOS-এ ইনপুট সোর্স রেজিস্টার হয়", icon: "square.and.pencil", done: manager.isInstalled)
                stepItem(number: "৩", text: "ইউনিজয় কীবোর্ড অটো সক্রিয় হয়", icon: "power", done: manager.isInputSourceEnabled)
                stepItem(number: "৪", text: "মেনু বারে Globe দিয়ে সুইচ করুন!", icon: "globe", done: false)
            }
            .padding(16)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(t.panel)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(t.line, lineWidth: 1))
            )
            
            // Wizard button
            Button(action: reopenWelcome) {
                HStack(spacing: 8) {
                    Image(systemName: "wand.and.stars")
                        .font(.system(size: 13))
                    Text("সেটআপ উইজার্ড আবার দেখুন")
                        .font(.system(size: 14, weight: .medium))
                }
                .foregroundColor(t.inkSoft)
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(t.panel)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(t.line, lineWidth: 1))
                )
            }
            .buttonStyle(.plain)
            .padding(.top, 18)
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
                .padding(.horizontal, 8)
                .padding(.vertical, 2)
                .overlay(
                    RoundedRectangle(cornerRadius: 99)
                        .stroke(t.line, lineWidth: 1)
                )
        }
        .padding(.top, 26)
        .padding(.bottom, 13)
    }
    
    // MARK: - Health Row
    func healthRow(icon: String, title: String, status: String, ok: Bool) -> some View {
        HStack(spacing: 14) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(t.inkFaint)
                .frame(width: 18)
            Text(title)
                .font(.system(size: 14.5, weight: .medium))
                .foregroundColor(t.ink)
            Spacer()
            HStack(spacing: 6) {
                Image(systemName: "checkmark")
                    .font(.system(size: 11, weight: .bold))
                    .foregroundColor(ok ? t.good : t.warn)
                Text(status)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(ok ? t.good : t.warn)
            }
        }
        .padding(.horizontal, 18)
        .padding(.vertical, 14)
    }
    
    // MARK: - Step Item
    func stepItem(number: String, text: String, icon: String, done: Bool) -> some View {
        HStack(spacing: 10) {
            ZStack {
                RoundedRectangle(cornerRadius: 10)
                    .fill(done ? t.accent : t.accentSoft)
                    .frame(width: 30, height: 30)
                if done {
                    Image(systemName: "checkmark")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(t.accentInk)
                } else {
                    Text(number)
                        .font(.system(size: 13, weight: .bold, design: .monospaced))
                        .foregroundColor(t.accent)
                }
            }
            Image(systemName: icon)
                .font(.system(size: 13))
                .foregroundColor(t.inkFaint)
                .frame(width: 16)
            Text(text)
                .font(.system(size: 13))
                .foregroundColor(done ? t.inkFaint : t.inkSoft)
                .lineLimit(2)
                .fixedSize(horizontal: false, vertical: true)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
        .padding(.vertical, 8)
    }
    
    // MARK: - Button Styles
    enum BtnStyle { case accent, neutral, danger, ghost }
    
    func actionBtn(title: String, style: BtnStyle, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 14, weight: .semibold))
                .padding(.horizontal, 16)
                .padding(.vertical, 10)
                .foregroundColor(btnFg(style))
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(btnBg(style))
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(btnBorder(style), lineWidth: 1))
                )
        }
        .buttonStyle(.plain)
        .disabled(manager.isProcessing)
    }
    
    func btnFg(_ s: BtnStyle) -> Color {
        switch s {
        case .accent: return t.accentInk
        case .neutral: return t.inkSoft
        case .danger: return t.danger
        case .ghost: return t.accent
        }
    }
    func btnBg(_ s: BtnStyle) -> Color {
        switch s {
        case .accent: return t.accent
        case .neutral: return t.panel
        case .danger: return t.panel
        case .ghost: return Color.clear
        }
    }
    func btnBorder(_ s: BtnStyle) -> Color {
        switch s {
        case .accent: return t.accent
        case .neutral: return t.line
        case .danger: return t.line
        case .ghost: return t.accent.opacity(0.4)
        }
    }
}
