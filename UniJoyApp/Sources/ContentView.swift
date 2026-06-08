import SwiftUI

struct ContentView: View {
    @StateObject private var layoutManager = KeyboardLayoutManager()
    @EnvironmentObject var themeManager: ThemeManager
    @AppStorage("hasSeenWelcome") private var hasSeenWelcome = false
    @State private var showWelcome: Bool = false
    @State private var selectedTab: TabItem = .install
    
    var t: TC { TC(isDark: themeManager.isDark) }
    
    enum TabItem: String, CaseIterable {
        case install = "ইনস্টল"
        case keyboard = "কীবোর্ড"
        case conjuncts = "যুক্তবর্ণ"
        case settings = "সেটিংস"
        case help = "সাহায্য"
        
        var icon: String {
            switch self {
            case .install: return "arrow.down.to.line"
            case .keyboard: return "keyboard"
            case .conjuncts: return "chevron.left.forwardslash.chevron.right"
            case .settings: return "gearshape"
            case .help: return "questionmark.circle"
            }
        }
        
        var englishLabel: String {
            switch self {
            case .install: return "Install"
            case .keyboard: return "Keyboard"
            case .conjuncts: return "Conjuncts"
            case .settings: return "Settings"
            case .help: return "Help"
            }
        }
        
        var subtitle: String {
            switch self {
            case .install: return "ওয়ান-ক্লিক অটো ইনস্টল — সবকিছু স্বয়ংক্রিয়!"
            case .keyboard: return "UniJoy কীবোর্ডের সম্পূর্ণ লেআউট"
            case .conjuncts: return "সব যুক্তবর্ণ ও তাদের কী কম্বিনেশন"
            case .settings: return "কীবোর্ড শর্টকাট ও অন্যান্য সেটিংস"
            case .help: return "UniJoy কীবোর্ড ব্যবহারের সম্পূর্ণ গাইড"
            }
        }
        
