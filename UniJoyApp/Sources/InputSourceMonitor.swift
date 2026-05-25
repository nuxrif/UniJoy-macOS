import SwiftUI
import AppKit
import Carbon

class InputSourceMonitor: ObservableObject {
    @AppStorage("showLanguageOverlay") var overlayEnabled: Bool = true
    
    private var overlayWindow: NSWindow?
    private var hideTimer: Timer?
    private var lastLanguage: String = ""
    
    init() {
        // Detect current language
        lastLanguage = getCurrentLanguage()
    }
    
    func startMonitoring() {
        DistributedNotificationCenter.default().addObserver(
            self,
            selector: #selector(inputSourceChanged),
            name: NSNotification.Name("com.apple.Carbon.TISNotifySelectedKeyboardInputSourceChanged"),
            object: nil
        )
    }
    
    func stopMonitoring() {
        DistributedNotificationCenter.default().removeObserver(self)
    }
    
    func getCurrentLanguage() -> String {
        guard let source = TISCopyCurrentKeyboardInputSource()?.takeRetainedValue(),
              let idPtr = TISGetInputSourceProperty(source, kTISPropertyInputSourceID) else {
            return "En"
        }
        let sourceID = Unmanaged<CFString>.fromOpaque(idPtr).takeUnretainedValue() as String
        
        if sourceID.lowercased().contains("unijoy") ||
           sourceID.lowercased().contains("bangla") ||
           sourceID.lowercased().contains("bengali") ||
           sourceID.lowercased().contains("bn") ||
           sourceID.contains("ইউনিজয়") {
            return "ইউ"
        }
        return "En"
    }
    
    @objc func inputSourceChanged() {
        DispatchQueue.main.async { [weak self] in
            guard let self = self, self.overlayEnabled else { return }
            
            let newLanguage = self.getCurrentLanguage()
            let oldLanguage = self.lastLanguage
            
            guard oldLanguage != newLanguage else { return }
            self.lastLanguage = newLanguage
            
            self.showOverlay(from: oldLanguage, to: newLanguage)
        }
    }
    
    private func showOverlay(from: String, to: String) {
        hideTimer?.invalidate()
        
        if overlayWindow == nil {
            createOverlayWindow()
        }
        
        let hostingView = NSHostingView(rootView: LanguageOverlayView(from: from, to: to))
        hostingView.frame = NSRect(x: 0, y: 0, width: 220, height: 90)
        overlayWindow?.contentView = hostingView
        
        // Center on main screen
        if let screen = NSScreen.main {
            let screenFrame = screen.frame
            let x = screenFrame.midX - 110
            let y = screenFrame.midY - 45
            overlayWindow?.setFrame(NSRect(x: x, y: y, width: 220, height: 90), display: true)
        }
        
        // Show with fade in
        overlayWindow?.alphaValue = 0
        overlayWindow?.orderFront(nil)
        
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.15
            self.overlayWindow?.animator().alphaValue = 1
        }
        
        // Auto hide after 1.2s
        hideTimer = Timer.scheduledTimer(withTimeInterval: 1.2, repeats: false) { [weak self] _ in
            NSAnimationContext.runAnimationGroup({ context in
                context.duration = 0.3
                self?.overlayWindow?.animator().alphaValue = 0
            }) {
                self?.overlayWindow?.orderOut(nil)
            }
        }
    }
    
    private func createOverlayWindow() {
        let panel = NSPanel(
            contentRect: NSRect(x: 0, y: 0, width: 220, height: 90),
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        panel.level = .floating
        panel.isOpaque = false
        panel.backgroundColor = .clear
        panel.hasShadow = true
        panel.ignoresMouseEvents = true
        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        
        overlayWindow = panel
    }
    
    deinit {
        stopMonitoring()
    }
}

struct LanguageOverlayView: View {
    let from: String
    let to: String
    
    var body: some View {
        HStack(spacing: 14) {
            Text(from)
                .font(.system(size: 26, weight: .medium))
                .foregroundColor(.white.opacity(0.5))
            
            Image(systemName: "arrow.right")
                .font(.system(size: 18, weight: .medium))
                .foregroundColor(.white.opacity(0.3))
            
            Text(to)
                .font(.system(size: 26, weight: .bold))
                .foregroundColor(.white)
        }
        .padding(.horizontal, 30)
        .padding(.vertical, 18)
        .background(
            RoundedRectangle(cornerRadius: 14)
                .fill(Color.black.opacity(0.75))
                .shadow(color: .black.opacity(0.4), radius: 20)
        )
    }
}
