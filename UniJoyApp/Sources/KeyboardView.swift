import SwiftUI

struct KeyboardView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var showShift: Bool = false
    @State private var hoveredKey: String? = nil
    @State private var testText: String = ""
    @State private var searchQuery: String = ""
    @State private var highlightedKeys: Set<String> = []
    
    var t: TC { TC(isDark: themeManager.isDark) }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Search + Toggle Row
            HStack(spacing: 14) {
                // Search
                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 14))
                        .foregroundColor(t.inkFaint)
                    TextField("অক্ষর খুঁজুন (যেমন: ক, খ)...", text: $searchQuery)
                        .textFieldStyle(.plain)
                        .font(.system(size: 14))
                        .foregroundColor(t.ink)
                        .onChange(of: searchQuery) { newValue in
                            updateHighlightedKeys(for: newValue)
                        }
                    if !searchQuery.isEmpty {
                        Button(action: { searchQuery = ""; highlightedKeys.removeAll() }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 13))
                                .foregroundColor(t.inkFaint)
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(.horizontal, 14)
                .padding(.vertical, 9)
                .background(
                    RoundedRectangle(cornerRadius: 11)
                        .fill(t.panel)
                        .overlay(RoundedRectangle(cornerRadius: 11).stroke(t.line, lineWidth: 1))
                )
                .frame(maxWidth: 300)
                
                // Segment control
                HStack(spacing: 3) {
                    segButton(title: "Normal", isActive: !showShift) {
                        withAnimation(.easeInOut(duration: 0.2)) { showShift = false }
                    }
                    segButton(title: "Shift ⇧", isActive: showShift) {
                        withAnimation(.easeInOut(duration: 0.2)) { showShift = true }
                    }
                }
                .padding(3)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(t.panel2)
                        .overlay(RoundedRectangle(cornerRadius: 10).stroke(t.line, lineWidth: 1))
                )
            }
            .padding(.bottom, 16)
            
            // Keyboard
            VStack(spacing: 3) {
                keyRow(keys: KeyboardLayoutData.numberRow, keyWidth: 36)
                HStack(spacing: 3) {
                    specialKey(label: "Tab", width: 46)
                    ForEach(Array(KeyboardLayoutData.topRow.enumerated()), id: \.offset) { _, key in
                        keyButton(topLabel: showShift ? key.shiftKey : key.key, mainLabel: showShift ? key.shift : key.normal, keyId: key.key)
                    }
                }
                HStack(spacing: 3) {
                    specialKey(label: "Caps", width: 56)
                    ForEach(Array(KeyboardLayoutData.homeRow.enumerated()), id: \.offset) { _, key in
                        keyButton(topLabel: showShift ? key.shiftKey : key.key, mainLabel: showShift ? key.shift : key.normal, keyId: key.key)
                    }
                    specialKey(label: "Return ⏎", width: 52)
                }
                HStack(spacing: 3) {
                    specialKey(label: "Shift ⇧", width: 70)
                    ForEach(Array(KeyboardLayoutData.bottomRow.enumerated()), id: \.offset) { _, key in
                        keyButton(topLabel: showShift ? key.shiftKey : key.key, mainLabel: showShift ? key.shift : key.normal, keyId: key.key)
                    }
                    specialKey(label: "Shift ⇧", width: 70)
                }
                HStack(spacing: 3) {
                    Spacer()
                    ZStack {
                        RoundedRectangle(cornerRadius: 7)
                            .fill(t.keyBg)
                            .overlay(RoundedRectangle(cornerRadius: 7).stroke(t.keyLine, lineWidth: 1))
                            .shadow(color: t.keyShadow, radius: 0, x: 0, y: 2)
                        Text("স্পেস")
                            .font(.system(size: 10, weight: .medium))
                            .foregroundColor(t.inkSoft)
                    }
                    .frame(width: 280, height: 36)
                    Spacer()
                }
            }
            .padding(14)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(t.panel)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(t.line, lineWidth: 1))
            )
            
            // Typing Test
            VStack(alignment: .leading, spacing: 11) {
                HStack(spacing: 9) {
                    Image(systemName: "character.cursor.ibeam")
                        .font(.system(size: 14))
                        .foregroundColor(t.good)
                    Text("টাইপিং টেস্ট")
                        .font(.system(size: 15.5, weight: .semibold))
                        .foregroundColor(t.ink)
                }
                ZStack(alignment: .topLeading) {
                    if testText.isEmpty {
                        Text("এখানে বাংলা টাইপ করে পরীক্ষা করুন...")
                            .font(.system(size: 22))
                            .foregroundColor(t.inkFaint)
                            .padding(14)
                    }
                    TextEditor(text: $testText)
                        .font(.system(size: 22))
                        .foregroundColor(t.ink)
                        .scrollContentBackground(.hidden)
                        .frame(height: 90)
                        .padding(8)
                }
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(t.panel2)
                        .overlay(RoundedRectangle(cornerRadius: 12).stroke(t.line, lineWidth: 1))
                )
                HStack {
                    Text("\(testText.count) অক্ষর")
                        .font(.system(size: 12, design: .monospaced))
                        .foregroundColor(t.inkSoft)
                    Spacer()
                    Text("Globe বা শর্টকাট দিয়ে ইউনিজয় কীবোর্ডে সুইচ করুন")
                        .font(.system(size: 12.5))
                        .foregroundColor(t.inkFaint)
                }
            }
            .padding(18)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(t.panel)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(t.line, lineWidth: 1))
            )
            .padding(.top, 16)
            
            HStack(spacing: 9) {
                Text("স্বরবর্ণ রেফারেন্স")
                    .font(.system(size: 15, weight: .bold))
                    .foregroundColor(t.ink)
                Spacer()
                Text("VOWELS")
                    .font(.system(size: 10.5, weight: .medium, design: .monospaced))
                    .foregroundColor(t.inkFaint)
                    .padding(.horizontal, 8).padding(.vertical, 2)
                    .overlay(RoundedRectangle(cornerRadius: 99).stroke(t.line, lineWidth: 1))
            }
            .padding(.top, 20).padding(.bottom, 10)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 6), count: 6), spacing: 6) {
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
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Search
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
    func segButton(title: String, isActive: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            Text(title)
                .font(.system(size: 13.5, weight: .semibold))
                .foregroundColor(isActive ? t.accent : t.inkSoft)
                .padding(.horizontal, 16)
                .padding(.vertical, 7)
                .background(
                    RoundedRectangle(cornerRadius: 7)
                        .fill(isActive ? t.panel : Color.clear)
                        .shadow(color: isActive ? Color.black.opacity(0.07) : Color.clear, radius: 2, y: 1)
                )
        }
        .buttonStyle(.plain)
    }
    
    func keyButton(topLabel: String, mainLabel: String, keyId: String, width: CGFloat = 36) -> some View {
        let isHovered = hoveredKey == keyId
        let isHighlighted = highlightedKeys.contains(keyId)
        let isActive = isHovered || isHighlighted
        
        return ZStack(alignment: .topLeading) {
            RoundedRectangle(cornerRadius: 9)
                .fill(isHighlighted ? t.accentSoft : isHovered ? t.accentSoft : t.keyBg)
                .overlay(
                    RoundedRectangle(cornerRadius: 9)
                        .stroke(isActive ? t.accent : t.keyLine, lineWidth: 1)
                )
                .shadow(color: t.keyShadow, radius: 0, x: 0, y: 2)
            VStack(alignment: .leading, spacing: 0) {
                Text(topLabel)
                    .font(.system(size: 8, weight: .medium, design: .monospaced))
                    .foregroundColor(t.inkFaint)
                    .padding(.top, 3).padding(.leading, 4)
                Spacer()
                HStack {
                    Spacer()
                    Text(mainLabel)
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(isActive ? t.accent : t.ink)
                    Spacer()
                }
                .padding(.bottom, 4)
            }
        }
        .frame(width: width, height: 36)
        .scaleEffect(isActive ? 1.06 : 1.0)
        .animation(.easeOut(duration: 0.12), value: isActive)
        .onHover { hovered in hoveredKey = hovered ? keyId : nil }
    }
    
    func keyRow(keys: [(key: String, shiftKey: String, normal: String, shift: String)], keyWidth: CGFloat) -> some View {
        HStack(spacing: 3) {
            ForEach(Array(keys.enumerated()), id: \.offset) { _, key in
                keyButton(topLabel: showShift ? key.shiftKey : key.key, mainLabel: showShift ? key.shift : key.normal, keyId: key.key, width: keyWidth)
            }
            specialKey(label: "⌫", width: 48)
        }
    }
    
    func specialKey(label: String, width: CGFloat, height: CGFloat = 36) -> some View {
        ZStack {
            RoundedRectangle(cornerRadius: 7)
                .fill(t.keyBg.opacity(0.7))
                .overlay(RoundedRectangle(cornerRadius: 7).stroke(t.keyLine, lineWidth: 1))
                .shadow(color: t.keyShadow, radius: 0, x: 0, y: 2)
            Text(label)
                .font(.system(size: 11, weight: .medium, design: .monospaced))
                .foregroundColor(t.inkSoft)
        }
        .frame(width: width, height: height)
    }
    
    func vowelChip(_ label: String, _ shortcut: String) -> some View {
        VStack(spacing: 3) {
            Text(label)
                .font(.system(size: 17, weight: .semibold))
                .foregroundColor(t.accent)
            Text(shortcut)
                .font(.system(size: 9.5, weight: .medium, design: .monospaced))
                .foregroundColor(t.inkFaint)
        }
        .padding(.horizontal, 6)
        .padding(.vertical, 7)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(t.panel)
                .overlay(RoundedRectangle(cornerRadius: 8).stroke(t.line, lineWidth: 1))
        )
    }
}
