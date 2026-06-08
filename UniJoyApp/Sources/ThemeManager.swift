import SwiftUI

class ThemeManager: ObservableObject {
    @AppStorage("appTheme") var isDark: Bool = false
    
    func toggle() {
        isDark.toggle()
        applyAppearance()
    }
    
    func applyAppearance() {
        NSApp.appearance = NSAppearance(named: isDark ? .darkAqua : .aqua)
        if let window = NSApplication.shared.windows.first {
            window.appearance = NSAppearance(named: isDark ? .darkAqua : .aqua)
            window.backgroundColor = isDark
                ? NSColor(red: 0.11, green: 0.11, blue: 0.09, alpha: 1.0)
                : NSColor(red: 0.96, green: 0.96, blue: 0.94, alpha: 1.0)
        }
    }
}

// MARK: - Theme Colors
struct TC {
    let isDark: Bool
    
    // Backgrounds
    var winBg: Color { isDark ? Color(red: 0.11, green: 0.11, blue: 0.09) : Color(red: 0.96, green: 0.96, blue: 0.94) }
    var panel: Color { isDark ? Color(red: 0.15, green: 0.14, blue: 0.12) : .white }
    var panel2: Color { isDark ? Color(red: 0.13, green: 0.12, blue: 0.10) : Color(red: 0.95, green: 0.93, blue: 0.91) }
    var sidebar: Color { isDark ? Color(red: 0.13, green: 0.12, blue: 0.10) : Color(red: 0.93, green: 0.91, blue: 0.87) }
    var titlebar: Color { isDark ? Color(red: 0.13, green: 0.12, blue: 0.10) : Color(red: 0.91, green: 0.89, blue: 0.85) }
    
    // Text
    var ink: Color { isDark ? Color(red: 0.95, green: 0.94, blue: 0.91) : Color(red: 0.13, green: 0.13, blue: 0.11) }
    var inkSoft: Color { isDark ? Color(red: 0.66, green: 0.64, blue: 0.60) : Color(red: 0.43, green: 0.42, blue: 0.38) }
    var inkFaint: Color { isDark ? Color(red: 0.46, green: 0.45, blue: 0.42) : Color(red: 0.60, green: 0.59, blue: 0.55) }
    
    // Lines
    var line: Color { isDark ? Color(red: 0.20, green: 0.18, blue: 0.16) : Color(red: 0.89, green: 0.87, blue: 0.82) }
    var lineStrong: Color { isDark ? Color(red: 0.25, green: 0.23, blue: 0.19) : Color(red: 0.82, green: 0.80, blue: 0.75) }
    
    // Accent (Vermilion)
    var accent: Color { isDark ? Color(red: 0.83, green: 0.39, blue: 0.31) : Color(red: 0.75, green: 0.22, blue: 0.17) }
    var accentSoft: Color { isDark ? Color(red: 0.25, green: 0.15, blue: 0.12) : Color(red: 0.96, green: 0.90, blue: 0.88) }
    var accentInk: Color { isDark ? Color(red: 0.11, green: 0.11, blue: 0.09) : .white }
    
    // Status
    var good: Color { isDark ? Color(red: 0.40, green: 0.78, blue: 0.48) : Color(red: 0.20, green: 0.66, blue: 0.33) }
    var goodSoft: Color { isDark ? Color(red: 0.15, green: 0.22, blue: 0.15) : Color(red: 0.90, green: 0.96, blue: 0.90) }
    var warn: Color { isDark ? Color(red: 0.85, green: 0.70, blue: 0.35) : Color(red: 0.70, green: 0.55, blue: 0.20) }
    var warnSoft: Color { isDark ? Color(red: 0.22, green: 0.20, blue: 0.12) : Color(red: 0.96, green: 0.94, blue: 0.88) }
    var danger: Color { isDark ? Color(red: 0.80, green: 0.35, blue: 0.30) : Color(red: 0.65, green: 0.20, blue: 0.15) }
    
    // Keys
    var keyBg: Color { isDark ? Color(red: 0.17, green: 0.17, blue: 0.14) : .white }
    var keyLine: Color { isDark ? Color(red: 0.23, green: 0.21, blue: 0.18) : Color(red: 0.85, green: 0.82, blue: 0.77) }
    var keyShadow: Color { isDark ? Color(red: 0.07, green: 0.07, blue: 0.06) : Color(red: 0.81, green: 0.78, blue: 0.73) }
}