        var title: String {
            switch self {
            case .install: return "ইনস্টলেশন"
            case .keyboard: return "কীবোর্ড লেআউট"
            case .conjuncts: return "যুক্তবর্ণ চার্ট"
            case .settings: return "সেটিংস"
            case .help: return "সাহায্য ও গাইড"
            }
        }
    }
    
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                sidebar
                VStack(spacing: 0) {
                    topbar
                    ZStack {
                        t.winBg
                        ScrollView {
                            Group {
                                switch selectedTab {
                                case .install:
                                    InstallView(manager: layoutManager, reopenWelcome: {
                                        withAnimation(.easeInOut(duration: 0.5)) { showWelcome = true }
                                    })
                                case .keyboard: KeyboardView()
                                case .conjuncts: ConjunctView()
                                case .settings: SettingsView()
                                case .help: HelpView()
                                }
                            }
                            .transition(.opacity.combined(with: .move(edge: .trailing)))
                            .padding(.horizontal, 24)
                            .padding(.top, 26)
                            .padding(.bottom, 40)
                        }
                    }
                }
            }
            .clipped()
            .background(t.winBg)
            .environmentObject(layoutManager)
            .environmentObject(themeManager)
            .environment(\.layoutDirection, .leftToRight)
            
            if showWelcome {
                WelcomeView(showWelcome: $showWelcome, manager: layoutManager)
                    .transition(.opacity)
                    .zIndex(100)
            }
        }
        .onAppear {
            if !hasSeenWelcome {
                showWelcome = true
                hasSeenWelcome = true
            }
            themeManager.applyAppearance()
        }
    }
    
    // MARK: - Topbar
    var topbar: some View {
        HStack(alignment: .center, spacing: 16) {
            VStack(alignment: .leading, spacing: 3) {
                Text(selectedTab.title)
                    .font(.system(size: 26, weight: .bold))
                    .foregroundColor(t.ink)
                Text(selectedTab.subtitle)
                    .font(.system(size: 14))
                    .foregroundColor(t.inkSoft)
            }
            Spacer()
            Text(selectedTab.englishLabel)
                .font(.system(size: 11.5, weight: .medium, design: .monospaced))
                .foregroundColor(t.inkFaint)
                .padding(.horizontal, 10)
                .padding(.vertical, 5)
                .overlay(
                    RoundedRectangle(cornerRadius: 99)
                        .stroke(t.line, lineWidth: 1)
                )
            Text("v1.0.0")
                .font(.system(size: 11, weight: .medium, design: .monospaced))
                .foregroundColor(t.inkFaint)
            Button(action: {
                withAnimation(.easeInOut(duration: 0.3)) {
                    themeManager.toggle()
                }
            }) {
                Image(systemName: themeManager.isDark ? "moon.fill" : "sun.max.fill")
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(t.inkSoft)
                    .frame(width: 30, height: 30)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(t.panel)
                            .overlay(RoundedRectangle(cornerRadius: 8).stroke(t.line, lineWidth: 1))
                    )
            }
            .buttonStyle(.plain)
        }
        .padding(.horizontal, 34)
        .padding(.top, 20)
        .padding(.bottom, 15)
        .background(t.winBg)
        .overlay(
            Rectangle().fill(t.line).frame(height: 1),
            alignment: .bottom
        )
    }
    
    // MARK: - Sidebar
    var sidebar: some View {
        VStack(spacing: 0) {
            // Brand
            VStack(alignment: .leading, spacing: 7) {
                HStack(spacing: 10) {
                    ZStack {
                        RoundedRectangle(cornerRadius: 8)
                            .fill(t.accent)
                            .frame(width: 30, height: 30)
                            .shadow(color: t.accent.opacity(0.4), radius: 6, x: 0, y: 3)
                        Text("ক")
                            .font(.system(size: 17, weight: .bold))
                            .foregroundColor(t.accentInk)
                    }
                    Text("UniJoy")
                        .font(.system(size: 22, weight: .bold))
                        .foregroundColor(t.ink)
                }
                Text("ইউনিজয় কীবোর্ড")
                    .font(.system(size: 12.5))
                    .foregroundColor(t.inkFaint)
                    .padding(.leading, 1)
            }
            .padding(.horizontal, 10)
            .padding(.top, 6)
            .padding(.bottom, 14)
            
            // Menu label
            Text("মেনু")
                .font(.system(size: 10.5, weight: .medium, design: .monospaced))
                .foregroundColor(t.inkFaint)
                .tracking(1.5)
                .textCase(.uppercase)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 10)
                .padding(.top, 10)
                .padding(.bottom, 6)
            
            // Nav items
            VStack(spacing: 4) {
                ForEach(TabItem.allCases, id: \.rawValue) { tab in
                    sidebarButton(tab: tab)
                }
            }
            
            Spacer()
            
            // Footer
            VStack(alignment: .leading, spacing: 8) {
                Rectangle().fill(t.line).frame(height: 1)
                HStack(spacing: 9) {
                    Circle()
                        .fill(t.good)
                        .frame(width: 8, height: 8)
                        .shadow(color: t.good.opacity(0.3), radius: 4)
                    Text(layoutManager.isInstalled ? "ইনস্টল করা আছে" : "ইনস্টল নেই")
                        .font(.system(size: 12.5))
                        .foregroundColor(t.inkFaint)
                }
                .padding(.top, 4)
                Text("by Sharif Ahammed")
                    .font(.system(size: 11, design: .monospaced))
                    .foregroundColor(t.inkFaint)
                    .padding(.leading, 1)
            }
            .padding(.horizontal, 10)
            .padding(.bottom, 12)
            

        }
        .padding(.horizontal, 14)
        .padding(.top, 18)
        .frame(width: 228)
        .background(t.sidebar)
        .overlay(
            Rectangle().fill(t.line).frame(width: 1),
            alignment: .trailing
        )
    }
    
    func sidebarButton(tab: TabItem) -> some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.2)) { selectedTab = tab }
        }) {
            HStack(spacing: 11) {
                Image(systemName: tab.icon)
                    .font(.system(size: 15, weight: .medium))
                    .frame(width: 19)
                Text(tab.rawValue)
                    .font(.system(size: 15, weight: selectedTab == tab ? .semibold : .medium))
                Spacer()
                if selectedTab == tab {
                    Text("›")
                        .font(.system(size: 16, weight: .medium))
                }
            }
            .padding(.horizontal, 11)
            .padding(.vertical, 9)
            .foregroundColor(selectedTab == tab ? t.accent : t.inkSoft)
            .background(
                RoundedRectangle(cornerRadius: 9)
                    .fill(selectedTab == tab ? t.panel : Color.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 9)
                            .stroke(selectedTab == tab ? t.line : Color.clear, lineWidth: 1)
                    )
                    .shadow(color: selectedTab == tab ? Color.black.opacity(0.04) : Color.clear, radius: 2, y: 1)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
