import SwiftUI

struct ConjunctView: View {
    @State private var searchText: String = ""
    @State private var selectedCategory: String = "সব"
    
    let categories = ["সব", "ক-গ্রুপ", "চ-গ্রুপ", "ট-গ্রুপ", "ত-গ্রুপ", "প-গ্রুপ", "অন্যান্য"]
    
    let conjuncts: [(String, String, String, String)] = [
        // (যুক্তবর্ণ, কী কম্বো, উচ্চারণ, গ্রুপ)
        ("ক্ক", "J + G + J", "ক্ক (পাক্কা)", "ক-গ্রুপ"),
        ("ক্ত", "J + G + L", "ক্ত (শক্ত)", "ক-গ্রুপ"),
        ("ক্ট", "J + G + T", "ক্ট (ডক্টর)", "ক-গ্রুপ"),
        ("ক্ষ", "J + G + N", "ক্ষ (রাক্ষস)", "ক-গ্রুপ"),
        ("ক্স", "J + G + M", "ক্স (বাক্স)", "ক-গ্রুপ"),
        ("ক্র", "J + Z", "ক্র (চক্র)", "ক-গ্রুপ"),
        ("খ্র", "Shift+J + Z", "খ্র (খ্রিস্ট)", "ক-গ্রুপ"),
        ("গ্ন", "O + G + B", "গ্ন (ভাগ্ন)", "ক-গ্রুপ"),
        ("গ্ধ", "O + G + Shift+L", "গ্ধ (মুগ্ধ)", "ক-গ্রুপ"),
        ("গ্র", "O + Z", "গ্র (গ্রাম)", "ক-গ্রুপ"),
        ("ঘ্র", "Shift+O + Z", "ঘ্র (ঘ্রাণ)", "ক-গ্রুপ"),
        ("ঙ্ক", "Shift+Q + G + J", "ঙ্ক (অঙ্ক)", "ক-গ্রুপ"),
        ("ঙ্গ", "Shift+Q + G + O", "ঙ্গ (বাঙ্গালি)", "ক-গ্রুপ"),
        
        ("চ্চ", "Y + G + Y", "চ্চ (বাচ্চা)", "চ-গ্রুপ"),
        ("চ্ছ", "Y + G + Shift+Y", "চ্ছ (ইচ্ছা)", "চ-গ্রুপ"),
        ("জ্জ", "U + G + U", "জ্জ (হজ্জ)", "চ-গ্রুপ"),
        ("জ্ঞ", "U + G + Shift+I", "জ্ঞ (জ্ঞান)", "চ-গ্রুপ"),
        ("জ্র", "U + Z", "জ্র (বজ্র)", "চ-গ্রুপ"),
        ("ঞ্চ", "Shift+I + G + Y", "ঞ্চ (কাঞ্চন)", "চ-গ্রুপ"),
        ("ঞ্জ", "Shift+I + G + U", "ঞ্জ (গঞ্জ)", "চ-গ্রুপ"),
        
        ("ট্ট", "T + G + T", "ট্ট (চট্টগ্রাম)", "ট-গ্রুপ"),
        ("ড্র", "E + Z", "ড্র (ড্রাইভার)", "ট-গ্রুপ"),
        ("ণ্ড", "Shift+B + G + E", "ণ্ড (ণ্ড)", "ট-গ্রুপ"),
        ("ণ্ট", "Shift+B + G + T", "ণ্ট (ঘণ্টা)", "ট-গ্রুপ"),
        ("ণ্ঠ", "Shift+B + G + Shift+T", "ণ্ঠ (কণ্ঠ)", "ট-গ্রুপ"),
        
        ("ত্ত", "L + G + L", "ত্ত (উত্তর)", "ত-গ্রুপ"),
        ("ত্র", "L + Z", "ত্র (ত্রাণ)", "ত-গ্রুপ"),
        ("ত্থ", "L + G + Shift+L", "ত্থ (উত্থান)", "ত-গ্রুপ"),
        ("দ্দ", "K + G + K", "দ্দ (উদ্দেশ্য)", "ত-গ্রুপ"),
        ("দ্ধ", "K + G + Shift+K", "দ্ধ (বুদ্ধ)", "ত-গ্রুপ"),
        ("দ্র", "K + Z", "দ্র (দ্রুত)", "ত-গ্রুপ"),
        ("ধ্র", "Shift+K + Z", "ধ্র (ধ্রুব)", "ত-গ্রুপ"),
        ("ন্ত", "B + G + L", "ন্ত (অন্ত)", "ত-গ্রুপ"),
        ("ন্দ", "B + G + K", "ন্দ (আনন্দ)", "ত-গ্রুপ"),
        ("ন্ধ", "B + G + Shift+K", "ন্ধ (অন্ধ)", "ত-গ্রুপ"),
        ("ন্ন", "B + G + B", "ন্ন (অন্ন)", "ত-গ্রুপ"),
        ("ন্র", "B + Z", "ন্র (হেন্‌রি)", "ত-গ্রুপ"),
        
        ("প্প", "R + G + R", "প্প (গোষ্ঠীপ্প)", "প-গ্রুপ"),
        ("প্র", "R + Z", "প্র (প্রেম)", "প-গ্রুপ"),
        ("প্ত", "R + G + L", "প্ত (সপ্তম)", "প-গ্রুপ"),
        ("ব্র", "H + Z", "ব্র (ব্রাহ্মণ)", "প-গ্রুপ"),
        ("ভ্র", "Shift+H + Z", "ভ্র (ভ্রমণ)", "প-গ্রুপ"),
        ("ম্প", "Shift+M + G + R", "ম্প (কম্প)", "প-গ্রুপ"),
        ("ম্ব", "Shift+M + G + H", "ম্ব (লম্বা)", "প-গ্রুপ"),
        ("ম্ম", "Shift+M + G + Shift+M", "ম্ম (সম্মান)", "প-গ্রুপ"),
        ("ম্র", "Shift+M + Z", "ম্র (নম্র)", "প-গ্রুপ"),
        
        ("শ্র", "Shift+N + Z", "শ্র (শ্রম)", "অন্যান্য"),
        ("স্র", "M + Z", "স্র (স্রোত)", "অন্যান্য"),
        ("স্ত", "M + G + L", "স্ত (বিস্তার)", "অন্যান্য"),
        ("স্থ", "M + G + Shift+L", "স্থ (স্থান)", "অন্যান্য"),
        ("স্ন", "M + G + B", "স্ন (স্নান)", "অন্যান্য"),
        ("স্প", "M + G + R", "স্প (স্পর্শ)", "অন্যান্য"),
        ("হ্ন", "I + G + B", "হ্ন (বাহ্ন)", "অন্যান্য"),
        ("হ্র", "I + Z", "হ্র (হ্রদ)", "অন্যান্য"),
        ("ল্ল", "Shift+V + G + Shift+V", "ল্ল (উল্লাস)", "অন্যান্য"),
        ("র্ক", "Shift+A + J", "র্ক (তর্ক)", "অন্যান্য"),
        ("ষ্ট", "Shift+N + G + T", "ষ্ট (কষ্ট)", "অন্যান্য"),
        ("ষ্ঠ", "Shift+N + G + Shift+T", "ষ্ঠ (শ্রেষ্ঠ)", "অন্যান্য"),
    ]
    
