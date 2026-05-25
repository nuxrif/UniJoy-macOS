import SwiftUI

struct KeyboardView: View {
    @State private var showShift: Bool = false
    @State private var hoveredKey: String? = nil
    @State private var pressedKey: String? = nil
    @State private var testText: String = ""
    @State private var searchQuery: String = ""
    @State private var highlightedKeys: Set<String> = []
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 6) {
                    Text("কীবোর্ড লেআউট")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("UniJoy কীবোর্ডের সম্পূর্ণ লেআউট")
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.5))
                }
                .padding(.top, 24)
                
                // Search + Toggle Row
                HStack(spacing: 12) {
                    // Search
                    HStack(spacing: 8) {
                        Image(systemName: "magnifyingglass")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.3))
                        
                        TextField("অক্ষর খুঁজুন (যেমন: ক, খ)...", text: $searchQuery)
                            .textFieldStyle(.plain)
                            .font(.system(size: 12))
                            .foregroundColor(.white)
                            .onChange(of: searchQuery) { newValue in
                                updateHighlightedKeys(for: newValue)
                            }
                        
                        if !searchQuery.isEmpty {
                            Button(action: {
                                searchQuery = ""
                                highlightedKeys.removeAll()
                            }) {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.system(size: 12))
                                    .foregroundColor(.white.opacity(0.3))
                            }
                            .buttonStyle(.plain)
                        }
                    }
                    .padding(.horizontal, 10)
                    .padding(.vertical, 7)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white.opacity(0.06))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.white.opacity(0.08), lineWidth: 1)
                            )
                    )
                    .frame(maxWidth: 280)
                    
                    // Toggle
                    HStack(spacing: 0) {
                        toggleButton(title: "Normal", isActive: !showShift) {
                            withAnimation(.easeInOut(duration: 0.2)) { showShift = false }
                        }
                        toggleButton(title: "Shift ⇧", isActive: showShift) {
                            withAnimation(.easeInOut(duration: 0.2)) { showShift = true }
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white.opacity(0.06))
                    )
                    .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                
                // Keyboard
                VStack(spacing: 6) {
                    // Number Row
                    keyRow(keys: KeyboardLayoutData.numberRow, keyWidth: 48)
                    
                    // Top Row (QWERTY)
                    HStack(spacing: 5) {
                        specialKey(label: "Tab", width: 62)
                        ForEach(Array(KeyboardLayoutData.topRow.enumerated()), id: \.offset) { _, key in
                            keyButton(
                                topLabel: showShift ? key.shiftKey : key.key,
                                mainLabel: showShift ? key.shift : key.normal,
                                keyId: key.key
                            )
                        }
                    }
                    
                    // Home Row (ASDF)
                    HStack(spacing: 5) {
                        specialKey(label: "Caps", width: 76)
                        ForEach(Array(KeyboardLayoutData.homeRow.enumerated()), id: \.offset) { _, key in
                            keyButton(
                                topLabel: showShift ? key.shiftKey : key.key,
                                mainLabel: showShift ? key.shift : key.normal,
                                keyId: key.key
                            )
                        }
                        specialKey(label: "Return ⏎", width: 72)
                    }
                    
                    // Bottom Row (ZXCV)
                    HStack(spacing: 5) {
                        specialKey(label: "Shift ⇧", width: 96)
                        ForEach(Array(KeyboardLayoutData.bottomRow.enumerated()), id: \.offset) { _, key in
                            keyButton(
                                topLabel: showShift ? key.shiftKey : key.key,
                                mainLabel: showShift ? key.shift : key.normal,
                                keyId: key.key
                            )
                        }
                        specialKey(label: "Shift ⇧", width: 96)
                    }
                    
                    // Space Row
                    HStack(spacing: 5) {
                        specialKey(label: "Fn", width: 48)
                        specialKey(label: "⌃", width: 48)
                        specialKey(label: "⌥", width: 48)
                        specialKey(label: "⌘", width: 62)
                        
                        ZStack {
                            RoundedRectangle(cornerRadius: 7)
                                .fill(Color.white.opacity(0.08))
                                .shadow(color: .black.opacity(0.3), radius: 2, x: 0, y: 1)
                            
                            Text("স্পেস")
                                .font(.system(size: 12, weight: .medium))
                                .foregroundColor(.white.opacity(0.5))
                        }
                        .frame(width: 280, height: 42)
                        
                        specialKey(label: "⌘", width: 62)
                        specialKey(label: "⌥", width: 48)
                        specialKey(label: "←", width: 48)
                        VStack(spacing: 1) {
                            specialKey(label: "↑", width: 48, height: 20)
                            specialKey(label: "↓", width: 48, height: 20)
                        }
                        specialKey(label: "→", width: 48)
                    }
                }
                .padding(18)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white.opacity(0.03))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white.opacity(0.06), lineWidth: 1)
                        )
                )
                .padding(.horizontal, 12)
                
                // Live Typing Test
                typingTestSection
                    .padding(.horizontal, 12)
                
                // Vowel Reference
                vowelReference
                    .padding(.horizontal, 12)
                    .padding(.bottom, 24)
            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    // MARK: - Typing Test
    
    var typingTestSection: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack(spacing: 8) {
                Image(systemName: "character.cursor.ibeam")
                    .font(.system(size: 13))
                    .foregroundColor(Color(red: 0.4, green: 0.8, blue: 0.5))
                Text("টাইপিং টেস্ট")
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(.white)
                
                Spacer()
                
                if !testText.isEmpty {
                    Button(action: { testText = "" }) {
                        HStack(spacing: 4) {
                            Image(systemName: "trash")
                                .font(.system(size: 10))
                            Text("মুছুন")
                                .font(.system(size: 11))
                        }
                        .foregroundColor(.white.opacity(0.3))
                        .padding(.horizontal, 10)
                        .padding(.vertical, 4)
                        .background(
                            Capsule()
                                .fill(Color.white.opacity(0.06))
                        )
                    }
                    .buttonStyle(.plain)
                }
            }
            
            ZStack(alignment: .topLeading) {
                if testText.isEmpty {
                    Text("এখানে বাংলা টাইপ করে পরীক্ষা করুন...")
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.2))
                        .padding(12)
                }
                
                TextEditor(text: $testText)
                    .font(.system(size: 16))
                    .foregroundColor(.white)
                    .scrollContentBackground(.hidden)
                    .frame(height: 80)
                    .padding(6)
            }
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(Color.white.opacity(0.04))
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(Color.white.opacity(0.08), lineWidth: 1)
                    )
            )
            
            // Character count
            HStack {
                Text("\(testText.count) অক্ষর")
                    .font(.system(size: 10))
                    .foregroundColor(.white.opacity(0.25))
                Spacer()
                Text("Globe 🌐 বা শর্টকাট দিয়ে ইউনিজয় কীবোর্ডে সুইচ করুন")
                    .font(.system(size: 10))
                    .foregroundColor(.white.opacity(0.2))
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.03))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color(red: 0.4, green: 0.8, blue: 0.5).opacity(0.15), lineWidth: 1)
                )
        )
    }
    
    // MARK: - Search Logic
    
    func updateHighlightedKeys(for query: String) {
        highlightedKeys.removeAll()
        guard !query.isEmpty else { return }
        
        let allRows = KeyboardLayoutData.numberRow + KeyboardLayoutData.topRow + KeyboardLayoutData.homeRow + KeyboardLayoutData.bottomRow
        
        for key in allRows {
            if key.normal.contains(query) || key.shift.contains(query) {
                highlightedKeys.insert(key.key)
            }
        }
    }
    
    // MARK: - UI Components
    
    func toggleButton(title: String, isActive: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(isActive ? .white : .white.opacity(0.4))
                .padding(.horizontal, 20)
                .padding(.vertical, 7)
                .background(
                    isActive ? AnyShapeStyle(
                        LinearGradient(
                            colors: [Color(red: 0.2, green: 0.5, blue: 1.0), Color(red: 0.4, green: 0.2, blue: 0.9)],
                            startPoint: .leading, endPoint: .trailing
                        )
                    ) : AnyShapeStyle(Color.clear)
                )
        }
        .buttonStyle(.plain)
    }
    
    func keyButton(topLabel: String, mainLabel: String, keyId: String, width: CGFloat = 52) -> some View {
        let isHovered = hoveredKey == keyId
        let isHighlighted = highlightedKeys.contains(keyId)
        let isActive = isHovered || isHighlighted
        
        return ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 7)
                .fill(isHighlighted ?
                      Color(red: 0.2, green: 0.8, blue: 0.4).opacity(0.3) :
                      isHovered ?
                      Color(red: 0.2, green: 0.5, blue: 1.0).opacity(0.25) :
                      Color.white.opacity(0.08))
                .shadow(color: isActive ? Color(red: 0.3, green: 0.5, blue: 1.0).opacity(0.3) : .black.opacity(0.3), radius: isActive ? 6 : 2, x: 0, y: 1)
                .overlay(
                    RoundedRectangle(cornerRadius: 7)
                        .stroke(isHighlighted ?
                                Color(red: 0.2, green: 0.8, blue: 0.4).opacity(0.6) :
                                isHovered ?
                                Color(red: 0.3, green: 0.5, blue: 1.0).opacity(0.5) :
                                Color.white.opacity(0.08), lineWidth: 1)
                )
            
            VStack(alignment: .leading, spacing: 0) {
                Text(topLabel)
                    .font(.system(size: 9, weight: .medium, design: .monospaced))
                    .foregroundColor(.white.opacity(0.35))
                    .padding(.top, 4)
                    .padding(.leading, 5)
                
                Spacer()
                
                HStack {
                    Spacer()
                    Text(mainLabel)
                        .font(.system(size: 18, weight: .semibold))
                        .foregroundColor(isHighlighted ? Color(red: 0.3, green: 0.9, blue: 0.5) : isHovered ? Color(red: 0.5, green: 0.7, blue: 1.0) : .white.opacity(0.9))
                    Spacer()
                }
                .padding(.bottom, 6)
            }
        }
        .frame(width: width, height: 46)
        .scaleEffect(isActive ? 1.08 : 1.0)
        .animation(.easeOut(duration: 0.15), value: isActive)
        .onHover { hovered in
            hoveredKey = hovered ? keyId : nil
        }
    }
    
    func keyRow(keys: [(key: String, shiftKey: String, normal: String, shift: String)], keyWidth: CGFloat) -> some View {
        HStack(spacing: 5) {
            ForEach(Array(keys.enumerated()), id: \.offset) { _, key in
                keyButton(
                    topLabel: showShift ? key.shiftKey : key.key,
                    mainLabel: showShift ? key.shift : key.normal,
                    keyId: key.key,
                    width: keyWidth
                )
            }
            specialKey(label: "⌫", width: 68)
        }
    }
    
    func specialKey(label: String, width: CGFloat, height: CGFloat = 42) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 7)
                .fill(Color.white.opacity(0.05))
                .shadow(color: .black.opacity(0.2), radius: 1, x: 0, y: 1)
            
            Text(label)
                .font(.system(size: 11, weight: .medium))
                .foregroundColor(.white.opacity(0.4))
        }
        .frame(width: width, height: height)
    }
    
    var vowelReference: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("স্বরবর্ণ রেফারেন্স")
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.white)
            
            HStack(spacing: 16) {
                vowelChip("অ", "Shift+F")
                vowelChip("আ/া", "F / া")
                vowelChip("ই/ি", "D")
                vowelChip("ঈ/ী", "Shift+D")
                vowelChip("উ/ু", "S")
                vowelChip("ঊ/ূ", "Shift+S")
                vowelChip("ঋ/ৃ", "A")
                vowelChip("এ/ে", "C")
                vowelChip("ঐ/ৈ", "Shift+C")
                vowelChip("ও/ো", "X")
                vowelChip("ঔ/ৌ", "Shift+X")
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.03))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.06), lineWidth: 1)
                )
        )
    }
    
    func vowelChip(_ label: String, _ shortcut: String) -> some View {
        VStack(spacing: 4) {
            Text(label)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(Color(red: 0.5, green: 0.7, blue: 1.0))
            Text(shortcut)
                .font(.system(size: 9, weight: .medium, design: .monospaced))
                .foregroundColor(.white.opacity(0.35))
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white.opacity(0.04))
        )
    }
}
