import SwiftUI

struct HelpView: View {
    @EnvironmentObject var themeManager: ThemeManager
    @State private var expandedSection: String? = nil
    
    var t: TC { TC(isDark: themeManager.isDark) }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            // Quick Tips — 6 tips in 2-column grid
            sectionHeader("দ্রুত টিপস", tag: "TIPS")
            
            LazyVGrid(columns: [
                GridItem(.flexible(), spacing: 12),
                GridItem(.flexible(), spacing: 12)
            ], spacing: 12) {
                tipCard(icon: "keyboard", title: "কীবোর্ড সুইচ",
                    description: "Globe (🌐) কী বা Control+Space চেপে ইউনিজয় ↔ ইংরেজি সুইচ করুন")
                tipCard(icon: "textformat", title: "যুক্তবর্ণ লেখা",
                    description: "প্রথম অক্ষর + G (হসন্ত) + দ্বিতীয় অক্ষর = যুক্তবর্ণ। যেমন: ক + G + ত = ক্ত")
                tipCard(icon: "character.textbox", title: "র-ফলা (্র)",
                    description: "Z কী চাপলে র-ফলা (্র) যোগ হবে। যেমন: ক + Z = ক্র")
                tipCard(icon: "character.textbox", title: "য-ফলা (্য)",
                    description: "Shift+Z চাপলে য-ফলা (্য) যোগ হবে। যেমন: স + Shift+Z = স্য")
                tipCard(icon: "number", title: "বাংলা সংখ্যা",
                    description: "সরাসরি নম্বর কী (1-0) চাপলে বাংলা সংখ্যা (১-০) আসবে")
                tipCard(icon: "textformat.abc", title: "চন্দ্রবিন্দু ও বিসর্গ",
                    description: "Shift+G চাপলে চন্দ্রবিন্দু (ঁ) এবং Shift+I চাপলে বিসর্গ (ঃ) আসবে")
            }
            
            // FAQ
            sectionHeader("সাধারণ প্রশ্ন", tag: "FAQ")
            
            VStack(spacing: 8) {
                faqItem(
                    question: "ইনস্টল করার পরেও ইউনিজয় কীবোর্ড দেখাচ্ছে না?",
                    answer: "System Settings → Keyboard → Input Sources এ গিয়ে '+' ক্লিক করে 'Other' থেকে 'ইউনিজয়' যোগ করুন। কিছু ক্ষেত্রে লগ আউট করে আবার লগ ইন করতে হতে পারে।",
                    id: "faq1"
                )
                faqItem(
                    question: "হসন্ত (্) কীভাবে লিখব?",
                    answer: "G কী চাপলে হসন্ত আসবে। হসন্ত দিয়ে যুক্তবর্ণ তৈরি করা যায়। দুইবার G চাপলে দৃশ্যমান হসন্ত (্) দেখাবে।",
                    id: "faq2"
                )
                faqItem(
                    question: "স্বরবর্ণ (অ, আ, ই...) কীভাবে লিখব?",
                    answer: "হসন্ত (G) চাপার পরে স্বরচিহ্ন চাপলে স্বরবর্ণ আসবে। যেমন: G + F = আ, G + D = ই, G + S = উ",
                    id: "faq3"
                )
                faqItem(
                    question: "রেফ (র্) কীভাবে লিখব?",
                    answer: "Shift+A চাপলে রেফ (র্) আসবে। যেমন: Shift+A + ক = র্ক",
                    id: "faq4"
                )
                faqItem(
                    question: "UniJoy কি আমার কোনো ডেটা সংগ্রহ করে?",
                    answer: "না, UniJoy সম্পূর্ণ অফলাইন অ্যাপ। এটি কোনো ধরনের ব্যক্তিগত তথ্য, টাইপ করা টেক্সট, বা ব্যবহারকারীর আচরণ সংগ্রহ করে না। ইন্টারনেট সংযোগের প্রয়োজন নেই এবং কোনো সার্ভারে ডেটা পাঠানো হয় না।",
                    id: "faq5"
                )
                faqItem(
                    question: "অ্যাপটি কি ইন্টারনেট ব্যবহার করে?",
                    answer: "না। UniJoy সম্পূর্ণ অফলাইনে কাজ করে। ইনস্টলেশন থেকে শুরু করে প্রতিদিনের ব্যবহার পর্যন্ত কোনো ইন্টারনেট সংযোগ প্রয়োজন হয় না।",
                    id: "faq6"
                )
                faqItem(
                    question: "UniJoy কি ওপেন সোর্স?",
                    answer: "হ্যাঁ। UniJoy কীবোর্ড লেআউটটি GNU LGPL v2.1 লাইসেন্সের অধীনে ওপেন সোর্স। macOS অ্যাপের সোর্স কোড GitHub-এ পাওয়া যাবে।",
                    id: "faq7"
                )
                faqItem(
                    question: "macOS আপডেটের পর কীবোর্ড কাজ করছে না?",
                    answer: "মাঝে মাঝে macOS আপডেটের পর Input Source রিসেট হয়। ইনস্টল ট্যাবে গিয়ে আবার 'ইনস্টল ও শুরু করুন' বাটনে ক্লিক করুন। এরপর লগ আউট করে লগ ইন করুন।",
                    id: "faq8"
                )
                faqItem(
                    question: "অ্যাপটি কি সব macOS ভার্সনে কাজ করে?",
                    answer: "UniJoy macOS 13.0 (Ventura) এবং তার পরবর্তী সব ভার্সনে কাজ করে। Apple Silicon (M1/M2/M3/M4) এবং Intel উভয় Mac-এ Universal Binary হিসেবে চলে।",
                    id: "faq9"
                )
                faqItem(
                    question: "একাধিক ব্যবহারকারী অ্যাকাউন্টে ব্যবহার করা যাবে?",
                    answer: "হ্যাঁ। ইনস্টলেশনের সময় System-wide ইনস্টল করলে সব ব্যবহারকারী অ্যাকাউন্টে কীবোর্ড লেআউট পাওয়া যাবে, তবে প্রতিটি অ্যাকাউন্টে আলাদাভাবে Input Source যোগ করতে হবে।",
                    id: "faq10"
                )
            }
            
