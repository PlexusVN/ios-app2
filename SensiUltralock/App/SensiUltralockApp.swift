import SwiftUI

@main
struct SensiUltralockApp: App {
    @StateObject private var authViewModel = AuthViewModel()
    @State private var showSplash = true

    var body: some Scene {
        WindowGroup {
            ZStack {
                if showSplash {
                    SplashView()
                        .transition(.opacity)
                        .onAppear {
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
                                withAnimation(.easeOut(duration: 0.6)) {
                                    showSplash = false
                                }
                            }
                        }
                } else {
                    Group {
                        if authViewModel.isAuthenticated {
                            HomeView(authViewModel: authViewModel)
                                .environmentObject(authViewModel)
                                .transition(.opacity)
                        } else {
                            LoginView()
                                .environmentObject(authViewModel)
                                .transition(.opacity)
                        }
                    }
                }
            }
            .preferredColorScheme(.dark)
        }
    }
}

struct SplashView: View {
    @State private var scale: CGFloat = 0.5
    @State private var opacity: Double = 0
    @State private var glowPulse = false

    var body: some View {
        ZStack {
            AppColors.background.ignoresSafeArea()

            RadialGradient(
                colors: [
                    AppColors.primaryRed.opacity(0.15),
                    .clear
                ],
                center: .center,
                startRadius: 0,
                endRadius: 200
            )
            .blur(radius: 40)

            VStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(AppColors.primaryRed.opacity(0.1))
                        .frame(width: 100, height: 100)
                        .blur(radius: 15)

                    Circle()
                        .stroke(
                            AngularGradient(
                                colors: [AppColors.primaryRed, AppColors.glowRed, AppColors.secondaryRed, AppColors.primaryRed],
                                center: .center
                            ),
                            lineWidth: 2
                        )
                        .frame(width: 80, height: 80)
                        .shadow(color: AppColors.glowRed.opacity(glowPulse ? 0.8 : 0.2), radius: glowPulse ? 30 : 10)

                    Image(systemName: "shield.lefthalf.filled")
                        .font(.system(size: 36, weight: .bold))
                        .foregroundColor(AppColors.glowRed)
                        .neonGlow()
                }

                Text("SENSI ULTRALOCK")
                    .font(.system(size: 24, weight: .heavy))
                    .foregroundColor(.white)
                    .tracking(4)
                    .shadow(color: AppColors.glowRed.opacity(0.5), radius: 10)

                Text("Premium Gaming Optimizer")
                    .font(.system(size: 13, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)
                    .tracking(2)
            }
            .scaleEffect(scale)
            .opacity(opacity)
            .onAppear {
                withAnimation(.spring(response: 0.8, dampingFraction: 0.7)) {
                    scale = 1
                    opacity = 1
                }
                withAnimation(AppAnimations.glowPulse) {
                    glowPulse = true
                }
            }
        }
        .preferredColorScheme(.dark)
    }
}
