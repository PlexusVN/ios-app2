import SwiftUI

struct LoginView: View {
    @EnvironmentObject var viewModel: AuthViewModel
    @State private var showHelp = false
    @State private var avatarPulse = false
    @State private var offsetY: CGFloat = 50
    @State private var opacity: Double = 0

    @FocusState private var isKeyFieldFocused: Bool

    var body: some View {
        ZStack {
            AnimatedBackground()
            ParticlesView(count: 20)

            ScrollView(showsIndicators: false) {
                VStack(spacing: 24) {
                    Spacer().frame(height: 60)

                    avatarSection
                    titleSection
                    loginCard
                    Spacer().frame(minHeight: 20)
                }
                .padding(.horizontal, AppTheme.padding)
            }

            if viewModel.isLoading {
                loadingOverlay
            }
        }
        .preferredColorScheme(.dark)
        .interactiveDismissDisabled()
    }

    private var avatarSection: some View {
        VStack(spacing: 0) {
            ZStack {
                Circle()
                    .fill(AppColors.primaryRed.opacity(0.15))
                    .frame(width: 120, height: 120)
                    .blur(radius: 20)

                Circle()
                    .stroke(
                        AngularGradient(
                            colors: [AppColors.primaryRed, AppColors.glowRed, AppColors.secondaryRed, AppColors.primaryRed],
                            center: .center
                        ),
                        lineWidth: 3
                    )
                    .frame(width: 108, height: 108)
                    .shadow(color: AppColors.glowRed.opacity(avatarPulse ? 0.8 : 0.2), radius: avatarPulse ? 30 : 10)
                    .scaleEffect(avatarPulse ? 1.05 : 1)

                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 50, weight: .regular))
                    .foregroundColor(.white)
                    .frame(width: 100, height: 100)
                    .background(AppColors.card)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(AppColors.glassBorder, lineWidth: 1)
                    )
            }
            .onAppear {
                withAnimation(AppAnimations.glowPulse) {
                    avatarPulse = true
                }
            }
        }
        .opacity(opacity)
        .offset(y: offsetY)
        .onAppear {
            withAnimation(.spring(response: 0.8, dampingFraction: 0.7).delay(0.2)) {
                offsetY = 0
                opacity = 1
            }
        }
    }

    private var titleSection: some View {
        VStack(spacing: 6) {
            Text("SENSI ULTRALOCK")
                .font(.system(size: 26, weight: .heavy))
                .foregroundColor(.white)
                .tracking(4)
                .shadow(color: AppColors.glowRed.opacity(0.5), radius: 10)

            Text("Premium Gaming Optimizer")
                .font(.system(size: 14, weight: .medium))
                .foregroundColor(AppColors.textSecondary)
                .tracking(2)
        }
        .opacity(opacity)
        .offset(y: offsetY)
    }

    private var loginCard: some View {
        VStack(spacing: 20) {
            GlassCard(radius: AppTheme.cornerRadiusLarge) {
                VStack(spacing: 20) {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("License Key")
                            .font(.system(size: 13, weight: .semibold))
                            .foregroundColor(AppColors.textSecondary)
                            .tracking(1)

                        ZStack(alignment: .leading) {
                            if viewModel.licenseKey.isEmpty {
                                Text("Enter your License Key")
                                    .font(.system(size: 16, weight: .regular))
                                    .foregroundColor(AppColors.textSecondary.opacity(0.5))
                                    .padding(.leading, 16)
                            }

                            TextField("", text: $viewModel.licenseKey)
                                .font(.system(size: 16, weight: .medium))
                                .foregroundColor(.white)
                                .autocapitalization(.none)
                                .disableAutocorrection(true)
                                .keyboardType(.asciiCapable)
                                .focused($isKeyFieldFocused)
                                .padding(.horizontal, 16)
                                .padding(.vertical, 14)
                                .background(AppColors.cardSecondary)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(
                                            isKeyFieldFocused ? AppColors.glowRed.opacity(0.5) : AppColors.borderDim,
                                            lineWidth: 1
                                        )
                                )
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }

                    PrimaryButton(
                        title: "LOGIN",
                        icon: "arrow.right",
                        isLoading: viewModel.isLoading
                    ) {
                        isKeyFieldFocused = false
                        viewModel.login()
                    }

                    SecondaryButton(
                        title: "Join Zalo Group",
                        icon: "message.fill"
                    ) {
                        if let url = URL(string: "https://zalo.me/g/sensiultralock") {
                            UIApplication.shared.open(url)
                        }
                    }
                }
            }

            helpCard
        }
        .opacity(opacity)
        .offset(y: offsetY)
    }

    private var helpCard: some View {
        VStack(alignment: .leading, spacing: 12) {
            Button(action: {
                withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                    showHelp.toggle()
                }
            }) {
                HStack {
                    Image(systemName: "questionmark.circle")
                        .font(.system(size: 16, weight: .semibold))
                        .foregroundColor(AppColors.glowRed)

                    Text("How to get a key?")
                        .font(.system(size: 15, weight: .semibold))
                        .foregroundColor(.white)

                    Spacer()

                    Image(systemName: showHelp ? "chevron.up" : "chevron.down")
                        .font(.system(size: 12, weight: .bold))
                        .foregroundColor(AppColors.textSecondary)
                }
            }

            if showHelp {
                VStack(alignment: .leading, spacing: 10) {
                    helpStep(1, "Join our official Zalo Group")
                    helpStep(2, "Contact Administrator")
                    helpStep(3, "Receive License Key")
                    helpStep(4, "Paste License Key above")
                }
                .transition(.opacity.combined(with: .move(edge: .top)))
            }
        }
        .padding(16)
        .background(AppColors.cardSecondary)
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.cornerRadiusSmall)
                .stroke(AppColors.borderDim, lineWidth: 1)
        )
        .clipShape(RoundedRectangle(cornerRadius: AppTheme.cornerRadiusSmall))
    }

    private func helpStep(_ number: Int, _ text: String) -> some View {
        HStack(spacing: 12) {
            Text("\(number)")
                .font(.system(size: 12, weight: .bold))
                .foregroundColor(.white)
                .frame(width: 24, height: 24)
                .background(AppColors.primaryRed)
                .clipShape(Circle())

            Text(text)
                .font(.system(size: 13, weight: .regular))
                .foregroundColor(AppColors.textSecondary)
        }
    }

    private var loadingOverlay: some View {
        ZStack {
            AppColors.background.opacity(0.8)
                .ignoresSafeArea()

            LoadingView(message: "Authenticating...")
        }
        .transition(.opacity)
    }
}
