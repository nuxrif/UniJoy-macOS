import SwiftUI

struct ContentView: View {
    @StateObject private var layoutManager = KeyboardLayoutManager()
    @AppStorage("hasSeenWelcome") private var hasSeenWelcome = false
    @State private var showWelcome: Bool = false
    @State private var selectedTab: TabItem = .install
    
    enum TabItem: String, CaseIterable {
        case install = "ইনস্টল"
        case keyboard = "কীবোর্ড"
        case conjuncts = "যুক্তবর্ণ"
        case settings = "সেটিংস"
        case help = "সাহায্য"
        
        var icon: String {
            switch self {
            case .install: return "arrow.down.circle"
            case .keyboard: return "keyboard"
            case .conjuncts: return "character.textbox"
            case .settings: return "gearshape"
            case .help: return "questionmark.circle"
            }
        }
    }
    
    var body: some View {
        ZStack {
            HStack(spacing: 0) {
                sidebar
                ZStack {
                    Color(nsColor: NSColor(red: 0.07, green: 0.07, blue: 0.11, alpha: 1.0))
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
                }
            }
            .background(Color(nsColor: NSColor(red: 0.05, green: 0.05, blue: 0.09, alpha: 1.0)))
            .environmentObject(layoutManager)
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
        }
    }
    
    var sidebar: some View {
        VStack(spacing: 0) {
            // App Logo
            VStack(spacing: 8) {
                ZStack {
                    RoundedRectangle(cornerRadius: 16)
                        .fill(LinearGradient(
                            colors: [Color(red: 0.2, green: 0.5, blue: 1.0), Color(red: 0.4, green: 0.2, blue: 0.9)],
                            startPoint: .topLeading, endPoint: .bottomTrailing
                        ))
                        .frame(width: 52, height: 52)
                        .shadow(color: Color(red: 0.3, green: 0.4, blue: 1.0).opacity(0.4), radius: 12, x: 0, y: 4)
                    Text("ক")
                        .font(.system(size: 26, weight: .bold))
                        .foregroundColor(.white)
                }
                Text("UniJoy")
                    .font(.system(size: 15, weight: .bold, design: .rounded))
                    .foregroundColor(.white)
                Text("ইউনিজয় কীবোর্ড")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.white.opacity(0.5))
            }
            .padding(.top, 28)
            .padding(.bottom, 24)
            
            // Status Indicator
            HStack(spacing: 6) {
                Circle()
                    .fill(layoutManager.isInstalled ? Color.green : Color.orange)
                    .frame(width: 7, height: 7)
                    .shadow(color: layoutManager.isInstalled ? Color.green.opacity(0.6) : Color.orange.opacity(0.6), radius: 4)
                Text(layoutManager.isInstalled ? "ইনস্টল করা আছে" : "ইনস্টল নেই")
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(.white.opacity(0.6))
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 6)
            .background(Capsule().fill(Color.white.opacity(0.06)))
            .padding(.bottom, 28)
            
            Rectangle()
                .fill(Color.white.opacity(0.06))
                .frame(height: 1)
                .padding(.horizontal, 20)
            
            VStack(spacing: 4) {
                ForEach(TabItem.allCases, id: \.rawValue) { tab in
                    sidebarButton(tab: tab)
                }
            }
            .padding(.top, 16)
            .padding(.horizontal, 12)
            
            Spacer()
            
            VStack(spacing: 2) {
                Text("v1.0.0")
                    .font(.system(size: 10, weight: .medium, design: .monospaced))
                    .foregroundColor(.white.opacity(0.25))
                Text("by Sharif Ahammad")
                    .font(.system(size: 9))
                    .foregroundColor(.white.opacity(0.2))
            }
            .padding(.bottom, 20)
        }
        .frame(width: 180)
        .background(Color(nsColor: NSColor(red: 0.06, green: 0.06, blue: 0.1, alpha: 1.0)))
    }
    
    func sidebarButton(tab: TabItem) -> some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.2)) { selectedTab = tab }
        }) {
            HStack(spacing: 10) {
                Image(systemName: tab.icon)
                    .font(.system(size: 14, weight: .medium))
                    .frame(width: 20)
                Text(tab.rawValue)
                    .font(.system(size: 13, weight: selectedTab == tab ? .semibold : .regular))
                Spacer()
            }
            .padding(.horizontal, 14)
            .padding(.vertical, 10)
            .foregroundColor(selectedTab == tab ? .white : .white.opacity(0.5))
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(selectedTab == tab ?
                          LinearGradient(
                            colors: [Color(red: 0.2, green: 0.5, blue: 1.0).opacity(0.3), Color(red: 0.4, green: 0.2, blue: 0.9).opacity(0.15)],
                            startPoint: .leading, endPoint: .trailing
                          ) :
                          LinearGradient(colors: [.clear], startPoint: .leading, endPoint: .trailing)
                    )
            )
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                    .stroke(selectedTab == tab ? Color(red: 0.3, green: 0.5, blue: 1.0).opacity(0.3) : .clear, lineWidth: 1)
            )
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}
