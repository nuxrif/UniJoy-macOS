import Foundation
import AppKit
import Carbon
import ServiceManagement

class KeyboardLayoutManager: ObservableObject {
    @Published var isInstalled: Bool = false
    @Published var isInputSourceEnabled: Bool = false
    @Published var isLoginItemEnabled: Bool = false
    @Published var statusMessage: String = ""
    @Published var isProcessing: Bool = false
    
    private let keylayoutFileName = "UniJoy.keylayout"
    private let icnsFileName = "UniJoy.icns"
    private let systemKeyboardLayoutsPath = "/Library/Keyboard Layouts"
    private let userKeyboardLayoutsPath: String
    private let inputSourceID = "com.apple.keyboardlayout.বাংলা"
    
    init() {
        self.userKeyboardLayoutsPath = NSHomeDirectory() + "/Library/Keyboard Layouts"
        checkInstallationStatus()
    }
    
    // MARK: - Status Check
    
    func checkInstallationStatus() {
        let systemPath = "\(systemKeyboardLayoutsPath)/\(keylayoutFileName)"
        let userPath = "\(userKeyboardLayoutsPath)/\(keylayoutFileName)"
        isInstalled = FileManager.default.fileExists(atPath: systemPath) || 
                      FileManager.default.fileExists(atPath: userPath)
        
        isInputSourceEnabled = findUniJoyInputSource() != nil
        checkLoginItemStatus()
    }
    
    // MARK: - Login Items
    