    var filteredConjuncts: [(String, String, String, String)] {
        conjuncts.filter { item in
            let matchCategory = selectedCategory == "সব" || item.3 == selectedCategory
            let matchSearch = searchText.isEmpty || 
                item.0.contains(searchText) || 
                item.2.localizedCaseInsensitiveContains(searchText) ||
                item.1.localizedCaseInsensitiveContains(searchText)
            return matchCategory && matchSearch
        }
    }
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                // Header
                VStack(spacing: 6) {
                    Text("যুক্তবর্ণ চার্ট")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("সব যুক্তবর্ণ ও তাদের কী কম্বিনেশন")
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.5))
                }
                .padding(.top, 28)
                
                // Search bar
                HStack(spacing: 10) {
                    Image(systemName: "magnifyingglass")
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.3))
                    
                    TextField("যুক্তবর্ণ খুঁজুন...", text: $searchText)
                        .textFieldStyle(.plain)
                        .font(.system(size: 13))
                        .foregroundColor(.white)
                    
                    if !searchText.isEmpty {
                        Button(action: { searchText = "" }) {
                            Image(systemName: "xmark.circle.fill")
                                .font(.system(size: 13))
                                .foregroundColor(.white.opacity(0.3))
                        }
                        .buttonStyle(.plain)
                    }
                }
                .padding(10)
                .background(
                    RoundedRectangle(cornerRadius: 10)
                        .fill(Color.white.opacity(0.06))
                        .overlay(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(Color.white.opacity(0.08), lineWidth: 1)
                        )
                )
                .frame(maxWidth: 500)
                
                // Category pills
                ScrollView(.horizontal, showsIndicators: false) {
                    HStack(spacing: 8) {
                        ForEach(categories, id: \.self) { cat in
                            Button(action: {
                                withAnimation(.easeInOut(duration: 0.15)) {
                                    selectedCategory = cat
                                }
                            }) {
                                Text(cat)
                                    .font(.system(size: 11, weight: selectedCategory == cat ? .semibold : .regular))
                                    .foregroundColor(selectedCategory == cat ? .white : .white.opacity(0.4))
                                    .padding(.horizontal, 14)
                                    .padding(.vertical, 6)
                                    .background(
                                        Capsule()
                                            .fill(selectedCategory == cat ?
                                                  Color(red: 0.2, green: 0.5, blue: 1.0).opacity(0.25) :
                                                  Color.white.opacity(0.04))
                                            .overlay(
                                                Capsule()
                                                    .stroke(selectedCategory == cat ?
                                                            Color(red: 0.3, green: 0.6, blue: 1.0).opacity(0.3) :
                                                            Color.white.opacity(0.06), lineWidth: 1)
                                            )
                                    )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                .frame(maxWidth: 600)
                
                // Count
                HStack {
                    Text("\(filteredConjuncts.count)টি যুক্তবর্ণ")
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.3))
                    Spacer()
                }
                .frame(maxWidth: 600)
                
                // Grid
                LazyVGrid(columns: [
                    GridItem(.flexible(), spacing: 10),
                    GridItem(.flexible(), spacing: 10),
                    GridItem(.flexible(), spacing: 10)
                ], spacing: 10) {
                    ForEach(filteredConjuncts, id: \.0) { item in
                        conjunctCard(letter: item.0, keys: item.1, example: item.2)
                    }
                }
                .frame(maxWidth: 600)
                .padding(.bottom, 28)
            }
            .padding(.horizontal, 24)
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func conjunctCard(letter: String, keys: String, example: String) -> some View {
        VStack(spacing: 8) {
            Text(letter)
                .font(.system(size: 28, weight: .bold))
                .foregroundColor(Color(red: 0.5, green: 0.7, blue: 1.0))
            
            Text(keys)
                .font(.system(size: 10, weight: .medium, design: .monospaced))
                .foregroundColor(.white.opacity(0.7))
                .padding(.horizontal, 8)
                .padding(.vertical, 3)
                .background(
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white.opacity(0.06))
                )
            
            Text(example)
                .font(.system(size: 10))
                .foregroundColor(.white.opacity(0.35))
                .lineLimit(1)
        }
        .padding(12)
        .frame(maxWidth: .infinity)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.03))
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(Color.white.opacity(0.06), lineWidth: 1)
                )
        )
    }
}
