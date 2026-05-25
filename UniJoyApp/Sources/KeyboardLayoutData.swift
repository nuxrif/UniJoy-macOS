import SwiftUI

// MARK: - Keyboard Layout Data
struct KeyMapping: Identifiable {
    let id = UUID()
    let englishKey: String
    let normalOutput: String
    let shiftOutput: String
}

struct KeyboardLayoutData {
    // macOS key codes mapped to US QWERTY physical positions
    // Row 1 (Number row): ` 1 2 3 4 5 6 7 8 9 0 - =
    // Row 2: Q W E R T Y U I O P [ ]
    // Row 3: A S D F G H J K L ; ' 
    // Row 4: Z X C V B N M , . /
    
    static let numberRow: [(key: String, shiftKey: String, normal: String, shift: String)] = [
        ("`", "~", "'", "'"),
        ("1", "!", "১", "!"),
        ("2", "@", "২", "@"),
        ("3", "#", "৩", "#"),
        ("4", "$", "৪", "৳"),
        ("5", "%", "৫", "%"),
        ("6", "^", "৬", "÷"),
        ("7", "&", "৭", "ঁ"),
        ("8", "*", "৮", "×"),
        ("9", "(", "৯", "("),
        ("0", ")", "০", ")"),
        ("-", "_", "-", "—"),
        ("=", "+", "=", "+"),
    ]
    
    static let topRow: [(key: String, shiftKey: String, normal: String, shift: String)] = [
        ("Q", "Q", "ঙ", "ং"),
        ("W", "W", "য", "য়"),
        ("E", "E", "ড", "ঢ"),
        ("R", "R", "প", "ফ"),
        ("T", "T", "ট", "ঠ"),
        ("Y", "Y", "চ", "ছ"),
        ("U", "U", "জ", "ঝ"),
        ("I", "I", "হ", "ঞ"),
        ("O", "O", "গ", "ঘ"),
        ("P", "P", "ড়", "ঢ়"),
        ("[", "{", "[", "{"),
        ("]", "}", "]", "}"),
    ]
    
    static let homeRow: [(key: String, shiftKey: String, normal: String, shift: String)] = [
        ("A", "A", "ৃ", "র্"),
        ("S", "S", "ু", "ূ"),
        ("D", "D", "ি", "ী"),
        ("F", "F", "া", "অ"),
        ("G", "G", "্", "।"),
        ("H", "H", "ব", "ভ"),
        ("J", "J", "ক", "খ"),
        ("K", "K", "ত", "থ"),
        ("L", "L", "দ", "ধ"),
        (";", ":", ";", ":"),
        ("'", "\"", "'", "\""),
    ]
    
    static let bottomRow: [(key: String, shiftKey: String, normal: String, shift: String)] = [
        ("Z", "Z", "্র", "্য"),
        ("X", "X", "ো", "ৌ"),
        ("C", "C", "ে", "ৈ"),
        ("V", "V", "র", "ল"),
        ("B", "B", "ন", "ণ"),
        ("N", "N", "স", "ষ"),
        ("M", "M", "ম", "শ"),
        (",", "<", ",", "<"),
        (".", ">", ".", ">"),
        ("/", "?", "/", "?"),
    ]
}