    func checkLoginItemStatus() {
        if #available(macOS 13.0, *) {
            isLoginItemEnabled = SMAppService.mainApp.status == .enabled
        }
    }
    
    func enableLoginItem() {
        if #available(macOS 13.0, *) {
            do {
                try SMAppService.mainApp.register()
                isLoginItemEnabled = true
            } catch {
                statusMessage = "Login Item যোগ করতে ব্যর্থ: \(error.localizedDescription)"
            }
        }
    }
    
    func disableLoginItem() {
        if #available(macOS 13.0, *) {
            do {
                try SMAppService.mainApp.unregister()
                isLoginItemEnabled = false
            } catch {
                statusMessage = "Login Item সরাতে ব্যর্থ: \(error.localizedDescription)"
            }
        }
    }
    
    // MARK: - Find Source Files
    
    func getSourcePath(for filename: String) -> String? {
        // Check bundle Resources folder
        let appDir = Bundle.main.bundlePath
        let resourcePath = "\(appDir)/Contents/Resources/\(filename)"
        if FileManager.default.fileExists(atPath: resourcePath) {
            return resourcePath
        }
        // Check bundle main resource path
        if let bundlePath = Bundle.main.path(forResource: (filename as NSString).deletingPathExtension, 
                                              ofType: (filename as NSString).pathExtension) {
            return bundlePath
        }
        // Check alongside the app
        let parentDir = (appDir as NSString).deletingLastPathComponent
        let siblingPath = "\(parentDir)/\(filename)"
        if FileManager.default.fileExists(atPath: siblingPath) {
            return siblingPath
        }
        return nil
    }
    
    // MARK: - Carbon TIS Integration
    
    /// Find the UniJoy/বাংলা input source in the system
    /// Custom .keylayout files get IDs like "com.apple.keyboardlayout.বাংলা"
    /// Built-in Apple keyboards have IDs like "com.apple.keylayout.Bangla-QWERTY"
    /// We must only match the custom one (keyboardlayout, not keylayout)
    private func findUniJoyInputSource() -> TISInputSource? {
        guard let sourceList = TISCreateInputSourceList(nil, true)?.takeRetainedValue() as? [TISInputSource] else {
            return nil
        }
        
        for source in sourceList {
            guard let idPtr = TISGetInputSourceProperty(source, kTISPropertyInputSourceID) else {
                continue
            }
            let sourceID = Unmanaged<CFString>.fromOpaque(idPtr).takeUnretainedValue() as String
            
            // Custom .keylayout files get "keyboardlayout" (with "board") in the ID
            // Built-in Apple ones have "keylayout" (without "board")
            // Skip built-in Apple keyboards entirely
            if sourceID.hasPrefix("com.apple.keylayout.") {
                continue
            }
            
            // Check if this is our custom UniJoy keyboard
            if sourceID.contains("keyboardlayout") && (sourceID.contains("বাংলা") || sourceID.contains("UniJoy")) {
                return source
            }
            
            // Also match by localized name for non-Apple sources
            if let namePtr = TISGetInputSourceProperty(source, kTISPropertyLocalizedName) {
                let name = Unmanaged<CFString>.fromOpaque(namePtr).takeUnretainedValue() as String
                if name == "বাংলা" && !sourceID.hasPrefix("com.apple.") {
                    return source
                }
            }
        }
        return nil
    }
    
    /// Register the keyboard layout directory with the system
    private func registerInputSource(from directoryPath: String) -> Bool {
        let dirURL = URL(fileURLWithPath: directoryPath, isDirectory: true)
        let status = TISRegisterInputSource(dirURL as CFURL)
        if status != noErr {
            print("⚠️ TISRegisterInputSource returned: \(status)")
        }
        return status == noErr
    }
    
    /// Enable the input source so it appears in the keyboard menu
    private func enableInputSource(_ source: TISInputSource) -> Bool {
        let status = TISEnableInputSource(source)
        return status == noErr
    }
    
    /// Select/activate the input source as current keyboard
    private func selectInputSource(_ source: TISInputSource) -> Bool {
        let status = TISSelectInputSource(source)
        return status == noErr
    }
    
    // MARK: - Full Auto Install
    
    func install() {
        isProcessing = true
        statusMessage = "⏳ ইনস্টল হচ্ছে..."
        
        DispatchQueue.global(qos: .userInitiated).async { [weak self] in
            guard let self = self else { return }
            
            // Step 1: Copy files
            let destDir = self.userKeyboardLayoutsPath
            
            do {
                if !FileManager.default.fileExists(atPath: destDir) {
                    try FileManager.default.createDirectory(atPath: destDir, withIntermediateDirectories: true)
                }
            } catch {
                DispatchQueue.main.async {
                    self.installSystemLevel()
                }
                return
            }
            
            let files = [self.keylayoutFileName, self.icnsFileName]
            for file in files {
                guard let sourcePath = self.getSourcePath(for: file) else {
                    DispatchQueue.main.async {
                        self.statusMessage = "❌ \(file) পাওয়া যায়নি! অ্যাপ বান্ডেলে ফাইলটি নেই।"
                        self.isProcessing = false
                    }
                    return
                }
                
                let destPath = "\(destDir)/\(file)"
                do {
                    if FileManager.default.fileExists(atPath: destPath) {
                        try FileManager.default.removeItem(atPath: destPath)
                    }
                    try FileManager.default.copyItem(atPath: sourcePath, toPath: destPath)
                } catch {
                    DispatchQueue.main.async {
                        self.installSystemLevel()
                    }
                    return
                }
            }
            
            DispatchQueue.main.async {
                self.updateStatus("📋 ফাইল কপি হয়েছে, কীবোর্ড রেজিস্টার হচ্ছে...")
            }
            
            // Step 2: Register the input source
            let registered = self.registerInputSource(from: destDir)
            
            // Small delay to let the system pick up the new source
            Thread.sleep(forTimeInterval: 1.0)
            
            // Step 3: Find and enable the input source
            DispatchQueue.main.async {
                self.activateKeyboardLayout(filesInstalledAt: destDir)
            }
        }
    }
    
    private func activateKeyboardLayout(filesInstalledAt destDir: String) {
        // Try to find the newly registered source
        var attempts = 0
        let maxAttempts = 5
        
        func tryActivate() {
            if let source = findUniJoyInputSource() {
                // Enable it
                let enabled = enableInputSource(source)
                
                // Select it as active
                let selected = selectInputSource(source)
                
                isInstalled = true
                isInputSourceEnabled = true
                isProcessing = false
                
                // Auto-add to Login Items
                self.enableLoginItem()
                
                if enabled && selected {
                    statusMessage = "✅ সম্পূর্ণ অটো-ইনস্টল সফল! বাংলা কীবোর্ড এখন সক্রিয়। Login Items এ যোগ হয়েছে।"
                } else if enabled {
                    statusMessage = "✅ কীবোর্ড ইনস্টল ও সক্রিয় হয়েছে! মেনু বারে 🌐 Globe কী দিয়ে সুইচ করুন।"
                } else {
                    statusMessage = "✅ ফাইল ইনস্টল হয়েছে! কীবোর্ড অটো-সক্রিয় করতে লগআউট করে আবার লগইন করুন।"
                }
            } else {
                attempts += 1
                if attempts < maxAttempts {
                    updateStatus("🔄 কীবোর্ড খোঁজা হচ্ছে... (চেষ্টা \(attempts)/\(maxAttempts))")
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        tryActivate()
                    }
                } else {
                    // Fallback — files are installed, just needs logout
                    isInstalled = true
                    isProcessing = false
                    statusMessage = "✅ ফাইল ইনস্টল হয়েছে! সম্পূর্ণ সক্রিয় করতে একবার লগ-আউট করে লগ-ইন করুন, তারপর মেনু বারে বাংলা দেখাবে।"
                }
            }
        }
        
        tryActivate()
    }
    
    func installSystemLevel() {
        guard let keylayoutSource = getSourcePath(for: keylayoutFileName),
              let icnsSource = getSourcePath(for: icnsFileName) else {
            statusMessage = "❌ সোর্স ফাইল পাওয়া যায়নি!"
            isProcessing = false
            return
        }
        
        let script = """
        do shell script "mkdir -p '\(systemKeyboardLayoutsPath)' && cp '\(keylayoutSource)' '\(systemKeyboardLayoutsPath)/\(keylayoutFileName)' && cp '\(icnsSource)' '\(systemKeyboardLayoutsPath)/\(icnsFileName)'" with administrator privileges
        """
        
        var error: NSDictionary?
        if let appleScript = NSAppleScript(source: script) {
            appleScript.executeAndReturnError(&error)
            if let error = error {
                statusMessage = "❌ ইনস্টল ব্যর্থ: \(error[NSAppleScript.errorMessage] ?? "Unknown error")"
                isProcessing = false
                return
            }
        }
        
        updateStatus("📋 ফাইল কপি হয়েছে, কীবোর্ড রেজিস্টার হচ্ছে...")
        
        // Register and activate
        let _ = registerInputSource(from: systemKeyboardLayoutsPath)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) { [weak self] in
            self?.activateKeyboardLayout(filesInstalledAt: self?.systemKeyboardLayoutsPath ?? "")
        }
    }
    
    // MARK: - Uninstall
    
    func uninstall() {
        isProcessing = true
        statusMessage = "⏳ আনইনস্টল হচ্ছে..."
        
        // Step 1: Disable input source first
        if let source = findUniJoyInputSource() {
            TISDisableInputSource(source)
        }
        
        // Step 2: Remove files
        let userKeylayout = "\(userKeyboardLayoutsPath)/\(keylayoutFileName)"
        let userIcns = "\(userKeyboardLayoutsPath)/\(icnsFileName)"
        let sysKeylayout = "\(systemKeyboardLayoutsPath)/\(keylayoutFileName)"
        let sysIcns = "\(systemKeyboardLayoutsPath)/\(icnsFileName)"
        
        var removedSomething = false
        
        // User-level
        for path in [userKeylayout, userIcns] {
            if FileManager.default.fileExists(atPath: path) {
                try? FileManager.default.removeItem(atPath: path)
                removedSomething = true
            }
        }
        
        // System-level (needs admin)
        if FileManager.default.fileExists(atPath: sysKeylayout) || FileManager.default.fileExists(atPath: sysIcns) {
            let script = """
            do shell script "rm -f '\(sysKeylayout)' '\(sysIcns)'" with administrator privileges
            """
            var error: NSDictionary?
            if let appleScript = NSAppleScript(source: script) {
                appleScript.executeAndReturnError(&error)
                if error == nil {
                    removedSomething = true
                }
            }
        }
        
        isInstalled = false
        isInputSourceEnabled = false
        isProcessing = false
        statusMessage = removedSomething ? 
            "✅ সফলভাবে আনইনস্টল হয়েছে! সম্পূর্ণ সরাতে একবার লগ-আউট করুন।" : 
            "ℹ️ কোনো ইনস্টলেশন পাওয়া যায়নি।"
    }
    
    // MARK: - Helpers
    
    private func updateStatus(_ message: String) {
        DispatchQueue.main.async {
            self.statusMessage = message
        }
    }
    
    func openKeyboardPreferences() {
        if let url = URL(string: "x-apple.systempreferences:com.apple.Keyboard-Settings.extension") {
            NSWorkspace.shared.open(url)
        }
    }
    
    func switchToBangla() {
        if let source = findUniJoyInputSource() {
            let _ = selectInputSource(source)
            statusMessage = "✅ বাংলা কীবোর্ড সক্রিয় করা হয়েছে!"
        } else {
            statusMessage = "⚠️ বাংলা কীবোর্ড পাওয়া যায়নি। আগে ইনস্টল করুন।"
        }
    }
}
