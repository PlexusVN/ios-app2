import SwiftUI

struct TopBar: View {
    let title: String
    let tier: Tier
    var fps: Int = 60
    var serverStatus: Bool = true
    var onLogout: (() -> Void)?

    @State private var fpsPulse = false

    var body: some View {
        HStack(spacing: 12) {
            HStack(spacing: 8) {
                Image(systemName: "shield.lefthalf.filled")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(AppColors.glowRed)
                    .neonGlow(color: AppColors.glowRed)

                Text(title)
                    .font(.system(size: 15, weight: .heavy))
                    .foregroundColor(.white)
                    .tracking(2)
            }

            Spacer()

            HStack(spacing: 10) {
                tierBadge

                HStack(spacing: 4) {
                    Circle()
                        .fill(serverStatus ? AppColors.statusOnline : AppColors.statusOffline)
                        .frame(width: 6, height: 6)
                    Text(serverStatus ? "Online" : "Offline")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(AppColors.textSecondary)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(AppColors.glass)
                .clipShape(RoundedRectangle(cornerRadius: 6))

                HStack(spacing: 4) {
                    Image(systemName: "gauge.medium")
                        .font(.system(size: 10, weight: .bold))
                        .foregroundColor(fpsPulse ? AppColors.glowRed : AppColors.textSecondary)
                    Text("\(fps) FPS")
                        .font(.system(size: 10, weight: .semibold))
                        .foregroundColor(AppColors.textSecondary)
                }
                .padding(.horizontal, 8)
                .padding(.vertical, 4)
                .background(AppColors.glass)
                .clipShape(RoundedRectangle(cornerRadius: 6))
            }
        }
        .padding(.horizontal, AppTheme.padding)
        .padding(.vertical, 12)
        .background(
            ZStack {
                AppColors.tabBarBg
                AppColors.glass
            }
        )
        .overlay(
            Rectangle()
                .fill(AppColors.borderDim)
                .frame(height: 1),
            alignment: .bottom
        )
        .onAppear {
            withAnimation(AppAnimations.glowPulse) {
                fpsPulse = true
            }
        }
    }

    @ViewBuilder
    private var tierBadge: some View {
        HStack(spacing: 4) {
            Image(systemName: tier.icon)
                .font(.system(size: 9, weight: .bold))
            Text(tier.label)
                .font(.system(size: 9, weight: .bold))
        }
        .foregroundColor(.white)
        .padding(.horizontal, 8)
        .padding(.vertical, 4)
        .background(tierColor.opacity(0.25))
        .overlay(
            RoundedRectangle(cornerRadius: 5)
                .stroke(tierColor.opacity(0.6), lineWidth: 0.5)
        )
        .clipShape(RoundedRectangle(cornerRadius: 5))
    }

    private var tierColor: Color {
        switch tier {
        case .basic: return AppColors.tierBasic
        case .pro: return AppColors.pro
        case .vip: return AppColors.vip
        }
    }
}
