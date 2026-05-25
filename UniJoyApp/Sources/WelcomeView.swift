import SwiftUI

struct WelcomeView: View {
    @Binding var showWelcome: Bool
    @ObservedObject var manager: KeyboardLayoutManager
    @State private var currentStep = 0
    @State private var animateIn = false
    @State private var isInstalling = false
    
    let steps = [
        ("hand.wave.fill", "স্বাগতম!", "UniJoy বাংলা কীবোর্ড — macOS-এ সবচেয়ে সহজ বাংলা লেখার উপায়।"),
        ("keyboard.fill", "ইউনিজয় লেআউট", "জনপ্রিয় ইউনিজয় লেআউট — ফোনেটিক নয়, ফিক্সড পজিশন। একবার শিখলে দ্রুততম বাংলা টাইপিং!"),
        ("bolt.circle.fill", "ওয়ান-ক্লিক সেটআপ", "নিচের বাটনে ক্লিক করুন — বাকি সব অটোমেটিক!")
    ]
    
    var body: some View {
        ZStack {
            // Background
            Color(nsColor: NSColor(red: 0.05, green: 0.05, blue: 0.09, alpha: 1.0))
                .ignoresSafeArea()
            
            // Gradient orbs
            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color(red: 0.2, green: 0.5, blue: 1.0).opacity(0.15), .clear],
                        center: .center, startRadius: 0, endRadius: 300
                    )
                )
                .frame(width: 600, height: 600)
                .offset(x: -200, y: -200)
            
            Circle()
                .fill(
                    RadialGradient(
                        colors: [Color(red: 0.6, green: 0.2, blue: 0.9).opacity(0.1), .clear],
                        center: .center, startRadius: 0, endRadius: 250
                    )
                )
                .frame(width: 500, height: 500)
                .offset(x: 200, y: 200)
            
            VStack(spacing: 0) {
                Spacer()
                
                // Logo
                ZStack {
                    RoundedRectangle(cornerRadius: 24)
                        .fill(
                            LinearGradient(
                                colors: [Color(red: 0.2, green: 0.5, blue: 1.0), Color(red: 0.4, green: 0.2, blue: 0.9)],
                                startPoint: .topLeading, endPoint: .bottomTrailing
                            )
                        )
                        .frame(width: 80, height: 80)
                        .shadow(color: Color(red: 0.3, green: 0.4, blue: 1.0).opacity(0.5), radius: 20, x: 0, y: 8)
                    
                    Text("ক")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(.white)
                }
                .scaleEffect(animateIn ? 1.0 : 0.5)
                .opacity(animateIn ? 1.0 : 0)
                
                Spacer().frame(height: 32)
                
                // Step content
                VStack(spacing: 12) {
                    Image(systemName: steps[currentStep].0)
                        .font(.system(size: 28))
                        .foregroundColor(Color(red: 0.5, green: 0.7, blue: 1.0))
                        .padding(.bottom, 4)
                    
                    Text(steps[currentStep].1)
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text(steps[currentStep].2)
                        .font(.system(size: 14))
                        .foregroundColor(.white.opacity(0.5))
                        .multilineTextAlignment(.center)
                        .frame(maxWidth: 400)
                        .lineSpacing(4)
                }
                .id(currentStep)
                .transition(.asymmetric(
                    insertion: .move(edge: .trailing).combined(with: .opacity),
                    removal: .move(edge: .leading).combined(with: .opacity)
                ))
                
                Spacer().frame(height: 40)
                
                // Progress dots
                HStack(spacing: 8) {
                    ForEach(0..<steps.count, id: \.self) { i in
                        Circle()
                            .fill(i == currentStep ? Color(red: 0.3, green: 0.6, blue: 1.0) : Color.white.opacity(0.15))
                            .frame(width: i == currentStep ? 10 : 6, height: i == currentStep ? 10 : 6)
                            .animation(.easeInOut(duration: 0.2), value: currentStep)
                    }
                }
                
                Spacer().frame(height: 36)
                
                // Action buttons
                HStack(spacing: 16) {
                    if currentStep > 0 {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentStep -= 1
                            }
                        }) {
                            HStack(spacing: 6) {
                                Image(systemName: "chevron.left")
                                    .font(.system(size: 12, weight: .semibold))
                                Text("পিছনে")
                                    .font(.system(size: 13, weight: .medium))
                            }
                            .foregroundColor(.white.opacity(0.5))
                            .padding(.horizontal, 24)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color.white.opacity(0.06))
                            )
                        }
                        .buttonStyle(.plain)
                    }
                    
                    if currentStep < steps.count - 1 {
                        Button(action: {
                            withAnimation(.easeInOut(duration: 0.3)) {
                                currentStep += 1
                            }
                        }) {
                            HStack(spacing: 6) {
                                Text("পরবর্তী")
                                    .font(.system(size: 13, weight: .semibold))
                                Image(systemName: "chevron.right")
                                    .font(.system(size: 12, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 28)
                            .padding(.vertical, 12)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(
                                        LinearGradient(
                                            colors: [Color(red: 0.2, green: 0.5, blue: 1.0), Color(red: 0.4, green: 0.2, blue: 0.9)],
                                            startPoint: .leading, endPoint: .trailing
                                        )
                                    )
                                    .shadow(color: Color(red: 0.3, green: 0.5, blue: 1.0).opacity(0.3), radius: 8, x: 0, y: 4)
                            )
                        }
                        .buttonStyle(.plain)
                    } else {
                        // Final step — Install & Go
                        Button(action: {
                            if !manager.isInstalled {
                                isInstalling = true
                                manager.install()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 3.0) {
                                    withAnimation(.easeInOut(duration: 0.5)) {
                                        showWelcome = false
                                    }
                                }
                            } else {
                                withAnimation(.easeInOut(duration: 0.5)) {
                                    showWelcome = false
                                }
                            }
                        }) {
                            HStack(spacing: 8) {
                                if isInstalling {
                                    ProgressView()
                                        .progressViewStyle(.circular)
                                        .scaleEffect(0.6)
                                        .tint(.white)
                                } else {
                                    Image(systemName: manager.isInstalled ? "checkmark.circle.fill" : "bolt.circle.fill")
                                        .font(.system(size: 16))
                                }
                                Text(manager.isInstalled ? "শুরু করুন ✨" : "⚡ ইনস্টল ও শুরু করুন")
                                    .font(.system(size: 14, weight: .semibold))
                            }
                            .foregroundColor(.white)
                            .padding(.horizontal, 32)
                            .padding(.vertical, 14)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(
                                        LinearGradient(
                                            colors: manager.isInstalled ?
                                                [Color(red: 0.2, green: 0.7, blue: 0.4), Color(red: 0.1, green: 0.5, blue: 0.3)] :
                                                [Color(red: 0.2, green: 0.5, blue: 1.0), Color(red: 0.4, green: 0.2, blue: 0.9)],
                                            startPoint: .leading, endPoint: .trailing
                                        )
                                    )
                                    .shadow(color: Color(red: 0.3, green: 0.5, blue: 1.0).opacity(0.4), radius: 12, x: 0, y: 6)
                            )
                        }
                        .buttonStyle(.plain)
                        .disabled(isInstalling)
                    }
                }
                
                Spacer().frame(height: 16)
                
                // Skip button
                if currentStep < steps.count - 1 {
                    Button(action: {
                        withAnimation(.easeInOut(duration: 0.5)) {
                            showWelcome = false
                        }
                    }) {
                        Text("স্কিপ করুন")
                            .font(.system(size: 12))
                            .foregroundColor(.white.opacity(0.25))
                    }
                    .buttonStyle(.plain)
                }
                
                Spacer()
            }
        }
        .onAppear {
            withAnimation(.spring(response: 0.6, dampingFraction: 0.7)) {
                animateIn = true
            }
        }
    }
}
