import SwiftUI

struct HelpView: View {
    @State private var expandedSection: String? = nil
    
    var body: some View {
        ScrollView {
            VStack(spacing: 24) {
                // Header
                VStack(spacing: 6) {
                    Text("সাহায্য ও গাইড")
                        .font(.system(size: 24, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("UniJoy কীবোর্ড ব্যবহারের সম্পূর্ণ গাইড")
                        .font(.system(size: 13))
                        .foregroundColor(.white.opacity(0.5))
                }
                .padding(.top, 28)
                
                // Quick Tips
                VStack(alignment: .leading, spacing: 14) {
                    sectionHeader("দ্রুত টিপস", icon: "lightbulb.fill")
                    
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
                }
                .padding(.horizontal, 32)
                
                // FAQ
                VStack(alignment: .leading, spacing: 14) {
                    sectionHeader("সাধারণ প্রশ্ন", icon: "questionmark.bubble")
                    
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
                .padding(.horizontal, 32)
                
                // About
                VStack(spacing: 12) {
                    Image(systemName: "heart.fill")
                        .font(.system(size: 18))
                        .foregroundColor(Color(red: 0.9, green: 0.3, blue: 0.4))
                    
                    Text("UniJoy for macOS")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(.white.opacity(0.7))
                    
                    Text("মূল লেআউট ডিজাইন: S. M. Raiyan Kabir")
                        .font(.system(size: 11))
                        .foregroundColor(.white.opacity(0.35))
                        .multilineTextAlignment(.center)
                    
                    // Sharif Ahammad link
                    Button(action: {
                        if let url = URL(string: "https://sharif.bd") {
                            NSWorkspace.shared.open(url)
                        }
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "person.fill")
                                .font(.system(size: 10))
                            Text("macOS App by Sharif Ahammad")
                                .font(.system(size: 11, weight: .medium))
                        }
                        .foregroundColor(Color(red: 0.5, green: 0.7, blue: 1.0))
                    }
                    .buttonStyle(.plain)
                    
                    Button(action: {
                        if let url = URL(string: "https://ekushey.org/keyboard-layout/ekusheyr-shadhinota-unijoy-layout/") {
                            NSWorkspace.shared.open(url)
                        }
                    }) {
                        HStack(spacing: 4) {
                            Image(systemName: "link")
                                .font(.system(size: 10))
                            Text("ekushey.org")
                                .font(.system(size: 11, weight: .medium))
                        }
                        .foregroundColor(Color(red: 0.5, green: 0.7, blue: 1.0))
                    }
                    .buttonStyle(.plain)
                    
                    Text("GNU LGPL v2.1 লাইসেন্সের অধীনে")
                        .font(.system(size: 10))
                        .foregroundColor(.white.opacity(0.2))
                }
                .padding(20)
                .frame(maxWidth: 400)
                .background(
                    RoundedRectangle(cornerRadius: 12)
                        .fill(Color.white.opacity(0.03))
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.white.opacity(0.06), lineWidth: 1)
                        )
                )
                .padding(.bottom, 28)
            }
            .frame(maxWidth: .infinity)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func sectionHeader(_ title: String, icon: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 13))
                .foregroundColor(Color(red: 0.5, green: 0.7, blue: 1.0))
            Text(title)
                .font(.system(size: 15, weight: .semibold))
                .foregroundColor(.white)
        }
    }
    
    func tipCard(icon: String, title: String, description: String) -> some View {
        HStack(alignment: .top, spacing: 14) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color(red: 0.2, green: 0.5, blue: 1.0).opacity(0.12))
                    .frame(width: 36, height: 36)
                Image(systemName: icon)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(Color(red: 0.5, green: 0.7, blue: 1.0))
            }
            VStack(alignment: .leading, spacing: 4) {
                Text(title)
                    .font(.system(size: 13, weight: .semibold))
                    .foregroundColor(.white.opacity(0.9))
                Text(description)
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.45))
                    .lineSpacing(2)
            }
        }
        .padding(14)
        .frame(maxWidth: .infinity, alignment: .leading)
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.03))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white.opacity(0.05), lineWidth: 1))
        )
    }
    
    func faqItem(question: String, answer: String, id: String) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Button(action: {
                withAnimation(.easeInOut(duration: 0.2)) {
                    expandedSection = expandedSection == id ? nil : id
                }
            }) {
                HStack {
                    Text(question)
                        .font(.system(size: 13, weight: .medium))
                        .foregroundColor(.white.opacity(0.85))
                        .multilineTextAlignment(.leading)
                    Spacer()
                    Image(systemName: expandedSection == id ? "chevron.up" : "chevron.down")
                        .font(.system(size: 11, weight: .medium))
                        .foregroundColor(.white.opacity(0.3))
                }
                .padding(14)
            }
            .buttonStyle(.plain)
            
            if expandedSection == id {
                Text(answer)
                    .font(.system(size: 12))
                    .foregroundColor(.white.opacity(0.5))
                    .lineSpacing(3)
                    .padding(.horizontal, 14)
                    .padding(.bottom, 14)
                    .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .background(
            RoundedRectangle(cornerRadius: 10)
                .fill(Color.white.opacity(0.03))
                .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color.white.opacity(0.05), lineWidth: 1))
        )
    }
}
