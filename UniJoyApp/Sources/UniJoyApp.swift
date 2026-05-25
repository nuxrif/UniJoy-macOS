import SwiftUI
import AppKit

@main
struct UniJoyApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    
    var body: some Scene {
        WindowGroup {
            ContentView()
                .frame(width: 1060, height: 860)
                .preferredColorScheme(.dark)
        }
        .windowStyle(.titleBar)
        .windowResizability(.contentSize)
        .defaultSize(width: 1060, height: 860)
    }
}

class AppDelegate: NSObject, NSApplicationDelegate {
    var inputMonitor: InputSourceMonitor?
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Always dark mode
        NSApp.appearance = NSAppearance(named: .darkAqua)
        
        // Force scrollbars to always show
        UserDefaults.standard.set("Always", forKey: "AppleShowScrollBars")
        NotificationCenter.default.post(name: UserDefaults.didChangeNotification, object: nil)
        
        // Center window and fix size
        DispatchQueue.main.async {
            if let window = NSApplication.shared.windows.first {
                window.center()
                window.title = "UniJoy — ইউনিজয় কীবোর্ড"
                window.appearance = NSAppearance(named: .darkAqua)
                window.titlebarAppearsTransparent = true
                window.backgroundColor = NSColor(red: 0.05, green: 0.05, blue: 0.09, alpha: 1.0)
                window.styleMask.remove(.resizable)
                let size = NSSize(width: 1060, height: 860)
                window.setContentSize(size)
                window.minSize = size
                window.maxSize = size
            }
        }
        
        // Start language switch overlay monitor
        inputMonitor = InputSourceMonitor()
        inputMonitor?.startMonitoring()
    }
    
    func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
        return true
    }
}

// MARK: - Translations Dictionary (kept for compatibility, not used in UI)
let translations: [String: String] = [:]
