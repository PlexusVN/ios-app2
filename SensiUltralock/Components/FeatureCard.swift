import SwiftUI

struct FeatureCard: View {
    let feature: FeatureModel
    var isActive: Bool = false
    var onToggle: ((FeatureModel) -> Void)?

    @State private var isHovered = false
    @State private var animatePulse = false

    var body: some View {
        HStack(spacing: 16) {
            iconView

            VStack(alignment: .leading, spacing: 4) {
                HStack(spacing: 8) {
                    Text(feature.title)
                        .font(.system(size: 16, weight: .bold))
                        .foregroundColor(feature.isLocked ? AppColors.textSecondary : .white)

                    if feature.isLocked {
                        tierBadge
                    }
                }

                Text(feature.subtitle)
                    .font(.system(size: 13, weight: .regular))
                    .foregroundColor(AppColors.textSecondary)
            }

            Spacer()

            if feature.isLocked {
                lockIcon
            } else {
                toggleView
            }
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 14)
        .background(
            RoundedRectangle(cornerRadius: AppTheme.cornerRadiusSmall)
                .fill(
                    feature.isEnabled
                        ? AppColors.primaryRed.opacity(0.08)
                        : AppColors.cardSecondary
                )
                .overlay(
                    RoundedRectangle(cornerRadius: AppTheme.cornerRadiusSmall)
                        .stroke(
                            feature.isEnabled
                                ? AppColors.glowRed.opacity(0.3)
                                : AppColors.borderDim,
                            lineWidth: 1
                        )
                )
        )
        .overlay(
            RoundedRectangle(cornerRadius: AppTheme.cornerRadiusSmall)
                .stroke(
                    AppColors.glowRed.opacity(feature.isEnabled ? (animatePulse ? 0.5 : 0.2) : 0),
                    lineWidth: 1.5
                )
        )
        .scaleEffect(isHovered && !feature.isLocked ? 1.01 : 1)
        .onTapGesture {
            withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                isHovered = true
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                withAnimation(.spring(response: 0.3, dampingFraction: 0.6)) {
                    isHovered = false
                }
            }
            onToggle?(feature)
        }
        .onAppear {
            if feature.isEnabled {
                withAnimation(AppAnimations.glowPulse) {
                    animatePulse = true
                }
            }
        }
    }

    private var iconView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 10)
                .fill(feature.isEnabled ? AppColors.primaryRed : AppColors.card)
                .frame(width: 40, height: 40)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(
                            feature.isEnabled ? AppColors.glowRed.opacity(0.5) : AppColors.borderDim,
                            lineWidth: 1
                        )
                )

            Image(systemName: feature.icon)
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(feature.isEnabled ? .white : AppColors.textSecondary)
        }
    }

    private var tierBadge: some View {
        HStack(spacing: 4) {
            Image(systemName: feature.tier.icon)
                .font(.system(size: 9, weight: .bold))
            Text(feature.tier.label)
                .font(.system(size: 9, weight: .bold))
        }
        .foregroundColor(.white)
        .padding(.horizontal, 8)
        .padding(.vertical, 3)
        .background(tierColor.opacity(0.3))
        .overlay(
            RoundedRectangle(cornerRadius: 4)
                .stroke(tierColor.opacity(0.5), lineWidth: 0.5)
        )
        .clipShape(RoundedRectangle(cornerRadius: 4))
    }

    private var lockIcon: some View {
        Image(systemName: "lock.fill")
            .font(.system(size: 14, weight: .semibold))
            .foregroundColor(AppColors.textSecondary)
            .frame(width: 36, height: 36)
            .background(AppColors.card)
            .clipShape(RoundedRectangle(cornerRadius: 8))
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(AppColors.borderDim, lineWidth: 1)
            )
    }

    private var toggleView: some View {
        ZStack {
            RoundedRectangle(cornerRadius: 18)
                .fill(feature.isEnabled ? AppColors.primaryRed : AppColors.card)
                .frame(width: 48, height: 28)
                .overlay(
                    RoundedRectangle(cornerRadius: 18)
                        .stroke(
                            feature.isEnabled ? AppColors.glowRed.opacity(0.5) : AppColors.borderDim,
                            lineWidth: 1
                        )
                )

            Circle()
                .fill(.white)
                .frame(width: 22, height: 22)
                .shadow(color: feature.isEnabled ? AppColors.glowRed.opacity(0.5) : .clear, radius: 4)
                .offset(x: feature.isEnabled ? 10 : -10)
                .animation(.spring(response: 0.3, dampingFraction: 0.6), value: feature.isEnabled)
        }
        .shadow(color: feature.isEnabled ? AppColors.glowRed.opacity(0.3) : .clear, radius: 8)
    }

    private var tierColor: Color {
        switch feature.tier {
        case .basic: return AppColors.tierBasic
        case .pro: return AppColors.pro
        case .vip: return AppColors.vip
        }
    }
}
