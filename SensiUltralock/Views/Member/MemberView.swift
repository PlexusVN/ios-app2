import SwiftUI

struct MemberView: View {
    let user: UserModel
    var onLogout: (() -> Void)?

    @StateObject private var viewModel: MemberViewModel
    @State private var showLogoutAlert = false
    @State private var avatarPulse = false
    @State private var isAnimating = false

    init(user: UserModel, onLogout: (() -> Void)? = nil) {
        self.user = user
        self.onLogout = onLogout
        _viewModel = StateObject(wrappedValue: MemberViewModel(user: user))
    }

    var body: some View {
        ScrollView(showsIndicators: false) {
            VStack(spacing: 20) {
                profileHeader
                statusSection
                licenseCard
                accountCard
                subscriptionCard
                logoutSection
                Spacer().frame(height: 100)
            }
            .padding(.horizontal, AppTheme.padding)
            .padding(.top, 16)
        }
        .toast(isPresented: $viewModel.showCopiedToast, message: viewModel.copiedMessage, icon: "doc.on.doc.fill", color: AppColors.success)
        .alertPopup(
            isPresented: $showLogoutAlert,
            title: "Logout",
            message: "Are you sure you want to logout?",
            buttonText: "Logout",
            buttonColor: AppColors.primaryRed,
            action: {
                withAnimation(.easeInOut(duration: 0.5)) {
                    onLogout?()
                }
            }
        )
    }

    private var profileHeader: some View {
        VStack(spacing: 12) {
            ZStack {
                Circle()
                    .fill(AppColors.primaryRed.opacity(0.15))
                    .frame(width: 110, height: 110)
                    .blur(radius: 15)

                Circle()
                    .stroke(
                        AngularGradient(
                            colors: [AppColors.primaryRed, AppColors.glowRed, AppColors.secondaryRed, AppColors.primaryRed],
                            center: .center
                        ),
                        lineWidth: 3
                    )
                    .frame(width: 100, height: 100)
                    .shadow(color: AppColors.glowRed.opacity(avatarPulse ? 0.6 : 0.2), radius: avatarPulse ? 25 : 10)

                Image(systemName: "person.crop.circle.fill")
                    .font(.system(size: 44, weight: .regular))
                    .foregroundColor(.white)
                    .frame(width: 90, height: 90)
                    .background(AppColors.card)
                    .clipShape(Circle())
                    .overlay(
                        Circle()
                            .stroke(AppColors.glassBorder, lineWidth: 1)
                    )

                Circle()
                    .fill(AppColors.success)
                    .frame(width: 20, height: 20)
                    .overlay(
                        Circle()
                            .stroke(AppColors.background, lineWidth: 3)
                    )
                    .offset(x: 34, y: 34)
            }
            .onAppear {
                withAnimation(AppAnimations.glowPulse) {
                    avatarPulse = true
                }
            }

            Text(user.username)
                .font(.system(size: 22, weight: .bold))
                .foregroundColor(.white)

            PremiumBadge(text: user.tier.label.uppercased(), color: tierColor, icon: user.tier.icon)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
    }

    private var statusSection: some View {
        HStack(spacing: 12) {
            StatusBadge(label: "Verified", color: AppColors.success, icon: "checkmark.seal.fill")
            StatusBadge(label: "Active", color: AppColors.success, icon: "checkmark.circle.fill")

            if user.isPremium {
                StatusBadge(label: "Premium", color: AppColors.vip, icon: "crown.fill")
            }
        }
    }

    private var licenseCard: some View {
        MemberCard(title: "LICENSE", icon: "key.fill") {
            VStack(spacing: 12) {
                InfoRow(
                    label: "License Key",
                    value: user.licenseKey,
                    icon: "key",
                    showCopy: true,
                    onCopy: { viewModel.copyToClipboard(user.licenseKey, label: "License Key") }
                )

                Divider()
                    .background(AppColors.borderDim)

                InfoRow(
                    label: "Account Type",
                    value: user.accountType,
                    icon: "person.text.rectangle"
                )

                Divider()
                    .background(AppColors.borderDim)

                InfoRow(
                    label: "HWID",
                    value: user.hwid,
                    icon: "qrcode",
                    showCopy: true,
                    onCopy: { viewModel.copyToClipboard(user.hwid, label: "HWID") }
                )
            }
        }
    }

    private var accountCard: some View {
        MemberCard(title: "ACCOUNT", icon: "person.circle") {
            VStack(spacing: 12) {
                InfoRow(
                    label: "Auth Status",
                    value: user.isAuthenticated ? "Authenticated" : "Pending",
                    icon: "lock.shield",
                    valueColor: user.isAuthenticated ? AppColors.success : AppColors.warning
                )

                Divider()
                    .background(AppColors.borderDim)

                InfoRow(
                    label: "Subscription",
                    value: user.isPremium ? "Premium" : "Free",
                    icon: "crown",
                    valueColor: user.isPremium ? AppColors.vip : AppColors.textSecondary
                )
            }
        }
    }

    private var subscriptionCard: some View {
        MemberCard(title: "SUBSCRIPTION", icon: "clock.arrow.circlepath") {
            VStack(spacing: 12) {
                InfoRow(
                    label: "Expiration",
                    value: viewModel.formatDate(user.expirationDate),
                    icon: "calendar"
                )

                Divider()
                    .background(AppColors.borderDim)

                InfoRow(
                    label: "Last Login",
                    value: viewModel.formatDate(user.lastLogin),
                    icon: "clock"
                )

                Divider()
                    .background(AppColors.borderDim)

                InfoRow(
                    label: "Member Since",
                    value: viewModel.formatDate(user.memberSince),
                    icon: "star"
                )
            }
        }
    }

    private var logoutSection: some View {
        VStack(spacing: 12) {
            HStack {
                Text("Server v\(viewModel.serverVersion)")
                    .font(.system(size: 12, weight: .medium))
                    .foregroundColor(AppColors.textSecondary)

                Spacer()

                StatusBadge(
                    label: viewModel.connectionStatus.rawValue,
                    color: viewModel.connectionStatus.color,
                    icon: viewModel.connectionStatus.icon
                )
            }
            .padding(.horizontal, 4)

            SecondaryButton(
                title: "LOGOUT",
                icon: "rectangle.portrait.and.arrow.right",
                gradient: LinearGradient(
                    colors: [AppColors.statusOffline.opacity(0.2), AppColors.statusOffline.opacity(0.1)],
                    startPoint: .leading,
                    endPoint: .trailing
                )
            ) {
                showLogoutAlert = true
            }
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(AppColors.statusOffline.opacity(0.3), lineWidth: 1)
            )
        }
    }

    private var tierColor: Color {
        switch user.tier {
        case .basic: return AppColors.tierBasic
        case .pro: return AppColors.pro
        case .vip: return AppColors.vip
        }
    }
}