            // About
            HStack(spacing: 20) {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .fill(t.accent)
                        .frame(width: 58, height: 58)
                        .shadow(color: t.accent.opacity(0.3), radius: 10, x: 0, y: 4)
                    Text("ক")
                        .font(.system(size: 29, weight: .bold))
                        .foregroundColor(t.accentInk)
                }
                
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 8) {
                        Text("UniJoy for macOS")
                            .font(.system(size: 19, weight: .bold))
                            .foregroundColor(t.ink)
                        Text("❤")
                            .font(.system(size: 15))
                            .foregroundColor(t.accent)
                    }
                    Text("মূল লেআউট ডিজাইন: S. M. Raiyan Kabir")
                        .font(.system(size: 13))
                        .foregroundColor(t.inkSoft)
                    Text("macOS অ্যাপ ডেভেলপমেন্ট: Sharif Ahammed")
                        .font(.system(size: 13))
                        .foregroundColor(t.inkSoft)
                        .padding(.top, 1)
                    
                    HStack(spacing: 8) {
                        aboutLink("👤 Sharif Ahammed", url: "https://sharif.bd")
                        aboutLink("🔗 ekushey.org", url: "https://ekushey.org/keyboard-layout/ekusheyr-shadhinota-unijoy-layout/")
                    }
                    .padding(.top, 7)
                    
                    Text("GNU LGPL v2.1 লাইসেন্সের অধীনে")
                        .font(.system(size: 11, design: .monospaced))
                        .foregroundColor(t.inkFaint)
                        .padding(.top, 5)
                }
            }
            .padding(22)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(t.panel)
                    .overlay(RoundedRectangle(cornerRadius: 12).stroke(t.line, lineWidth: 1))
            )
            .padding(.top, 20)
        }
        .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    // MARK: - Section Header
    func sectionHeader(_ title: String, tag: String) -> some View {
        HStack(spacing: 9) {
            Text(title)
                .font(.system(size: 17, weight: .bold))
                .foregroundColor(t.ink)
            Spacer()
            Text(tag)
                .font(.system(size: 10.5, weight: .medium, design: .monospaced))
                .foregroundColor(t.inkFaint)
                .padding(.horizontal, 8).padding(.vertical, 2)
                .overlay(RoundedRectangle(cornerRadius: 99).stroke(t.line, lineWidth: 1))
        }
        .padding(.top, 26)
        .padding(.bottom, 13)
    }
    
    // MARK: - Tip Card
    func tipCard(icon: String, title: String, description: String) -> some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 9)
                    .fill(t.accentSoft)
                    .frame(width: 36, height: 36)
                Image(systemName: icon)
                    .font(.system(size: 15, weight: .medium))
                    .foregroundColor(t.accent)
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(t.ink)
                Text(description)
                    .font(.system(size: 13))
                    .foregroundColor(t.inkSoft)
                    .lineSpacing(3)
            }
        }
        .padding(15)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(t.panel)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(t.line, lineWidth: 1))
        )
    }
    
    // MARK: - FAQ Item
    func faqItem(question: String, answer: String, id: String) -> some View {
        Button(action: {
            withAnimation(.easeInOut(duration: 0.2)) {
                expandedSection = expandedSection == id ? nil : id
            }
        }) {
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Text(question)
                        .font(.system(size: 14.5, weight: .semibold))
                        .foregroundColor(t.ink)
                        .multilineTextAlignment(.leading)
                    Spacer()
                    Text("+")
                        .font(.system(size: 20, weight: .medium))
                        .foregroundColor(t.accent)
                        .rotationEffect(.degrees(expandedSection == id ? 45 : 0))
                        .animation(.easeInOut(duration: 0.2), value: expandedSection == id)
                }
                .padding(15)
                
                if expandedSection == id {
                    Text(answer)
                        .font(.system(size: 13.5))
                        .foregroundColor(t.inkSoft)
                        .lineSpacing(4)
                        .padding(.horizontal, 18)
                        .padding(.bottom, 16)
                        .transition(.opacity.combined(with: .move(edge: .top)))
                }
            }
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(t.panel)
                .overlay(RoundedRectangle(cornerRadius: 12).stroke(t.line, lineWidth: 1))
        )
    }
    
    // MARK: - About Link
    func aboutLink(_ text: String, url: String) -> some View {
        Button(action: {
            if let u = URL(string: url) { NSWorkspace.shared.open(u) }
        }) {
            Text(text)
                .font(.system(size: 12.5, weight: .semibold))
                .foregroundColor(t.accent)
                .padding(.horizontal, 12)
                .padding(.vertical, 5)
                .overlay(
                    RoundedRectangle(cornerRadius: 8)
                        .stroke(t.line, lineWidth: 1)
                )
        }
        .buttonStyle(.plain)
    }
}
