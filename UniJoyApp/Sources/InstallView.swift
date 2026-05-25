import SwiftUI

struct InstallView: View {
    @ObservedObject var manager: KeyboardLayoutManager
    var reopenWelcome: () -> Void = {}
    @State private var animateGlow: Bool = false
    
    var body: some View {
        VStack(spacing: 16) {
                Spacer(minLength: 10)
                
                // Header
                VStack(spacing: 4) {
                    Text("ইনস্টলেশন")
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                    
                    Text("ওয়ান-ক্লিক অটো ইনস্টল — সবকিছু স্বয়ংক্রিয়!")
                        .font(.system(size: 12))
                        .foregroundColor(.white.opacity(0.5))
                }
                .padding(.top, 10)
                
                // Status Card
                VStack(spacing: 10) {
                    ZStack {
                        Circle()
                            .fill(
                                manager.isInstalled ?
                                RadialGradient(colors: [Color.green.opacity(0.3), Color.clear], center: .center, startRadius: 0, endRadius: 40) :
                                RadialGradient(colors: [Color.orange.opacity(0.3), Color.clear], center: .center, startRadius: 0, endRadius: 40)
                            )
                            .frame(width: 80, height: 80)
                            .scaleEffect(animateGlow ? 1.2 : 1.0)
                            .animation(.easeInOut(duration: 2).repeatForever(autoreverses: true), value: animateGlow)
                        
                        ZStack {
                            Circle()
                                .fill(Color.white.opacity(0.06))
                                .frame(width: 54, height: 54)
                            
                            Image(systemName: manager.isInstalled ? "checkmark.circle.fill" : "arrow.down.circle")
                                .font(.system(size: 26, weight: .light))
                                .foregroundColor(manager.isInstalled ? .green : .orange)
                        }
                    }
                    .onAppear { animateGlow = true }
                    
                    Text(manager.isInstalled ? "ইনস্টল করা আছে" : "ইনস্টল করা হয়নি")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)
                    
                    // Health Dashboard
                    if manager.isInstalled {
                        VStack(spacing: 4) {
                            healthRow(
                                icon: "doc.fill",
                                title: "লেআউট ফাইল",
                                status: "ইনস্টল আছে",
                                ok: true
                            )
                            healthRow(
                                icon: "square.and.pencil",
                                title: "সিস্টেম রেজিস্ট্রেশন",
                                status: "রেজিস্টার্ড",
                                ok: true
                            )
                            healthRow(
                                icon: "power.circle.fill",
                                title: "ইনপুট সোর্স",
                                status: manager.isInputSourceEnabled ? "সক্রিয়" : "নিষ্ক্রিয়",
                                ok: manager.isInputSourceEnabled
                            )
                            
                            // Login Items row
                            healthRow(
                                icon: "person.crop.circle.badge.clock",
                                title: "Login Items",
                                status: manager.isLoginItemEnabled ? "যোগ আছে" : "যোগ নেই",
                                ok: manager.isLoginItemEnabled,
                                fixAction: manager.isLoginItemEnabled ? nil : { manager.enableLoginItem() }
                            )
                        }
                    } else {
                        VStack(spacing: 4) {
                            autoFeature(icon: "doc.on.doc", text: "ফাইল অটো কপি হবে")
                            autoFeature(icon: "keyboard", text: "কীবোর্ড অটো রেজিস্টার হবে")
                            autoFeature(icon: "power", text: "ইনপুট সোর্স অটো সক্রিয় হবে")
                            autoFeature(icon: "hand.tap", text: "কোনো ম্যানুয়াল সেটিং লাগবে না!")
                        }
                    }
                }
                .padding(18)
                .frame(maxWidth: 460)
                .background(
                    RoundedRectangle(cornerRadius: 16)
                        .fill(Color.white.opacity(0.03))
                        .overlay(
                            RoundedRectangle(cornerRadius: 16)
                                .stroke(Color.white.opacity(0.06), lineWidth: 1)
                        )
                )
                
                // Action Buttons
                VStack(spacing: 8) {
                    HStack(spacing: 16) {
                        if !manager.isInstalled {
                            actionButton(
                                title: "⚡ ওয়ান-ক্লিক ইনস্টল",
                                icon: "bolt.circle.fill",
                                gradient: [Color(red: 0.2, green: 0.7, blue: 0.4), Color(red: 0.1, green: 0.5, blue: 0.3)],
                                isLoading: manager.isProcessing
                            ) {
                                manager.install()
                            }
                        } else {
                            actionButton(
                                title: "আনইনস্টল",
                                icon: "trash.circle.fill",
                                gradient: [Color(red: 0.8, green: 0.2, blue: 0.2), Color(red: 0.6, green: 0.1, blue: 0.1)],
                                isLoading: manager.isProcessing
                            ) {
                                manager.uninstall()
                            }
                            
                            actionButton(
                                title: "পুনরায় ইনস্টল",
                                icon: "arrow.triangle.2.circlepath",
                                gradient: [Color(red: 0.2, green: 0.5, blue: 1.0), Color(red: 0.4, green: 0.2, blue: 0.9)],
                                isLoading: false
                            ) {
                                manager.uninstall()
                                DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                                    manager.install()
                                }
                            }
                        }
                    }
                    
                    // Quick Switch Button
                    if manager.isInstalled {
                        HStack(spacing: 12) {
                            Button(action: { manager.switchToBangla() }) {
                                HStack(spacing: 8) {
                                    Text("ক")
                                        .font(.system(size: 14, weight: .bold))
                                    Text("বাংলায় সুইচ করুন")
                                        .font(.system(size: 11, weight: .medium))
                                }
                                .foregroundColor(Color(red: 0.5, green: 0.7, blue: 1.0))
                                .padding(.horizontal, 14)
                                .padding(.vertical, 7)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color(red: 0.2, green: 0.5, blue: 1.0).opacity(0.1))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color(red: 0.2, green: 0.5, blue: 1.0).opacity(0.2), lineWidth: 1)
                                        )
                                )
                            }
                            .buttonStyle(.plain)
                            
                            Button(action: { manager.openKeyboardPreferences() }) {
                                HStack(spacing: 8) {
                                    Image(systemName: "gear")
                                        .font(.system(size: 12))
                                    Text("System Settings")
                                        .font(.system(size: 11, weight: .medium))
                                }
                                .foregroundColor(.white.opacity(0.5))
                                .padding(.horizontal, 14)
                                .padding(.vertical, 7)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color.white.opacity(0.04))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: 10)
                                                .stroke(Color.white.opacity(0.08), lineWidth: 1)
                                        )
                                )
                            }
                            .buttonStyle(.plain)
                        }
                    }
                }
                
                // Status Message
                if !manager.statusMessage.isEmpty {
                    HStack(alignment: .top, spacing: 10) {
                        if manager.isProcessing {
                            ProgressView()
                                .progressViewStyle(.circular)
                                .scaleEffect(0.6)
                                .tint(.white)
                        }
                        
                        Text(manager.statusMessage)
                            .font(.system(size: 13))
                            .foregroundColor(.white.opacity(0.7))
                            .lineSpacing(3)
                    }
                    .padding(16)
                    .frame(maxWidth: 520)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.white.opacity(0.04))
                            .overlay(
                                RoundedRectangle(cornerRadius: 10)
                                    .stroke(Color.white.opacity(0.06), lineWidth: 1)
                            )
                    )
                    .transition(.opacity.combined(with: .move(edge: .bottom)))
                    .animation(.easeInOut, value: manager.statusMessage)
                }
                
                // What happens automatically
                autoStepsSection
                    .padding(.horizontal, 40)
                
                // Reopen welcome
                Button(action: reopenWelcome) {
                    HStack(spacing: 6) {
                        Image(systemName: "wand.and.stars")
                            .font(.system(size: 12))
                        Text("সেটআপ উইজার্ড আবার দেখুন")
                            .font(.system(size: 12, weight: .medium))
                    }
                    .foregroundColor(.white.opacity(0.3))
                    .padding(.horizontal, 16)
                    .padding(.vertical, 8)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.white.opacity(0.04))
                            .overlay(
                                RoundedRectangle(cornerRadius: 8)
                                    .stroke(Color.white.opacity(0.06), lineWidth: 1)
                            )
                    )
                }
                .buttonStyle(.plain)
                
                Spacer(minLength: 20)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
    
    func healthRow(icon: String, title: String, status: String, ok: Bool, fixAction: (() -> Void)? = nil) -> some View {
        HStack(spacing: 12) {
            Image(systemName: icon)
                .font(.system(size: 14))
                .foregroundColor(ok ? Color.green : Color.orange)
                .frame(width: 20)
            
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.white.opacity(0.6))
            
            Spacer()
            
            if let fixAction = fixAction {
                Button(action: fixAction) {
                    HStack(spacing: 3) {
                        Image(systemName: "wrench.fill")
                            .font(.system(size: 8))
                        Text("Fix")
                            .font(.system(size: 10, weight: .semibold))
                    }
                    .foregroundColor(.orange)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 3)
                    .background(Color.orange.opacity(0.1))
                    .cornerRadius(6)
                }
                .buttonStyle(.plain)
                .padding(.trailing, 4)
            }
            
            HStack(spacing: 4) {
                Circle()
                    .fill(ok ? Color.green : Color.orange)
                    .frame(width: 5, height: 5)
                Text(status)
                    .font(.system(size: 10, weight: .medium))
                    .foregroundColor(ok ? Color.green.opacity(0.8) : Color.orange.opacity(0.8))
            }
            .padding(.horizontal, 8)
            .padding(.vertical, 3)
            .background(
                Capsule()
                    .fill(ok ? Color.green.opacity(0.1) : Color.orange.opacity(0.1))
            )
        }
        .padding(.horizontal, 8)
        .padding(.vertical, 6)
        .background(
            RoundedRectangle(cornerRadius: 8)
                .fill(Color.white.opacity(0.03))
        )
        .frame(maxWidth: 320)
    }
    
    func autoFeature(icon: String, text: String) -> some View {
        HStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundColor(Color(red: 0.4, green: 0.8, blue: 0.5))
                .frame(width: 16)
            Text(text)
                .font(.system(size: 12))
                .foregroundColor(.white.opacity(0.5))
            Spacer()
        }
        .frame(maxWidth: 260)
    }
    
    func actionButton(title: String, icon: String, gradient: [Color], isLoading: Bool, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack(spacing: 8) {
                if isLoading {
                    ProgressView()
                        .progressViewStyle(.circular)
                        .scaleEffect(0.6)
                        .tint(.white)
                } else {
                    Image(systemName: icon)
                        .font(.system(size: 14))
                }
                Text(title)
                    .font(.system(size: 12, weight: .semibold))
            }
            .foregroundColor(.white)
            .padding(.horizontal, 20)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 10)
                    .fill(LinearGradient(colors: gradient, startPoint: .leading, endPoint: .trailing))
                    .shadow(color: gradient[0].opacity(0.3), radius: 6, x: 0, y: 3)
            )
        }
        .buttonStyle(.plain)
        .disabled(isLoading)
    }
    
    var autoStepsSection: some View {
        VStack(alignment: .leading, spacing: 16) {
            HStack(spacing: 8) {
                Image(systemName: "wand.and.stars")
                    .font(.system(size: 13))
                    .foregroundColor(Color(red: 0.5, green: 0.7, blue: 1.0))
                Text("অটো ইনস্টলে কী হয়?")
                    .font(.system(size: 15, weight: .semibold))
                    .foregroundColor(.white)
            }
            
            stepItem(number: "1", text: "কীবোর্ড লেআউট ফাইল সিস্টেমে কপি হয়", icon: "doc.fill", done: manager.isInstalled)
            stepItem(number: "2", text: "macOS-এ ইনপুট সোর্স রেজিস্টার হয়", icon: "square.and.pencil", done: manager.isInstalled)
            stepItem(number: "3", text: "বাংলা কীবোর্ড অটো সক্রিয় হয়", icon: "power", done: manager.isInputSourceEnabled)
            stepItem(number: "4", text: "মেনু বারে 🌐 দিয়ে সুইচ করুন!", icon: "globe", done: false)
        }
        .padding(20)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color.white.opacity(0.03))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.white.opacity(0.06), lineWidth: 1)
                )
        )
    }
    
    func stepItem(number: String, text: String, icon: String, done: Bool) -> some View {
        HStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(done ? Color.green.opacity(0.2) : Color(red: 0.2, green: 0.5, blue: 1.0).opacity(0.2))
                    .frame(width: 28, height: 28)
                
                if done {
                    Image(systemName: "checkmark")
                        .font(.system(size: 11, weight: .bold))
                        .foregroundColor(.green)
                } else {
                    Text(number)
                        .font(.system(size: 12, weight: .bold, design: .rounded))
                        .foregroundColor(Color(red: 0.5, green: 0.7, blue: 1.0))
                }
            }
            
            Image(systemName: icon)
                .font(.system(size: 12))
                .foregroundColor(.white.opacity(0.3))
                .frame(width: 16)
            
            Text(text)
                .font(.system(size: 13))
                .foregroundColor(done ? .white.opacity(0.4) : .white.opacity(0.6))
                .strikethrough(done, color: .white.opacity(0.2))
        }
    }
}
